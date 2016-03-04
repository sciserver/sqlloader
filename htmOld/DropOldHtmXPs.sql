-----------------------------------------------------------------------------
-- DropOldHtmXPs.sql
-- 
-- Script to drop old HTM extended procedures from the master database.
-- Adapted from Maria's MySkyServer MySky1_DB.sql script by Ani Thakar.
--
-- 2006-03-10: Ani: Fixed bug - changed xp_HTM_Cover to xpHTM2_Cover in
--             existence test (Maria found the bug).
-----------------------------------------------------------------------------

SET NOCOUNT ON
USE MASTER

PRINT N'************************************************************'
PRINT N'Running DropOldHtmXPs.sql'
PRINT N'************************************************************'

PRINT ''
PRINT N'Installing HTM extended procedures'

IF exists (SELECT * FROM master.dbo.sysobjects WHERE NAME = N'xp_HTM2_Cover')
        BEGIN
        exec sp_dropextendedproc N'[dbo].[xp_HTM2_Lookup]'
        exec sp_dropextendedproc N'[dbo].[xp_HTM2_Cover]'
        exec sp_dropextendedproc N'[dbo].[xp_HTM2_toNormalForm]'
        exec sp_dropextendedproc N'[dbo].[xp_HTM2_toPoint]'
        exec sp_dropextendedproc N'[dbo].[xp_HTM2_toVertices]'
        exec sp_dropextendedproc N'[dbo].[xp_HTM2_Version]'
        DBCC Htm_V2 (FREE) WITH NO_INFOMSGS
        END

PRINT N'Finished dropping old HTM extended procedures.'

-----------------------------------------------------------------------------

