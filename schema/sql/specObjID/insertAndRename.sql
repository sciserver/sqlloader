

dbcc traceon(610)
insert SpecObjAll2 with (tablock)
select * from SpecObjAll
order by SpecObjID

--2:59:41

dbcc traceon(610)
insert sppParams2 with (tablock)
select * from sppParams

--2:13

insert specDR72 with (tablock)
select * from SpecDR7

-- 27s

insert galSpecLine2 with (tablock)
select * from galSpecLine


exec sp_rename 'SpecObjAll', 'SpecObjAll_bak'
exec sp_rename 'SpecObjAll2', 'SpecObjAll'

exec sp_rename 'sppParams', 'SppParams_bak'
exec sp_rename 'sppParams2', 'SppParams'

exec sp_rename 'specDR7', 'SpecDR7_bak'
exec sp_rename 'specDR72', 'SpecDR7'

exec sp_rename 'galSpecLine', 'GalSpecLine_bak'
exec sp_rename 'GalSpecLine2', 'GalSpecLine'

