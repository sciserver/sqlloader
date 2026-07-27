-- =====================================================================================
-- Enable Deadlock Tracing - Captures Details to SQL Server Error Log
-- =====================================================================================
-- This will write detailed deadlock graphs to the error log
-- Run this BEFORE attempting the loads again
-- =====================================================================================

-- Enable deadlock trace flag globally (persists until server restart)
DBCC TRACEON (1222, -1);
GO

-- Verify it's enabled
DBCC TRACESTATUS (1222, -1);
GO

PRINT 'Deadlock tracing enabled'
PRINT 'When a deadlock occurs, details will be written to SQL Server error log'
PRINT ''
PRINT 'To view the error log:'
PRINT '  EXEC sp_readerrorlog 0, 1, ''deadlock'''
PRINT ''
PRINT 'Or check this location:'
PRINT '  C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Log\ERRORLOG'
GO
