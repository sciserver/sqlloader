-- =====================================================================================
-- Run this WHILE the insert is happening to see what's competing
-- =====================================================================================
-- Open TWO SSMS windows:
-- Window 1: Run the INSERT statement for ONE table
-- Window 2: Run this script repeatedly while Window 1 is running
-- =====================================================================================

USE minidb_dr20_v2;
GO

PRINT '=== ACTIVE REQUESTS ON minidb_dr20_v2 ==='
SELECT
    r.session_id,
    r.status,
    r.command,
    r.blocking_session_id,
    r.wait_type,
    r.wait_time,
    r.cpu_time,
    r.reads,
    r.writes,
    r.granted_query_memory * 8 / 1024 AS granted_memory_mb,
    SUBSTRING(st.text, (r.statement_start_offset/2)+1,
        ((CASE r.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE r.statement_end_offset
        END - r.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) st
WHERE r.database_id = DB_ID('minidb_dr20_v2')
ORDER BY r.total_elapsed_time DESC;

PRINT ''
PRINT '=== ACTIVE REQUESTS ON minidb_dr20 (SOURCE) ==='
SELECT
    r.session_id,
    r.status,
    r.command,
    r.blocking_session_id,
    r.wait_type,
    r.wait_time
FROM sys.dm_exec_requests r
WHERE r.database_id = DB_ID('minidb_dr20')
ORDER BY r.total_elapsed_time DESC;

PRINT ''
PRINT '=== BLOCKING CHAINS ==='
SELECT
    blocking_session_id,
    session_id AS blocked_session,
    wait_type,
    wait_time,
    wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;

PRINT ''
PRINT '=== PARALLEL QUERY WORKERS ==='
SELECT
    session_id,
    request_id,
    exec_context_id,
    task_state,
    wait_type,
    wait_duration_ms
FROM sys.dm_os_tasks
WHERE session_id IN (
    SELECT session_id FROM sys.dm_exec_requests
    WHERE database_id IN (DB_ID('minidb_dr20_v2'), DB_ID('minidb_dr20'))
)
ORDER BY session_id, exec_context_id;
