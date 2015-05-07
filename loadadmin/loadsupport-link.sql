--=============================================================
-- loadsupport-link.sql
-- 2002-09-11 Alex Szalay
--
-- All the stored procedures needed to setup linked servers
---------------------------------------------------------------
-- 2002-11-11	Alex: modified sp_addlinkedserverlogin mappings
--=============================================================

SET NOCOUNT ON
GO

DECLARE @msg varchar(256);
SELECT @msg=cast(getdate() as varchar(64)) 
	+ '  -- Loadserver set to '+name FROM Loadserver WITH (nolock)
PRINT @msg
GO


--=============================================================
CREATE PROCEDURE spAddLinkedServer (@linkname varchar(64))
---------------------------------------------------
--/H Creates a two-way linked server relationship with @linkname
---------------------------------------------------
--/T Also creates an account for the loadagent on the linked server
---------------------------------------------------
AS
BEGIN
    --
    declare @test sysname;
    --
    SELECT @test=srvname FROM master.dbo.sysservers WHERE upper(srvname)= upper(@linkname)
    --
    IF @test is not null 
	EXEC sp_dropserver @linkname, 'droplogins'
    --
    -- now we set up the linked server
    --
    EXEC sp_addlinkedserver @linkname
    --EXEC sp_setnetname @linkname, @linkname
    --EXEC sp_addlinkedsrvlogin @linkname
    --
    RETURN(0);
END
GO


CREATE PROCEDURE spCreateLinks
---------------------------------------------------
--/H Creates a two-way linked server relationship to the Loadserver
---------------------------------------------------
--/T Also creates local View for easy access of the Loadadmin tables
---------------------------------------------------
AS
BEGIN

    DECLARE @loadname varchar(64), @cmd nvarchar(1024), @host varchar(64);

    -- first get the name of the loadserver
    SELECT @loadname=name from Loadserver
    SELECT @host = @@servername;

    IF upper(@loadname)<>upper(@host) 
      BEGIN
	-- I am not the master, link myself to the loadserver
	EXEC spAddLinkedServer @loadname;
	PRINT 'called spAddLinkedServer ' + @loadname
	--
	SET @cmd = N'EXEC [' + @loadname +N'].loadsupport.dbo.spAddLinkedServer '''+ @host + '''';
	EXEC sp_executesql @cmd
	--
	SET @loadname = @loadname+'.loadadmin.dbo.'
      END
    ELSE
	SET @loadname = 'loadadmin.dbo.'
    --
    SET @cmd = N'CREATE VIEW Task AS SELECT * FROM '+@loadname+'Task'
    EXEC sp_executesql @cmd
    SET @cmd = N'CREATE VIEW Step AS SELECT * FROM '+@loadname+'Step'
    EXEC sp_executesql @cmd
    SET @cmd = N'CREATE VIEW Files AS SELECT * FROM '+@loadname+'Files'
    EXEC sp_executesql @cmd
    SET @cmd = N'CREATE VIEW Phase AS SELECT * FROM '+@loadname+'Phase'
    EXEC sp_executesql @cmd
    SET @cmd = N'CREATE VIEW NextStep AS SELECT * FROM '+@loadname+'NextStep'
    EXEC sp_executesql @cmd
    SET @cmd = N'CREATE VIEW Constants AS SELECT * FROM '+@loadname+'Constants'
    EXEC sp_executesql @cmd
--    SET @cmd = N'CREATE VIEW GlobalRunState AS SELECT * FROM '+@loadname+'GlobalRunState'
--    EXEC sp_executesql @cmd
    SET @cmd = N'CREATE VIEW ServerState AS SELECT * FROM '+@loadname+'ServerState'
    EXEC sp_executesql @cmd
    --
    PRINT cast(getdate() as varchar(64)) + '  -- Loadsupport views created'
    --
    EXEC sp_configure 'remote proc trans' , 1 
    --
    PRINT cast(getdate() as varchar(64)) + '  -- Remote transactions enabled'
    --

END
GO


exec spCreateLinks
go

PRINT cast(getdate() as varchar(64)) + '  -- Linked server relationship configured'
go
