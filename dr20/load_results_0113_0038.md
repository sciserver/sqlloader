# DR20 Full Production Load Results
**Generated**: 2026-01-13 00:38 (load completed)
**Started**: 2026-01-12 12:28 PM
**Duration**: ~12 hours
**Total Files**: 171
**Successful**: 164 (95.9%)
**Failed**: 7 (4.1%)

## Summary Statistics

### Successfully Loaded Tables
**Total Rows Loaded**: ~3.8+ billion rows across 164 tables

#### Largest Tables (by row count)
| Table | Rows | Status |
|-------|------|--------|
| dr20_carton_to_target | 395,566,629 | ✓ |
| dr20_assignment | 308,876,160 | ✓ |
| dr20_sdss_id_to_catalog | 279,429,626 | ✓ |
| dr20_sdss_id_flat | 278,732,646 | ✓ |
| dr20_catalog | 272,695,124 | ✓ |
| dr20_magnitude | 250,403070 | ✓ |
| dr20_sdss_id_stacked | 126,948,826 | ✓ |
| dr20_panstarrs1 | 46,404,799 | ✓ |

## Failed Loads (7 files)

### 1. Unexpected End of File Errors (5 files)

**Error Message**:
```
Msg 4832, Level 16, State 1, Server sdss4c, Line 7
Bulk load: An unexpected end of file was encountered in the data file.
```

| Table | Rows Loaded | Issue |
|-------|-------------|-------|
| dr20_gaia_dr2_source | 0 | EOF error |
| dr20_gaia_dr3_astrophysical_parameters | 0 | EOF error |
| dr20_gaia_dr3_source | 0 | EOF error |
| dr20_gaia_dr3_synthetic_photometry_gspc | 0 | EOF error |
| dr20_gaiadr2_tmass_best_neighbour | 0 | EOF error |

**Likely Causes**:
- Corrupted/truncated CSV files
- File transfer incomplete
- Encoding issues (UTF-16 vs UTF-8)
- Line ending issues (Unix vs Windows)

### 2. Type Mismatch Errors (2 files)

#### dr20_lamost_dr6
**Error**: Type mismatch on column 33 `[offsets]`
**First Error Row**: 2,705,651
**Rows Loaded**: 0

```
Msg 4864, Level 16, State 1, Server sdss4c, Line 7
Bulk load data conversion error (type mismatch or invalid character
for the specified codepage) for row 2705651, column 33 (offsets).
```

**Sample Error Rows**: 2705651, 2705672, 2705888, 2705946, 2705976, 2706122, 2706127, 2706203, 2706215, 2706237, 2706243

**Likely Causes**:
- `offsets` column is varchar(max) but may contain special characters
- Encoding issues with array-like values
- Quote escaping issues

#### dr20_target
**Error**: Type mismatch on column 8 `catalogid`
**First Error Row**: 2
**Rows Loaded**: 0

```
Msg 4864, Level 16, State 1, Server sdss4c, Line 7
Bulk load data conversion error (type mismatch or invalid character
for the specified codepage) for row 2, column 8 (catalogid).
```

**Sample Error Rows**: 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 (failed immediately)

**Likely Causes**:
- `catalogid` expected as bigint but contains non-numeric values
- NULL values represented as "NULL" string
- Scientific notation not recognized
- Empty string instead of NULL

## Complete Load Results

### All Tables (alphabetical)
| Table | Rows | Status |
|-------|------|--------|
| dr20_allstar_dr17_synspec_rev1 | 733,901 | ✓ |
| dr20_allwise | 61,473,310 | ✓ |
| dr20_assignment | 308,876,160 | ✓ |
| dr20_bailer_jones_edr3 | 60,465,191 | ✓ |
| dr20_best_brightest | 646,940 | ✓ |
| dr20_bhm_csc | 86,050 | ✓ |
| dr20_bhm_csc_v2 | 148,443 | ✓ |
| dr20_bhm_csc_v3 | 188,647 | ✓ |
| dr20_bhm_efeds_veto | 6,300 | ✓ |
| dr20_bhm_rm_tweaks | 1,914 | ✓ |
| dr20_bhm_rm_v0 | 135,653 | ✓ |
| dr20_bhm_rm_v0_2 | 135,653 | ✓ |
| dr20_bhm_rm_v1 | 5,470 | ✓ |
| dr20_bhm_rm_v1_1 | 5,987 | ✓ |
| dr20_bhm_rm_v1_3 | 5,987 | ✓ |
| dr20_bhm_spiders_agn_superset | 18,319 | ✓ |
| dr20_bhm_spiders_clusters_superset | 11,576 | ✓ |
| dr20_cadence | 7,163 | ✓ |
| dr20_cadence_epoch | 235,519 | ✓ |
| dr20_carton | 530 | ✓ |
| dr20_carton_to_target | 395,566,629 | ✓ |
| dr20_cataclysmic_variables | 5,167 | ✓ |
| dr20_catalog | 272,695,124 | ✓ |
| dr20_catalog_from_sdss_dr19p_speclite | 6,147,091 | ✓ |
| dr20_catalog_to_allstar_dr17_synspec_rev1 | 733,915 | ✓ |
| dr20_catalog_to_allwise | 176,329,430 | ✓ |
| dr20_catalog_to_bhm_csc | 187,499 | ✓ |
| dr20_catalog_to_bhm_efeds_veto | 10,326 | ✓ |
| dr20_catalog_to_bhm_rm_v0 | 280,387 | ✓ |
| dr20_catalog_to_bhm_rm_v0_2 | 280,387 | ✓ |
| dr20_catalog_to_catwise2020 | 71,348,021 | ✓ |
| dr20_catalog_to_gaia_dr2_source | 185,031,960 | ✓ |
| dr20_catalog_to_gaia_dr3_source | 67,281,150 | ✓ |
| dr20_catalog_to_glimpse | 9,522,652 | ✓ |
| dr20_catalog_to_guvcat | 40,108,740 | ✓ |
| dr20_catalog_to_legacy_survey_dr10 | 37,735,461 | ✓ |
| dr20_catalog_to_legacy_survey_dr8 | 81,777,039 | ✓ |
| dr20_catalog_to_mangatarget | 43,068 | ✓ |
| dr20_catalog_to_marvels_dr11_star | 7,066 | ✓ |
| dr20_catalog_to_marvels_dr12_star | 11,040 | ✓ |
| dr20_catalog_to_mastar_goodstars | 25,474 | ✓ |
| dr20_catalog_to_milliquas_7_7 | 1,310,382 | ✓ |
| dr20_catalog_to_panstarrs1 | 92,585,030 | ✓ |
| dr20_catalog_to_sdss_dr13_photoobj_primary | 61,411,894 | ✓ |
| dr20_catalog_to_sdss_dr16_specobj | 10,459,312 | ✓ |
| dr20_catalog_to_sdss_dr17_specobj | 5,809,366 | ✓ |
| dr20_catalog_to_skies_v1 | 23,876,823 | ✓ |
| dr20_catalog_to_skies_v2 | 25,197,586 | ✓ |
| dr20_catalog_to_skymapper_dr2 | 36,738,727 | ✓ |
| dr20_catalog_to_supercosmos | 68,293,540 | ✓ |
| dr20_catalog_to_tic_v8 | 200,180,323 | ✓ |
| dr20_catalog_to_twomass_psc | 168,117,282 | ✓ |
| dr20_catalog_to_tycho2 | 7,621,635 | ✓ |
| dr20_catalog_to_unwise | 83,596,999 | ✓ |
| dr20_catalog_to_uvotssc1 | 6,585,473 | ✓ |
| dr20_catalog_to_xmm_om_suss_4_1 | 1,985,388 | ✓ |
| dr20_catalog_to_xmm_om_suss_5_0 | 1,058,123 | ✓ |
| dr20_catalogdb_version | 2 | ✓ |
| dr20_category | 12 | ✓ |
| dr20_catwise2020 | 70,162,958 | ✓ |
| dr20_design | 678,415 | ✓ |
| dr20_design_mode | 16 | ✓ |
| dr20_design_mode_check_results | 634,712 | ✓ |
| dr20_design_to_field | 781,197 | ✓ |
| dr20_ebosstarget_v5 | 2,348,261 | ✓ |
| dr20_erosita_superset_agn | 2,139,926 | ✓ |
| dr20_erosita_superset_clusters | 240,763 | ✓ |
| dr20_erosita_superset_compactobjects | 94,782 | ✓ |
| dr20_erosita_superset_stars | 183,101 | ✓ |
| dr20_erosita_superset_v1_agn | 5,766,468 | ✓ |
| dr20_erosita_superset_v1_clusters | 512,657 | ✓ |
| dr20_erosita_superset_v1_compactobjects | 11,113 | ✓ |
| dr20_erosita_superset_v1_stars | 351,188 | ✓ |
| dr20_field | 138,116 | ✓ |
| dr20_gaia_assas_sn_cepheids | 2,357 | ✓ |
| dr20_gaia_dr2_ruwe | 62,928,957 | ✓ |
| dr20_gaia_dr2_source | 0 | ✗ EOF |
| dr20_gaia_dr2_wd | 270,553 | ✓ |
| dr20_gaia_dr3_astrophysical_parameters | 0 | ✗ EOF |
| dr20_gaia_dr3_nss_two_body_orbit | 385,828 | ✓ |
| dr20_gaia_dr3_source | 0 | ✗ EOF |
| dr20_gaia_dr3_synthetic_photometry_gspc | 0 | ✗ EOF |
| dr20_gaia_dr3_vari_rrlyrae | 135,896 | ✓ |
| dr20_gaia_unwise_agn | 2,561,693 | ✓ |
| dr20_gaiadr2_tmass_best_neighbour | 0 | ✗ EOF |
| dr20_galah_dr3 | 458,238 | ✓ |
| dr20_galex_gr7_gaia_dr3 | 16,415,167 | ✓ |
| dr20_gedr3spur_main | 60,465,191 | ✓ |
| dr20_geometric_distances_gaia_dr2 | 58,885,466 | ✓ |
| dr20_glimpse | 3,163,667 | ✓ |
| dr20_guvcat | 12,868,822 | ✓ |
| dr20_hecate_1_1 | 204,733 | ✓ |
| dr20_hole | 1,094 | ✓ |
| dr20_instrument | 2 | ✓ |
| dr20_lamost_dr6 | 0 | ✗ Type mismatch |
| dr20_legacy_survey_dr10 | 37,732,159 | ✓ |
| dr20_legacy_survey_dr8 | 27,829,140 | ✓ |
| dr20_magnitude | 250,403,070 | ✓ |
| dr20_mangadapall | 43,128 | ✓ |
| dr20_mangadrpall | 11,273 | ✓ |
| dr20_mangatarget | 43,068 | ✓ |
| dr20_mapper | 2 | ✓ |
| dr20_marvels_dr11_star | 7,066 | ✓ |
| dr20_marvels_dr12_star | 11,040 | ✓ |
| dr20_mastar_goodstars | 24,290 | ✓ |
| dr20_mastar_goodvisits | 59,266 | ✓ |
| dr20_milliquas_7_7 | 1,275,449 | ✓ |
| dr20_mipsgal | 855,305 | ✓ |
| dr20_mwm_tess_ob | 364 | ✓ |
| dr20_observatory | 2 | ✓ |
| dr20_obsmode | 14 | ✓ |
| dr20_opsdb_apo_camera | 3 | ✓ |
| dr20_opsdb_apo_camera_frame | 48,440 | ✓ |
| dr20_opsdb_apo_completion_status | 3 | ✓ |
| dr20_opsdb_apo_configuration | 17,462 | ✓ |
| dr20_opsdb_apo_design_to_status | 763,589 | ✓ |
| dr20_opsdb_apo_exposure | 55,338 | ✓ |
| dr20_opsdb_apo_exposure_flavor | 14 | ✓ |
| dr20_opsdb_lco_camera | 5 | ✓ |
| dr20_opsdb_lco_camera_frame | 31,544 | ✓ |
| dr20_opsdb_lco_completion_status | 4 | ✓ |
| dr20_opsdb_lco_configuration | 11,975 | ✓ |
| dr20_opsdb_lco_design_to_status | 763,589 | ✓ |
| dr20_opsdb_lco_exposure | 15,969 | ✓ |
| dr20_opsdb_lco_exposure_flavor | 14 | ✓ |
| dr20_panstarrs1 | 46,404,799 | ✓ |
| dr20_positioner_status | 2 | ✓ |
| dr20_rave_dr6_gauguin_madera | 453,490 | ✓ |
| dr20_rave_dr6_xgaiae3 | 517,357 | ✓ |
| dr20_revised_magnitude | 50,320,585 | ✓ |
| dr20_sagitta | 175,349 | ✓ |
| dr20_sagitta_edr3 | 214,949 | ✓ |
| dr20_sdss_apogeeallstarmerge_r13 | 617,583 | ✓ |
| dr20_sdss_dr13_photoobj_primary | 20,007,080 | ✓ |
| dr20_sdss_dr16_qso | 750,255 | ✓ |
| dr20_sdss_dr16_specobj | 5,299,600 | ✓ |
| dr20_sdss_dr17_apogee_allstarmerge | 648,515 | ✓ |
| dr20_sdss_dr17_specobj | 5,801,200 | ✓ |
| dr20_sdss_dr19p_speclite | 6,103,248 | ✓ |
| dr20_sdss_id_flat | 278,732,646 | ✓ |
| dr20_sdss_id_stacked | 126,948,826 | ✓ |
| dr20_sdss_id_to_catalog | 279,429,626 | ✓ |
| dr20_sdssv_boss_conflist | 393 | ✓ |
| dr20_sdssv_boss_spall | 195,500 | ✓ |
| dr20_sdssv_plateholes | 312,384 | ✓ |
| dr20_sdssv_plateholes_meta | 374 | ✓ |
| dr20_skies_v1 | 23,876,823 | ✓ |
| dr20_skies_v2 | 25,197,586 | ✓ |
| dr20_skymapper_dr2 | 36,733,293 | ✓ |
| dr20_skymapper_gaia | 3,339,040 | ✓ |
| dr20_supercosmos | 67,911,712 | ✓ |
| dr20_target | 0 | ✗ Type mismatch |
| dr20_targetdb_version | 85 | ✓ |
| dr20_targeting_generation | 10 | ✓ |
| dr20_targeting_generation_to_carton | 1,697 | ✓ |
| dr20_targeting_generation_to_version | 13 | ✓ |
| dr20_tess_toi | 221,808 | ✓ |
| dr20_tess_toi_v05 | 280,151 | ✓ |
| dr20_tess_toi_v1 | 426,023 | ✓ |
| dr20_tic_v8 | 67,135,331 | ✓ |
| dr20_twomass_psc | 56,915,690 | ✓ |
| dr20_tycho2 | 2,542,994 | ✓ |
| dr20_unwise | 78,130,918 | ✓ |
| dr20_uvotssc1 | 2,101,401 | ✓ |
| dr20_visual_binary_gaia_dr3 | 1,771,306 | ✓ |
| dr20_wd_gaia_dr3 | 314,731 | ✓ |
| dr20_xmm_om_suss_4_1 | 928,973 | ✓ |
| dr20_xmm_om_suss_5_0 | 1,006,136 | ✓ |
| dr20_xpfeh_gaia_dr3 | 30,434,520 | ✓ |
| dr20_yso_clustering | 814,380 | ✓ |
| dr20_zari18pms | 43,595 | ✓ |

## Next Steps

1. **Investigate EOF errors** - Check file sizes and integrity for the 5 Gaia files
2. **Fix type mismatch errors**:
   - `dr20_lamost_dr6`: Examine row 2,705,651 and `[offsets]` column data
   - `dr20_target`: Examine row 2 and `catalogid` column data type/values
3. **Verify row counts** - Compare loaded counts against expected values
4. **Execute primary keys** - Run `mssql_pk_0112.sql` for 179 PKs
5. **Execute indexes** - Run `mssql_indexes_0112.sql` for 992 indexes
6. **Execute foreign keys** - Run `mssql_fk_0112.sql` for 102 FKs
