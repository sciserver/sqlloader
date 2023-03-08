/*
Copyright 2023 Johns Hopkins University

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/


USE xmatchdb

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create PMTS table

IF EXISTS (SELECT * FROM sys.objects
WHERE object_id = OBJECT_ID(N'pmts') AND type in (N'U'))
	DROP TABLE pmts
GO


CREATE TABLE pmts(
--/H XMatch parameters
--/T These parameters defines a Zone schema defined by a particular zone height.
	theta float not null, --/D Value of theta
	zone_height float not null, --/D zone height
	ra_lo float not null, --/D minimum value of Right Ascension to be considered in the search
	ra_hi float not null, --/D maximum value of Right Ascension to be considered in the search
)
GO
INSERT Pmts 
--VALUES (7.0 / 3600.0, 7.1 / 3600.0, 0, 360)
VALUES (7.0 / 3600.0, 7.0 / 3600.0, 0, 360)
GO	


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create fAlpha function


IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'fAlpha') 
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION fAlpha
GO

CREATE FUNCTION fAlpha(@theta float, @dec float)
--/H Returns the value of alpha at each declination (which links to a zone), and a search radius theta
--/U ------------------------------------------------------------
--/T Parameters:<br>
--/T <li> @theta float: value of theta in degrees
--/T <li> @dec float: value of declination in degrees
--/T <li> returns alpha float: value of alpha (improved search radius)
--/T <br><samp> select dbo.fAlpha(0.1, 40) as alpha </samp>
--/T <br> returns 0.130540775596751
RETURNS float
AS BEGIN 
	IF abs(@dec)+@theta > 89.9 return 180
	RETURN(degrees(abs(atan(
	sin(radians(@theta)) 
	/ sqrt(abs(
		cos(radians(@dec-@theta)) * cos(radians(@dec+@theta)) 
	))
	))))
END
GO


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create DEFS table


IF  EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'Def') AND type in (N'U'))
	DROP TABLE Def
GO

CREATE TABLE Def (
--/H ZOnes defininitions
--/T Contains the definitions of all zones.
	ZoneID int NOT NULL,
	DecMin float NOT NULL,
	DecMax float NOT NULL,
	Alpha float NOT NULL
) 
GO
ALTER TABLE Def ADD CONSTRAINT PK_zone_Def PRIMARY KEY (ZoneID)
GO

DECLARE @zoneHeight float, @theta float;
SELECT @zoneHeight=zone_height FROM Pmts
SELECT @theta=theta FROM Pmts

DECLARE @maxZone bigint, @minZone bigint, @zoneDec float;
SET NOCOUNT ON

SET @minZone = 0;
SET @maxZone =  floor(180.0/@zoneHeight);

WHILE @minZone <= @maxZone
BEGIN   
	SET @zoneDec = @minZone * @zoneHeight - 90;
	INSERT Def VALUES (@minZone, @zoneDec, @zoneDec+@zoneHeight, -1)
	SET @minZone = @minZone + 1
END
	
UPDATE Def
SET alpha = CASE WHEN ABS(decMax) < ABS(decMin)
THEN dbo.fAlpha(@theta, decMin - @zoneHeight / 100)
ELSE dbo.fAlpha(@theta, decMax + @zoneHeight / 100)
END

SET NOCOUNT OFF

GO	



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create sp_getDataParts procedure



if exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'sp_getDataParts'))							 
												drop procedure sp_getDataParts
go
CREATE PROCEDURE sp_getDataParts @table sysname, @do_include_server BIT = 1, @server_name sysname OUTPUT, @db_name sysname OUTPUT, @schema_name sysname OUTPUT, @table_name sysname OUTPUT
----------------------------------------------------------------
--/H Returns the 4 parts defining a sys object name:  server.database.schema.table
--/U ------------------------------------------------------------
--/T Parameters:<br>
--/T <li> @table sysname: can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @do_include_server bit: whether to output the server name or not.
--/T <li> @server_name sysname OUTPUT: name of database server, or empty string if not defined or @do_include_server=0
--/T <li> @db_name sysname OUTPUT: name of database, or empty string if not defined.
--/T <li> @schema_name sysname OUTPUT: name of database schema, or 'dbo' if not defined.
--/T <li> @table_name sysname OUTPUT: name of database table, or empty string of not defined.
AS BEGIN

	SET @table_name  = PARSENAME(@table, 1)
	SET @schema_name = PARSENAME(@table, 2)
	SET @db_name	 = PARSENAME(@table, 3)
	SET @server_name = PARSENAME(@table, 4)

	IF COALESCE(@server_name, @db_name, @schema_name, @table_name) IS NULL
	BEGIN
		
		SET @db_name  = N''
		SET @schema_name  = N'dbo'
		SET @table_name  = N''
		SET @server_name = N''
		RETURN
	END

	IF @do_include_server = 1 -- Expects @table = server.database.schema.table 
		BEGIN
			SET @table_name  = COALESCE(@table_name, N'')
			SET @schema_name = COALESCE(@schema_name, N'dbo')
			SET @db_name	 = COALESCE(@db_name, N'')
			SET @server_name = COALESCE(@server_name, N'')

		END
	ELSE	-- Expects @table=database.schema.table or @table=database.table
		BEGIN
			SET @server_name = N''
			-- Case @table=table
			IF COALESCE(@db_name, @schema_name) is null
			BEGIN 
				SET @db_name = N''
				SET @schema_name = N'dbo'
			END

			-- Case @table=database.table (assuming this interpretation takes precedence over @table=schema.table)
			IF @db_name IS NULL AND @schema_name IS NOT NULL
			BEGIN 
				SET @db_name = @schema_name
				SET @schema_name = N'dbo'
			END

			-- Case when @table=database..table
			IF @schema_name IS NULL
				SET @schema_name = N'dbo'

		END
	RETURN 
END
GO


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create sp_hascolumn procedure


if exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'sp_hascolumn'))
												drop procedure sp_hascolumn
go
CREATE PROCEDURE sp_hascolumn(@table sysname, @column sysname, @has_column bit OUTPUT)
----------------------------------------------------------------
--/H Returns whether or not a table or view has a particular column.
--/U ------------------------------------------------------------
--/T Parameters:<br>
--/T <li> @table sysname: can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @column sysname: name of column
--/T <li> @has_column bit OUTPUT: has the value of 1 if the column is in @table, and 0 otherwise,
AS BEGIN
	SET NOCOUNT ON
	declare @server_name sysname,
			@db_name sysname,
			@schema_name sysname,
			@table_name sysname, 
			@temp_table_name sysname

	EXECUTE sp_getDataParts @table=@table, @do_include_server=0, @server_name=@server_name OUTPUT, @db_name=@db_name OUTPUT, @schema_name=@schema_name OUTPUT, @table_name=@table_name OUTPUT 

	SET @column = parsename(@column, 1) -- unquotes the column name, if entered with quotes.

	IF @server_name != ''
		SET @server_name =  QUOTENAME(@server_name)
	IF @db_name != ''
		SET @db_name =  QUOTENAME(@db_name)

	SET @temp_table_name = 'tempdb.' + QUOTENAME(@schema_name) + '.' + QUOTENAME(@table_name)

	DECLARE @sql nvarchar(max) = N'
	SELECT @numrows = count(*) FROM (
		SELECT c.name as col_name
		FROM ' + @server_name + N'.' + @db_name + N'.sys.tables t 
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.columns c ON t.object_id = c.object_id
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = @table_name AND s.name = @schema_name
		AND c.name = @column
		UNION ALL
		SELECT c.name as col_name
		FROM ' + @server_name + N'.' + @db_name + N'.sys.views t 
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.columns c ON t.object_id = c.object_id
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = @table_name AND s.name = @schema_name
		AND c.name = @column
		UNION ALL
		SELECT c.name as col_name
		FROM tempdb.sys.tables t 
		JOIN tempdb.sys.columns c ON t.object_id = c.object_id
		WHERE t.object_id = OBJECT_ID(@temp_table_name)
		AND c.name = @column
		UNION ALL
		SELECT c.name as col_name
		FROM tempdb.sys.views t 
		JOIN tempdb.sys.columns c ON t.object_id = c.object_id
		WHERE t.object_id = OBJECT_ID(@temp_table_name)
		AND c.name = @column
	) as a'
	
	--PRINT @sql
	DECLARE @numrows BIGINT
	EXECUTE sp_executesql @sql, N'@table_name sysname, @schema_name sysname, @temp_table_name sysname, @column sysname, @numrows bigint OUTPUT', 
							      @table_name=@table_name, @schema_name=@schema_name, @temp_table_name=@temp_table_name, @column=@column, @numrows=@numrows OUTPUT

	if @numrows > 0
	begin
		SET @has_column = 1;
	end
	else
	begin 
		SET @has_column = 0;
	end
END
GO



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create sp_columntype procedure


if exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'sp_columntype'))
	drop procedure sp_columntype
go
CREATE PROCEDURE sp_columntype(@table sysname, @column sysname, @col_type sysname OUTPUT, @col_length BIGINT OUTPUT, @col_precision BIGINT OUTPUT, @col_scale BIGINT OUTPUT)
----------------------------------------------------------------
--/H Gets the type of a particular column in a table or view.
--/U ------------------------------------------------------------
--/T Parameters:<br>
--/T <li> @table sysname: can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @column sysname: name of column.
--/T <li> @col_type sysname OUTPUT: type of column
--/T <li> @col_length BIGINT OUTPUT: column length
--/T <li> @col_precision BIGINT OUTPUT: column precision
--/T <li> @col_scale BIGINT OUTPUT: column scale
AS BEGIN
	SET NOCOUNT ON
	declare @server_name sysname,
			@db_name sysname,
			@schema_name sysname,
			@table_name sysname, 
			@temp_table_name sysname

	EXECUTE sp_getDataParts @table=@table, @do_include_server=0, @server_name=@server_name OUTPUT, @db_name=@db_name OUTPUT, @schema_name=@schema_name OUTPUT, @table_name=@table_name OUTPUT 

	SET @column = parsename(@column, 1) -- unquotes the column name, if entered with quotes.

	IF @server_name != ''
		SET @server_name =  QUOTENAME(@server_name)
	IF @db_name != ''
		SET @db_name =  QUOTENAME(@db_name)

	SET @temp_table_name = 'tempdb.' + QUOTENAME(@schema_name) + '.' + QUOTENAME(@table_name)


	DECLARE @sql nvarchar(max) = N'
	SELECT @col_type=col_type, @col_length=col_length, @col_precision=col_precision, @col_scale=col_scale FROM (
		SELECT y.name as col_type, c.max_length as col_length, c.precision as col_precision, c.scale as col_scale
		FROM ' + @server_name + N'.' + @db_name + N'.sys.tables t 
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.columns c ON t.object_id = c.object_id
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.types y ON y.user_type_id = c.user_type_id
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = @table_name AND s.name = @schema_name
		AND c.name = @column
		UNION ALL
		SELECT y.name as col_type, c.max_length as col_length, c.precision as col_precision, c.scale as col_scale
		FROM ' + @server_name + N'.' + @db_name + N'.sys.views t 
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.columns c ON t.object_id = c.object_id
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.types y ON y.user_type_id = c.user_type_id
		JOIN ' + @server_name + N'.' + @db_name + N'.sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.name = @table_name AND s.name = @schema_name
		AND c.name = @column
		UNION ALL
		SELECT y.name as col_type, c.max_length as col_length, c.precision as col_precision, c.scale as col_scale
		FROM tempdb.sys.tables t 
		JOIN tempdb.sys.columns c ON t.object_id = c.object_id
		JOIN tempdb.sys.types y ON y.user_type_id = c.user_type_id
		WHERE t.object_id = OBJECT_ID(@temp_table_name)
		AND c.name = @column
		UNION ALL
		SELECT y.name as col_type, c.max_length as col_length, c.precision as col_precision, c.scale as col_scale
		FROM tempdb.sys.views t 
		JOIN tempdb.sys.columns c ON t.object_id = c.object_id
		JOIN tempdb.sys.types y ON y.user_type_id = c.user_type_id
		WHERE t.object_id = OBJECT_ID(@temp_table_name)
		AND c.name = @column
	) as a'
	
	--PRINT @sql
	DECLARE @numrows BIGINT
	EXECUTE sp_executesql @sql, N'@table_name sysname, @schema_name sysname, @temp_table_name sysname, @column sysname, @col_type nvarchar(max) OUTPUT, @col_length BIGINT OUTPUT, @col_precision BIGINT OUTPUT, @col_scale BIGINT OUTPUT', 
								@table_name=@table_name, @schema_name=@schema_name, @temp_table_name=@temp_table_name, @column=@column, @col_type=@col_type OUTPUT, @col_length=@col_length OUTPUT, @col_precision=@col_precision OUTPUT, @col_scale=@col_scale OUTPUT
END
GO




----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create sp_buildcatalog procedure




if exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'sp_buildcatalog'))
	drop procedure sp_buildcatalog
go
CREATE PROCEDURE sp_buildcatalog(@table sysname, @zoneHeight float = 7, @id_col sysname = 'objid', @ra_col sysname = 'ra', @dec_col sysname = 'dec', @max_catalog_rows BIGINT = null)
----------------------------------------------------------------
--/H Returns a modified version of an input table, in a format ready to be used by the sp_xmatch procedure.
--/T The input table is expected to have at least a unique identifier column, as well as an RA (Right Ascention) and Dec (Declination) columns.
--/T If the columns defining the cartesian coordinates an object (must be named 'cx', 'cy', and 'cz') are missing, then this procedure will calculate and add them.
--/T If the column defining the zone ID (must be named 'zoneid') is missing, then this procedure will calculate and add it by using the value of @zoneHeight.
--/U ------------------------------------------------------------
--/T Parameters:<br>
--/T <li> @table sysname: input table. Can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @zoneHeight float: If @table does not contain a column named 'zoneid', then it will calculate this column using zones of this height (in units of arcsec). Takes a default value of 7 arsec.
--/T <li> @id_col sysname: name of column that uniquely identifies an object. Defaults to 'objid'.
--/T <li> @ra_col sysname: name of column containing the RA (Right Ascension) value of an object. Defaults to 'ra'.
--/T <li> @dec_col sysname: name of column containing the Dec (Declination) value of an object. Defaults to 'dec'.
--/T <li> @max_catalog_rows bigint: default value of null. If set, the procedure will return the TOP @max_catalog_rows rows, with no special ordering.
AS BEGIN

	SET NOCOUNT ON
	
	declare @server_name sysname,
			@db_name sysname,
			@schema_name sysname,
			@table_name sysname,
			@data_source sysname

	EXECUTE sp_getDataParts @table=@table, @do_include_server=0, @server_name=@server_name OUTPUT, @db_name=@db_name OUTPUT, @schema_name=@schema_name OUTPUT, @table_name=@table_name OUTPUT


	SET @table_name = QUOTENAME(@table_name)
	if @db_name != N''
		SET @db_name = QUOTENAME(@db_name)
	if @server_name != N''
		SET @server_name = QUOTENAME(@server_name)
	if @schema_name != N'dbo'
		SET @schema_name = QUOTENAME(@schema_name)


	SET @data_source = @server_name + N'.' +   @db_name + N'.' + @schema_name + N'.' + @table_name
	SET @id_col = QUOTENAME(PARSENAME(@id_col, 1))
	SET @ra_col = QUOTENAME(PARSENAME(@ra_col, 1))
	SET @dec_col = QUOTENAME(PARSENAME(@dec_col, 1))

	--DECLARE @zoneHeight float, @ra_lo float, @ra_hi float;
	--SELECT @zoneHeight = Value FROM Pmts WHERE Keyword = 'ZoneHeight';

	DECLARE @has_column bit
	EXECUTE sp_hascolumn @table=@table, @column=@id_col, @has_column=@has_column OUTPUT
	if @has_column = 0
		BEGIN
			RAISERROR('Input table must have an ID column.',16,1)
			RETURN
		END
	EXECUTE sp_hascolumn @table=@table, @column=@ra_col, @has_column=@has_column OUTPUT
	if @has_column = 0
		BEGIN
			RAISERROR('Input table must have an RA column.',16,1)
			RETURN
		END
	EXECUTE sp_hascolumn @table=@table, @column=@dec_col, @has_column=@has_column OUTPUT
	if @has_column = 0
		BEGIN
			RAISERROR('Input table must have a Dec column.',16,1)
			RETURN
		END

	declare @has_columns BIT = 1
	DECLARE @has_zoneid BIT = 1
	DECLARE @has_cxcycz BIT = 1


	EXECUTE sp_hascolumn @table=@table, @column='cx', @has_column=@has_column OUTPUT
	SET @has_columns = @has_column
	EXECUTE sp_hascolumn @table=@table, @column='cy', @has_column=@has_column OUTPUT
	SET @has_columns = @has_columns & @has_column
	EXECUTE sp_hascolumn @table=@table, @column='cz', @has_column=@has_column OUTPUT
	SET @has_cxcycz = @has_columns & @has_column
	EXECUTE sp_hascolumn @table=@table, @column='zoneid', @has_column=@has_zoneid OUTPUT


	DECLARE @sql nvarchar(max)
	DECLARE @select_top nvarchar(max) = N'SELECT '
	if @max_catalog_rows is not null
		SET @select_top = @select_top + N' TOP ' + CAST(@max_catalog_rows as nvarchar) + N' '

	SET @sql = N'DECLARE @d2r float = PI()/180.0; ' + @select_top 
	IF @has_zoneid = 1
		SET @sql = @sql + N'zoneid, ' 
	ELSE
		SET @sql = @sql + 'CONVERT(INT,FLOOR((' + @dec_col + N' + 90.0)/' + CAST(@zoneHeight as nvarchar) + N')) as zoneid, '

	SET @sql = @sql + @id_col + N' as objid, ' +  @ra_col + N' as ra, ' + @dec_col + N' as dec, '

	IF @has_cxcycz = 1
		SET @sql = @sql + N' cx, cy, cz '
	ELSE
		SET @sql = @sql + N' COS(' + @dec_col + N'*@d2r)*COS(' + @ra_col + N'*@d2r) as cx, 
							 COS(' + @dec_col + N'*@d2r)*SIN(' + @ra_col + N'*@d2r) as cy, 
							 SIN(' + @dec_col + N'*@d2r) as cz '

	SET @sql = @sql + N'FROM ' + @data_source + N' WHERE ' + @id_col + N' is not null ORDER BY zoneid, ra, objid;'


	--print @sql
	EXECUTE sp_executesql @sql
END
GO




----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create sp_SetCatalogIdColumn procedure



if exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'sp_SetCatalogIdColumn'))
	drop procedure sp_SetCatalogIdColumn
go
CREATE PROCEDURE sp_SetCatalogIdColumn(@target_table sysname, @reference_table sysname, @reference_id_col sysname = 'objid')
----------------------------------------------------------------
--/H Changes the type of the unique identifier column (must be named 'objid') in a target table, and set it equal to the type of a column in a refernece table.
--/U ------------------------------------------------------------
--/T Parameters:<br>
--/T <li> @target_table sysname: target table. Can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @reference_table sysname: reference table. Can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @reference_id_col sysname: name of column in the refernce table. Takes the default value 'objid'.
AS BEGIN
	SET NOCOUNT ON
	DECLARE @sql NVARCHAR(max)
	DECLARE @col_type NVARCHAR(max)
	DECLARE @col_length BIGINT
	DECLARE @col_precision BIGINT
	DECLARE @col_scale BIGINT
	EXECUTE sp_columntype @table=@reference_table, @column=@reference_id_col, @col_type=@col_type OUTPUT, @col_length=@col_length OUTPUT, @col_precision=@col_precision OUTPUT, @col_scale=@col_scale OUTPUT

	declare @server_name sysname,
			@db_name sysname,
			@schema_name sysname,
			@table_name sysname

	EXECUTE sp_getDataParts @table=@target_table, @do_include_server=0, @server_name=@server_name OUTPUT, @db_name=@db_name OUTPUT, @schema_name=@schema_name OUTPUT, @table_name=@table_name OUTPUT 

	-- Force table to be a local temp table:
	IF @table_name NOT LIKE '#%'
	BEGIN
		RAISERROR('TABLE TO ALTER SHOULD BE TEMP TABLE', 16, 1)
		RETURN
	END

	SET @table_name = QUOTENAME(@table_name)
	if @db_name != N''
		SET @db_name = QUOTENAME(@db_name)
	if @server_name != N''
		SET @server_name = QUOTENAME(@server_name)
	if @schema_name != N'dbo'
		SET @schema_name = QUOTENAME(@schema_name)


	
	SET @table_name = @server_name + N'.' +   @db_name + N'.' + @schema_name + N'.' + @table_name



	if @col_type like N'%char%' or @col_type = N'text' or @col_type like N'%binary%'  
		BEGIN
			SET @sql = N'ALTER TABLE ' + @table_name + N' ALTER COLUMN objid @col_type(@col_length) NOT NULL'
		END
	ELSE
		BEGIN
			if @col_type = N'numeric' or @col_type = N'decimal'
				BEGIN
					SET @sql = N'ALTER TABLE ' + @target_table + N' ALTER COLUMN objid @col_type(@col_precision, @col_scale) NOT NULL'
				END
			ELSE
				BEGIN
					SET @sql = N'ALTER TABLE ' + @target_table + N' ALTER COLUMN objid ' + @col_type + N' NOT NULL'
				END
		END

	SET @sql = REPLACE(@sql, N'@col_length', @col_length)
	SET @sql = REPLACE(@sql, N'@col_type', @col_type)
	SET @sql = REPLACE(@sql, N'@col_scale', @col_scale)
	SET @sql = REPLACE(@sql, N'@col_precision', @col_precision)
	--PRINT(@sql)
	EXECUTE sp_executesql @sql
END


GO



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create sp_xmatch procedure

if exists (select * from sys.objects WHERE object_id = OBJECT_ID(N'sp_xmatch'))
	drop procedure sp_xmatch
go
CREATE PROCEDURE sp_xmatch
	@table1 sysname, @table2 sysname, @radius float = 10, 
	@id_col1 sysname = 'objid', @id_col2 sysname = 'objid', 
	@ra_col1 sysname = 'ra', @ra_col2 sysname = 'ra', 
	@dec_col1 sysname = 'dec', @dec_col2 sysname = 'dec',
	@max_catalog_rows1 bigint = null, @max_catalog_rows2 bigint = null
----------------------------------------------------------------
--/H Runs a 2-dimensional spatial crossmatch between 2 catalogs of objects, using the Zones algorithm. Returns a table with the object IDs and angular separation between matching objects. 
--/U ------------------------------------------------------------
--/T The 2 catalogs can be tables or views, and are expected to have at least a unique identifier column, as well as an RA (Right Ascention) and Dec (Declination) columns.
--/T For each catalog, if the columns defining the cartesian coordinates an object (must be named 'cx', 'cy', and 'cz') are missing, then the code will calculate them on the fly.
--/T If the column defining the zone ID (must be named 'zoneid') is missing, then the code will calculate it on the fly, based on the value of the search radius @radius around each object.
--/T Parameters:<br>
--/T <li> @table1 sysname: name of first input catalog. Can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @table2 sysname: name of first input catalog. Can be any of these formats: 'server.database.schema.table', 'database.schema.table', or 'database.table'
--/T <li> @radius float: search radius around each object, in arcseconds. Takes a default value of 10 arcseconds.
--/T <li> @id_col1 sysname: name of the column defining a unique object identifier in catalog @table1. Takes a default value of 'objid'.
--/T <li> @id_col2 sysname: name of the column defining a unique object identifier in catalog @table2. Takes a default value of 'objid'.
--/T <li> @ra_col1 sysname: name of the column containing the Right Ascention (RA) of objects in catalog @table1. Takes a default value of 'ra'.
--/T <li> @ra_col2 sysname: name of the column containing the Right Ascention (RA) of objects in catalog @table2. Takes a default value of 'ra'.
--/T <li> @dec_col1 sysname: name of the column containing the Declination (Dec) of objects in catalog @table1. Takes a default value of 'dec'.
--/T <li> @dec_col2 sysname: name of the column containing the Declination (Dec) of objects in catalog @table2. Takes a default value of 'dec'.
--/T <li> @max_catalog_rows1 bigint: default value of null. If set, the procedure will consider the TOP @max_catalog_rows1 rows in catalog @table1, with no special ordering.
--/T <li> @max_catalog_rows2 bigint: default value of null. If set, the procedure will consider the TOP @max_catalog_rows2 rows in catalog @table2, with no special ordering.
--/T <li> RETURNS TABLE (id1, id2, sep) where
--/T <li> id1 and id2 are the unique object iudentifier columns in @table1 and @table2, respectively, and sep is the angular separation between objetcs in arseconds.

AS BEGIN

	SET NOCOUNT ON 

	DECLARE @zoneHeight float, @ra_lo float, @ra_hi float;
	SELECT @zoneHeight=zone_height, @ra_lo=ra_lo, @ra_hi=ra_hi FROM pmts as p



	DECLARE @sql NVARCHAR(MAX);

	DECLARE @col_type NVARCHAR(max)
	DECLARE @col_length BIGINT
	DECLARE @col_precision BIGINT
	DECLARE @col_scale BIGINT


	--IF OBJECT_ID('tempdb..#Table1') IS NOT NULL DROP TABLE #Table1
	CREATE TABLE #Table1 (
	  ZoneID int not null,
	  ObjID bigint not null,
	  RA float not null,
	  Dec float not null,
	  Cx float not null,
	  Cy float not null,
	  Cz float not null,
	)
	CREATE UNIQUE CLUSTERED INDEX PK_zone_Table1 ON #Table1(ZoneID, RA, ObjID);
	--ALTER TABLE #Table1 ADD CONSTRAINT PK_zone_Table1 PRIMARY KEY ( ZoneID, RA, ObjID )
	EXECUTE sp_SetCatalogIdColumn @target_table='#Table1', @reference_table=@table1, @reference_id_col=@id_col1

	--IF OBJECT_ID('tempdb..#Table2') IS NOT NULL DROP TABLE #Table2
	CREATE TABLE #Table2 (
	  ZoneID int not null,
	  ObjID bigint not null,
	  RA float not null,
	  Dec float not null,
	  Cx float not null,
	  Cy float not null,
	  Cz float not null,
	)
	CREATE UNIQUE CLUSTERED INDEX PK_zone_Table2 ON #Table2(ZoneID, RA, ObjID);
	--ALTER TABLE #Table2 ADD CONSTRAINT PK_zone_Table2 PRIMARY KEY ( ZoneID, RA, ObjID )
	EXECUTE sp_SetCatalogIdColumn @target_table='#Table2', @reference_table=@table2, @reference_id_col=@id_col2

	
	INSERT INTO #Table1
	EXECUTE sp_buildcatalog @table=@table1, @zoneHeight=@zoneHeight, @id_col=@id_col1, @ra_col=@ra_col1, @dec_col=@dec_col1, @max_catalog_rows=@max_catalog_rows1
	--PRINT 'Table Table1 created with '+cast(@@rowcount as varchar(15))+' rows in '+db_name()+' at ' + cast(getdate() as varchar(22))
	INSERT #Table1 WITH (TABLOCK)
	SELECT t.ZoneID, ObjID, RA-360, Dec, Cx,Cy,Cz
	FROM #Table1 t 
	JOIN Def d on d.ZoneID = t.ZoneID
	WHERE RA + d.Alpha > 360
	--PRINT 'Added ' + cast(@@rowcount as varchar(15)) + ' wraparound to Table1 in '+db_name()+' at ' + cast(getdate() as varchar(22))
  
	INSERT INTO #Table2
	EXECUTE sp_buildcatalog @table=@table2, @zoneHeight=@zoneHeight, @id_col=@id_col2, @ra_col=@ra_col2, @dec_col=@dec_col2, @max_catalog_rows=@max_catalog_rows2
	--PRINT 'Table Table2 created with '+cast(@@rowcount as varchar(15))+' rows in '+db_name()+' at ' + cast(getdate() as varchar(22))
	INSERT #Table2 WITH (TABLOCK)
	SELECT t.ZoneID, ObjID, RA-360, Dec, Cx,Cy,Cz
	FROM #Table2 t 
	JOIN Def d on d.ZoneID = t.ZoneID
	WHERE RA + d.Alpha > 360
	--PRINT 'Added ' + cast(@@rowcount as varchar(15)) + ' wraparound to Table2 in '+db_name()+' at ' + cast(getdate() as varchar(22))


	DECLARE @theta float = @radius/3600

	CREATE TABLE #def(  
	ZoneID int primary key NOT NULL,
	DecMin float NOT NULL,
	DecMax float NOT NULL,
	Alpha float NOT NULL
	)

	INSERT #def
	select zoneid, decmin, decmax, 
		CASE WHEN ABS(decMax) < ABS(decMin)
		THEN dbo.fAlpha(@theta, decMin - @zoneHeight / 100)  -- overshoot a bit
		ELSE dbo.fAlpha(@theta, decMax + @zoneHeight / 100) 
		END
	from def
	order by zoneid



	--IF OBJECT_ID('tempdb..#Link') IS NOT NULL DROP TABLE #Link
	CREATE TABLE #Link (
	  ZoneID1	int not null,
	  ZoneID2	int not null,
	  Alpha2	float not null
	)
	CREATE UNIQUE CLUSTERED INDEX PK_zone_Link ON #Link(ZoneID1, ZoneID2);
	--ALTER TABLE #Link ADD CONSTRAINT PK_zone_Link PRIMARY KEY ( ZoneID1, ZoneID2 )
	

	DECLARE @num_zones int = ceiling(@theta/@zoneheight)

	INSERT #Link WITH (TABLOCK)
	SELECT Z1.zoneid, Z2.zoneid, d2.alpha
	FROM (SELECT DISTINCT ZoneID FROM #Table1) z1 		
	JOIN (SELECT DISTINCT ZoneID FROM #Table2) z2 
	ON Z2.zoneid between Z1.zoneid - @num_zones and Z1.zoneid + @num_zones
	JOIN #Def d2 ON d2.ZoneID = Z2.ZoneID
	--WHERE d2.radius_id = @radius_id
	ORDER BY 1, 2
	

	--PRINT 'Table zone.Link created with '+cast(@@rowcount as varchar(15)) +' rows in '+db_name()+' at ' + cast(getdate() as varchar(22))



	update statistics #table1
	update statistics #table2
	update statistics #link
	--go

	--PRINT 'Updated stats in '+db_name()+' at ' + cast(getdate() as varchar(22))

  
  
	DECLARE @dist2 float = 4 * power(sin(radians(@theta/2)), 2);
	
	SELECT t1.objid as id1, t2.objid as id2, 
	--SELECT t1.objid as id1, t1.ra as ra1, t1.dec as dec1, t2.objid as id2, t2.ra as ra2, t2.dec as dec2,
  
	  60*120*degrees(asin(sqrt(
		(t1.cx-t2.cx) * (t1.cx-t2.cx) 
		+ (t1.cy-t2.cy) * (t1.cy-t2.cy) 
		+ (t1.cz-t2.cz) * (t1.cz-t2.cz)
	  )/2)) sep 
	--INTO #Match
	FROM #Table1 t1 
	INNER LOOP JOIN #Link zz on zz.zoneid1 = t1.zoneid 
	INNER LOOP JOIN #Table2 t2 on (
		zz.zoneid2 = t2.zoneid 
		and t2.ra between t1.ra - zz.Alpha2 and t1.ra + zz.Alpha2
		and t2.dec between t1.dec - @theta and t1.dec + @theta 
		and ( t1.RA >= 0 or t2.RA >= 0 )
	)
	WHERE (t1.cx-t2.cx) * (t1.cx-t2.cx)
	  + (t1.cy-t2.cy) * (t1.cy-t2.cy)
	  + (t1.cz-t2.cz) * (t1.cz-t2.cz) < @dist2
	--ORDER BY t1.objid, t2.objid

	--PRINT 'Created table zone.Match with '+ cast(@@rowcount as varchar(15))+' rows in '+db_name()+' at ' + cast(getdate() as varchar(22))
	--select * from #match

END
GO


