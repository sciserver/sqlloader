-- =====================================================================================
-- Read Deadlock Information from SQL Server Error Log
-- =====================================================================================
-- Run this AFTER a deadlock occurs (with Trace Flag 1222 enabled)
-- =====================================================================================

-- Read error log entries containing 'deadlock'
EXEC sp_readerrorlog 0, 1, 'deadlock';
GO

-- Alternative: Read all recent entries (last 100 lines)
-- Uncomment if you want to see more context:
-- EXEC sp_readerrorlog 0, 1;
-- GO
