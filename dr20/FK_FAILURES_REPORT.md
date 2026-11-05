# Foreign Key Creation Report - DR20

**Date**: 2026-01-22
**Database**: minidb_dr20_v2

---

## Summary

- **Total FKs Attempted**: 101 (1 skipped: planname issue)
- **Successful**: 90
- **Failed**: 11

---

## Failed Foreign Keys

### 1. Data Type Mismatches (9)

#### 1.1 dr20_catalog_to_catwise2020_target_id_fkey
- **Child**: `dr20_catalog_to_catwise2020.target_id`
- **Parent**: `dr20_catwise2020.source_id`
- **Issue**: Data type mismatch (varchar vs char)
- **Error**: Column 'dbo.dr20_catwise2020.source_id' is not the same data type as referencing column 'dr20_catalog_to_catwise2020.target_id'

#### 1.2 dr20_catalog_to_mangatarget_target_id_fkey
- **Child**: `dr20_catalog_to_mangatarget.target_id`
- **Parent**: `dr20_mangatarget.mangaid`
- **Issue**: Column length mismatch
- **Error**: Column 'dbo.dr20_mangatarget.mangaid' is not the same length or scale as referencing column 'dr20_catalog_to_mangatarget.target_id'

#### 1.3 dr20_catalog_to_marvels_dr11_star_target_id_fkey
- **Child**: `dr20_catalog_to_marvels_dr11_star.target_id`
- **Parent**: `dr20_marvels_dr11_star.starname`
- **Issue**: Column length mismatch
- **Error**: Column 'dbo.dr20_marvels_dr11_star.starname' is not the same length or scale as referencing column 'dr20_catalog_to_marvels_dr11_star.target_id'

#### 1.4 dr20_catalog_to_mastar_goodstars_target_id_fkey
- **Child**: `dr20_catalog_to_mastar_goodstars.target_id`
- **Parent**: `dr20_mastar_goodstars.mangaid`
- **Issue**: Column length mismatch
- **Error**: Column 'dbo.dr20_mastar_goodstars.mangaid' is not the same length or scale as referencing column 'dr20_catalog_to_mastar_goodstars.target_id'

#### 1.5 dr20_opsdb_apo_camera_frame_camera_pk_fkey
- **Child**: `dr20_opsdb_apo_camera_frame.camera_pk` (smallint)
- **Parent**: `dr20_opsdb_apo_camera.pk` (int)
- **Issue**: Data type mismatch (smallint vs int)
- **Error**: Column 'dbo.dr20_opsdb_apo_camera.pk' is not the same data type as referencing column 'dr20_opsdb_apo_camera_frame.camera_pk'

#### 1.6 dr20_opsdb_apo_exposure_exposure_flavor_pk_fkey
- **Child**: `dr20_opsdb_apo_exposure.exposure_flavor_pk` (smallint)
- **Parent**: `dr20_opsdb_apo_exposure_flavor.pk` (int)
- **Issue**: Data type mismatch (smallint vs int)
- **Error**: Column 'dbo.dr20_opsdb_apo_exposure_flavor.pk' is not the same data type as referencing column 'dr20_opsdb_apo_exposure.exposure_flavor_pk'

#### 1.7 dr20_opsdb_lco_camera_frame_camera_pk_fkey
- **Child**: `dr20_opsdb_lco_camera_frame.camera_pk` (smallint)
- **Parent**: `dr20_opsdb_lco_camera.pk` (int)
- **Issue**: Data type mismatch (smallint vs int)
- **Error**: Column 'dbo.dr20_opsdb_lco_camera.pk' is not the same data type as referencing column 'dr20_opsdb_lco_camera_frame.camera_pk'

#### 1.8 dr20_opsdb_lco_design_to_status_completion_status_pk_fkey
- **Child**: `dr20_opsdb_lco_design_to_status.completion_status_pk` (smallint)
- **Parent**: `dr20_opsdb_lco_completion_status.pk` (int)
- **Issue**: Data type mismatch (smallint vs int)
- **Error**: Column 'dbo.dr20_opsdb_lco_completion_status.pk' is not the same data type as referencing column 'dr20_opsdb_lco_design_to_status.completion_status_pk'

#### 1.9 dr20_opsdb_lco_exposure_exposure_flavor_pk_fkey
- **Child**: `dr20_opsdb_lco_exposure.exposure_flavor_pk` (smallint)
- **Parent**: `dr20_opsdb_lco_exposure_flavor.pk` (int)
- **Issue**: Data type mismatch (smallint vs int)
- **Error**: Column 'dbo.dr20_opsdb_lco_exposure_flavor.pk' is not the same data type as referencing column 'dr20_opsdb_lco_exposure.exposure_flavor_pk'

---

### 2. Missing Primary Key / Unique Constraint (2)

#### 2.1 dr20_mipsgal_twomass_name_fkey
- **Child**: `dr20_mipsgal.twomass_name`
- **Parent**: `dr20_twomass_psc.designation`
- **Issue**: Parent column does not have a primary key or unique constraint
- **Error**: There are no primary or candidate keys in the referenced table 'dbo.dr20_twomass_psc' that match the referencing column list

#### 2.2 dr20_sdss_dr16_qso_plate_fiberid_mjd_fkey
- **Child**: `dr20_sdss_dr16_qso.plate, fiberid, mjd`
- **Parent**: `dr20_sdss_dr16_specobj.plate, fiberid, mjd`
- **Issue**: Parent columns do not have a composite primary key or unique constraint
- **Error**: There are no primary or candidate keys in the referenced table 'dbo.dr20_sdss_dr16_specobj' that match the referencing column list

---

## Skipped Foreign Keys (1)

### dr20_carton_target_selection_plan_fkey
- **Child**: `dr20_carton.target_selection_plan`
- **Parent**: `dr20_targetdb_version.plan` (renamed to `planname`)
- **Issue**: Column was renamed to avoid reserved word conflict; FK references wrong column name
- **Note**: This FK should reference `planname` instead of `plan`, but would still fail because `planname` is not the primary key (pk is `pk` column)

---

## Recommendations for DR21

### Schema Conversion Improvements

1. **Data Type Consistency**
   - Ensure foreign key columns match parent column types exactly
   - Common issue: `smallint` vs `int` for ID columns
   - Fix: Update pg2mssql.py to detect FK relationships and ensure consistent types

2. **VARCHAR Size Matching**
   - Cross-match tables have `target_id varchar(255)` but parent tables have varying sizes
   - Fix: Either standardize all ID columns to same size, or update cross-match table schemas

3. **Reserved Word Handling**
   - When renaming columns (e.g., `plan` → `planname`), update all FK references
   - Fix: Add post-processing step to update FK definitions after column renames

4. **Unique Constraints**
   - Some parent tables lack unique constraints on foreign key target columns
   - Fix: Add unique constraints where FKs are intended but PKs don't exist

### Specific Fixes for DR20

For the 11 failed FKs, options are:
1. **Accept as-is**: FKs provide referential integrity but aren't strictly required for queries
2. **Fix data types**: ALTER TABLE to change child column types to match parents
3. **Add unique constraints**: Create unique indexes on parent columns where appropriate
4. **Skip problematic FKs**: Document in issues.md and exclude from future runs

---

## Database Final Status

- **Tables**: 185 (171 dr20_* data tables + 14 metadata tables)
- **Primary Keys**: 179
- **Indexes**: 990 (989 nonclustered + 1 HTM spatial with INCLUDE)
- **Computed Columns**: 3 (with indexes)
- **Foreign Keys**: 90 (out of 102 total, 11 failed, 1 skipped)
- **Data**: 4.7 billion rows loaded successfully

---

**Status**: Database is production-ready with 88% of foreign keys created. Failed FKs are documented above and do not affect query functionality.
