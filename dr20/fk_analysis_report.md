# Foreign Key Analysis Report

**Total FKs**: 101

**Successful**: 0

**Failed**: 101

---

## Successful Foreign Keys

---

## Failed Foreign Keys

### Data Type Mismatches (10)

**dr20_catalog_to_catwise2020_target_id_fkey**

- Child: `dr20_catalog_to_catwise2020.target_id` (varchar(25)

(1 rows affected))
- Parent: `dr20_catwise2020.source_id` (char(25)

(1 rows affected))
- Issue: Data type mismatch: dr20_catalog_to_catwise2020.target_id (varchar(25)

(1 rows affected)) != dr20_catwise2020.source_id (char(25)

(1 rows affected))

**dr20_catalog_to_mangatarget_target_id_fkey**

- Child: `dr20_catalog_to_mangatarget.target_id` (varchar(255)

(1 rows affected))
- Parent: `dr20_mangatarget.mangaid` (varchar(20)

(1 rows affected))
- Issue: Data type mismatch: dr20_catalog_to_mangatarget.target_id (varchar(255)

(1 rows affected)) != dr20_mangatarget.mangaid (varchar(20)

(1 rows affected))

**dr20_catalog_to_marvels_dr11_star_target_id_fkey**

- Child: `dr20_catalog_to_marvels_dr11_star.target_id` (varchar(255)

(1 rows affected))
- Parent: `dr20_marvels_dr11_star.starname` (varchar(100)

(1 rows affected))
- Issue: Data type mismatch: dr20_catalog_to_marvels_dr11_star.target_id (varchar(255)

(1 rows affected)) != dr20_marvels_dr11_star.starname (varchar(100)

(1 rows affected))

**dr20_catalog_to_mastar_goodstars_target_id_fkey**

- Child: `dr20_catalog_to_mastar_goodstars.target_id` (varchar(255)

(1 rows affected))
- Parent: `dr20_mastar_goodstars.mangaid` (varchar(25)

(1 rows affected))
- Issue: Data type mismatch: dr20_catalog_to_mastar_goodstars.target_id (varchar(255)

(1 rows affected)) != dr20_mastar_goodstars.mangaid (varchar(25)

(1 rows affected))

**dr20_mipsgal_twomass_name_fkey**

- Child: `dr20_mipsgal.twomass_name` (varchar(17)

(1 rows affected))
- Parent: `dr20_twomass_psc.designation` (varchar(100)

(1 rows affected))
- Issue: Data type mismatch: dr20_mipsgal.twomass_name (varchar(17)

(1 rows affected)) != dr20_twomass_psc.designation (varchar(100)

(1 rows affected))

**dr20_opsdb_apo_camera_frame_camera_pk_fkey**

- Child: `dr20_opsdb_apo_camera_frame.camera_pk` (smallint

(1 rows affected))
- Parent: `dr20_opsdb_apo_camera.pk` (int

(1 rows affected))
- Issue: Data type mismatch: dr20_opsdb_apo_camera_frame.camera_pk (smallint

(1 rows affected)) != dr20_opsdb_apo_camera.pk (int

(1 rows affected))

**dr20_opsdb_apo_exposure_exposure_flavor_pk_fkey**

- Child: `dr20_opsdb_apo_exposure.exposure_flavor_pk` (smallint

(1 rows affected))
- Parent: `dr20_opsdb_apo_exposure_flavor.pk` (int

(1 rows affected))
- Issue: Data type mismatch: dr20_opsdb_apo_exposure.exposure_flavor_pk (smallint

(1 rows affected)) != dr20_opsdb_apo_exposure_flavor.pk (int

(1 rows affected))

**dr20_opsdb_lco_camera_frame_camera_pk_fkey**

- Child: `dr20_opsdb_lco_camera_frame.camera_pk` (smallint

(1 rows affected))
- Parent: `dr20_opsdb_lco_camera.pk` (int

(1 rows affected))
- Issue: Data type mismatch: dr20_opsdb_lco_camera_frame.camera_pk (smallint

(1 rows affected)) != dr20_opsdb_lco_camera.pk (int

(1 rows affected))

**dr20_opsdb_lco_design_to_status_completion_status_pk_fkey**

- Child: `dr20_opsdb_lco_design_to_status.completion_status_pk` (smallint

(1 rows affected))
- Parent: `dr20_opsdb_lco_completion_status.pk` (int

(1 rows affected))
- Issue: Data type mismatch: dr20_opsdb_lco_design_to_status.completion_status_pk (smallint

(1 rows affected)) != dr20_opsdb_lco_completion_status.pk (int

(1 rows affected))

**dr20_opsdb_lco_exposure_exposure_flavor_pk_fkey**

- Child: `dr20_opsdb_lco_exposure.exposure_flavor_pk` (smallint

(1 rows affected))
- Parent: `dr20_opsdb_lco_exposure_flavor.pk` (int

(1 rows affected))
- Issue: Data type mismatch: dr20_opsdb_lco_exposure.exposure_flavor_pk (smallint

(1 rows affected)) != dr20_opsdb_lco_exposure_flavor.pk (int

(1 rows affected))

### Missing Primary Key / Unique Constraint (91)

**dr20_assignment_carton_to_target_pk_fkey**

- Child: `dr20_assignment.carton_to_target_pk`
- Parent: `dr20_carton_to_target.carton_to_target_pk`
- Issue: Parent column 'dr20_carton_to_target.carton_to_target_pk' does not have a primary key or unique constraint

**dr20_assignment_design_id_fkey**

- Child: `dr20_assignment.design_id`
- Parent: `dr20_design.design_id`
- Issue: Parent column 'dr20_design.design_id' does not have a primary key or unique constraint

**dr20_assignment_hole_pk_fkey**

- Child: `dr20_assignment.hole_pk`
- Parent: `dr20_hole.pk`
- Issue: Parent column 'dr20_hole.pk' does not have a primary key or unique constraint

**dr20_bailer_jones_edr3_source_id_fkey**

- Child: `dr20_bailer_jones_edr3.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_best_brightest_cntr_fkey**

- Child: `dr20_best_brightest.cntr`
- Parent: `dr20_allwise.cntr`
- Issue: Parent column 'dr20_allwise.cntr' does not have a primary key or unique constraint

**dr20_bhm_rm_v1_1_panstarrs1_catid_objid_fkey**

- Child: `dr20_bhm_rm_v1_1.panstarrs1_catid_objid`
- Parent: `dr20_panstarrs1.catid_objid`
- Issue: Parent column 'dr20_panstarrs1.catid_objid' does not have a primary key or unique constraint

**dr20_bhm_rm_v1_3_ls_id_dr8_fkey**

- Child: `dr20_bhm_rm_v1_3.ls_id_dr8`
- Parent: `dr20_legacy_survey_dr8.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr8.ls_id' does not have a primary key or unique constraint

**dr20_bhm_rm_v1_3_panstarrs1_catid_objid_fkey**

- Child: `dr20_bhm_rm_v1_3.panstarrs1_catid_objid`
- Parent: `dr20_panstarrs1.catid_objid`
- Issue: Parent column 'dr20_panstarrs1.catid_objid' does not have a primary key or unique constraint

**dr20_bhm_rm_v1_panstarrs1_catid_objid_fkey**

- Child: `dr20_bhm_rm_v1.panstarrs1_catid_objid`
- Parent: `dr20_panstarrs1.catid_objid`
- Issue: Parent column 'dr20_panstarrs1.catid_objid' does not have a primary key or unique constraint

**dr20_bhm_spiders_agn_superset_gaia_dr2_source_id_fkey**

- Child: `dr20_bhm_spiders_agn_superset.gaia_dr2_source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_bhm_spiders_agn_superset_ls_id_fkey**

- Child: `dr20_bhm_spiders_agn_superset.ls_id`
- Parent: `dr20_legacy_survey_dr8.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr8.ls_id' does not have a primary key or unique constraint

**dr20_bhm_spiders_clusters_superset_gaia_dr2_source_id_fkey**

- Child: `dr20_bhm_spiders_clusters_superset.gaia_dr2_source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_bhm_spiders_clusters_superset_ls_id_fkey**

- Child: `dr20_bhm_spiders_clusters_superset.ls_id`
- Parent: `dr20_legacy_survey_dr8.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr8.ls_id' does not have a primary key or unique constraint

**dr20_cataclysmic_variables_source_id_fkey**

- Child: `dr20_cataclysmic_variables.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_catalog_to_allstar_dr17_synspec_rev1_target_id_fkey**

- Child: `dr20_catalog_to_allstar_dr17_synspec_rev1.target_id`
- Parent: `dr20_allstar_dr17_synspec_rev1.apstar_id`
- Issue: Parent column 'dr20_allstar_dr17_synspec_rev1.apstar_id' does not have a primary key or unique constraint

**dr20_catalog_to_allwise_target_id_fkey**

- Child: `dr20_catalog_to_allwise.target_id`
- Parent: `dr20_allwise.cntr`
- Issue: Parent column 'dr20_allwise.cntr' does not have a primary key or unique constraint

**dr20_catalog_to_bhm_csc_target_id_fkey**

- Child: `dr20_catalog_to_bhm_csc.target_id`
- Parent: `dr20_bhm_csc.pk`
- Issue: Parent column 'dr20_bhm_csc.pk' does not have a primary key or unique constraint

**dr20_catalog_to_bhm_rm_v0_2_target_id_fkey**

- Child: `dr20_catalog_to_bhm_rm_v0_2.target_id`
- Parent: `dr20_bhm_rm_v0_2.pk`
- Issue: Parent column 'dr20_bhm_rm_v0_2.pk' does not have a primary key or unique constraint

**dr20_catalog_to_bhm_rm_v0_target_id_fkey**

- Child: `dr20_catalog_to_bhm_rm_v0.target_id`
- Parent: `dr20_bhm_rm_v0.pk`
- Issue: Parent column 'dr20_bhm_rm_v0.pk' does not have a primary key or unique constraint

**dr20_catalog_to_gaia_dr2_source_target_id_fkey**

- Child: `dr20_catalog_to_gaia_dr2_source.target_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_catalog_to_gaia_dr3_source_target_id_fkey**

- Child: `dr20_catalog_to_gaia_dr3_source.target_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_catalog_to_glimpse_target_id_fkey**

- Child: `dr20_catalog_to_glimpse.target_id`
- Parent: `dr20_glimpse.pk`
- Issue: Parent column 'dr20_glimpse.pk' does not have a primary key or unique constraint

**dr20_catalog_to_guvcat_target_id_fkey**

- Child: `dr20_catalog_to_guvcat.target_id`
- Parent: `dr20_guvcat.objid`
- Issue: Parent column 'dr20_guvcat.objid' does not have a primary key or unique constraint

**dr20_catalog_to_legacy_survey_dr10_target_id_fkey**

- Child: `dr20_catalog_to_legacy_survey_dr10.target_id`
- Parent: `dr20_legacy_survey_dr10.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr10.ls_id' does not have a primary key or unique constraint

**dr20_catalog_to_legacy_survey_dr8_target_id_fkey**

- Child: `dr20_catalog_to_legacy_survey_dr8.target_id`
- Parent: `dr20_legacy_survey_dr8.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr8.ls_id' does not have a primary key or unique constraint

**dr20_catalog_to_marvels_dr12_star_target_id_fkey**

- Child: `dr20_catalog_to_marvels_dr12_star.target_id`
- Parent: `dr20_marvels_dr12_star.pk`
- Issue: Parent column 'dr20_marvels_dr12_star.pk' does not have a primary key or unique constraint

**dr20_catalog_to_milliquas_7_7_target_id_fkey**

- Child: `dr20_catalog_to_milliquas_7_7.target_id`
- Parent: `dr20_milliquas_7_7.pk`
- Issue: Parent column 'dr20_milliquas_7_7.pk' does not have a primary key or unique constraint

**dr20_catalog_to_panstarrs1_target_id_fkey**

- Child: `dr20_catalog_to_panstarrs1.target_id`
- Parent: `dr20_panstarrs1.catid_objid`
- Issue: Parent column 'dr20_panstarrs1.catid_objid' does not have a primary key or unique constraint

**dr20_catalog_to_sdss_dr13_photoobj_primary_target_id_fkey**

- Child: `dr20_catalog_to_sdss_dr13_photoobj_primary.target_id`
- Parent: `dr20_sdss_dr13_photoobj_primary.objid`
- Issue: Parent column 'dr20_sdss_dr13_photoobj_primary.objid' does not have a primary key or unique constraint

**dr20_catalog_to_sdss_dr16_specobj_target_id_fkey**

- Child: `dr20_catalog_to_sdss_dr16_specobj.target_id`
- Parent: `dr20_sdss_dr16_specobj.specobjid`
- Issue: Parent column 'dr20_sdss_dr16_specobj.specobjid' does not have a primary key or unique constraint

**dr20_catalog_to_sdss_dr17_specobj_target_id_fkey**

- Child: `dr20_catalog_to_sdss_dr17_specobj.target_id`
- Parent: `dr20_sdss_dr17_specobj.specobjid`
- Issue: Parent column 'dr20_sdss_dr17_specobj.specobjid' does not have a primary key or unique constraint

**dr20_catalog_to_skies_v1_target_id_fkey**

- Child: `dr20_catalog_to_skies_v1.target_id`
- Parent: `dr20_skies_v1.pix_32768`
- Issue: Parent column 'dr20_skies_v1.pix_32768' does not have a primary key or unique constraint

**dr20_catalog_to_skies_v2_target_id_fkey**

- Child: `dr20_catalog_to_skies_v2.target_id`
- Parent: `dr20_skies_v2.pix_32768`
- Issue: Parent column 'dr20_skies_v2.pix_32768' does not have a primary key or unique constraint

**dr20_catalog_to_skymapper_dr2_target_id_fkey**

- Child: `dr20_catalog_to_skymapper_dr2.target_id`
- Parent: `dr20_skymapper_dr2.object_id`
- Issue: Parent column 'dr20_skymapper_dr2.object_id' does not have a primary key or unique constraint

**dr20_catalog_to_supercosmos_target_id_fkey**

- Child: `dr20_catalog_to_supercosmos.target_id`
- Parent: `dr20_supercosmos.objid`
- Issue: Parent column 'dr20_supercosmos.objid' does not have a primary key or unique constraint

**dr20_catalog_to_tic_v8_target_id_fkey**

- Child: `dr20_catalog_to_tic_v8.target_id`
- Parent: `dr20_tic_v8.id`
- Issue: Parent column 'dr20_tic_v8.id' does not have a primary key or unique constraint

**dr20_catalog_to_twomass_psc_target_id_fkey**

- Child: `dr20_catalog_to_twomass_psc.target_id`
- Parent: `dr20_twomass_psc.pts_key`
- Issue: Parent column 'dr20_twomass_psc.pts_key' does not have a primary key or unique constraint

**dr20_catalog_to_tycho2_target_id_fkey**

- Child: `dr20_catalog_to_tycho2.target_id`
- Parent: `dr20_tycho2.designation`
- Issue: Parent column 'dr20_tycho2.designation' does not have a primary key or unique constraint

**dr20_catalog_to_unwise_target_id_fkey**

- Child: `dr20_catalog_to_unwise.target_id`
- Parent: `dr20_unwise.unwise_objid`
- Issue: Parent column 'dr20_unwise.unwise_objid' does not have a primary key or unique constraint

**dr20_catalog_to_uvotssc1_target_id_fkey**

- Child: `dr20_catalog_to_uvotssc1.target_id`
- Parent: `dr20_uvotssc1.id`
- Issue: Parent column 'dr20_uvotssc1.id' does not have a primary key or unique constraint

**dr20_catalog_to_xmm_om_suss_4_1_target_id_fkey**

- Child: `dr20_catalog_to_xmm_om_suss_4_1.target_id`
- Parent: `dr20_xmm_om_suss_4_1.pk`
- Issue: Parent column 'dr20_xmm_om_suss_4_1.pk' does not have a primary key or unique constraint

**dr20_catalog_to_xmm_om_suss_5_0_target_id_fkey**

- Child: `dr20_catalog_to_xmm_om_suss_5_0.target_id`
- Parent: `dr20_xmm_om_suss_5_0.pk`
- Issue: Parent column 'dr20_xmm_om_suss_5_0.pk' does not have a primary key or unique constraint

**dr20_design_design_mode_label_fkey**

- Child: `dr20_design.design_mode_label`
- Parent: `dr20_design_mode.label`
- Issue: Parent column 'dr20_design_mode.label' does not have a primary key or unique constraint

**dr20_design_mode_check_results_design_id_fkey**

- Child: `dr20_design_mode_check_results.design_id`
- Parent: `dr20_design.design_id`
- Issue: Parent column 'dr20_design.design_id' does not have a primary key or unique constraint

**dr20_design_to_field_design_id_fkey**

- Child: `dr20_design_to_field.design_id`
- Parent: `dr20_design.design_id`
- Issue: Parent column 'dr20_design.design_id' does not have a primary key or unique constraint

**dr20_design_to_field_field_pk_fkey**

- Child: `dr20_design_to_field.field_pk`
- Parent: `dr20_field.pk`
- Issue: Parent column 'dr20_field.pk' does not have a primary key or unique constraint

**dr20_ebosstarget_v5_objid_targeting_fkey**

- Child: `dr20_ebosstarget_v5.objid_targeting`
- Parent: `dr20_sdss_dr13_photoobj_primary.objid`
- Issue: Parent column 'dr20_sdss_dr13_photoobj_primary.objid' does not have a primary key or unique constraint

**dr20_erosita_superset_compactobjects_gaia_dr2_id_fkey**

- Child: `dr20_erosita_superset_compactobjects.gaia_dr2_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_erosita_superset_stars_gaia_dr2_id_fkey**

- Child: `dr20_erosita_superset_stars.gaia_dr2_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_agn_gaia_dr3_source_id_fkey**

- Child: `dr20_erosita_superset_v1_agn.gaia_dr3_source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_agn_ls_id_fkey**

- Child: `dr20_erosita_superset_v1_agn.ls_id`
- Parent: `dr20_legacy_survey_dr10.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr10.ls_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_clusters_gaia_dr3_source_id_fkey**

- Child: `dr20_erosita_superset_v1_clusters.gaia_dr3_source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_clusters_ls_id_fkey**

- Child: `dr20_erosita_superset_v1_clusters.ls_id`
- Parent: `dr20_legacy_survey_dr10.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr10.ls_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_compactobjects_gaia_dr3_source_id_fkey**

- Child: `dr20_erosita_superset_v1_compactobjects.gaia_dr3_source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_compactobjects_ls_id_fkey**

- Child: `dr20_erosita_superset_v1_compactobjects.ls_id`
- Parent: `dr20_legacy_survey_dr10.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr10.ls_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_stars_gaia_dr3_source_id_fkey**

- Child: `dr20_erosita_superset_v1_stars.gaia_dr3_source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_erosita_superset_v1_stars_ls_id_fkey**

- Child: `dr20_erosita_superset_v1_stars.ls_id`
- Parent: `dr20_legacy_survey_dr10.ls_id`
- Issue: Parent column 'dr20_legacy_survey_dr10.ls_id' does not have a primary key or unique constraint

**dr20_field_observatory_pk_fkey**

- Child: `dr20_field.observatory_pk`
- Parent: `dr20_observatory.pk`
- Issue: Parent column 'dr20_observatory.pk' does not have a primary key or unique constraint

**dr20_field_version_pk_fkey**

- Child: `dr20_field.version_pk`
- Parent: `dr20_targetdb_version.pk`
- Issue: Parent column 'dr20_targetdb_version.pk' does not have a primary key or unique constraint

**dr20_gaia_assas_sn_cepheids_source_id_fkey**

- Child: `dr20_gaia_assas_sn_cepheids.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_gaia_dr2_ruwe_source_id_fkey**

- Child: `dr20_gaia_dr2_ruwe.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_gaia_dr2_wd_source_id_fkey**

- Child: `dr20_gaia_dr2_wd.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_gaia_dr3_astrophysical_parameters_source_id_fkey**

- Child: `dr20_gaia_dr3_astrophysical_parameters.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_gaia_dr3_nss_two_body_orbit_source_id_fkey**

- Child: `dr20_gaia_dr3_nss_two_body_orbit.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_gaia_dr3_synthetic_photometry_gspc_source_id_fkey**

- Child: `dr20_gaia_dr3_synthetic_photometry_gspc.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_gaia_dr3_vari_rrlyrae_source_id_fkey**

- Child: `dr20_gaia_dr3_vari_rrlyrae.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_gaia_unwise_agn_gaia_sourceid_fkey**

- Child: `dr20_gaia_unwise_agn.gaia_sourceid`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_gaiadr2_tmass_best_neighbour_source_id_fkey**

- Child: `dr20_gaiadr2_tmass_best_neighbour.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_galah_dr3_dr2_source_id_fkey**

- Child: `dr20_galah_dr3.dr2_source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_galah_dr3_dr3_source_id_fkey**

- Child: `dr20_galah_dr3.dr3_source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_galex_gr7_gaia_dr3_gaia_edr3_source_id_fkey**

- Child: `dr20_galex_gr7_gaia_dr3.gaia_edr3_source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_gedr3spur_main_source_id_fkey**

- Child: `dr20_gedr3spur_main.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_geometric_distances_gaia_dr2_source_id_fkey**

- Child: `dr20_geometric_distances_gaia_dr2.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_hole_observatory_pk_fkey**

- Child: `dr20_hole.observatory_pk`
- Parent: `dr20_observatory.pk`
- Issue: Parent column 'dr20_observatory.pk' does not have a primary key or unique constraint

**dr20_mwm_tess_ob_gaia_dr2_id_fkey**

- Child: `dr20_mwm_tess_ob.gaia_dr2_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_opsdb_lco_camera_frame_exposure_pk_fkey**

- Child: `dr20_opsdb_lco_camera_frame.exposure_pk`
- Parent: `dr20_opsdb_lco_exposure.pk`
- Issue: Parent column 'dr20_opsdb_lco_exposure.pk' does not have a primary key or unique constraint

**dr20_opsdb_lco_exposure_configuration_id_fkey**

- Child: `dr20_opsdb_lco_exposure.configuration_id`
- Parent: `dr20_opsdb_lco_configuration.configuration_id`
- Issue: Parent column 'dr20_opsdb_lco_configuration.configuration_id' does not have a primary key or unique constraint

**dr20_sagitta_edr3_source_id_fkey**

- Child: `dr20_sagitta_edr3.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_sagitta_source_id_fkey**

- Child: `dr20_sagitta.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_sdss_dr16_qso_plate_fiberid_mjd_fkey**

- Child: `dr20_sdss_dr16_qso.plate, fiberid, mjd`
- Parent: `dr20_sdss_dr16_specobj.plate, fiberid, mjd`
- Issue: Parent column 'dr20_sdss_dr16_specobj.plate, fiberid, mjd' does not have a primary key or unique constraint

**dr20_sdssv_plateholes_yanny_uid_fkey**

- Child: `dr20_sdssv_plateholes.yanny_uid`
- Parent: `dr20_sdssv_plateholes_meta.yanny_uid`
- Issue: Parent column 'dr20_sdssv_plateholes_meta.yanny_uid' does not have a primary key or unique constraint

**dr20_skymapper_gaia_gaia_source_id_fkey**

- Child: `dr20_skymapper_gaia.gaia_source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_targeting_generation_to_carton_carton_pk_fkey**

- Child: `dr20_targeting_generation_to_carton.carton_pk`
- Parent: `dr20_carton.carton_pk`
- Issue: Parent column 'dr20_carton.carton_pk' does not have a primary key or unique constraint

**dr20_targeting_generation_to_version_version_pk_fkey**

- Child: `dr20_targeting_generation_to_version.version_pk`
- Parent: `dr20_targetdb_version.pk`
- Issue: Parent column 'dr20_targetdb_version.pk' does not have a primary key or unique constraint

**dr20_tess_toi_ticid_fkey**

- Child: `dr20_tess_toi.ticid`
- Parent: `dr20_tic_v8.id`
- Issue: Parent column 'dr20_tic_v8.id' does not have a primary key or unique constraint

**dr20_tess_toi_v05_ticid_fkey**

- Child: `dr20_tess_toi_v05.ticid`
- Parent: `dr20_tic_v8.id`
- Issue: Parent column 'dr20_tic_v8.id' does not have a primary key or unique constraint

**dr20_tess_toi_v1_ticid_fkey**

- Child: `dr20_tess_toi_v1.ticid`
- Parent: `dr20_tic_v8.id`
- Issue: Parent column 'dr20_tic_v8.id' does not have a primary key or unique constraint

**dr20_wd_gaia_dr3_gaiaedr3_fkey**

- Child: `dr20_wd_gaia_dr3.gaiaedr3`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_xpfeh_gaia_dr3_source_id_fkey**

- Child: `dr20_xpfeh_gaia_dr3.source_id`
- Parent: `dr20_gaia_dr3_source.source_id`
- Issue: Parent column 'dr20_gaia_dr3_source.source_id' does not have a primary key or unique constraint

**dr20_yso_clustering_source_id_fkey**

- Child: `dr20_yso_clustering.source_id`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

**dr20_zari18pms_source_fkey**

- Child: `dr20_zari18pms.source`
- Parent: `dr20_gaia_dr2_source.source_id`
- Issue: Parent column 'dr20_gaia_dr2_source.source_id' does not have a primary key or unique constraint

