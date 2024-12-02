# DR19 Loading - Nov 2024

## General notes

The minidb now contains 108 tables.  Converting the postgres schema to t-sql went smoothly using the pg2mssql.py script.  

**Question: should we prefix these tables with 'mos_' like we did for dr18?**

## Specific issues
### column names / types

- dr19_opsdb_apo_exposure
  - start_time was "timestamp without time zone" type.  Changed it to datetime (timestamp in t-sql means something different)
  
- dr19_sdssv_boss_conflist
  - there is a column named "public" which is a reserved word in t-sql.  For now I put [brackets] around it so i could create the table, but we should change it to something else. **what should i rename 'public' to**


-  dr19_design
   -  assignment_hash column had type uuid, changed to uniqueidentifier


### indexes

--CREATE NONCLUSTERED INDEX dr19_gaia_dr2_source_expr_idx ON dbo.dr19_gaia_dr2_source  (((parallax - parallax_error)));


--CREATE NONCLUSTERED INDEX dr19_allwise_expr_idx ON dbo.dr19_allwise  (((w1mpro - w2mpro)));

--CREATE NONCLUSTERED INDEX dr19_guvcat_expr_idx ON dbo.dr19_guvcat  (((fuv_mag - nuv_mag)));

Can't have math in indexes in sql server.  I can create persisted computed columns for these values and add them to the corresponding table and put an index on that column.  **For DR18 I named the columns like 'parallax_parallax_error', does that still work?**

### loading

- dr19_field.csv - Msg 4864, Level 16, State 1, Line 1
Bulk load data conversion error (type mismatch or invalid character for the specified codepage) for row 2, column 9 (field_id).
    - there was some issue with the quotes and commas.  was able to load fine using the SSMS import flat file GUI so I did that rather than mess around with bulk insert for an hour

-  dr19_mwm_tess_ob - Msg 4863, Level 16, State 1, Line 1 Bulk load data conversion error (truncation) for row 2, column 5 (instrument).
   -  changed instrument and cadence columns from varchar(1) to varchar(20), loaded fine
  

-  dr19_sdss_apogeeallstarmerge_r13
   -  problem with quotes / commas
   -  changed visits to varchar(1500)
   -  changed apstarid to varchar(1000)
   -  loaded fine w import flat file


## TODO:
- get schema / table / column descriptions
- load with data compression
- add htmid, cx, cy, cz to all tables with ra/dec?

  


  




  


