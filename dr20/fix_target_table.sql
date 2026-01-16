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
