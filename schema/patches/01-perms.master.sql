---- stuff to run in master


USE [master]
GO

--Check if logger user exists, if not, create it
if ((select count(*) from sys.server_principals where name = 'logger') = 0 )
	begin
		Print 'Creating logger user....'
		/* For security reasons the login is created disabled and with a random password. */
		/****** Object:  Login [logger]    Script Date: 7/10/2015 3:28:48 PM ******/
		CREATE LOGIN [logger] WITH PASSWORD=N'@êÐ^ðÛù0FÐÿèUnÙáø¶¤éµãâÄ²$R', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
		ALTER LOGIN [logger] DISABLE
		DENY CONNECT SQL TO [logger]

	end
	else
		print 'Logger user already exists!'



-----------------------------------------------------------
-- grant impersonate privs to skyuser and webuser on logger 
-----------------------------------------------------------

print 'Granting impersonate privs...'

--check if webuser exists
if (select count(*) from sys.server_principals where name = 'webuser') != 0
begin	
	grant impersonate on login::logger to webuser
	print 'granted impersonate to webuser'
end


if (select count(*) from sys.server_principals where name = 'skyuser') != 0
begin
	grant impersonate on login::logger to skyuser
	print 'granted impersonate to skyuser'
end
go

print 'master db successfully updated!'

