--================================================
-- loadsupport-schema.sql
-- 2002-06-03 Alex Szalay
--------------------------------------------------
-- 2002-08-14 Alex: split off loadsupport
-- 2002-10-16 Alex: added LoadServer table to point to LoadServer
-- 2002-11-05 Alex: added LocalRunState table for flow control
-- 2002-11-16 Alex: added Server table to control server roles
-- 2002-12-19 Alex: added ServerState table for better control of server roles
-- 2002-12-20 Alex: dropped Server and LocalRunState, replaced by ServerState
-- 2013-04-02 Ani:  Added table FinishPhase to keep track of where the
--                  the last FINISH left off.
--================================================
--
SET NOCOUNT ON
GO

--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[LoadServer]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [LoadServer]
GO
--
CREATE TABLE LoadServer (
	[name]		varchar(16) NOT NULL	--/D the name of the loadserver
)
GO

--===================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[FinishPhase]') 
	and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [FinishPhase]
GO
--
CREATE TABLE FinishPhase (
	[name]		varchar(32) NOT NULL	--/D the name of the FINISH phase
)
GO

print cast(getdate() as varchar(64)) + '  -- Loadsupport tables created'

