-- DR20 Bulk Insert Statements
-- Generated: 2026-01-12 12:19:13
-- Files validated: 1/1
-- Test mode: First 10 rows passed

-- Total data volume: ~5581.7 MB validated

-- ==============================================================================

-- File: minidb_dr20.dr20_allstar_dr17_synspec_rev1.csv (5581.7 MB)
-- Table: dbo.dr20_allstar_dr17_synspec_rev1
-- Delimiter: pipe (|)
-- Test result: PASSED (0/10 rows)
BULK INSERT dbo.dr20_allstar_dr17_synspec_rev1
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_allstar_dr17_synspec_rev1.csv'
WITH (
    DATAFILETYPE='char',
    FIRSTROW=2,
    FIELDTERMINATOR='|',
    ROWTERMINATOR='0x0a',
    TABLOCK,
    FIELDQUOTE='"'
);
GO

SELECT 'Loaded dr20_allstar_dr17_synspec_rev1', COUNT(*) AS row_count FROM dbo.dr20_allstar_dr17_synspec_rev1;
GO



-- SUMMARY
-- Total files: 1
-- Total size: ~5581.7 MB
