


select * from IndexMap
where tablename = 'mangaGalaxyZoo'

exec spIndexCreate_print 0,0,90


SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE mangaGalaxyZoo ADD CONSTRAINT pk_mangaGalaxyZoo_nsa_id PRIMARY KEY CLUSTERED (nsa_id)  WITH (DATA_COMPRESSION = page) ON [SPEC]

set statistics io on
set statistics time on


insert mangaGalaxyZoo with (tablock)
select * from BESTTEST.dbo.mangaGalaxyZoo


--------------
select * from IndexMap
where tablename = 'sdssEbossFirefly'

exec spIndexCreate_print 0,0,103

SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE sdssEbossFirefly ADD CONSTRAINT pk_sdssEbossFirefly_specObjID PRIMARY KEY CLUSTERED (specObjID)  WITH (DATA_COMPRESSION = page) ON [SPEC]

insert sdssEbossFirefly with (tablock)
select * from BESTTEST.dbo.sdssEbossFirefly


----------------------------------------

select * from IndexMap where tablename = 'PawlikMorph'

exec spIndexCreate_print 0,0,107

SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE PawlikMorph ADD CONSTRAINT pk_PawlikMorph_mangaid PRIMARY KEY CLUSTERED (mangaid)  WITH (DATA_COMPRESSION = page) ON [SPEC]

insert PawlikMorph with (tablock)
select * from BESTTEST.dbo.PawlikMorph

----------------------------------------------
select * from IndexMap where tablename = 'spiders_quasar'

exec spIndexCreate_print 0,0,104

ALTER TABLE spiders_quasar ADD CONSTRAINT pk_spiders_quasar_name PRIMARY KEY CLUSTERED (name)  WITH (DATA_COMPRESSION = page) ON [SPEC]

insert spiders_quasar with (tablock)
select * from BESTTEST.dbo.spiders_quasar

---------------------------------------------------
select * from IndexMap where tablename like 'mangaAl%' --88 hiall 89 hibonus 91 mangaAlfalfaDR15

exec spIndexCreate_print 0,0,88
exec spIndexCreate_print 0,0,89
exec spIndexCreate_print 0,0,91

SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE mangaHIall ADD CONSTRAINT pk_mangaHIall_plateIFU PRIMARY KEY CLUSTERED (plateIFU)  WITH (DATA_COMPRESSION = page) ON [SPEC]

SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE mangaHIbonus ADD CONSTRAINT pk_mangaHIbonus_plateIFU_bonusid PRIMARY KEY CLUSTERED (plateIFU,bonusid)  WITH (DATA_COMPRESSION = page) ON [SPEC]

SET ANSI_NULLS ON; SET ANSI_PADDING ON; SET ANSI_WARNINGS ON; SET ARITHABORT OFF; SET CONCAT_NULL_YIELDS_NULL ON;  SET NUMERIC_ROUNDABORT OFF; SET QUOTED_IDENTIFIER ON; ALTER TABLE mangaAlfalfaDR15 ADD CONSTRAINT pk_mangaAlfalfaDR15_plateIFU PRIMARY KEY CLUSTERED (plateIFU)  WITH (DATA_COMPRESSION = page) ON [SPEC]


insert mangaHiAll with (tablock)
select * from BESTTEST.dbo.mangaHIall

insert mangaHIbonus with (tablock)
select * from BESTTEST.dbo.mangaHIbonus

insert mangaAlfalfaDR15 with (tablock)
select * from BESTTEST.dbo.mangaAlfalfaDR15







