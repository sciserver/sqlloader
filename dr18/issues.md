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
  - has_wise_phot should be a bit but has "f" for a value



