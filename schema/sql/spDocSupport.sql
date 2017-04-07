--=========================================================================
--   spDocSupport.sql (split from spWebSupport.sql in Sql2k version)
--   2001-11-01 Alex Szalay
---------------------------------------------------------------------------
-- History:
--* 2001-12-02 Jim:  added comments, fixed things
--* 2002-11-16 Alex: Switched to Columns->DBColumns, ViewCol->DBViewCols
--* 2003-02-20 Alex: added fEnum() and spDocEnum to render the enumerated
--*		data types correctly
--* 2003-06-26 Ani: Updated fEnum() to handle small and tiny ints.
--* 2005-04-12 Ani: Added fDocColumnsWithRank to return table columns with
--*            rank for ordered column display in query builder tools (PR
--*            #6405).
--* 2007-01-01 Alex: modified fDocColumns, fDocColumnsWithRank and 
--*            fDocFunctionParams to work with SQL2005's catalog view sys
--*            tables
--* 2007-01-01 Alex+Jim: added fVarBinToHex function to replace 
--*            xp_varbintohextstr procedure
--* 2007-07-20 Ani: Changed call to fVarBintoHex with call to built-in
--*            function master.dbo.fn_varbintohexstr in fEnum to fix
--*            PR #7339 (UberCalibStatus values wrong).
--* 2011-09-28 Ani: Modified spDocEnum to list only data values for
--*            name != '', since that special value is used for the
--*            description of that group of constants.
--* 2012-07-26 Ani: Fixed bug in fDocFunctionParams that was labeling
--*            output params also as input.
--* 2013-04-09 Ani: Fixed bug in fDocFunctionParams - needed ORDER BY
--*            pnum for both input and output params.
--* 2013-07-08 Ani: Modified spDocEnum to just call the view for the
--*            fieldname if it exists.
--*
--* 2017-04-07 Sue:modified fDocColumns to include column_id so columns
--*			   are correctly ordered.	
---------------------------------------------------------------------------
SET NOCOUNT ON;
GO 

--==================================================================
if exists (select * from sys.objects 
	where [name] = N'fVarBinToHex') 
    drop function fVarBinToHex 
go 
--
CREATE FUNCTION fVarBinToHex (@varBinary varbinary(4000)) 
--------------------------------------------------- 
--/H Returns hexadecimal string of varbinary input
--------------------------------------------------- 
--/T The input is scanned converting nibbles to hex characters
--/T <br> 
--/T <sample> 
--/T          select dbo.fVarBinToHex(0x4532ae1245) 
--/T</sample> 
--------------------------------------------------- 
RETURNS varchar(8000)
AS
BEGIN
	-----------------------------------------------------------------------
    DECLARE	@i      int,              -- index on the @varBinary string 
			@length int,              -- length of input string (bytes) 
			@val    int,              -- next byte from input string 
			@char   char(1),          -- next hex char from input string 
			@ans    varchar(8000)     -- output hex string. 
    ----------------------------------------------------------------------- 
    -- initialize the working variables
	-------------------------------------
    SET @ans = ''                        -- null answer string 
    SET @length = len(@varBinary)        -- byte length of input 
    SET @i = 1                           -- cursor on input string. 
    --------------------------------------------------- 
    -- translate each byte to a pair of hex characters
	---------------------------------------------------
	WHILE (@i <= @length) 
	BEGIN							-- high order nibble 
		SET @val = cast(substring(@varbinary, @i, 1) as int) / 16 
		IF @val < 10 SET @char = cast(@val as char(1)) 
				ELSE SET @char = char (0x41+ @val - 10) 
		--
		SET @ans = @ans + @char		-- low order nibble 
		SET @val = cast(substring(@varbinary, @i, 1) as int) & 0xF 
		IF @val < 10 SET @char = cast(@val as char(1)) 
				ELSE SET @char = char (0x41+ @val - 10) 
		SET @ans = @ans + @char 
		SET @i = @i + 1;			-- go to next byte. 
	END								-- end of byte loop 
	RETURN @ans
END
GO


--=================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fEnum' )
	DROP FUNCTION fEnum
GO
--
CREATE FUNCTION fEnum(
	@value binary(8), 
	@type varchar(32), 
	@length int)
----------------------------------------------------
--/H Converts @value in an enum table to a string
--/U
--/T Takes a binary(8) value, and converts it first
--/T to a type of given length, then to a string.
--/T It is used by the spDocEnum procedure.
----------------------------------------------------
RETURNS varchar(64)
AS BEGIN
    DECLARE @vstr varchar(64),
			@vbin4 binary(4),
			@vint int;
    SET @vint  = CAST(@value as int);
    --	
    IF (@type<>'binary')
		SET @vstr = CAST(@vint as varchar(64));
    ELSE 
    BEGIN
	IF (@length = 8) SELECT @vstr = master.dbo.fn_varbintohexstr(@value);
        ELSE 
            BEGIN
		SET @vbin4   = CAST(@value as binary(4));
		SELECT @vstr = master.dbo.fn_varbintohexstr(@vbin4);
		----------------------------------------------
		-- also handle the tinyint and smallint cases
		----------------------------------------------
            	IF (@length = 2) SET @vstr = CAST(@vstr as varchar(6));
		IF (@length = 1) SET @vstr = CAST(@vstr as varchar(4));
	    END
    END
    RETURN @vstr;
END
GO


--=================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fDocColumns' )
	DROP FUNCTION fDocColumns
GO
--
CREATE FUNCTION [dbo].[fDocColumns](@tablename varchar(400))
-------------------------------------------------
--/H Return the list of Columns in a given table or view
-------------------------------------------------
--/T Used by the auto-doc interface.  For getting 
--/T the 'rank' column in the DBColumns table, 
--/T see fDocColumnsWithRank.
--/T <samp>
--/T select * from dbo.fDocColumns('Star')
--/T </samp>
-------------------------------------------------
RETURNS @out TABLE (
	[enum]		varchar(64),
	[name]		varchar(64),
	[type] 		varchar(32),
	[length]	int,
	[unit]		varchar(64),
	[ucd]		varchar(64),
	[description]	varchar(2048),
	[columnID]		int primary key
)
AS BEGIN
	---------------------------------
	-- get the objectid of DBObject,
	-- and its system type
	---------------------------------
	DECLARE @oid bigint, @type varchar(3);
	SELECT @oid=object_id, @type=type
	FROM sys.objects
	WHERE name=@tablename
	-------------------
	-- handle views
	-------------------
	IF (@type='V')
	BEGIN
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
    RETURN
END

GO


--=================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fDocColumnsWithRank' )
	DROP FUNCTION fDocColumnsWithRank
GO
--
CREATE FUNCTION fDocColumnsWithRank(@tablename varchar(400))
-------------------------------------------------
--/H Return the list of Columns plus 'rank'
-------------------------------------------------
--/T Used by the auto-doc interface and query builder tools.
--/T Also returns the 'rank' column that is used to order 
--/T the columns in query tools.
--/T <samp>
--/T select * from dbo.fDocColumnsWithRank('PhotoObjAll')
--/T </samp>
-------------------------------------------------
RETURNS @out TABLE (
	[enum]		varchar(64),
	[name]		varchar(64),
	[type] 		varchar(32),
	[length]	int,
	[unit]		varchar(64),
	[ucd]		varchar(128),
	[description]	varchar(2048),
	[rank]		int
)
AS BEGIN
	---------------------------------
	-- get the objectid of DBObject,
	-- and its system type
	---------------------------------
	DECLARE @oid bigint, @type varchar(3);
	SELECT @oid=object_id, @type=type
	FROM sys.objects
	WHERE name=@tablename
	-------------------
	-- handle views
	-------------------
	IF (@type='V')
	BEGIN
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
			description varchar(2000),
			rank int
		)
		DECLARE @depends table (
			child varchar(32),
			parent varchar(32),
			type varchar(32)
		)
		--
		INSERT @depends
		SELECT distinct d.VIEW_NAME as child, 
				d.TABLE_NAME as parent, o.TABLE_TYPE as type
		FROM INFORMATION_SCHEMA.VIEW_COLUMN_USAGE d, 
			INFORMATION_SCHEMA.TABLES o
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
		SELECT m.tablename, m.name, m.unit, m.ucd, 
				m.enum, m.description, m.rank
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
			'','','',0
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
			description = m.description,
			rank = m.rank
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
			m.unit, m.ucd, m.description, m.rank
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
    RETURN
END
GO


--=================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fDocFunctionParams' )
	DROP FUNCTION fDocFunctionParams
GO
--
CREATE FUNCTION fDocFunctionParams(@functionname varchar(400))
-------------------------------------------------
--/H Return the parameters of a function
-------------------------------------------------
--/T Used by the auto-doc interface.
--/T<br>
--/T<samp>
--/T select * from dbo.fDocFunctionParams('fGetNearbyObjEq')
--/T</samp>
-------------------------------------------------
RETURNS @params TABLE (
	[name]		varchar(64),
	[type] 		varchar(32),
	[length]	int,
	[inout]		varchar(8),
	pnum		int
)
AS BEGIN
	---------------------------------
	-- get the objectid of DBObject,
	-- and its system type
	---------------------------------
	DECLARE @oid bigint, @type varchar(3);
	SELECT @oid=object_id, @type=type
	FROM sys.objects
	WHERE name=@functionname

	----------------------------
	-- get the input parameters
	----------------------------
	INSERT @params
	SELECT p.name, t.name as type, p.max_length as length,	
		'input', parameter_id as pnum
	FROM sys.objects o
	   JOIN sys.parameters p ON o.object_id = p.object_id
           JOIN sys.types t ON p.system_type_id = t.system_type_id
	WHERE 
	  o.object_id=@oid
	  and p.is_output != 'True'
	ORDER BY pnum
	  
	----------------------------
	-- get the output params
	----------------------------
	INSERT @params
	SELECT p.name, t.name as type, p.max_length as length, 
		'output', p.parameter_id as pnum
	FROM sys.objects o
	   JOIN sys.parameters p ON o.object_id = p.object_id
	   JOIN sys.types t ON p.system_type_id = t.system_type_id
	WHERE 
	  o.object_id=@oid
	  and p.is_output = 'True'

	----------------------------
	-- get the output columns
	----------------------------
	INSERT @params
	SELECT c.name, t.name as type, c.max_length as length, 
		'output', c.column_id as pnum
	FROM sys.objects o
	   JOIN sys.columns c ON o.object_id = c.object_id
	   JOIN sys.types t ON c.system_type_id = t.system_type_id
	WHERE 
	  o.object_id=@oid
	ORDER BY pnum
    RETURN
END
GO




--=================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spDocEnum' )
	DROP PROCEDURE spDocEnum
GO
--
CREATE PROCEDURE spDocEnum(@fieldname varchar(64))
------------------------------------------------------
--/H Display the properly rendered values from DataConstants 
--
--/T The parameter is the name of the enumerated field in DataConstants.
--/T The type and length is taken from the View of corresponding name.
--/T <br><samp>
--/T exec spDocEnum 'PhotoType'
--/T</samp>
------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @type varchar(32),
		@length int;
	DECLARE @cmd NVARCHAR(256)
	
	IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = @fieldname AND xtype = 'V')
	   BEGIN 
	      SET @cmd = 'SELECT * FROM ' + @fieldname + ' ORDER BY value';
	      EXEC (@cmd)
	   END
	ELSE   
	   BEGIN
	      SELECT	@type=t.name,
		   @length=c.length
	      FROM syscolumns c WITH (nolock), 
	 	   sysobjects o WITH (nolock),
		   systypes t WITH (nolock)
	      WHERE c.[id] = o.[id]
	        and o.xtype  = 'V'
	        and t.xtype  = c.xtype
	        and c.[name] = 'value'
	       and o.[name] = @fieldname;
	       --
	       SELECT	name, 
	 	   dbo.fEnum(value,@type, @length) as value,
		   description
	       FROM DataConstants WITH (nolock)
	      WHERE field=@fieldname
                AND name != ''
	      ORDER BY value
           END 
END
GO


--=================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'spDocKeySearch' )
	DROP PROCEDURE spDocKeySearch
GO
--
CREATE PROCEDURE spDocKeySearch (@key varchar(32), @option int)
-------------------------------------------------------
--/H Search Columns table for @key
-- ----------------------------------------------------
--/T @option sets the scope of the search:  
--/T <li>1 is Columns, 
--/T <li>2 is Constants,
--/T <li>4 is SDSSConstants, 
--/T <li>8 is DBObjects
--/T <br> 
--/T Returns those rows, which had a hit. They will 
--/T have a weblink to the parent table.
--/T <br>
--/T <samp>
--/T exec spDocKeySearch 'lupt', 1
--/T </samp>
-------------------------------------------------------
AS BEGIN
    --
    DECLARE @skey varchar(40);
    SET @skey = '%'+UPPER(@key)+'%';
    --
    IF (@option & 1)<>0
    BEGIN
		SELECT 	'<a href="description.asp?n='+c.tablename+'&t=U">'
				+c.tablename+'</a>' as tablename,
				c.name, c.unit, c.description
		FROM DBColumns c, DBObjects o
		WHERE c.tablename = o.name
		  and o.access='U' 
		  and (UPPER(c.name) LIKE @skey
			OR UPPER(c.description) LIKE @skey
			OR UPPER(c.unit) LIKE @skey
			)
    END
    --
    IF (@option & 2)<>0
    BEGIN
		SELECT '<a href="enum.asp?n='+field+'">'+field+'</a>' as field,
			name, value, description
		FROM DataConstants
		WHERE UPPER(name) LIKE @skey
	       OR UPPER(description) LIKE @skey

    END
    --
    IF (@option & 4) <> 0
    BEGIN
		SELECT name, value, unit, description
		FROM SDSSConstants
		WHERE (    UPPER(name) LIKE @skey
			    OR UPPER(description) LIKE @skey
			    OR UPPER(unit) LIKE @skey
			)
    END
    --
    IF (@option & 8)<>0
    BEGIN
		SELECT '<a href="description.asp?n='+name+'&t='+type+'">'
			+name+'</a>' as name, type, description
		FROM DBObjects
		WHERE access='U'
		  and (  UPPER(name) LIKE @skey
			  OR UPPER(description) LIKE @skey
			)
    END
    --
END
GO

------------------------------------------------------------------------
PRINT '[spDocSupport.sql]: DocSupport procs and functions created.'

