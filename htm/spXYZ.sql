--=======================================================
-- spXYZ.sql
-- Scalar wrapper functions for extracting Cartesian coordinates
-- from RA/DEC using the HTM library's fHtmEqToXyz function
--
-- These functions are needed for PERSISTED computed columns
-- in tables that require x, y, z Cartesian unit vector coordinates.
--
-- Dependencies: Requires SphericalHTM CLR assembly and fHtmEqToXyz function
--               (deployed via spHtmCsharp.sql)
--
-- Created: 2026-01-13 for DR20 target table computed columns
--=======================================================

--=======================================================
IF  EXISTS (SELECT * FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[fCartesianX]')
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fCartesianX]
GO
--
CREATE FUNCTION dbo.fCartesianX(@ra float, @dec float)
------------------------------------------------------------------
--/H Extract X component of Cartesian unit vector from RA, Dec
------------------------------------------------------------------
--/T <br>Parameters:
--/T <li>@ra float, Right Ascension (degrees)
--/T <li>@dec float, Declination (degrees)
--/T <br>Returns the x component of the Cartesian unit vector
--/T <samp>select dbo.fCartesianX(0.0, 0.0)
--/T <br> gives:  1.0
--/T </samp>
-----------------------------------------------------------------
RETURNS float
WITH SCHEMABINDING
AS BEGIN
    DECLARE @x float
    SELECT @x = x FROM dbo.fHtmEqToXyz(@ra, @dec)
    RETURN @x
END
GO

--=======================================================
IF  EXISTS (SELECT * FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[fCartesianY]')
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fCartesianY]
GO
--
CREATE FUNCTION dbo.fCartesianY(@ra float, @dec float)
------------------------------------------------------------------
--/H Extract Y component of Cartesian unit vector from RA, Dec
------------------------------------------------------------------
--/T <br>Parameters:
--/T <li>@ra float, Right Ascension (degrees)
--/T <li>@dec float, Declination (degrees)
--/T <br>Returns the y component of the Cartesian unit vector
--/T <samp>select dbo.fCartesianY(90.0, 0.0)
--/T <br> gives:  1.0
--/T </samp>
-----------------------------------------------------------------
RETURNS float
WITH SCHEMABINDING
AS BEGIN
    DECLARE @y float
    SELECT @y = y FROM dbo.fHtmEqToXyz(@ra, @dec)
    RETURN @y
END
GO

--=======================================================
IF  EXISTS (SELECT * FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[fCartesianZ]')
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fCartesianZ]
GO
--
CREATE FUNCTION dbo.fCartesianZ(@ra float, @dec float)
------------------------------------------------------------------
--/H Extract Z component of Cartesian unit vector from RA, Dec
------------------------------------------------------------------
--/T <br>Parameters:
--/T <li>@ra float, Right Ascension (degrees)
--/T <li>@dec float, Declination (degrees)
--/T <br>Returns the z component of the Cartesian unit vector
--/T <samp>select dbo.fCartesianZ(0.0, 90.0)
--/T <br> gives:  1.0
--/T </samp>
-----------------------------------------------------------------
RETURNS float
WITH SCHEMABINDING
AS BEGIN
    DECLARE @z float
    SELECT @z = z FROM dbo.fHtmEqToXyz(@ra, @dec)
    RETURN @z
END
GO

--=======================================================
-- Example usage:
--
-- In a CREATE TABLE statement with computed columns:
--
-- CREATE TABLE dbo.example_table (
--     ra float NOT NULL,
--     [dec] float NOT NULL,
--     cx AS (dbo.fCartesianX(ra, [dec])) PERSISTED,
--     cy AS (dbo.fCartesianY(ra, [dec])) PERSISTED,
--     cz AS (dbo.fCartesianZ(ra, [dec])) PERSISTED
-- );
--
-- Or to test the functions:
-- SELECT
--     dbo.fCartesianX(0.0, 0.0) as x,
--     dbo.fCartesianY(0.0, 0.0) as y,
--     dbo.fCartesianZ(0.0, 0.0) as z
-- -- Expected: x=1.0, y=0.0, z=0.0
--
--=======================================================
