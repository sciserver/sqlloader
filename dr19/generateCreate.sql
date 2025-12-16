-- Script to generate CREATE TABLE statements for tables listed in a control table
-- Assumes you have a table with the list of table names you want to script

DECLARE @TableList TABLE (TableName NVARCHAR(128))

declare @outtab table (sql varchar(max), tablename sysname)

-- Example: Insert your table names here, or replace with actual table query
--INSERT INTO @TableList VALUES 
--    ('YourTable1'),
--    ('YourTable2'),
--    ('YourTable3')
-- OR replace the above with: SELECT TableName FROM YourControlTable

insert into @TableList
select tablename from tables_sue
DECLARE @SQL NVARCHAR(MAX)
DECLARE @TableName NVARCHAR(128)
DECLARE @SchemaName NVARCHAR(128) = 'dbo' -- Default schema, adjust as needed

DECLARE table_cursor CURSOR FOR
SELECT TableName FROM @TableList

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @TableName

SET NOCOUNT ON

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Initialize SQL for this table
    SET @SQL = ''
    
    -- Add DROP TABLE IF EXISTS statement
    SET @SQL = @SQL + 'DROP TABLE IF EXISTS [BestDR19].[' + @SchemaName + '].[' + @TableName + ']' + ';' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
    
    SET @SQL = @SQL + 'CREATE TABLE Best[' + @SchemaName + '].[' + @TableName + '] (' + CHAR(13) + CHAR(10)
    
    -- Get column definitions using STRING_AGG (SQL Server 2017+) or FOR XML PATH for older versions
    DECLARE @ColumnDefs NVARCHAR(MAX) = ''
    
    SELECT @ColumnDefs = STRING_AGG(
        '    [' + sc.name + '] ' + 
        UPPER(st.name) + 
        CASE 
            WHEN st.name IN ('varchar', 'char', 'nvarchar', 'nchar') THEN 
                CASE WHEN sc.max_length = -1 THEN '(MAX)' 
                     WHEN st.name IN ('nvarchar', 'nchar') THEN '(' + CAST(sc.max_length/2 AS VARCHAR(10)) + ')'
                     ELSE '(' + CAST(sc.max_length AS VARCHAR(10)) + ')' 
                END
            WHEN st.name IN ('decimal', 'numeric') THEN 
                '(' + CAST(sc.precision AS VARCHAR(10)) + ',' + CAST(sc.scale AS VARCHAR(10)) + ')'
            WHEN st.name IN ('float') THEN 
                CASE WHEN sc.precision IS NOT NULL AND sc.precision < 53 THEN '(' + CAST(sc.precision AS VARCHAR(10)) + ')' ELSE '' END
            WHEN st.name IN ('datetime2', 'time', 'datetimeoffset') THEN 
                CASE WHEN sc.scale IS NOT NULL THEN '(' + CAST(sc.scale AS VARCHAR(10)) + ')' ELSE '' END
            ELSE ''
        END +
        CASE WHEN sc.is_nullable = 0 THEN ' NOT NULL' ELSE ' NULL' END +
        CASE WHEN dc.definition IS NOT NULL THEN ' DEFAULT ' + dc.definition ELSE '' END +
        CASE WHEN sc.is_identity = 1 THEN ' IDENTITY(' + CAST(ISNULL(ic.seed_value, 1) AS VARCHAR(10)) + ',' + CAST(ISNULL(ic.increment_value, 1) AS VARCHAR(10)) + ')' ELSE '' END,
        ',' + CHAR(13) + CHAR(10)
    ) WITHIN GROUP (ORDER BY sc.column_id)
    FROM sys.columns sc
    JOIN sys.tables t ON sc.object_id = t.object_id
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    JOIN sys.types st ON sc.user_type_id = st.user_type_id
    LEFT JOIN sys.default_constraints dc ON sc.default_object_id = dc.object_id
    LEFT JOIN sys.identity_columns ic ON sc.object_id = ic.object_id AND sc.column_id = ic.column_id
    WHERE t.name = @TableName
    AND s.name = @SchemaName
    
    
    SET @SQL = @SQL + @ColumnDefs + CHAR(13) + CHAR(10) + ')' + CHAR(13) + CHAR(10)
    
    -- Add primary key constraint if exists
    IF EXISTS (
        SELECT 1 FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
        WHERE tc.TABLE_NAME = @TableName 
        AND tc.TABLE_SCHEMA = @SchemaName
        AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
    )
    BEGIN
        DECLARE @PKName NVARCHAR(128)
        DECLARE @PKColumns NVARCHAR(MAX) = ''
        
        SELECT @PKName = tc.CONSTRAINT_NAME
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
        WHERE tc.TABLE_NAME = @TableName 
        AND tc.TABLE_SCHEMA = @SchemaName
        AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
        
        SELECT @PKColumns = @PKColumns + '[' + kcu.COLUMN_NAME + '],'
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
        WHERE kcu.TABLE_NAME = @TableName
        AND kcu.TABLE_SCHEMA = @SchemaName
        AND kcu.CONSTRAINT_NAME = @PKName
        ORDER BY kcu.ORDINAL_POSITION
        
        SET @PKColumns = LEFT(@PKColumns, LEN(@PKColumns) - 1) -- Remove last comma
        SET @SQL = @SQL + 'ALTER TABLE [' + @SchemaName + '].[' + @TableName + '] ADD CONSTRAINT [' + @PKName + '] PRIMARY KEY (' + @PKColumns + ') WITH (DATA_COMPRESSION=PAGE) ON SPEC' + CHAR(13) + CHAR(10)
    END
    
    SET @SQL = @SQL + CHAR(13) + CHAR(10) + 'GO' + CHAR(13) + CHAR(10)
    
    -- Option 1: Use SELECT instead of PRINT to output to Results grid
    --SELECT @SQL AS [CreateTableScript]--, @TableName AS [TableName]
    
    -- Option 2: Break up PRINT statements for long output (commented out)
    /*
    WHILE LEN(@SQL) > 8000
    BEGIN
        PRINT LEFT(@SQL, 8000)
        SET @SQL = SUBSTRING(@SQL, 8001, LEN(@SQL))
    END
    IF LEN(@SQL) > 0
        PRINT @SQL
	*/

	insert @outtab
	select @sql, @tablename
    
    
    FETCH NEXT FROM table_cursor INTO @TableName
END

CLOSE table_cursor
DEALLOCATE table_cursor

select * from @outtab