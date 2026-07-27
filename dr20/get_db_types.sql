-- Export actual column types from BestDR20 for use by pg2mos_descriptions.py.
-- Output: table_name|col_name|type_string  (one row per column, mos_* tables only)
--
-- Usage:
--   sqlcmd -S localhost -d BestDR20 -E -i get_db_types.sql -s "|" -W -h -1 -o actual_column_types.tsv
--
SET NOCOUNT ON;

SELECT
    OBJECT_NAME(c.object_id)                          AS table_name,
    c.name                                            AS col_name,
    CASE
        WHEN t.name IN ('varchar', 'char')
            THEN t.name + '(' +
                 CASE WHEN c.max_length = -1 THEN 'max'
                      ELSE CAST(c.max_length AS varchar(10)) END + ')'
        WHEN t.name IN ('nvarchar', 'nchar')
            THEN t.name + '(' +
                 CASE WHEN c.max_length = -1 THEN 'max'
                      ELSE CAST(c.max_length / 2 AS varchar(10)) END + ')'
        WHEN t.name IN ('varbinary', 'binary')
            THEN t.name + '(' +
                 CASE WHEN c.max_length = -1 THEN 'max'
                      ELSE CAST(c.max_length AS varchar(10)) END + ')'
        WHEN t.name IN ('decimal', 'numeric')
            THEN t.name + '(' + CAST(c.precision AS varchar(10))
                        + ',' + CAST(c.scale    AS varchar(10)) + ')'
        ELSE t.name
    END                                               AS type_string
FROM sys.columns  c
JOIN sys.types    t   ON c.user_type_id = t.user_type_id
JOIN sys.tables   tbl ON c.object_id    = tbl.object_id
WHERE tbl.name LIKE 'mos_%'
ORDER BY tbl.name, c.column_id;
