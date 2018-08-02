drop view [Neighbors]
GO
create view Neighbors as select * from BestDRx.dbo.[Neighbors] with (nolock)
GO
 
drop view [PhotoObjAll]
GO
create view PhotoObjAll as select * from BestDRx.dbo.[PhotoObjAll] with (nolock)
GO
 
drop view [PhotoProfile]
GO
create view PhotoProfile as select * from BestDRx.dbo.[PhotoProfile] with (nolock)
GO
 
drop view [AtlasOutline]
GO
create view AtlasOutline as select * from BestDRx.dbo.[AtlasOutline] with (nolock)
GO
 
drop view [Frame]
GO
create view Frame as select * from BestDRx.dbo.[Frame] with (nolock)
GO
 
drop view [PhotoPrimaryDR7]
GO
create view PhotoPrimaryDR7 as select * from BestDRx.dbo.[PhotoPrimaryDR7] with (nolock)
GO
 
drop view [PhotoObjDR7]
GO
create view PhotoObjDR7 as select * from BestDRx.dbo.[PhotoObjDR7] with (nolock)
GO
 
drop view [Field]
GO
create view Field as select * from BestDRx.dbo.[Field] with (nolock)
GO
 
drop view [FieldProfile]
GO
create view FieldProfile as select * from BestDRx.dbo.[FieldProfile] with (nolock)
GO
 
drop view [Mask]
GO
create view Mask as select * from BestDRx.dbo.[Mask] with (nolock)
GO
 
drop view [First]
GO
create view First as select * from BestDRx.dbo.[First] with (nolock)
GO
 
drop view [RC3]
GO
create view RC3 as select * from BestDRx.dbo.[RC3] with (nolock)
GO
 
drop view [Rosat]
GO
create view Rosat as select * from BestDRx.dbo.[Rosat] with (nolock)
GO
 
drop view [USNO]
GO
create view USNO as select * from BestDRx.dbo.[USNO] with (nolock)
GO
 
drop view [TwoMass]
GO
create view TwoMass as select * from BestDRx.dbo.[TwoMass] with (nolock)
GO
 
drop view [TwoMassXSC]
GO
create view TwoMassXSC as select * from BestDRx.dbo.[TwoMassXSC] with (nolock)
GO
 
drop view [WISE_xmatch]
GO
create view WISE_xmatch as select * from BestDRx.dbo.[WISE_xmatch] with (nolock)
GO
 
drop view [WISE_allsky]
GO
create view WISE_allsky as select * from BestDRx.dbo.[WISE_allsky] with (nolock)
GO
 
drop view [wiseForcedTarget]
GO
create view wiseForcedTarget as select * from BestDRx.dbo.[wiseForcedTarget] with (nolock)
GO
 
drop view [thingIndex]
GO
create view thingIndex as select * from BestDRx.dbo.[thingIndex] with (nolock)
GO
 
drop view [detectionIndex]
GO
create view detectionIndex as select * from BestDRx.dbo.[detectionIndex] with (nolock)
GO
 
drop view [ProperMotions]
GO
create view ProperMotions as select * from BestDRx.dbo.[ProperMotions] with (nolock)
GO
 
drop view [StripeDefs]
GO
create view StripeDefs as select * from BestDRx.dbo.[StripeDefs] with (nolock)
GO
 
drop view [MaskedObject]
GO
create view MaskedObject as select * from BestDRx.dbo.[MaskedObject] with (nolock)
GO
 
drop view [zooMirrorBias]
GO
create view zooMirrorBias as select * from BestDRx.dbo.[zooMirrorBias] with (nolock)
GO
 
drop view [zooMonochromeBias]
GO
create view zooMonochromeBias as select * from BestDRx.dbo.[zooMonochromeBias] with (nolock)
GO
 
drop view [zooNoSpec]
GO
create view zooNoSpec as select * from BestDRx.dbo.[zooNoSpec] with (nolock)
GO
 
drop view [zooVotes]
GO
create view zooVotes as select * from BestDRx.dbo.[zooVotes] with (nolock)
GO
 
drop view [zoo2MainPhotoz]
GO
create view zoo2MainPhotoz as select * from BestDRx.dbo.[zoo2MainPhotoz] with (nolock)
GO
 
drop view [RMatrix]
GO
create view RMatrix as select * from BestDRx.dbo.[RMatrix] with (nolock)
GO
 
drop view [Region]
GO
create view Region as select * from BestDRx.dbo.[Region] with (nolock)
GO
 
drop view [HalfSpace]
GO
create view HalfSpace as select * from BestDRx.dbo.[HalfSpace] with (nolock)
GO
 
drop view [RegionArcs]
GO
create view RegionArcs as select * from BestDRx.dbo.[RegionArcs] with (nolock)
GO
 
drop view [RegionPatch]
GO
create view RegionPatch as select * from BestDRx.dbo.[RegionPatch] with (nolock)
GO
 
drop view [sdssImagingHalfspaces]
GO
create view sdssImagingHalfspaces as select * from BestDRx.dbo.[sdssImagingHalfspaces] with (nolock)
GO
 
drop view [sdssPolygon2Field]
GO
create view sdssPolygon2Field as select * from BestDRx.dbo.[sdssPolygon2Field] with (nolock)
GO
 
drop view [sdssPolygons]
GO
create view sdssPolygons as select * from BestDRx.dbo.[sdssPolygons] with (nolock)
GO
 
drop view [SpecDR7]
GO
create view SpecDR7 as select * from BestDRx.dbo.[SpecDR7] with (nolock)
GO
 
drop view [sppParams]
GO
create view sppParams as select * from BestDRx.dbo.[sppParams] with (nolock)
GO
 
drop view [sppLines]
GO
create view sppLines as select * from BestDRx.dbo.[sppLines] with (nolock)
GO
 
drop view [segueTargetAll]
GO
create view segueTargetAll as select * from BestDRx.dbo.[segueTargetAll] with (nolock)
GO
 
drop view [galSpecExtra]
GO
create view galSpecExtra as select * from BestDRx.dbo.[galSpecExtra] with (nolock)
GO
 
drop view [galSpecIndx]
GO
create view galSpecIndx as select * from BestDRx.dbo.[galSpecIndx] with (nolock)
GO
 
drop view [galSpecInfo]
GO
create view galSpecInfo as select * from BestDRx.dbo.[galSpecInfo] with (nolock)
GO
 
drop view [galSpecLine]
GO
create view galSpecLine as select * from BestDRx.dbo.[galSpecLine] with (nolock)
GO
 
drop view [emissionLinesPort]
GO
create view emissionLinesPort as select * from BestDRx.dbo.[emissionLinesPort] with (nolock)
GO
 
drop view [stellarMassFSPSGranEarlyDust]
GO
create view stellarMassFSPSGranEarlyDust as select * from BestDRx.dbo.[stellarMassFSPSGranEarlyDust] with (nolock)
GO
 
drop view [stellarMassFSPSGranEarlyNoDust]
GO
create view stellarMassFSPSGranEarlyNoDust as select * from BestDRx.dbo.[stellarMassFSPSGranEarlyNoDust] with (nolock)
GO
 
drop view [stellarMassFSPSGranWideDust]
GO
create view stellarMassFSPSGranWideDust as select * from BestDRx.dbo.[stellarMassFSPSGranWideDust] with (nolock)
GO
 
drop view [stellarMassFSPSGranWideNoDust]
GO
create view stellarMassFSPSGranWideNoDust as select * from BestDRx.dbo.[stellarMassFSPSGranWideNoDust] with (nolock)
GO
 
drop view [stellarMassPCAWiscBC03]
GO
create view stellarMassPCAWiscBC03 as select * from BestDRx.dbo.[stellarMassPCAWiscBC03] with (nolock)
GO
 
drop view [stellarMassPCAWiscM11]
GO
create view stellarMassPCAWiscM11 as select * from BestDRx.dbo.[stellarMassPCAWiscM11] with (nolock)
GO
 
drop view [stellarMassStarformingPort]
GO
create view stellarMassStarformingPort as select * from BestDRx.dbo.[stellarMassStarformingPort] with (nolock)
GO
 
drop view [stellarMassPassivePort]
GO
create view stellarMassPassivePort as select * from BestDRx.dbo.[stellarMassPassivePort] with (nolock)
GO
 
drop view [sppTargets]
GO
create view sppTargets as select * from BestDRx.dbo.[sppTargets] with (nolock)
GO
 
drop view [Target]
GO
create view Target as select * from BestDRx.dbo.[Target] with (nolock)
GO
 
drop view [TargetInfo]
GO
create view TargetInfo as select * from BestDRx.dbo.[TargetInfo] with (nolock)
GO
 
drop view [sdssTargetParam]
GO
create view sdssTargetParam as select * from BestDRx.dbo.[sdssTargetParam] with (nolock)
GO
 
drop view [sdssTileAll]
GO
create view sdssTileAll as select * from BestDRx.dbo.[sdssTileAll] with (nolock)
GO
 
drop view [sdssTilingGeometry]
GO
create view sdssTilingGeometry as select * from BestDRx.dbo.[sdssTilingGeometry] with (nolock)
GO
 
drop view [sdssTilingRun]
GO
create view sdssTilingRun as select * from BestDRx.dbo.[sdssTilingRun] with (nolock)
GO
 
drop view [sdssTiledTargetAll]
GO
create view sdssTiledTargetAll as select * from BestDRx.dbo.[sdssTiledTargetAll] with (nolock)
GO
 
drop view [sdssTilingInfo]
GO
create view sdssTilingInfo as select * from BestDRx.dbo.[sdssTilingInfo] with (nolock)
GO
 
drop view [plate2Target]
GO
create view plate2Target as select * from BestDRx.dbo.[plate2Target] with (nolock)
GO
 
drop view [Zone]
GO
create view Zone as select * from BestDRx.dbo.[Zone] with (nolock)
GO
 
