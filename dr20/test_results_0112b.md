# DR20 CSV Bulk Load Test Results

**Date**: 2026-01-12 12:09:23

**Test Mode**: First 10 rows per file

## Summary Statistics

- **Total CSV files**: 5
- **Passed validation**: 5 (100.0%)
- **Failed validation**: 0 (0.0%)
- **Total data volume**: 6.3 GB
- **Tested successfully**: 6.3 GB

## Files Passed

Total: 5 files ready for bulk loading

| Table Name | File Size | Status |
|------------|-----------|--------|
| dr20_allstar_dr17_synspec_rev1 | 5.5 GB | PASSED (10/10 rows) |
| dr20_sdss_apogeeallstarmerge_r13 | 364.7 MB | PASSED (10/10 rows) |
| dr20_gaia_dr3_nss_two_body_orbit | 328.3 MB | PASSED (10/10 rows) |
| dr20_gaia_dr3_vari_rrlyrae | 152.1 MB | PASSED (10/10 rows) |
| dr20_field | 28.2 MB | PASSED (10/10 rows) |

## Files Failed

No files failed validation! 🎉

## Generated Files

- `mssql_bulk_insert_0112b.sql` - BULK INSERT statements for 5 validated files
- `test_results_0112b.md` - This report

## Next Steps

1. Review generated SQL file
2. Execute full bulk load
3. Verify row counts match expected values
