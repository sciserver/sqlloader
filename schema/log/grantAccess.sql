--====================================================
-- Grants select and execure authority to all user objects in Weblog db 
-- and insert authority on the SQL log tables
-- =============================================
-- Grant test/SkySeverV4User read/execute acces to user objects
-- =============================================
set nocount on
go
use WebLog
exec sp_addrole [SkyServerV4User]
exec sp_adduser test,test, [SkyServerV4User]
exec sp_addrolemember [SkyServerV4User],'test'
go

PRINT 'Granting access to WebLog tables'
DECLARE userObject CURSOR
READ_ONLY
FOR 	select name, type 
	from sysobjects 
	where type in ('P ', 'FN', 'TF', 'TR', 'U ', 'V ', 'X ') 
  	  and name not like 'dt_%'

DECLARE @name varchar(256)
DECLARE @type char(2)
DECLARE @verb varchar(32)
DECLARE @command varchar(1000)
OPEN userObject

FETCH NEXT FROM userObject INTO @name, @type
WHILE (@@fetch_status <> -1)
BEGIN
	
	FETCH NEXT FROM userObject INTO @name, @type
	IF (@@fetch_status != 0) BREAK
 	IF	(@type in ('U ', 'V ', 'TF'))  SET @verb = 'SELECT' 
	ELSE IF	(@type in ('P ', 'TR', 'FN', 'X '))  SET @verb = 'EXECUTE'
	SET @command = 'GRANT ' + @verb + ' ON ' + @name + ' TO [SkyServerV4User]'
	exec (@command)
	print @command + ' Type is: ' + @type	
END

CLOSE userObject
DEALLOCATE userObject

GRANT INSERT ON dbo.SqlStatementLog   to [SkyServerV4User]
GRANT INSERT ON dbo.SqlPerformanceLog to [SkyServerV4User]

PRINT 'Access granted to weblog tables'