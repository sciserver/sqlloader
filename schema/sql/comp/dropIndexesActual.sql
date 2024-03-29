ALTER TABLE PhotoObjAll DROP CONSTRAINT pk_PhotoObjAll_objID
ALTER TABLE PhotoProfile DROP CONSTRAINT pk_PhotoProfile_objID_bin_band
ALTER TABLE PhotoPrimaryDR7 DROP CONSTRAINT pk_PhotoPrimaryDR7_dr8objID
DROP INDEX PhotoObjDR7.i_PhotoObjDR7_dr7objID
ALTER TABLE PhotoObjDR7 DROP CONSTRAINT pk_PhotoObjDR7_dr8objID
ALTER TABLE PhotozErrorMap DROP CONSTRAINT pk_PhotozErrorMap_cellID
DROP INDEX Field.i_Field_run_camcol_field_rerun
DROP INDEX Field.i_Field_field_camcol_run_rerun
ALTER TABLE Field DROP CONSTRAINT pk_Field_fieldID
ALTER TABLE FieldProfile DROP CONSTRAINT pk_FieldProfile_fieldID_bin_band
DROP INDEX Mask.i_Mask_htmID_ra_dec_cx_cy_cz
ALTER TABLE Mask DROP CONSTRAINT pk_Mask_maskID
ALTER TABLE FIRST DROP CONSTRAINT pk_First_objID
ALTER TABLE USNO DROP CONSTRAINT pk_USNO_objID
DROP INDEX TwoMass.i_TwoMass_phqual
DROP INDEX TwoMass.i_TwoMass_ccflag
DROP INDEX TwoMass.i_TwoMass_k
DROP INDEX TwoMass.i_TwoMass_h
DROP INDEX TwoMass.i_TwoMass_j
DROP INDEX TwoMass.i_TwoMass_dec
DROP INDEX TwoMass.i_TwoMass_ra
ALTER TABLE TwoMass DROP CONSTRAINT pk_TwoMass_objID
ALTER TABLE TwoMassXSC DROP CONSTRAINT pk_TwoMassXSC_objID
DROP INDEX WISE_xmatch.i_WISE_xmatch_wise_cntr
ALTER TABLE WISE_xmatch DROP CONSTRAINT pk_WISE_xmatch_sdss_objID_wise_c
DROP INDEX thingIndex.i_thingIndex_objID
ALTER TABLE thingIndex DROP CONSTRAINT pk_thingIndex_thingId
DROP INDEX detectionIndex.i_detectionIndex_thingID
ALTER TABLE detectionIndex DROP CONSTRAINT pk_detectionIndex_thingId_objID
ALTER TABLE ProperMotions DROP CONSTRAINT pk_ProperMotions_objID
ALTER TABLE MaskedObject DROP CONSTRAINT pk_MaskedObject_objid_maskid
DROP INDEX zooVotes.i_zooVotes_objID
ALTER TABLE zooVotes DROP CONSTRAINT pk_zooVotes_dr7objid
ALTER TABLE zoo2MainPhotoz DROP CONSTRAINT pk_zoo2MainPhotoz_dr7objid
ALTER TABLE sppLines DROP CONSTRAINT pk_sppLines_specObjID
DROP INDEX segueTargetAll.i_segueTargetAll_segue1_target1_
ALTER TABLE segueTargetAll DROP CONSTRAINT pk_segueTargetAll_objID
ALTER TABLE galSpecExtra DROP CONSTRAINT pk_galSpecExtra_specObjID
ALTER TABLE galSpecIndx DROP CONSTRAINT pk_galSpecIndx_specObjID
ALTER TABLE galSpecInfo DROP CONSTRAINT pk_galSpecInfo_specObjID
ALTER TABLE emissionLinesPort DROP CONSTRAINT pk_emissionLinesPort_specObjID
ALTER TABLE stellarMassFSPSGranEarlyDust DROP CONSTRAINT pk_stellarMassFSPSGranEarlyDust_
ALTER TABLE stellarMassFSPSGranEarlyNoDust DROP CONSTRAINT pk_stellarMassFSPSGranEarlyNoDus
ALTER TABLE stellarMassFSPSGranWideDust DROP CONSTRAINT pk_stellarMassFSPSGranWideDust_s
ALTER TABLE stellarMassFSPSGranWideNoDust DROP CONSTRAINT pk_stellarMassFSPSGranWideNoDust
ALTER TABLE stellarMassPCAWiscBC03 DROP CONSTRAINT pk_stellarMassPCAWiscBC03_specOb
ALTER TABLE stellarMassPCAWiscM11 DROP CONSTRAINT pk_stellarMassPCAWiscM11_specObj
ALTER TABLE stellarMassStarformingPort DROP CONSTRAINT pk_stellarMassStarformingPort_sp
ALTER TABLE stellarMassPassivePort DROP CONSTRAINT pk_stellarMassPassivePort_specOb
DROP INDEX apogeeVisit.i_apogeeVisit_plate_mjd_fiberid
DROP INDEX apogeeVisit.i_apogeeVisit_apogee_id
ALTER TABLE apogeeVisit DROP CONSTRAINT pk_apogeeVisit_visit_id
DROP INDEX apogeeStar.i_apogeeStar_htmID
DROP INDEX apogeeStar.i_apogeeStar_apogee_id
ALTER TABLE apogeeStar DROP CONSTRAINT pk_apogeeStar_apstar_id
DROP INDEX aspcapStar.i_aspcapStar_apstar_id
ALTER TABLE aspcapStar DROP CONSTRAINT pk_aspcapStar_aspcap_id
ALTER TABLE aspcapStarCovar DROP CONSTRAINT pk_aspcapStarCovar_aspcap_covar_
DROP INDEX apogeeObject.i_apogeeObject_apogee_id_j_h_k_j
ALTER TABLE apogeeObject DROP CONSTRAINT pk_apogeeObject_target_id
ALTER TABLE apogeeStarVisit DROP CONSTRAINT pk_apogeeStarVisit_visit_id
ALTER TABLE apogeeStarAllVisit DROP CONSTRAINT pk_apogeeStarAllVisit_visit_id_a
DROP INDEX zooSpec.i_zooSpec_objID
ALTER TABLE zooSpec DROP CONSTRAINT pk_zooSpec_specObjID
DROP INDEX zooConfidence.i_zooConfidence_objID
ALTER TABLE zooConfidence DROP CONSTRAINT pk_zooConfidence_specObjID
ALTER TABLE zoo2MainSpecz DROP CONSTRAINT pk_zoo2MainSpecz_dr7objid
ALTER TABLE zoo2Stripe82Coadd1 DROP CONSTRAINT pk_zoo2Stripe82Coadd1_stripe82ob
ALTER TABLE zoo2Stripe82Coadd2 DROP CONSTRAINT pk_zoo2Stripe82Coadd2_stripe82ob
ALTER TABLE zoo2Stripe82Normal DROP CONSTRAINT pk_zoo2Stripe82Normal_dr7objid
ALTER TABLE marvelsVelocityCurveUF1D DROP CONSTRAINT pk_marvelsVelocityCurveUF1D_STAR
DROP INDEX sdssTiledTargetAll.i_sdssTiledTargetAll_htmID_ra_de
ALTER TABLE sdssTiledTargetAll DROP CONSTRAINT pk_sdssTiledTargetAll_targetID
DROP INDEX sdssTilingInfo.i_sdssTilingInfo_tile_collisionG
DROP INDEX sdssTilingInfo.i_sdssTilingInfo_tileRun_tid_col
DROP INDEX sdssTilingInfo.i_sdssTilingInfo_targetID_tileRu
ALTER TABLE sdssTilingInfo DROP CONSTRAINT pk_sdssTilingInfo_tileRun_target
DROP INDEX HalfSpace.i_HalfSpace_regionID_convexID_x_
ALTER TABLE HalfSpace DROP CONSTRAINT pk_HalfSpace_constraintid
ALTER TABLE RegionArcs DROP CONSTRAINT pk_RegionArcs_regionId_convexid_
ALTER TABLE sdssPolygon2Field DROP CONSTRAINT pk_sdssPolygon2Field_sdssPolygon
ALTER TABLE sdssPolygons DROP CONSTRAINT pk_sdssPolygons_sdssPolygonID
ALTER TABLE Zone DROP CONSTRAINT pk_Zone_zoneID_ra_objID
DROP INDEX Neighbors.I_Neighbors_distance
ALTER TABLE Neighbors DROP CONSTRAINT pk_Neighbors_objID_NeighborObjID
DROP INDEX SpecPhotoAll.i_SpecPhotoAll_targetObjID_scien
DROP INDEX SpecPhotoAll.i_SpecPhotoAll_objID_sciencePrim
ALTER TABLE SpecPhotoAll DROP CONSTRAINT pk_SpecPhotoAll_specObjID
