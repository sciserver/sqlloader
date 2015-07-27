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
	set noexec on --don't do anything else
end

--grant insert privs to 2 tables
print 'granting insert privs on weblog tables to logger....'

grant insert on SqlPerformanceLogUTC to logger

grant insert on SqlStatementLogUTC to logger

---remove skyuser and webuser from weblog db if neccessary
print 'removing unneeded users from weblog db'
if (select count(*) from sys.database_principals where name = 'skyuser') != 0
begin
	if (select COUNT(*) from sys.schemas where principal_id=USER_ID('skyuser')) != 0
	begin
		alter authorization on schema::skyuser TO dbo;
	end
	drop user skyuser;
end
if (select count(*) from sys.database_principals where name = 'webuser') != 0
begin
	if (select COUNT(*) from sys.schemas where principal_id=USER_ID('webuser')) != 0
	begin
		alter authorization on schema::webuser TO dbo;
	end
drop user webuser;
end

print 'weblog db successfully updated!'


set noexec off






