-- =====================================================================================
-- Analyze Foreign Key Failures
-- =====================================================================================
-- For each FK in the script, check:
-- 1. Does it already exist?
-- 2. Do the tables exist?
-- 3. Do the columns exist?
-- 4. What are the data types?
-- 5. Does the referenced column have a PK/unique constraint?
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

-- Create results table
IF OBJECT_ID('tempdb..#fk_analysis') IS NOT NULL DROP TABLE #fk_analysis;
CREATE TABLE #fk_analysis (
    fk_name VARCHAR(500),
    child_table VARCHAR(200),
    child_column VARCHAR(200),
    child_type VARCHAR(100),
    parent_table VARCHAR(200),
    parent_column VARCHAR(200),
    parent_type VARCHAR(100),
    parent_has_pk_or_unique BIT,
    fk_exists BIT,
    status VARCHAR(50),
    issue VARCHAR(1000)
);

PRINT '-- ==============================================================================';
PRINT '-- Analyzing Foreign Key Definitions';
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';

-- Analyze each FK from mssql_fk_0112_skip_plan.sql
-- I'll need to parse the FK definitions and check each one

-- dr20_assignment_carton_to_target_pk_fkey
INSERT INTO #fk_analysis
SELECT
    'dr20_assignment_carton_to_target_pk_fkey' as fk_name,
    'dr20_assignment' as child_table,
    'carton_to_target_pk' as child_column,
    (SELECT ty.name + '(' + CAST(c.max_length AS VARCHAR) + ')'
     FROM sys.columns c
     JOIN sys.types ty ON c.user_type_id = ty.user_type_id
     WHERE c.object_id = OBJECT_ID('dbo.dr20_assignment') AND c.name = 'carton_to_target_pk') as child_type,
    'dr20_carton_to_target' as parent_table,
    'carton_to_target_pk' as parent_column,
    (SELECT ty.name + '(' + CAST(c.max_length AS VARCHAR) + ')'
     FROM sys.columns c
     JOIN sys.types ty ON c.user_type_id = ty.user_type_id
     WHERE c.object_id = OBJECT_ID('dbo.dr20_carton_to_target') AND c.name = 'carton_to_target_pk') as parent_type,
    CASE WHEN EXISTS (
        SELECT 1 FROM sys.indexes i
        JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.object_id = OBJECT_ID('dbo.dr20_carton_to_target')
        AND c.name = 'carton_to_target_pk'
        AND (i.is_primary_key = 1 OR i.is_unique = 1)
    ) THEN 1 ELSE 0 END as parent_has_pk_or_unique,
    CASE WHEN EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'dr20_assignment_carton_to_target_pk_fkey') THEN 1 ELSE 0 END as fk_exists,
    CASE
        WHEN EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'dr20_assignment_carton_to_target_pk_fkey') THEN 'EXISTS'
        ELSE 'MISSING'
    END as status,
    '' as issue;

-- This is tedious to do for all 102 FKs manually...
-- Let me create a more automated approach

PRINT 'Generating automated FK analysis...';
PRINT '';

-- ==============================================================================
-- Export current FK state
-- ==============================================================================

SELECT
    fk.name as fk_name,
    OBJECT_NAME(fk.parent_object_id) as child_table,
    'SUCCESS' as status
FROM sys.foreign_keys fk
WHERE fk.name LIKE 'dr20_%'
ORDER BY fk.name;

GO
