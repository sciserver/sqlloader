drop view if exists Neighbors
GO
create view Neighbors as select * from BestDRx.dbo.[Neighbors]
GO
 
drop view if exists PhotoProfile
GO
create view PhotoProfile as select * from BestDRx.dbo.[PhotoProfile]
GO
 
drop view if exists Frame
GO
create view Frame as select * from BestDRx.dbo.[Frame]
GO
 
drop view if exists PhotoObjDR7
GO
create view PhotoObjDR7 as select * from BestDRx.dbo.[PhotoObjDR7]
GO
 
drop view if exists FieldProfile
GO
create view FieldProfile as select * from BestDRx.dbo.[FieldProfile]
GO
 
drop view if exists First
GO
create view First as select * from BestDRx.dbo.[First]
GO
 
drop view if exists Rosat
GO
create view Rosat as select * from BestDRx.dbo.[Rosat]
GO
 
drop view if exists TwoMass
GO
create view TwoMass as select * from BestDRx.dbo.[TwoMass]
GO
 
drop view if exists WISE_xmatch
GO
create view WISE_xmatch as select * from BestDRx.dbo.[WISE_xmatch]
GO
 
drop view if exists wiseForcedTarget
GO
create view wiseForcedTarget as select * from BestDRx.dbo.[wiseForcedTarget]
GO
 
drop view if exists detectionIndex
GO
create view detectionIndex as select * from BestDRx.dbo.[detectionIndex]
GO
 
drop view if exists StripeDefs
GO
create view StripeDefs as select * from BestDRx.dbo.[StripeDefs]
GO
 
drop view if exists zooMirrorBias
GO
create view zooMirrorBias as select * from BestDRx.dbo.[zooMirrorBias]
GO
 
drop view if exists zooNoSpec
GO
create view zooNoSpec as select * from BestDRx.dbo.[zooNoSpec]
GO
 
drop view if exists zoo2MainPhotoz
GO
create view zoo2MainPhotoz as select * from BestDRx.dbo.[zoo2MainPhotoz]
GO
 
drop view if exists Region
GO
create view Region as select * from BestDRx.dbo.[Region]
GO
 
drop view if exists RegionArcs
GO
create view RegionArcs as select * from BestDRx.dbo.[RegionArcs]
GO
 
drop view if exists sdssImagingHalfspaces
GO
create view sdssImagingHalfspaces as select * from BestDRx.dbo.[sdssImagingHalfspaces]
GO
 
drop view if exists sdssPolygons
GO
create view sdssPolygons as select * from BestDRx.dbo.[sdssPolygons]
GO
 
drop view if exists sppParams
GO
create view sppParams as select * from BestDRx.dbo.[sppParams]
GO
 
drop view if exists segueTargetAll
GO
create view segueTargetAll as select * from BestDRx.dbo.[segueTargetAll]
GO
 
drop view if exists galSpecIndx
GO
create view galSpecIndx as select * from BestDRx.dbo.[galSpecIndx]
GO
 
drop view if exists galSpecLine
GO
create view galSpecLine as select * from BestDRx.dbo.[galSpecLine]
GO
 
drop view if exists stellarMassFSPSGranEarlyDust
GO
create view stellarMassFSPSGranEarlyDust as select * from BestDRx.dbo.[stellarMassFSPSGranEarlyDust]
GO
 
drop view if exists stellarMassFSPSGranWideDust
GO
create view stellarMassFSPSGranWideDust as select * from BestDRx.dbo.[stellarMassFSPSGranWideDust]
GO
 
drop view if exists stellarMassPCAWiscBC03
GO
create view stellarMassPCAWiscBC03 as select * from BestDRx.dbo.[stellarMassPCAWiscBC03]
GO
 
drop view if exists stellarMassStarformingPort
GO
create view stellarMassStarformingPort as select * from BestDRx.dbo.[stellarMassStarformingPort]
GO
 
drop view if exists sppTargets
GO
create view sppTargets as select * from BestDRx.dbo.[sppTargets]
GO
 
drop view if exists TargetInfo
GO
create view TargetInfo as select * from BestDRx.dbo.[TargetInfo]
GO
 
drop view if exists sdssTileAll
GO
create view sdssTileAll as select * from BestDRx.dbo.[sdssTileAll]
GO
 
drop view if exists sdssTilingRun
GO
create view sdssTilingRun as select * from BestDRx.dbo.[sdssTilingRun]
GO
 
drop view if exists sdssTilingInfo
GO
create view sdssTilingInfo as select * from BestDRx.dbo.[sdssTilingInfo]
GO
 
drop view if exists Zone
GO
create view Zone as select * from BestDRx.dbo.[Zone]
GO
 
drop view if exists PhotoZ
GO
create view PhotoZ as select * from BestDRx.dbo.[PhotoZ]
GO
 
