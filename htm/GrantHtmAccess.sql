-----------------------------------------------------------------------------
-- GrantHtmAccess.sql
-- 
-- Script to grant permissions for the HTM xps.
-- Adapted from Maria's MySkyServer MySky1_DB.sql script by Ani Thakar.
--
-----------------------------------------------------------------------------

SET NOCOUNT ON
USE MASTER

PRINT N'************************************************************'
PRINT N'Running GrantHtmAccess.sql'
PRINT N'************************************************************'

PRINT ''
PRINT N'Adding HTM stored procedures to master database'

EXEC sp_addextendedproc N'xp_HTM2_Lookup',       N'Htm_V2.dll'
EXEC sp_addextendedproc N'xp_HTM2_Cover',        N'Htm_V2.dll'
EXEC sp_addextendedproc N'xp_HTM2_toNormalForm', N'Htm_V2.dll' 
EXEC sp_addextendedproc N'xp_HTM2_toPoint',      N'Htm_V2.dll' 
EXEC sp_addextendedproc N'xp_HTM2_toVertices',   N'Htm_V2.dll' 
EXEC sp_addextendedproc N'xp_HTM2_Version',      N'Htm_V2.dll' 

PRINT ''
PRINT N'Granting public and test user access.'

GRANT EXECUTE ON xp_HTM2_Lookup       TO PUBLIC
GRANT EXECUTE ON xp_HTM2_Cover        TO PUBLIC
GRANT EXECUTE ON xp_HTM2_Cover        TO PUBLIC
GRANT EXECUTE ON xp_HTM2_toNormalForm TO PUBLIC
GRANT EXECUTE ON xp_HTM2_toPoint      TO PUBLIC
GRANT EXECUTE ON xp_HTM2_toVertices   TO PUBLIC
GRANT EXECUTE ON xp_HTM2_Version      TO PUBLIC

GRANT EXECUTE ON xp_HTM2_Lookup       TO [test]
GRANT EXECUTE ON xp_HTM2_Cover        TO [test]
GRANT EXECUTE ON xp_HTM2_Cover        TO [test]
GRANT EXECUTE ON xp_HTM2_toNormalForm TO [test]
GRANT EXECUTE ON xp_HTM2_toPoint      TO [test]
GRANT EXECUTE ON xp_HTM2_toVertices   TO [test]
GRANT EXECUTE ON xp_HTM2_Version      TO [test]

PRINT N'GrantHtmAccess.sql done.'

-----------------------------------------------------------------------------

