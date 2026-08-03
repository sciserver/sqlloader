-------------------------------------------------------------------------------
--  build_photomain.sql
--
--  Materialises the PhotoTag view (98 columns of PhotoObjAll, 1,231,051,050
--  rows) into TestXmatch as two tables, for the crossmatch-subset experiment:
--
--    photoMain      clustered PK on objID, PAGE compressed   ~448 GB expected
--    photoMain_cci  clustered COLUMNSTORE_ARCHIVE            ~357 GB expected
--
--  both with a nonclustered rowstore index on htmid.
--
--  WHY photoMain_cci IS BUILT FROM photoMain, NOT FROM PhotoTag
--  The view cannot be answered from the existing i_PhotoObjAll_PhotoTag
--  covering index: that index holds 93 of the 98 columns and is missing
--  skyVersion, rerun, clean, insideMask and size. So every pass over PhotoTag
--  is a full scan of PhotoObjAll's 3,069 GB clustered index. Building the
--  second table from the first reads ~448 GB instead.
--
--  Sizes above are extrapolated from a measured 5,000,000-row sample:
--  481.91 B/row uncompressed, 390.68 PAGE, 311.05 COLUMNSTORE_ARCHIVE.
--  Note plain CCI measured LARGER than PAGE on this column set (531.52 B/row)
--  because the data is 61 real + 6 float columns of high-entropy measurements,
--  which dictionary and RLE encoding cannot compress; ARCHIVE wins only because
--  it layers LZ77 on top.
--
--  Run each step separately - step 1 is multi-hour.
--
--  Suzanne Werner, 2026-07-31
-------------------------------------------------------------------------------
USE TestXmatch;
GO
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

-------------------------------------------------------------------------------
-- STEP 1: photoMain  -- clustered PK on objID, PAGE, then load
--
-- The clustered index is created BEFORE the insert, per the loading convention:
-- rows land in key order, already compressed, instead of building a heap and
-- rebuilding it afterwards. No sort is needed because PhotoTag is read in
-- objID order from PhotoObjAll's clustered index, which is the same key.
-------------------------------------------------------------------------------
IF OBJECT_ID('dbo.photoMain') IS NOT NULL DROP TABLE dbo.photoMain;
GO

SELECT TOP (0) * INTO dbo.photoMain FROM BestDR20.dbo.PhotoTag;
GO

ALTER TABLE dbo.photoMain ALTER COLUMN objID bigint NOT NULL;
GO

ALTER TABLE dbo.photoMain
    ADD CONSTRAINT pk_photoMain_objID PRIMARY KEY CLUSTERED (objID)
    WITH (DATA_COMPRESSION = PAGE);
GO

INSERT INTO dbo.photoMain WITH (TABLOCK)
SELECT * FROM BestDR20.dbo.PhotoTag;
GO

PRINT 'photoMain loaded: ' + CAST((SELECT COUNT_BIG(*) FROM dbo.photoMain) AS varchar(20)) + ' rows';
GO

CREATE NONCLUSTERED INDEX ix_photoMain_htmid ON dbo.photoMain (htmID)
    WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON);
GO

-------------------------------------------------------------------------------
-- STEP 2: photoMain_cci  -- clustered COLUMNSTORE_ARCHIVE
--
-- A table cannot have both a clustered PK and a clustered columnstore, so the
-- CCI is the clustered structure here and there is no separate PK.
--
-- The CCI is created on the empty table and loaded with TABLOCK so rows bulk
-- load directly into compressed rowgroups rather than passing through the
-- delta store.
-------------------------------------------------------------------------------
IF OBJECT_ID('dbo.photoMain_cci') IS NOT NULL DROP TABLE dbo.photoMain_cci;
GO

SELECT TOP (0) * INTO dbo.photoMain_cci FROM dbo.photoMain;
GO

CREATE CLUSTERED COLUMNSTORE INDEX cci_photoMain_cci ON dbo.photoMain_cci
    WITH (DATA_COMPRESSION = COLUMNSTORE_ARCHIVE);
GO

INSERT INTO dbo.photoMain_cci WITH (TABLOCK)
SELECT * FROM dbo.photoMain;
GO

PRINT 'photoMain_cci loaded: ' + CAST((SELECT COUNT_BIG(*) FROM dbo.photoMain_cci) AS varchar(20)) + ' rows';
GO

CREATE NONCLUSTERED INDEX ix_photoMain_cci_htmid ON dbo.photoMain_cci (htmID)
    WITH (DATA_COMPRESSION = PAGE, SORT_IN_TEMPDB = ON);
GO

-------------------------------------------------------------------------------
-- RESULT
-------------------------------------------------------------------------------
SELECT t.name,
       (SELECT MAX(rows) FROM sys.partitions WHERE object_id=t.object_id AND index_id IN (0,1)) AS rows,
       CAST(SUM(a.used_pages)*8.0/1024/1024 AS decimal(12,2)) AS total_gb
FROM sys.tables t
JOIN sys.partitions p ON p.object_id=t.object_id
JOIN sys.allocation_units a ON a.container_id=p.partition_id
WHERE t.name IN ('photoMain','photoMain_cci')
GROUP BY t.name, t.object_id;
GO
