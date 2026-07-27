-- Find what's blocking/competing with our load
USE minidb_dr20_v2;
GO

-- Active sessions on minidb_dr20_v2
SELECT
    session_id,
    status,
    command,
    cpu_time,
    total_elapsed_time / 1000 AS elapsed_seconds,
    reads,
    writes,
    logical_reads,
    granted_query_memory,
    DB_NAME(database_id) AS database_name,
    host_name,
    program_name,
    login_name,
    last_request_start_time
FROM sys.dm_exec_requests
WHERE database_id = DB_ID('minidb_dr20_v2')
ORDER BY total_elapsed_time DESC;

-- All connections to minidb_dr20_v2
SELECT
    session_id,
    login_name,
    host_name,
    program_name,
    status,
    last_request_end_time
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('minidb_dr20_v2')
ORDER BY last_request_end_time DESC;

-- Check for blocking
SELECT
    blocking_session_id,
    session_id AS blocked_session_id,
    wait_type,
    wait_time,
    wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
