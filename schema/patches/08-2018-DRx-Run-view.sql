

-------------------------
-- Script to create Run view on DRx db's
-- This creates a view onto the Run table in BestDR15
-- Change that dbname if needed.
-- SW
-------------------------

use master
go

alter database DR15x
set single_user with rollback immediate

alter database DR15x
set read_write

alter database DR15x
set multi_user


use DR15x
go
--------- Change DB name from BestDR15 to another db if needed ----------
create view [dbo].[Run] as select * from BestDR15.dbo.[Run] with (nolock)
-------------------------------------------------------------------------
go

use master
go

alter database DR15x
set single_user with rollback immediate

alter database DR15x
set read_only

alter database DR15x
set multi_user

