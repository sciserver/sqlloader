-- ============================================================================
-- Drop the pre-move APOGEE originals left behind by move_apogee_tables.sql.
--
-- This is the irreversible step, so it re-checks each pair before dropping
-- rather than trusting that the move went well:
--
--   1. dbo.<t>     exists, is on [SPEC], and has a clustered primary key
--   2. dbo.<t>_old exists
--   3. COUNT(*) matches between the two
--
-- Any table failing a check is skipped with a message and its _old copy is
-- left in place; the rest still proceed. Nothing is dropped on a mismatch.
--
-- Expected result: 10 tables dropped, ~25.6 GB returned to PRIMARY.
-- ============================================================================

SET NOCOUNT ON;
USE BestDR20;
GO

DECLARE @t sysname, @old sysname, @sql nvarchar(max);
DECLARE @src bigint, @dst bigint;
DECLARE @dropped int = 0, @skipped int = 0;

DECLARE c CURSOR LOCAL FAST_FORWARD FOR
SELECT name FROM (VALUES
    ('aspcap_apogee_star'),
    ('astro_nn_apogee_star'),
    ('astro_nn_apogee_visit'),
    ('astro_nn_dist_apogee_star'),
    ('apogee_net_apogee_star'),
    ('lite_all_star'),
    ('mwm_apogee_allstar'),
    ('mwm_apogee_allvisit'),
    ('the_payne_apogee_star'),
    ('the_payne_apogee_visit')
) v(name);

OPEN c;
FETCH NEXT FROM c INTO @t;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @old = @t + '_old';

    IF OBJECT_ID('dbo.' + QUOTENAME(@old)) IS NULL
    BEGIN
        PRINT 'SKIP ' + @t + ': dbo.' + @old + ' does not exist (already dropped?)';
        SET @skipped += 1;
    END
    ELSE IF NOT EXISTS (
        SELECT 1
        FROM sys.tables t
        JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id = 1
        JOIN sys.data_spaces fg ON i.data_space_id = fg.data_space_id
        WHERE t.name = @t AND fg.name = 'SPEC' AND i.is_primary_key = 1)
    BEGIN
        PRINT 'SKIP ' + @t + ': moved table is not on [SPEC] with a clustered PK -- NOT dropping ' + @old;
        SET @skipped += 1;
    END
    ELSE
    BEGIN
        SET @sql = N'SELECT @a = COUNT_BIG(*) FROM dbo.' + QUOTENAME(@t) + N';'
                 + N'SELECT @b = COUNT_BIG(*) FROM dbo.' + QUOTENAME(@old) + N';';
        EXEC sp_executesql @sql, N'@a bigint OUTPUT, @b bigint OUTPUT',
                           @a = @dst OUTPUT, @b = @src OUTPUT;

        IF @dst <> @src
        BEGIN
            PRINT 'SKIP ' + @t + ': row count mismatch (moved=' + CAST(@dst AS varchar(20))
                + ', old=' + CAST(@src AS varchar(20)) + ') -- NOT dropping ' + @old;
            SET @skipped += 1;
        END
        ELSE
        BEGIN
            SET @sql = N'DROP TABLE dbo.' + QUOTENAME(@old) + N';';
            EXEC sp_executesql @sql;
            PRINT 'dropped dbo.' + @old + ' (' + CAST(@src AS varchar(20)) + ' rows verified)';
            SET @dropped += 1;
        END
    END

    FETCH NEXT FROM c INTO @t;
END

CLOSE c;
DEALLOCATE c;

PRINT '';
PRINT 'Dropped: ' + CAST(@dropped AS varchar(10)) + '   Skipped: ' + CAST(@skipped AS varchar(10));
IF @skipped > 0
    PRINT 'Some _old tables were kept. Investigate the messages above before re-running.';
GO

-- Confirm PRIMARY no longer holds the old heaps.
SELECT fg.name AS filegroup_name,
       COUNT(DISTINCT t.object_id) AS tables,
       CAST(SUM(a.total_pages) * 8.0 / 1024 / 1024 AS decimal(10,2)) AS gb
FROM sys.tables t
JOIN sys.indexes i ON t.object_id = i.object_id AND i.index_id IN (0, 1)
JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN sys.allocation_units a ON p.partition_id = a.container_id
JOIN sys.data_spaces fg ON i.data_space_id = fg.data_space_id
WHERE fg.name IN ('PRIMARY', 'SPEC')
GROUP BY fg.name
ORDER BY fg.name;
GO
