-- Try loading lamost_dr6 with FORMAT='CSV' for better quote handling
-- Issue: tcomment field contains quoted values with internal commas
-- 153,732 rows have pattern: "<offset,10.92, 342.892450000,   1.506526000,0.74>10377729"
-- Created: 2026-01-13

USE minidb_dr20;
GO

-- Truncate and retry with FORMAT='CSV'
TRUNCATE TABLE dbo.dr20_lamost_dr6;
GO

-- Load with FORMAT='CSV' instead of DATAFILETYPE='char'
BULK INSERT dbo.dr20_lamost_dr6
FROM 'E:\DR20\minidb_dr20\casload\minidb_dr20.dr20_lamost_dr6.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDQUOTE='"',
    TABLOCK
);
GO

SELECT 'Loaded dr20_lamost_dr6', COUNT(*) AS row_count FROM dbo.dr20_lamost_dr6;
GO
