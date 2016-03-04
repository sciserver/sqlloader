PRINT '*** INSTALL UDTs ***'
--====================================================================
--                       User Defined Types
--====================================================================
CREATE TYPE dbo.Point EXTERNAL NAME SphericalSql.[Spherical.Sql.PointUDT];
CREATE TYPE dbo.Region EXTERNAL NAME SphericalSql.[Spherical.Sql.RegionUDT];
GO
