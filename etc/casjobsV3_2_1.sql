-- ALTER TABLE batch.Users ADD gvisible BIT NOT NULL DEFAULT 1

DROP TABLE Tables

-- Servers table
ALTER TABLE batch.Servers ADD CStringExtra VARCHAR(200) NOT NULL DEFAULT ''
ALTER TABLE batch.Servers ADD Password VARCHAR(200) NOT NULL DEFAULT ''
EXEC sp_rename 'batch.Servers.[owner]', 'usr', 'COLUMN'
ALTER TABLE batch.Servers DROP COLUMN ConnectionString

-- MyDBHosts table
EXEC sp_rename 'MyDBHosts.[user]', 'usr', 'COLUMN'
ALTER TABLE MyDBHosts ADD CStringExtra VARCHAR(200) NOT NULL DEFAULT ''
ALTER TABLE MyDBHosts ADD admin_usr VARCHAR(200) NOT NULL DEFAULT ''
ALTER TABLE MyDBHosts ADD admin_pw VARCHAR(200) NOT NULL DEFAULT ''

-- Groups table
ALTER TABLE Groups DROP COLUMN privs

ALTER TABLE Groups ADD privs VARCHAR(200) 

-- GroupTables table
DROP INDEX dbo.GroupTables.[IX_GroupTables]
CREATE UNIQUE CLUSTERED INDEX [IX_GroupTables] ON dbo.GroupTables (webservicesid, tablename, gid)

GO

-- Create "collab" group and add collab members to it
DECLARE @adminId BIGINT, @collabGid BIGINT;
SELECT @adminId = webservicesid FROM batch.users WHERE [name]='admin';
SELECT @collabGid = MAX(gid) FROM Groups;
SET @collabGid=@collabGid + 1;
delete groups where name='collab'

-- INSERT Groups VALUES( 'public', -1, -1, 'Everbody', NULL );
INSERT Groups VALUES( 'collab',@collabGid, @adminId, 'Collab members', 'SDSS' );
INSERT GroupMembers VALUES( @collabGid, @adminId, 2 );


INSERT GroupMembers
	SELECT @collabGid AS gid, webservicesid, 2 as status 
	FROM [sdsssql013].batchadmin.batch.users
    WHERE privileges LIKE '%collab%'

-- Preserve "admin" and "sight" privs and null out all the rest
-- Script to do schema updates and fix data in existing tables for CasJobs v3_2_1.

SELECT webservicesid INTO #admins
FROM batch.users WHERE privileges LIKE '%admin%'

SELECT webservicesid INTO #sights
FROM batch.users WHERE privileges LIKE '%sight%'

UPDATE batch.users
	SET privileges = ''

UPDATE u
	SET u.privileges = 'admin'
FROM batch.users u, #admins a
WHERE u.webservicesid=a.webservicesid

UPDATE u
	SET u.privileges = (CASE WHEN u.privileges='admin' THEN 'admin,sight' ELSE 'sight' END)
	FROM batch.users u, #sights a
	WHERE u.webservicesid=a.webservicesid
GO

-- Set status of running or ready jobs to "failed"
UPDATE batch.jobs
	SET status=4
	WHERE status IN (0,1)
GO

CREATE TABLE batch.[Notes] (
	[Note] [varchar] (2000) NOT NULL ,
	[Time] [datetime] NOT NULL DEFAULT (getdate()),
	[Author] [bigint] NOT NULL ,
	[ObjName] [varchar] (50) NOT NULL ,
	[ObjType] [tinyint] NOT NULL ,
	[Context] [varchar] (50) NOT NULL 
) 
GO

