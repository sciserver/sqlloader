-------------------------------------------------------------------------------
--  fix_spall_htm.sql
--
--  Rebuilds spAll's htmid/cx/cy/cz from racat/deccat.
--
--  They were originally computed from plug_ra/plug_dec, the old plugmap
--  columns, which in SDSS-V hold the null sentinel -9999 for 4,905,907 of
--  5,357,037 rows (91.6%). -9999 is a valid float, so nothing errored. The
--  result: all 4.9M rows share one htmid (16776973019819), they are invisible
--  to cone search at their true positions, and cos/sin of -9999 degrees lands
--  at ra=81.000 dec=81.000 - an ordinary point in the northern sky - so a cone
--  search there returns 4.9M spurious rows at zero separation.
--
--  racat/deccat rather than fiber_ra/fiber_dec because:
--    * racat/deccat is consistently ICRS at coord_epoch, whereas fiber_ra is
--      documented "J2000 for plate; at exp for FPS" - a mixed reference frame.
--    * fGetNearbySpAllXYZ already RETURNS racat/deccat as its ra/dec output.
--      It indexed on plug_* and reported racat, and that inconsistency is how
--      the bug survived. Indexing on racat makes search and results agree.
--    * Both column pairs have zero invalid values across all 5,357,037 rows.
--
--  Expect the table to grow somewhat: htmid/cx/cy/cz are currently identical
--  across 4.9M rows, which PAGE compression handles almost for free. Once they
--  are all distinct they compress far less well.
--
--  Suzanne Werner, 2026-07-28
-------------------------------------------------------------------------------
USE BestDR20;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

-- Everything from here to the end is ONE batch, deliberately. RETURN only
-- exits the batch it appears in, so a GO between the guard below and the
-- UPDATE would let the UPDATE run after the guard had refused.

-- Refuse if the source columns are not clean.
IF EXISTS (SELECT 1 FROM spAll
           WHERE racat IS NULL OR deccat IS NULL
              OR racat = -9999 OR deccat = -9999
              OR racat < 0 OR racat > 360 OR deccat < -90 OR deccat > 90)
BEGIN
    RAISERROR('spAll: racat/deccat contain invalid values - nothing changed',16,1);
    RETURN;
END

PRINT 'before:';
SELECT TOP 1 'biggest htmid pile' AS metric, COUNT(*) AS rows_sharing_one_htmid
FROM spAll GROUP BY htmid ORDER BY COUNT(*) DESC;

BEGIN TRANSACTION;

UPDATE s SET
    s.htmid = dbo.fHtmEq(s.racat, s.deccat),
    s.cx    = h.x,
    s.cy    = h.y,
    s.cz    = h.z
FROM dbo.spAll s
CROSS APPLY dbo.fHtmEqToXyz(s.racat, s.deccat) h;

PRINT CAST(@@ROWCOUNT AS varchar(20)) + ' rows updated';

-- Nothing should be left unset.
IF EXISTS (SELECT 1 FROM spAll WHERE htmid IS NULL OR cx IS NULL OR cy IS NULL OR cz IS NULL)
BEGIN
    ROLLBACK TRANSACTION;
    RAISERROR('spAll: NULL htmid/cx/cy/cz after update - rolled back',16,1);
    RETURN;
END

COMMIT;

-- The htmid index must be rebuilt; its key column just changed on every row.
-- Outside the transaction above, but still inside this batch, so a refusal by
-- the guard skips it too.
ALTER INDEX ix_spAll_htmid ON spAll REBUILD WITH (SORT_IN_TEMPDB = ON);

PRINT 'after:';
SELECT TOP 1 'biggest htmid pile' AS metric, COUNT(*) AS rows_sharing_one_htmid
FROM spAll GROUP BY htmid ORDER BY COUNT(*) DESC;
GO
