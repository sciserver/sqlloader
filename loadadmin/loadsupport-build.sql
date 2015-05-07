--=============================================================================
-- loadsupport-build.sql
-- 2003-06-03   Ani: Replaced 'loadagent' with variable @loadagent.
-- 2003-07-09   Ani: Replicated loadagent variable declaration where
--                   needed because one declaration at the top does
--                   not do it (each call to GO refreshes the scope).
--                   Also fixed "grant execute" on HTM procs to loadagent.
-- 2003-07-15   Ani: Forced granting of execute access on xp_cmdshell to
--                   loadagent user even if user already exists in sysusers.
--                   (exec on xp_cmdshell was not being granted on FNAL
--                    loadserver)
-- 2003-12-3    Jim: Set db options as per SQL Best Practices Advice
--                   Simple recovery.
-- 2005-03-17   Ani: Moved everything except creation of loadsupport DB
--                   to new script loadsupport-setup.sql, so the creation
--                   and set up of loadsupport can be invoked separately
--                   for incremental loading (where loadsupport already
--                   exists).
--=============================================================================

IF EXISTS (SELECT name 
	FROM master.dbo.sysdatabases 
	WHERE name = N'loadsupport')
	DROP DATABASE [loadsupport]
GO

EXEC xp_cmdshell N'if exist c:\sql_db\LoadSupport_Data1.MDF del /Q c:\sql_db\LoadSupport_*.*', NO_OUTPUT
GO

CREATE DATABASE [loadsupport] 
ON  (	NAME = N'LoadSupport_Data1', 
	FILENAME = N'C:\sql_db\LoadSupport_Data1.MDF' , 
	SIZE = 10, 
	FILEGROWTH = 10%
	)   
LOG ON 
   (	NAME = N'LoadSupport_Log', 
	FILENAME = N'C:\sql_db\LoadSupport_Log.LDF' , 
	SIZE = 10, 
	FILEGROWTH = 10%
   )
GO

PRINT CAST(getdate() as varchar(64)) + '  -- LoadSupport database created'

