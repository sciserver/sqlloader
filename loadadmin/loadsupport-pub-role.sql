--================================================
-- loadsupport-pub-role.sql
-- 2002-11-16 Alex Szalay
--------------------------------------------------
-- puts the server into the PUB role
--================================================

SET NOCOUNT ON
GO

EXEC spCreateSqlAgentJob 'PUB';
GO

IF NOT EXISTS (select srvid 
	FROM ServerState WITH (nolock)
	WHERE srvname=@@servername
	and role='PUB')
INSERT INTO ServerState VALUES(1,@@servername,'PUB','RUN');
GO

print cast(getdate() as varchar(64)) + '  -- Loadsupport configured in PUB role'

