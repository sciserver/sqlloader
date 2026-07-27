-- =====================================================================================
-- Create Production minidb_dr20_v2 Database on D: Drive
-- =====================================================================================
-- Strategy:
--   1. Create DB with MINIDB filegroup (4 files for RAID-6 parallelism)
--   2. Create tables (empty heaps in MINIDB filegroup)
--   3. Add primary keys (creates clustered indexes with PAGE compression)
--   4. Load data from E:\minidb_dr20 heap tables (INSERT SELECT - no CSV re-read)
--   5. Add nonclustered indexes (992 indexes)
--   6. Add foreign keys (102 FKs)
--
-- Why this order:
--   - Loading into clustered tables is faster than heap→clustered rebuild
--   - Data is physically sorted as it loads (better page density)
--   - Nonclustered indexes built on pre-sorted data (more efficient)
-- =====================================================================================

USE master;
GO

-- Drop existing database if needed (CAUTION: Uncomment only if you're sure!)
-- DROP DATABASE IF EXISTS minidb_dr20_v2;
-- GO

-- =====================================================================================
-- Create Database with PRIMARY and MINIDB Filegroups
-- =====================================================================================

CREATE DATABASE minidb_dr20_v2
ON PRIMARY
(
    NAME = N'minidb_dr20_v2_primary',
    FILENAME = N'D:\sql_db\minidb_dr20_v2_primary.mdf',
    SIZE = 100MB,          -- 100 MB for system tables (small)
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10MB      -- 10 MB autogrowth
),
FILEGROUP [MINIDB]          -- User data filegroup
(
    -- File 1
    NAME = N'minidb_dr20_v2_data_1',
    FILENAME = N'D:\sql_db\minidb_dr20_v2_data_1.ndf',
    SIZE = 286720MB,         -- 280 GB initial
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10240MB     -- 10 GB autogrowth (10% of initial)
),
(
    -- File 2
    NAME = N'minidb_dr20_v2_data_2',
    FILENAME = N'D:\sql_db\minidb_dr20_v2_data_2.ndf',
    SIZE = 286720MB,         -- 280 GB initial
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10240MB     -- 10 GB autogrowth
),
(
    -- File 3
    NAME = N'minidb_dr20_v2_data_3',
    FILENAME = N'D:\sql_db\minidb_dr20_v2_data_3.ndf',
    SIZE = 286720MB,         -- 280 GB initial
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10240MB     -- 10 GB autogrowth
),
(
    -- File 4
    NAME = N'minidb_dr20_v2_data_4',
    FILENAME = N'D:\sql_db\minidb_dr20_v2_data_4.ndf',
    SIZE = 286720MB,         -- 280 GB initial
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 10240MB     -- 10 GB autogrowth
)
LOG ON
(
    NAME = N'minidb_dr20_v2_log',
    FILENAME = N'D:\sql_db\minidb_dr20_v2_log.ldf',
    SIZE = 81920MB,          -- 80 GB initial
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 8192MB      -- 8 GB autogrowth
);
GO

-- =====================================================================================
-- Set MINIDB as Default Filegroup
-- =====================================================================================
-- All user tables will be created in MINIDB filegroup by default
-- PRIMARY filegroup will only contain system tables

ALTER DATABASE minidb_dr20_v2
MODIFY FILEGROUP [MINIDB] DEFAULT;
GO

-- =====================================================================================
-- Configure Database Options
-- =====================================================================================

ALTER DATABASE minidb_dr20_v2 SET RECOVERY SIMPLE;               -- No point-in-time recovery needed
ALTER DATABASE minidb_dr20_v2 SET AUTO_UPDATE_STATISTICS ON;     -- Keep statistics fresh
ALTER DATABASE minidb_dr20_v2 SET AUTO_CREATE_STATISTICS ON;     -- Create missing statistics
ALTER DATABASE minidb_dr20_v2 SET PAGE_VERIFY CHECKSUM;          -- Data integrity checks
ALTER DATABASE minidb_dr20_v2 SET TARGET_RECOVERY_TIME = 60;     -- Checkpoint every 60 seconds
ALTER DATABASE minidb_dr20_v2 SET DELAYED_DURABILITY = ALLOWED;  -- Allow delayed durability for bulk loads
GO

-- =====================================================================================
-- Verify Configuration
-- =====================================================================================

USE minidb_dr20_v2;
GO

SELECT
    fg.name AS filegroup_name,
    fg.is_default,
    df.name AS file_name,
    df.physical_name,
    df.size * 8 / 1024 AS size_mb,
    df.size * 8 / 1024 / 1024.0 AS size_gb,
    df.growth * 8 / 1024 AS growth_mb,
    df.max_size
FROM sys.filegroups fg
INNER JOIN sys.database_files df ON fg.data_space_id = df.data_space_id
WHERE df.type = 0  -- Data files only
ORDER BY fg.name, df.file_id;
GO

-- =====================================================================================
-- Next Steps (DO NOT RUN AUTOMATICALLY)
-- =====================================================================================
--
-- 1. Create tables in MINIDB filegroup (heaps):
--    sqlcmd -S localhost -d minidb_dr20_v2 -E -i mssql_tables_0112.sql
--
-- 2. Add primary keys (creates clustered indexes with PAGE compression):
--    sqlcmd -S localhost -d minidb_dr20_v2 -E -i mssql_pk_0112.sql
--
-- 3. Load data from E: drive heap tables (see load_from_heap_tables.sql):
--    - Source DB: minidb_dr20 (E: drive heap tables)
--    - Target DB: minidb_dr20_v2 (D: drive clustered tables)
--    - Uses INSERT INTO minidb_dr20_v2.dbo.table SELECT * FROM minidb_dr20.dbo.table
--    - Much faster than re-reading CSV files
--    - Data loads into clustered tables (pre-sorted)
--
-- 4. Add nonclustered indexes (992 indexes):
--    sqlcmd -S localhost -d minidb_dr20_v2 -E -i mssql_indexes_0112.sql
--
-- 5. Add foreign keys (102 FKs):
--    sqlcmd -S localhost -d minidb_dr20_v2 -E -i mssql_fk_0112.sql
--
-- =====================================================================================

PRINT 'Database minidb_dr20_v2 created successfully on D: drive';
PRINT 'Default filegroup: MINIDB (4 files x 280 GB = 1,120 GB capacity)';
PRINT 'PRIMARY filegroup: 10 GB for system tables';
PRINT 'Log file: 80 GB';
PRINT '';
PRINT 'Ready for table creation and data loading from minidb_dr20 (E: drive) heap tables.';
GO
