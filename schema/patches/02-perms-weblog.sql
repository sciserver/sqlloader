----------
-- run this in weblog db


use weblog
go

print 'adding logger user to weblog db...'

if (select count(*) from master.sys.server_principals where name = 'logger') = 1
begin
	create user [logger] for login [logger] with default_schema=[dbo]
end
else
begin
	print 'Error: must first add logger login -- run 01-perms.master.sql first'
	break;
end

--grant insert privs to 2 tables
print 'granting insert privs on weblog tables to logger....'

grant insert on SqlPerformanceLogUTC to logger

grant insert on SqlStatementLogUTC to logger

---remove skyuser and webuser from weblog db if neccessary

if (select count(*) from sys.database_principals where name = 'skyuser') != 0
begin
	alter authorization on schema::skyuser TO dbo;
	drop user skyuser;
end
if (select count(*) from sys.database_principals where name = 'webuser') != 0
drop user webuser;