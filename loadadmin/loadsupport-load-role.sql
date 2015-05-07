--================================================
-- loadsupport-load-role.sql
-- 2002-11-16 Alex Szalay
--------------------------------------------------
-- puts the server into the LOAD role
--================================================

SET NOCOUNT ON
GO

EXEC spCreateSqlAgentJob 'LOAD';
GO

IF NOT EXISTS (select srvid 
	FROM ServerState WITH (nolock)
	WHERE srvname=@@servername
	and role='LOAD')
    INSERT INTO ServerState VALUES(1,@@servername,'LOAD','RUN');
GO

PRINT cast(getdate() as varchar(64)) + '  -- Loadsupport configured in LOAD role'
GO
