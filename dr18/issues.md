
# First Pass of DR18 loading - Sept 2022

## General Notes:

Out of 60 csv files, I was able to load 46 of them with either no problems, or with small issues that I was able to fix by altering the table schema.  I did not alter the data in the csv files in any way.

The issues I did find in the remaining 14 files mostly fell into 2 categories -- Nan / Inf values, and boolean / bit columns with t/f as the values.  

- Nan / Inf -- When possible, I tried to identify specific rows/columns with NaN's but since the bulk load process I was using gives up on loading a row on the first invalid column value, it's possible that more NaN's exist in that row.  (I did notice that in a couple cases.)  Also, since the bulk load process aborts after a certain number of total errors, there could be more errors further down the file. So this should not be considered an exhaustive list of every invalid value in each file, but just a note to have a look at the file.  I also noticed in some of the files that some of the columns that had NaN's in some of the rows also had -9 in some of the rows (usually a small percentage.) I'm not sure if this is meant to be -9999 ?

- boolean / bit columns with t/f values -- I realize that the initial schema supplied was from postgresql but Sql Server doesn't have a "boolean" datatype.  Rather, it has "bit" which uses values 1/0/NULL instead of TRUE/FALSE/NULL.  I converted all the boolean columns to "bit" when creating the Sql Server schema but the t/f values in the csv's caused errors.

One more thing to keep in mind -- at this point I did not do any "sanity checking" of any individual values beyond "did they load correctly into the specified column type?" so we may need to do some range checking, etc in a subsequent pass.  Also I did not perform any checks for duplicates, etc at this time.

## Specific things from the csv files

- minidb.dr18_bhm_csc_v2.csv 
  - ora has NaN's (see row 6, row 14, row 17)

- minidb.dr18_bhm_rm_v0_2.csv 
  - magerr_ir_j (row 37, 224, 359, 501) some are NaN some are -9
  - photoz_galaxy_upper (row 219) some are NaN some are -9
  - photoz_qso_upper (row 607) some are NaN some are -9

- minidb.dr18_cataclysmic_variables.csv
  - astrometric_primary_flag - many NaN's
  - parallax - many NaN's 
  - there are NaN's in several other columns too, my load aborts after 10 errors so not sure which columns but just check the CSV's
  
- minidb.dr18_ebosstarget_v5.csv
  - has_wise_phot should be a bit but has "f" and "t" for values - please change to 0 or 1

- minidb.dr18_gaia_dr2_source.csv
  - astrometric_primary_flag should be a bit but has "f" and "t" for values - please change to 0 or 1

- minidb.dr18_geometric_distances_gaia_dr2.csv
  - NaN for r_est and other columns -- see output below
```
PS D:\dr18loading\minidb\csv> select-string -Path .\minidb.dr18_geometric_distances_gaia_dr2.csv -Pattern "NaN"

minidb.dr18_geometric_distances_gaia_dr2.csv:1699449:5602384138678998144,NaN,NaN,NaN,1137.3351,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:3478895:2021116403030167808,NaN,NaN,NaN,1760.201,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:3564695:84988679709971456,NaN,NaN,NaN,370.68353,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:3994215:4063157126452382208,NaN,NaN,NaN,2105.684,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:5912762:491254339229220992,NaN,NaN,NaN,1305.4711,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:6317530:2028521751251433600,NaN,NaN,NaN,1547.03,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:6569170:5686919128087798656,NaN,NaN,NaN,455.1742,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:6598594:3827747288819249280,NaN,NaN,NaN,398.66342,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:7493877:6025088463394669184,NaN,NaN,NaN,1888.097,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:7829564:3110257196548276480,NaN,NaN,NaN,922.7788,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:8077663:2020863240435806848,NaN,NaN,NaN,1534.1697,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:8630192:4044214705781399168,NaN,NaN,NaN,2371.0974,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:10832289:4066363194907555584,NaN,NaN,NaN,1748.7347,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:12866609:3154413338706643968,NaN,NaN,NaN,810.3975,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:13550599:5698071989932447104,NaN,NaN,NaN,967.57666,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:13717028:6103273704439341440,NaN,NaN,NaN,1316.8547,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:14067496:4055766759038487552,NaN,NaN,NaN,2377.1003,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:14166449:204031841576217984,NaN,NaN,NaN,1051.7035,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:15138170:4056547614096981248,NaN,NaN,NaN,2356.4028,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:15672235:64096339579115008,NaN,NaN,NaN,459.53928,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:16437985:5697465093885601280,NaN,NaN,NaN,1082.797,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:16546903:5822704755374406272,NaN,NaN,NaN,1577.0868,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:16967162:6735642595814406784,NaN,NaN,NaN,2146.8726,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:18332061:4976677428781876096,NaN,NaN,NaN,521.3843,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:21742620:1829049932261271552,NaN,NaN,NaN,1345.8134,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:22256262:1539603049558018816,NaN,NaN,NaN,368.68332,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:24064341:763459299044341760,NaN,NaN,NaN,360.69244,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:24558506:4057360531151981440,NaN,NaN,NaN,2310.9075,0,1
minidb.dr18_geometric_distances_gaia_dr2.csv:24696218:4122857206199371008,NaN,NaN,NaN,2189.1853,0,1
```

- \minidb.dr18_legacy_survey_dr8.csv
  - gaia_duplicated_source is a bit column but has values t and f -- please change to 1 or 0

- minidb.dr18_magnitude.csv
  - column "g" has NaN's in several rows (see row 23, 26, 113, etc)

- minidb.dr18_panstarrs1.csv
  - NaN's in several columns, Infinity in several columns 
```
  Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 6, column 31 (g_stk_kron_flux).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 9, column 54 (r_chp_aper).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 11, column 124 (z_chp_aper).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 24, column 89 (i_chp_aper).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 35, column 54 (r_chp_aper).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 45, column 8 (stargal).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 53, column 171 (y_stk_kron_flux).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 55, column 54 (r_chp_aper).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 84, column 89 (i_chp_aper).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 90, column 124 (z_chp_aper).
Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 106, column 101 (i_stk_kron_flux).
```

- minidb.sdss_apogee_allstarmerge_r13
  - many, many NaN's in several columns - most of the columns and their associated errors toward the end of the schema -- can give more info if needed but should be clear from looking at the file

- minidb.dr18_sdss_dr16_qso.csv
  - NaN's in many columns: xmm_total_lum, hmag_err, jflux_err, jmag_err, w2_mag, kmag_err, likely more

- minidb.dr18_skies_v2.csv
  - all bit (boolean) columns have t or f, please change to 1 or 0

- minidb.dr18_xmm_om_suss_4_1.csv
  - NaN's in many columns

- minidb.dr18_yso_clustering.csv
  - Nan's in j, h, k columns (possibly more) look at rows 19, 70, 85...



  







