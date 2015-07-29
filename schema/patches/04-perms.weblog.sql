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