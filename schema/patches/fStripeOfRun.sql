-- Fix bugs in fStrip[e]OfRun (replace Segment table with Run table]

ALTER FUNCTION fStripeOfRun(@run int)
-------------------------------------------------------------
--/H returns Stripe containing a particular run 
-------------------------------------------------------------
--/T <br> run is the run number
--/T <br>
--/T <samp>select top 10 objid, dbo.fStripeOfRun(run) from PhotoObj </samp>
-------------------------------------------------------------
RETURNS int as
BEGIN
  RETURN (SELECT TOP 1 [stripe] from Run where run = @run)
END
GO


--
ALTER FUNCTION fStripOfRun(@run int)
-------------------------------------------------------------
--/H returns Strip containing a particular run 
-------------------------------------------------------------
--/T <br> run is the run number
--/T <br>
--/T <samp>select top 10 objid, dbo.fStripOfRun(run) from PhotoObj </samp>
-------------------------------------------------------------
RETURNS int as
BEGIN
  RETURN (SELECT TOP 1 [strip] from Run where run = @run)
END
GO

