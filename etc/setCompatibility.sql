--=================================================================
--   spSetCompatibility.sql
--	 2011-04-26 Ani Thakar
-------------------------------------------------------------------
-- Sets the DB compatibility level to the given value.
-------------------------------------------------------------------
-- History:
-------------------------------------------------------------------

--====================================================================
PRINT '*** SET COMPATIBILITY LEVEL ***'
--
DECLARE @ret int
EXEC @ret=sp_dbcmptlevel $(SQLCMDDBNAME), $(compLevel)
PRINT 'Compatibility level has been set to ' + CAST($(compLevel) AS VARCHAR(4))
--
