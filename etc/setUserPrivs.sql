--=================================================================
--   spSetUserPrivs.sql
--	 2011-04-26 Ani Thakar
-------------------------------------------------------------------
-- Sets up the given db user with the given schema and privs.
-------------------------------------------------------------------
-- History:
-------------------------------------------------------------------

--====================================================================
PRINT '*** SET USER PRIVS ***'
--
EXEC sp_change_users_login N'UPDATE_ONE', [$(userName)], [$(userName)]
ALTER USER [$(userName)] WITH DEFAULT_SCHEMA = db_datareader
GRANT EXECUTE TO [$(userName)]
GRANT SELECT TO [$(userName)]
GRANT SHOWPLAN TO [$(userName)]
GRANT VIEW DEFINITION TO [$(userName)]
--
-- PRINT 'User ' + $(userName) + ' set up with the given privileges'
