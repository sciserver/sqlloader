--=============================================================================
-- loadsupport-setup.sql
-- 2005-03-17   Ani: Moved the set up commands for loadsupport DB here
--              from loadsupport-build.sql, so this script can be run
--              by itself when the loadsupport DB already exists (for
--              incremental loading).
-- 2024-08-27	Sue: got rid of sp_dboption stuff
--=============================================================================

USE master
GO
-------------------------------------------------
-- turn on trace flag 1807 -- enable NAS attach
-------------------------------------------------
DBCC TRACEON(1807)
PRINT CAST(getdate() as varchar(64)) + '  -- Turned on Trace Flag(1807)'
GO

-------------------------------------------------
-- Add login for loadagent to server.
------------------------------------------------- 

DECLARE @loadagent VARCHAR(128);
SELECT @loadagent=value 
	FROM  loadsupport.dbo.Constants WITH (nolock)
	WHERE name='loadagent';

IF NOT EXISTS (SELECT N'Login Exists' 
	FROM master..syslogins 
	WHERE name = @loadagent)
BEGIN
    EXEC sp_grantlogin @loginame=@loadagent
    --PRINT CAST(getdate() as varchar(64)) + '  -- loadagent login created'
END
GO

-------------------------------------------------
-- Add login 'webagent' to server
------------------------------------------------- 

IF NOT EXISTS (SELECT N'Login Exists' 
	FROM master..syslogins 
	WHERE name = N'webagent')
BEGIN
    EXEC sp_addlogin @loginame=N'webagent', @passwd=N'loadsql'
    --PRINT CAST(getdate() as varchar(64)) + '  -- webagent login created'
END
GO


IF NOT EXISTS (SELECT N'User Exists' 
	FROM master..sysusers 
	WHERE name = N'webagent')
BEGIN
    EXEC sp_grantdbaccess N'webagent', N'webagent'
    GRANT EXECUTE on xp_cmdshell TO webagent
    --PRINT CAST(getdate() as varchar(64)) + '  -- webagent user created on master'
END
--
GO

-----------------------------------------------
-- Add loadagent to master
-----------------------------------------------
DECLARE @loadagent VARCHAR(128);
SELECT @loadagent=value 
	FROM loadsupport.dbo.Constants WITH (nolock)
	WHERE name='loadagent';

IF NOT EXISTS (SELECT N'User Exists' 
	FROM master..sysusers 
	WHERE name = @loadagent)
BEGIN
    EXEC sp_grantdbaccess @loadagent, N'loadagent'
END
EXECUTE ('GRANT EXECUTE on xp_cmdshell TO ['+@loadagent+']')
PRINT CAST(getdate() as varchar(64)) + '  -- Granted cmdshell exec right to loadagent on master'
GO

-------------------------------------------------------------
-- Add user to LoadSupport database and appropriate roles.
-------------------------------------------------------------
USE loadsupport
GO

IF NOT EXISTS (SELECT N'User Exists' 
	FROM loadsupport..sysusers 
	WHERE name = N'webagent')
BEGIN
    EXEC sp_grantdbaccess N'webagent', N'webagent'
    -- PRINT CAST(getdate() as varchar(64)) + '  -- webagent user created on loadsupport'
END
GO

--
EXEC sp_addsrvrolemember N'webagent', N'sysadmin'
--PRINT CAST(getdate() as varchar(64)) + '  -- webagent added to sysadmin role'
GO


DECLARE @loadagent VARCHAR(128);
SELECT @loadagent=value 
	FROM loadsupport.dbo.Constants WITH (nolock)
	WHERE name='loadagent';

IF NOT EXISTS (SELECT N'User Exists' 
	FROM loadsupport..sysusers 
	WHERE name = @loadagent)
BEGIN
    EXEC sp_grantdbaccess @loadagent, N'loadagent'
    -- PRINT CAST(getdate() as varchar(64)) + '  -- loadagent user created on loadsupport'
END
GO

DECLARE @loadagent VARCHAR(128);
SELECT @loadagent=value 
	FROM loadsupport.dbo.Constants WITH (nolock)
	WHERE name='loadagent';

EXEC sp_addsrvrolemember @loadagent, N'sysadmin'
--PRINT CAST(getdate() as varchar(64)) + '  -- loadagent added to sysadmin role'
GO

----------------------------------------------------
-- Reconnect the user with the login, if needed
----------------------------------------------------
EXEC sp_change_users_login N'UPDATE_ONE', N'webagent', N'webagent'
GO

PRINT CAST(getdate() as varchar(64)) + '  -- Users/logins updated'

----------------------------------------------------
-- configure database options
----------------------------------------------------
ALTER DATABASE loadsupport SET
	 ANSI_NULLS              ON,
         ANSI_PADDING            ON,
         ANSI_WARNINGS           ON,
         ARITHABORT              ON,
         CONCAT_NULL_YIELDS_NULL ON, 
         QUOTED_IDENTIFIER       ON,
         CURSOR_CLOSE_ON_COMMIT OFF,
         AUTO_CREATE_STATISTICS  ON,
         AUTO_UPDATE_STATISTICS  ON,  
         RECURSIVE_TRIGGERS     OFF, 
         PAGE_VERIFY CHECKSUM,
         RECOVERY SIMPLE,      
         CURSOR_DEFAULT GLOBAL   

GO

Print CAST(getdate() as varchar(64)) + '  -- Database options set'
