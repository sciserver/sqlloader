# DR20 Database Size Estimation and Compression Strategy

## Total Data Volume
- **Source CSV files**: 171 files
- **Total CSV size**: ~773 GB

## Database Size Estimates

### Without Compression
CSV files are text-based and typically 2-3x larger than binary storage in SQL Server.
- **Estimated size**: 260-390 GB (assuming ~40% of CSV size)

### With Page Compression on Large Tables
Page compression typically achieves 50-70% space savings on large tables with repeating data patterns (common in astronomical catalogs).
- **Estimated size**: 180-260 GB (for large tables with compression)
- **Total estimated size**: 200-300 GB (mixed compression strategy)

## Recommended Compression Candidates

Tables over 5 GB in CSV form are excellent candidates for PAGE compression on the clustered index.

### Tier 1: Critical Compression (>20 GB CSV)
These tables will benefit most from compression:

| Table | CSV Size | Estimated DB Size (No Compress) | Estimated DB Size (PAGE) |
|-------|----------|--------------------------------|--------------------------|
| dr20_allwise | 95 GB | 38-48 GB | 15-24 GB |
| dr20_catwise2020 | 76 GB | 30-38 GB | 12-19 GB |
| dr20_panstarrs1 | 68 GB | 27-34 GB | 11-17 GB |
| dr20_tic_v8 | 50 GB | 20-25 GB | 8-13 GB |
| dr20_sdss_id_to_catalog | 42 GB | 17-21 GB | 7-11 GB |
| dr20_unwise | 39 GB | 16-20 GB | 6-10 GB |
| dr20_legacy_survey_dr10 | 37 GB | 15-19 GB | 6-9 GB |
| dr20_supercosmos | 34 GB | 14-17 GB | 6-9 GB |
| dr20_sdss_id_flat | 30 GB | 12-15 GB | 5-8 GB |
| dr20_magnitude | 26 GB | 10-13 GB | 4-7 GB |
| dr20_legacy_survey_dr8 | 26 GB | 10-13 GB | 4-7 GB |
| dr20_catalog | 22 GB | 9-11 GB | 4-6 GB |

**Subtotal Tier 1**: ~545 GB CSV → ~90-120 GB with compression

### Tier 2: High Priority Compression (10-20 GB CSV)
Significant space savings:

| Table | CSV Size |
|-------|----------|
| dr20_twomass_psc | 18 GB |
| dr20_skymapper_dr2 | 17 GB |
| dr20_carton_to_target | 17 GB |
| dr20_target | 16 GB |

**Subtotal Tier 2**: ~68 GB CSV → ~12-20 GB with compression

### Tier 3: Moderate Priority (5-10 GB CSV)
Still worthwhile for compression:

| Table | CSV Size |
|-------|----------|
| dr20_sdss_id_stacked | 9.6 GB |
| dr20_assignment | 9.5 GB |
| dr20_guvcat | 8.3 GB |
| dr20_sdss_dr17_specobj | 7.3 GB |
| dr20_catalog_to_gaia_dr2_source | 7.2 GB |
| dr20_catalog_to_allwise | 7.1 GB |
| dr20_revised_magnitude | 7.0 GB |
| dr20_sdss_dr16_specobj | 6.5 GB |
| dr20_catalog_to_tic_v8 | 6.0 GB |
| dr20_gaia_dr3_astrophysical_parameters | 5.7 GB |
| dr20_allstar_dr17_synspec_rev1 | 5.5 GB |
| dr20_gaia_dr2_source | 5.4 GB |
| dr20_bailer_jones_edr3 | 5.2 GB |
| dr20_catalog_to_twomass_psc | 5.0 GB |

**Subtotal Tier 3**: ~100 GB CSV → ~18-30 GB with compression

## Recommendations

### Recommended Approach
1. **Use PAGE compression** for all tables in Tier 1 and Tier 2 (32 tables total)
2. **Consider PAGE compression** for Tier 3 tables if disk space is a concern
3. **No compression** for tables < 5 GB CSV (minimal benefit, adds CPU overhead)

### T-SQL Syntax for Compression
When creating the clustered index (primary key):
```sql
ALTER TABLE dbo.dr20_allwise
ADD CONSTRAINT dr20_allwise_pkey PRIMARY KEY CLUSTERED (designation)
WITH (DATA_COMPRESSION = PAGE);
```

Or rebuild existing clustered index with compression:
```sql
ALTER INDEX dr20_allwise_pkey ON dbo.dr20_allwise
REBUILD WITH (DATA_COMPRESSION = PAGE);
```

## File Sizing Recommendations

For SQL Server 2022 database files:

### Initial Data File Size
- Start with: **300 GB** initial size
- Autogrowth: **10 GB** increments

### Log File Size
During bulk loading:
- Initial: **50 GB**
- Autogrowth: **5 GB** increments
- Use SIMPLE recovery model during load to minimize log growth

### Post-Load Optimization
After loading and compression:
- Monitor actual space used with `sp_spaceused`
- Shrink files if necessary (after compression saves significant space)
- Switch to FULL recovery model if needed for production

## Space Savings Summary

| Strategy | Estimated Total Size |
|----------|---------------------|
| No compression | 260-390 GB |
| Compress Tier 1 only | 200-300 GB |
| Compress Tier 1 + Tier 2 | 190-280 GB |
| Compress all large tables (Tier 1-3) | 180-260 GB |

**Recommended**: Compress Tier 1 + Tier 2 for optimal balance of space savings and CPU overhead.
