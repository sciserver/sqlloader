-- Fix dr20_target table with computed columns for htmid, cx, cy, cz
-- These columns will be automatically calculated from ra/dec using HTM library functions
-- Created: 2026-01-13

USE minidb_dr20;
GO

-- Drop existing table if present
DROP TABLE IF EXISTS dbo.dr20_target;
GO

-- Recreate with computed columns
CREATE TABLE dbo.dr20_target (
    target_pk bigint NOT NULL,
    ra double precision,
    [dec] double precision,
    pmra real,
    pmdec real,
    epoch real,
    parallax real,
    catalogid bigint,
    -- Computed columns using HTM library functions
    htmid AS (dbo.fHtmEq(ra, [dec])) PERSISTED,
    cx AS (dbo.fCartesianX(ra, [dec])) PERSISTED,
    cy AS (dbo.fCartesianY(ra, [dec])) PERSISTED,
    cz AS (dbo.fCartesianZ(ra, [dec])) PERSISTED
);
GO

PRINT 'dr20_target table recreated with computed columns';
GO



  BULK INSERT dbo.dr20_target
  FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_target.csv'
  WITH (
      DATAFILETYPE='char',
      FIRSTROW=2,
      FIELDTERMINATOR=',',
      ROWTERMINATOR='0x0a',
      TABLOCK,
      FIELDQUOTE='"'
  );
  GO

  SELECT 'Loaded dr20_target', COUNT(*) AS row_count FROM dbo.dr20_target;
  GO