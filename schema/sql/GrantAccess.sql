----------------------------------------------------------------
-- Creates SkyServer user role containing Internet logon.
-- Grants authority to use HTM routines in master.
-- Grants authority to use "user" tables in databases.
-- Only PersonalSkyServerDr1 DB is excuted here.
-- The same logic applies to 
--   BestDr1
--   Target
--   WebLog database (actually, weblog allows selective insert).
--
-- Created by Jim Gray 24 Sept 2003
--
--
----------------------------------------------------------------
-- Add role to MASTER database, and grant execute authorities.
--
Use Master

/* cleanup if needed
EXEC sp_dropuser  'Internet'
EXEC sp_droplogin 'Internet'
EXEC sp_droprole  'SkyServerUser'
*/

-- =============================================
-- Add SkyServerUser role
-- =============================================
EXEC sp_addrole SkyServerUser 
 
-- =============================================
-- Add Internet login
-- =============================================
EXEC sp_addlogin @loginame = Internet,
	    	@passwd    = 'xxxxxxxx',		--****** CHANGE THIS!!!! 
	    	@defdb     = PersonalSkyServerV4 	-- default database

-- =============================================
-- Give him access to this database
-- =============================================
EXEC sp_grantdbaccess Internet 

-- =============================================
-- Add login to server roles
-- =============================================
EXEC sp_addrolemember SkyServerUser, Internet   

-- =============================================
-- Grant Role access to Master, data, and web.
-- =============================================
GRANT EXECUTE ON xp_HTM2_Lookup       TO SkyServerUser
GRANT EXECUTE ON xp_HTM2_Cover        TO SkyServerUser
GRANT EXECUTE ON xp_HTM2_Cover        TO SkyServerUser
GRANT EXECUTE ON xp_HTM2_toNormalForm TO SkyServerUser

----------------------------------------------------------------
-- Add role to PersonalSkyServerDr1 database, and grant authorities.
--
USE PersonalSkyServerDr1
 -- =============================================
-- Add SkyServerUser role
-- =============================================
EXEC sp_addrole SkyServerUser 

-- =============================================
-- Give him access to this database
-- =============================================
EXEC sp_grantdbaccess Internet 

-- =============================================
-- Add login to server roles
-- =============================================
EXEC sp_addrolemember SkyServerUser, Internet  
 
-- =============================================
-- Grant SkyServerUser role read access to all user objects
-- =============================================
exec spGrantAccess 'U', SkyServerUser  