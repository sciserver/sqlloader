
DROP INDEX [dbo].[zooConfidence].[pk_zooConfidence_specObjID]

DROP INDEX [dbo].[stellarMassPCAWiscBC03].[pk_stellarMassPCAWiscBC03_specOb]
alter table [stellarMassPCAWiscBC03]
add constraint [pk_stellarMassPCAWiscBC03_specOb]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]
DROP INDEX [dbo].[stellarMassPCAWiscM11].[pk_stellarMassPCAWiscM11_specObj]
alter table [stellarMassPCAWiscM11]
add constraint [pk_stellarMassPCAWiscM11_specObj]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]


DROP INDEX [dbo].[stellarMassPassivePort].[pk_stellarMassPassivePort_specOb]
alter table [stellarMassPassivePort]
add constraint [pk_stellarMassPassivePort_specOb]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]
DROP INDEX [dbo].[stellarMassStarformingPort].[pk_stellarMassStarformingPort_sp]
alter table [stellarMassStarformingPort]
add constraint [pk_stellarMassStarformingPort_sp]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]
DROP INDEX [dbo].[stellarMassFSPSGranEarlyDust].[pk_stellarMassFSPSGranEarlyDust_]
alter table [stellarMassFSPSGranEarlyDust]
add constraint [pk_stellarMassFSPSGranEarlyDust_]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]

DROP INDEX [dbo].[stellarMassFSPSGranEarlyNoDust].[pk_stellarMassFSPSGranEarlyNoDus]
alter table [stellarMassFSPSGranEarlyNoDust]
add constraint [pk_stellarMassFSPSGranEarlyNoDus]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]

DROP INDEX [dbo].[stellarMassFSPSGranWideDust].[pk_stellarMassFSPSGranWideDust_s]
alter table [stellarMassFSPSGranWideDust]
add constraint [pk_stellarMassFSPSGranWideDust_s]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]

DROP INDEX [dbo].[stellarMassFSPSGranWideNoDust].[pk_stellarMassFSPSGranWideNoDust]
alter table [stellarMassFSPSGranWideNoDust]
add constraint [pk_stellarMassFSPSGranWideNoDust]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]
DROP INDEX [dbo].[emissionLinesPort].[pk_emissionLinesPort_specObjID]

DROP INDEX [dbo].[sppLines].[pk_sppLines_specObjID]
alter table [sppLines]
add constraint [pk_sppLines_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]

DROP INDEX [dbo].[sppParams].[pk_sppParams_specObjID]
alter table [sppParams]
add constraint [pk_sppParams_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]

DROP INDEX [dbo].[galSpecLine].[pk_galSpecLine_specObjID]
alter table [galSpecLine]
add constraint [pk_galSpecLine_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]
DROP INDEX [d
DROP INDEX [dbo].[galSpecInfo].[pk_galSpecInfo_specObjID]
alter table [galSpecInfo]
add constraint [pk_galSpecInfo_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]
DROP INDEX [dbo].[galSpecIndx].[pk_galSpecIndx_specObjID]
alter table [galSpecIndx]
add constraint [pk_galSpecIndx_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]
DROP INDEX [dbo].[galSpecExtra].[pk_galSpecExtra_specObjID]
alter table [galSpecExtra]
add constraint [pk_galSpecExtra_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]


DROP INDEX [dbo].[zooSpec].[pk_zooSpec_specObjID]

DROP INDEX [dbo].[zooConfidence].[pk_zooConfidence_specObjID]

alter table zooConfidence
add constraint pk_zooConfidence_specObjID
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]


DROP INDEX [dbo].[emissionLinesPort].[pk_emissionLinesPort_specObjID]
alter table [emissionLinesPort]
add constraint [pk_emissionLinesPort_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]


DROP INDEX [dbo].[zooSpec].[pk_zooSpec_specObjID]
alter table [zooSpec]
add constraint [pk_zooSpec_specObjID]
primary key clustered (specObjID)
with (sort_in_tempdb=on, data_compression=page)
on [datafg]



