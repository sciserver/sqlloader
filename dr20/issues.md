# DR20 Loading - December 2024

## General Notes

DR20 contains 185 tables (52 more than DR19). Converting PostgreSQL schema to T-SQL using improved pg2mssql.py script.

## Conversion Notes

- Source: PostgreSQL 15.15 schema from Utah
- Schema prefix: `minidb_dr20.` → `dbo.`
- Table prefix: `dr20_` (kept as-is for minidb loading database)
- CSV files: 171 files in E:\DR20\minidb_dr20\casload\

## Known Issues

### Production Load Failures (2026-01-13)

**Load Summary**: 164/171 files loaded successfully (95.9%), ~3.8+ billion rows loaded across 164 tables.

#### 1. Truncated CSV Files (5 files - EOF Errors)

All 5 files are incomplete downloads from SDSS data servers. Files exist but last row is truncated mid-line.

| File | Size | Header Cols | Last Line Cols | Status |
|------|------|-------------|----------------|--------|
| `minidb_dr20.dr20_gaia_dr2_source.csv` | 5.4 GB | 94 | 2 | ❌ Needs re-download |
| `minidb_dr20.dr20_gaia_dr3_astrophysical_parameters.csv` | 5.7 GB | 226 | 207 | ❌ Needs re-download |
| `minidb_dr20.dr20_gaia_dr3_source.csv` | 4.0 GB | 152 | 8 | ❌ Needs re-download |
| `minidb_dr20.dr20_gaia_dr3_synthetic_photometry_gspc.csv` | 4.5 GB | 54 | 24 | ❌ Needs re-download |
| `minidb_dr20.dr20_gaiadr2_tmass_best_neighbour.csv` | 3.1 GB | 9 | 5 | ❌ Needs re-download |

**Error Message**:
```
Msg 4832, Level 16, State 1, Server sdss4c, Line 7
Bulk load: An unexpected end of file was encountered in the data file.
```

**Resolution**: Contact Utah team to verify and re-download these 5 Gaia files (~21.7 GB total).

**Evidence of Truncation** (actual last lines from each file):

1. **gaia_dr2_source** - Stops mid-field at column 2:
```
1635721458409799680,Gaia DR2 87004361978008
```
Expected: 94 columns total

2. **gaia_dr3_astrophysical_parameters** - Stops at column 207 (missing last 19 columns):
```
...4947
```
Expected: 226 columns total (truncated mid-number)

3. **gaia_dr3_source** - Stops mid-field at column 8:
```
1636148068921376768,Gaia DR3 473232626390516352,473232626390516352,1063652964,2016,56.36839287765723,0.14663583,58.70395
```
Expected: 152 columns total

4. **gaia_dr3_synthetic_photometry_gspc** - Stops mid-field at column 24:
```
2079079116933367552,0.0113505125,5.444208e-17,7.576054e-19,14.811263,1,8.037342e-17,3.0127598e-19,14.766219,1,7.640375e-17,1.914189e-19,14.206114,1,6.382343e-17,1.2251353e-19,13.860749,1,4.639954e-17,7.104447e-20,13.512516,1,2.697069e-29,3.814309e-3
```
Expected: 54 columns total (truncated mid-number: `3.814309e-3` should be `3.814309e-32`)

5. **gaiadr2_tmass_best_neighbour** - Stops mid-field at column 5:
```
109755718,1,0,1,5
```
Expected: 9 columns total (truncated mid-number: `5` should be a full bigint like `5374867317129488256`)

#### 2. Data Type Mismatches (2 files)

##### Issue 2a: `dr20_lamost_dr6` - CSV Quoting Issue with Comma Delimiter

**Error**: Type mismatch on column 36 `[dec]` starting at row 2,705,651

```
Msg 4864, Level 16, State 1, Line 64
Bulk load data conversion error (type mismatch or invalid character
for the specified codepage) for row 2705651, column 36 (dec).
```

**Root Cause**: The `tcomment` field (column 32) contains **153,732 rows** with quoted values that have internal commas:
```
"<offset,10.92, 342.892450000,   1.506526000,0.74>10377729"
```

Example problem row (obsid 161101045, row 2,705,651):
```csv
161101045,J225134.23+013023.4,2013-10-04,56570,56569,EG225232N033308V01,1,45,342.8926547,1.506526,27.68,154.66,293.85,368.84,297.91,Star,STAR,F9,-0.0001032381,1.36094e-05,gri,11.74,10.92,10.89,99,99,99,99,LEGUE_LCH,Obj,UCAC4,"<offset,10.92, 342.892450000,   1.506526000,0.74>10377729",1,0.74,342.89245,1.506526,64,342.89246046071,1.50650654249,1.72e-05,1.33e-05,49.7,2655317213824699904
```

The comma-delimited format with `FIELDQUOTE='"'` cannot properly parse these quoted fields with internal commas, causing column misalignment. The SQL Server version doesn't support `FORMAT='CSV'` (RFC 4180 compliant parser).

**Resolution**: **Regenerate file with pipe delimiters** (like the other 4 files: allstar_dr17_synspec_rev1, field, gaia_dr3_nss_two_body_orbit, sdss_apogeeallstarmerge_r13). This eliminates the quoting problem entirely since pipes won't appear in the data.

**Note**: Schema fix was also needed - `[offsets]` column changed from `smallint` to `real` to handle decimal values. This fix is in `fix_lamost_dr6_table.sql`.

**File**: `E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_lamost_dr6.csv` (3.1 GB)
**Problem rows sample**: `H:\GitHub\sqlloader\dr20\lamost_dr6_problem_rows.csv` (header + 11 rows)

##### Issue 2b: `dr20_target` - Incomplete Rows

**Error**: Type mismatch on column 8 `catalogid` starting at row 2 (every row fails)

```
Msg 4864, Level 16, State 1, Server sdss4c, Line 7
Bulk load data conversion error (type mismatch or invalid character
for the specified codepage) for row 2, column 8 (catalogid).
```

**Root Cause**: CSV rows are incomplete - missing trailing NULL column values. Table expects 12 columns but rows have varying numbers (11 or fewer). Example from row 2:
```
57281447,315.018...,35.301...,-2.17881,-3.12563,2015.5,0.0490283,4204682196,,,
```
The last 3 columns (`htmid`, `cx`, `cy`, `cz`) are empty but not all trailing commas are present, causing column misalignment during parsing.

**Resolution Options**:
1. **Preferred**: Regenerate CSV with all columns properly delimited (even if empty)
2. **Alternative**: Use `FORMAT='CSV'` instead of `DATAFILETYPE='char'` for better NULL handling:
```sql
BULK INSERT dbo.dr20_target
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_target.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDQUOTE='"',
    TABLOCK
);
```

**File**: `E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_target.csv` (17 GB)

## TODO

- [x] Run schema conversion (completed 2026-01-12)
- [x] Review generated SQL files (mssql_tables_0112.sql, etc.)
- [x] Test load on subset of tables (5 pipe-delimited files, passed)
- [x] Execute full production load (164/171 tables loaded)
- [ ] **Request from Utah**:
  - **Re-download 5 truncated Gaia CSV files** (~21.7 GB): gaia_dr2_source, gaia_dr3_astrophysical_parameters, gaia_dr3_source, gaia_dr3_synthetic_photometry_gspc, gaiadr2_tmass_best_neighbour
  - **Regenerate dr20_lamost_dr6 with pipe delimiters** (3.1 GB) - file has 153K+ rows with comma-quoting issues
- [x] **Fix dr20_lamost_dr6 schema**: Changed `[offsets]` from smallint to real (fix_lamost_dr6_table.sql)
- [x] **Fix dr20_target table**: Added computed columns for htmid/cx/cy/cz using HTM library (fix_target_table.sql)
- [ ] Retry 7 failed file loads
- [ ] Execute primary keys (mssql_pk_0112.sql - 179 PKs)
- [ ] Execute indexes (mssql_indexes_0112.sql - 992 indexes)
- [ ] Execute foreign keys (mssql_fk_0112.sql - 102 FKs)
- [ ] Handle computed column indexes (if any)
- [ ] Handle q3c spatial indexes → convert to HTM
