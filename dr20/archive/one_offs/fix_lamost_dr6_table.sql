-- Fix dr20_lamost_dr6 table - change offsets column from smallint to real
-- Issue: Column contains decimal values like 10.92 but was defined as integer
-- Created: 2026-01-13

USE minidb_dr20;
GO

-- Drop existing table if present
DROP TABLE IF EXISTS dbo.dr20_lamost_dr6;
GO

-- Recreate with corrected data type
CREATE TABLE dbo.dr20_lamost_dr6 (
    obsid bigint NOT NULL,
    designation varchar(max),
    obsdate varchar(max),
    lmjd integer,
    mjd integer,
    planid varchar(max),
    spid integer,
    fiberid smallint,
    ra_obs double precision,
    dec_obs double precision,
    snru real,
    snrg real,
    snrr real,
    snri real,
    snrz real,
    objtype varchar(max),
    class varchar(max),
    subclass varchar(max),
    z real,
    z_err real,
    magtype varchar(max),
    mag1 real,
    mag2 real,
    mag3 real,
    mag4 real,
    mag5 real,
    mag6 real,
    mag7 real,
    tsource varchar(max),
    fibertype varchar(max),
    tfrom varchar(max),
    tcomment varchar(max),
    [offsets] real,  -- FIXED: Was smallint, now real to handle decimal values
    offsets_v real,
    ra double precision,
    [dec] double precision,
    fibermask integer,
    ra_x double precision,
    dec_x double precision,
    errhalfmaj real,
    errhalfmin real,
    errposang real,
    source_id bigint
);
GO

PRINT 'dr20_lamost_dr6 table recreated with offsets as real';
GO

-- Load the data (3.1 GB file)
BULK INSERT dbo.dr20_lamost_dr6
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_lamost_dr6.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_lamost_dr6', COUNT(*) AS row_count FROM dbo.dr20_lamost_dr6;
GO
