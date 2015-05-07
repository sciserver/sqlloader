PRINT '*** DROP UDTs ***'
--====================================================================
--                       User Defined Types
--====================================================================
BEGIN TRY DROP TYPE sph.Point; END TRY BEGIN CATCH END CATCH
BEGIN TRY DROP TYPE dbo.Point; END TRY BEGIN CATCH END CATCH
BEGIN TRY DROP TYPE dbo.Region; END TRY BEGIN CATCH END CATCH
GO
