--=================================================================
-- spCoordinates.sql
-- Alex Szalay, Baltimore, 2004-03-18
-------------------------------------------------------------------
-- History:
--* 2004-02-13 Ani: Fixed bugs in fCoordsFromEq, fLambdaFromEq and
--*                   fEtaFromEq (PR #5865).
--* 2004-03-18 Alex: extracted coordinate related stuff from spBoundary.sql
--* 2004-06-10 Alex: added support for Galactic coordinates
--* 2004-08-27 Alex: Moved Rmatrix to the RegionTables.sql module
--* 2004-10-08 Ani: Updated description of fGetLonLat, fGetLon and fGetLat.
--=================================================================
SET NOCOUNT ON;
GO
 

--==========================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[spTransposeRmatrix]') 
    and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    drop procedure [dbo].[spTransposeRmatrix]
GO
--
CREATE PROCEDURE spTransposeRmatrix(@to varchar(16), @from varchar(16))
-------------------------------------------------------
--/H Transposes and stores a rotation matrix
--/A --------------------------------------------------
--/T 
--/T 
-------------------------------------------------------
AS BEGIN
    --
    -- build the transpose
    --
    DECLARE @r11 float, @r12 float, @r13 float;
    DECLARE @r21 float, @r22 float, @r23 float;
    DECLARE @r31 float, @r32 float, @r33 float;
    --
    -- get the matrix
    --
    SELECT @r11=x, @r12=y, @r13=z FROM Rmatrix WHERE mode = @to and row=1
    SELECT @r21=x, @r22=y, @r23=z FROM Rmatrix WHERE mode = @to and row=2
    SELECT @r31=x, @r32=y, @r33=z FROM Rmatrix WHERE mode = @to and row=3
    --
    INSERT INTO Rmatrix VALUES(@from,1,@r11,@r21,@r31);
    INSERT INTO Rmatrix VALUES(@from,2,@r12,@r22,@r32);
    INSERT INTO Rmatrix VALUES(@from,3,@r13,@r23,@r33);
    --
END
GO


--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[spBuildRmatrix]') 
    and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spBuildRmatrix]
GO
--
CREATE PROCEDURE spBuildRmatrix
-------------------------------------------------------
--/H Builds the rotation matrices necessary to operate
--/A --------------------------------------------------
--/T 
--/T 
-------------------------------------------------------
AS
BEGIN
    -- 
    DECLARE @ra float, @dec float;
    ---------------------------
    -- Survey coordinates
    --------------------------
    -- x axis
    SET @ra  = RADIANS(185.0);
    SET @dec = RADIANS( 32.5);
    INSERT INTO Rmatrix VALUES('J2S',1,
	cos(@dec)*cos(@ra),cos(@dec)*sin(@ra),sin(@dec))
    --
    -- y axis
    SET @ra  = RADIANS(185.0);
    SET @dec = RADIANS(-57.5);
    INSERT INTO Rmatrix VALUES('J2S',2,
	cos(@dec)*cos(@ra),cos(@dec)*sin(@ra),sin(@dec))
    --
    -- z axis
    SET @ra  = RADIANS(95.0);
    SET @dec = RADIANS( 0.0);
    INSERT INTO Rmatrix VALUES('J2S',3,
	cos(@dec)*cos(@ra),cos(@dec)*sin(@ra),sin(@dec))
    --
    EXEC spTransposeRmatrix 'J2S', 'S2J'
    --
    --------------------------
    -- Galactic coordinates
    --------------------------
    -- x axis
    SET @ra  = RADIANS(266.405);
    SET @dec = RADIANS(-28.9362);
    INSERT INTO Rmatrix VALUES('J2G',1,
	cos(@dec)*cos(@ra),cos(@dec)*sin(@ra),sin(@dec))
    --
    -- y axis
    SET @ra  = RADIANS(318.00437);
    SET @dec = RADIANS(48.329626);
    INSERT INTO Rmatrix VALUES('J2G',2,
	cos(@dec)*cos(@ra),cos(@dec)*sin(@ra),sin(@dec))
    --
    -- z axis
    SET @ra  = RADIANS(192.8594);
    SET @dec = RADIANS( 27.1283);
    INSERT INTO Rmatrix VALUES('J2G',3,
	cos(@dec)*cos(@ra),cos(@dec)*sin(@ra),sin(@dec))
    --
    EXEC spTransposeRmatrix 'J2G', 'G2J'
    --

END
GO
--


--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fRotateV3]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fRotateV3]
GO
--
CREATE FUNCTION fRotateV3(@mode varchar(16),@cx float,@cy float,@cz float)
-------------------------------------------------------
--/H Rotates a 3-vector by a given rotation matrix
--  --------------------------------------------------
--/T 
--/T 
-------------------------------------------------------
RETURNS @v3 TABLE (
	x float NOT NULL, 
	y float NOT NULL, 
	z float NOT NULL
)
AS BEGIN
    -- 
    DECLARE @x float, @y float, @z float;
    --
    SELECT @x=x*@cx+y*@cy+z*@cz FROM Rmatrix WHERE mode=@mode and row=1;
    SELECT @y=x*@cx+y*@cy+z*@cz FROM Rmatrix WHERE mode=@mode and row=2;
    SELECT @z=x*@cx+y*@cy+z*@cz FROM Rmatrix WHERE mode=@mode and row=3;
    --
    INSERT @v3 SELECT @x as x, @y as y, @z as z
    RETURN
END 
GO


--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetLonLat]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fGetLonLat]
GO
--
CREATE FUNCTION fGetLonLat(@mode varchar(8),@cx float,@cy float,@cz float)
-------------------------------------------------------
--/H Converts a 3-vector to longitude-latitude (Galactic or Survey)
--  --------------------------------------------------
--/T @mode can be one of the following:
--/T <li> J2S for Survey coordinates
--/T <li> J2G for Galactic coordinates
--/T <br> This is an internal table-valued function that requires a cursor
--/T or variables to specify the coordinates.  Use the scalar functions
--/T fGetLon and fGetLat instead in queries. 
-------------------------------------------------------
RETURNS @coord TABLE (lon float, lat float)
AS BEGIN
    --
    DECLARE @lon float, @lat float;
    --
    SELECT @lon=DEGREES(ATN2(y,x)),@lat=DEGREES(ASIN(z))
	FROM dbo.fRotateV3(@mode,@cx,@cy,@cz)
    --
    IF @lon<0 SET @lon=@lon+360;
    INSERT @coord SELECT @lon as lon, @lat as lat
    RETURN
END
GO


--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetLon]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fGetLon]
GO
--
CREATE FUNCTION fGetLon(@mode varchar(8),@cx float,@cy float,@cz float)
-------------------------------------------------------
--/H Converts a 3-vector to longitude (Galactic or Survey)
--  --------------------------------------------------
--/T @mode can be one of the following:
--/T <li> J2S for Survey coordinates,
--/T <li> J2G for Galactic coordinates, e.g.,
--/T <dd> select top 10 dbo.fGetLon('J2S',cx,cy,cz) from PhotoTag
--/T <br> Use fGetLat to get latitude.
-------------------------------------------------------
RETURNS float
AS BEGIN
    DECLARE @lon float;
    SELECT @lon=DEGREES(ATN2(y,x)) FROM dbo.fRotateV3(@mode,@cx,@cy,@cz)
    IF @lon<0 SET @lon=@lon+360;
    RETURN @lon
END
GO


--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fGetLat]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fGetLat]
GO
--
CREATE FUNCTION fGetLat(@mode varchar(8),@cx float,@cy float,@cz float)
-------------------------------------------------------
--/H Converts a 3-vector to latitude (Galactic or Survey)
--  --------------------------------------------------
--/T @mode can be one of the following:
--/T <li> J2S for Survey coordinates,
--/T <li> J2G for Galactic coordinates, e.g.,
--/T <dd> select top 10 dbo.fGetLat('J2G',cx,cy,cz) from PhotoTag
--/T <br>Use fGetLon to get longitude.
-------------------------------------------------------
RETURNS float
AS BEGIN
    DECLARE @lat float;
    SELECT @lat=DEGREES(ASIN(z)) FROM dbo.fRotateV3(@mode,@cx,@cy,@cz)
    RETURN @lat
END
GO


--===============================================================
if exists (select * from dbo.sysobjects where 
	id = object_id(N'[dbo].[fEqFromMuNu]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fEqFromMuNu]
GO
--
CREATE FUNCTION fEqFromMuNu(
	@mu float,
	@nu float,
	@node float,
	@incl float
)
RETURNS @coord TABLE (ra float, dec float, cx float, cy float, cz float)
----------------------------------------------------
--/H Compute Equatorial coordinates from @mu and @nu
-- 
--/T Compute both ra,dec anmd cx,cy,cz, given @mu,@nu, @node,@incl
--/T all in degrees
----------------------------------------------------
AS BEGIN
    DECLARE
	@rmu float, @rnu float, @rin float,
	@ra float, @dec float, 
	@cx float, @cy float, @cz float,
	@gx float, @gy float, @gz float;
	--
    -- convert to radians
    SET @rmu = RADIANS(@mu-@node);
    SET @rnu = RADIANS(@nu);
    SET @rin = RADIANS(@incl);
    --
    SET @gx = cos(@rmu)*cos(@rnu);
    SET @gy = sin(@rmu)*cos(@rnu);
    SET @gz = sin(@rnu);
    --
    SET @cx = @gx;
    SET @cy = @gy*cos(@rin)-@gz*sin(@rin);
    SET @cz = @gy*sin(@rin)+@gz*cos(@rin);
    --
    SET @dec = DEGREES(asin(@cz));
    SET @ra  = DEGREES(atn2(@cy,@cx)) + @node;
    IF  @ra<0 SET @ra = @ra+360 ;
    --
    SET @cx = cos(RADIANS(@ra))*cos(RADIANS(@dec));
    SET @cy = sin(RADIANS(@ra))*cos(RADIANS(@dec));
    --
    INSERT @coord VALUES(@ra, @dec, @cx, @cy, @cz);
    RETURN
END
GO


--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fMuNuFromEq]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fMuNuFromEq]
GO
--
CREATE FUNCTION fMuNuFromEq(
	@ra float,
	@dec float,
	@stripe int,
	@node float,
	@incl float
)
RETURNS @coord TABLE (mu float, nu float)
----------------------------------------------------
--/H Compute stripe coordinates from Equatorial
-- 
--/T Compute mu, nu from @ra,@dec, @node,@incl
----------------------------------------------------
AS BEGIN
    DECLARE
	@rra float, @rdec float, @rin float,
	@mu float, @nu float,
	@qx float, @qy float, @qz float,
	@gx float, @gy float, @gz float;

    -- convert to radians
    SET @rin  = RADIANS(@incl);
    SET @rra  = RADIANS(@ra-@node);
    SET @rdec = RADIANS(@dec);
    --
    SET @qx   = cos(@rra)*cos(@rdec);
    SET @qy   = sin(@rra)*cos(@rdec);
    SET @qz   = sin(@rdec);
    --
    SET @gx =  @qx;
    SET @gy =  @qy*cos(@rin)+@qz*sin(@rin);
    SET @gz = -@qy*sin(@rin)+@qz*cos(@rin);
    --
    SET @nu = DEGREES(ASIN(@gz));
    SET @mu = DEGREES(ATN2(@gy,@gx)) + @node;
    IF  @mu<0 SET @mu = @mu+360 ;
    IF  @stripe>50 AND @mu<180 SET @mu = @mu+360 ;
    --
    INSERT @coord VALUES(@mu, @nu);
    RETURN
END
GO


--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fMuFromEq]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fMuFromEq]
GO
--
CREATE FUNCTION fMuFromEq(@ra float,@dec float)
------------------------------------------------------------
--/H Returns mu from ra,dec
------------------------------------------------------------
--/D This is the generic service function for SDSS specific
--/D coordinate conversions. It derives all the coordinates
--/D from the ra,dec, based on the definition of the primary
--/D areas of the stripes. For the Southern stripes, it returns
--/D a mu value shifted by 360 degrees, in order to have a
--/D non-negative and monotonic quantity.
------------------------------------------------------------
RETURNS float
AS BEGIN
    DECLARE 
	@cx float, @cy float, @cz float,
	@qx float, @qy float, @qz float,
	@eta float, 
	@stripe int, @incl float,
	@mu float;
    --
    SET @cx = cos(radians(@dec))* cos(radians(@ra-95.0));
    SET @cy = cos(radians(@dec))* sin(radians(@ra-95.0));
    SET @cz = sin(radians(@dec));
    --
    SET @eta    =  degrees(atn2(@cz,@cy))
    SET @eta	= @eta -32.5;
    IF  @eta<-180 SET @eta = @eta+360;
    SET @stripe = 23 + floor(@eta/2.5+0.5);
    -- 
    SET @incl = (@stripe-10)*2.5;
    IF  @stripe>50 SET @incl = (@stripe-82)*2.5;
    --
    SET @qx = @cx;
    SET @qy = @cy*cos(radians(@incl))+@cz*sin(radians(@incl));
    SET @qz =-@cy*sin(radians(@incl))+@cz*cos(radians(@incl));
    --
    SET @mu = degrees(atn2(@qy,@qx))+95.0;
    IF  @stripe>50 SET @mu = @mu+360;
    --
    RETURN @mu
END
GO


--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fNuFromEq]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fNuFromEq]
GO
--
CREATE FUNCTION fNuFromEq(@ra float,@dec float)
------------------------------------------------------------
--/H Returns nu from ra,dec
------------------------------------------------------------
--/D This is the generic service function for SDSS specific
--/D coordinate conversions. It derives all the coordinates
--/D from the ra,dec, based on the definition of the primary
--/D areas of the stripes. For the Southern stripes, it returns
--/D a mu value shifted by 360 degrees, in order to have a
--/D non-negative and monotonic quantity.
------------------------------------------------------------
RETURNS float
AS BEGIN
    DECLARE 
	@cy float, @cz float,
	@qz float,
	@eta float, 
	@stripe int, @incl float,
	@nu float;
    --
    SET @cy = cos(radians(@dec))* sin(radians(@ra-95.0));
    SET @cz = sin(radians(@dec));
    --
    SET @eta    =  degrees(atn2(@cz,@cy))
    SET @eta	= @eta -32.5;
    IF  @eta<-180 SET @eta = @eta+360;
    --
    SET @stripe = 23 + floor(@eta/2.5+0.5);
    -- 
    SET @incl = (@stripe-10)*2.5;
    IF  @stripe>50 SET @incl = (@stripe-82)*2.5;
    --
    SET @qz =-@cy*sin(radians(@incl))+@cz*cos(radians(@incl));
    --
    SET @nu = degrees(asin(@qz));
    --
    RETURN @nu
END
GO


--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fCoordsFromEq]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fCoordsFromEq]
GO
--
CREATE FUNCTION fCoordsFromEq(@ra float,@dec float)
------------------------------------------------------------
--/H Returns table of stripe, lambda, eta, mu, nu derived from ra,dec
--   -------------------------------------------------------
--/D This is the generic service function for SDSS specific
--/D coordinate conversions. It derives all the coordinates
--/D from the ra,dec, based on the definition of the primary
--/D areas of the stripes. For the Southern stripes, it returns
--/D a mu value shifted by 360 degrees, in order to have a
--/D non-negative and monotonic quantity.
------------------------------------------------------------
RETURNS @coords TABLE (
    ra	float,
    [dec] float,
    [stripe] int,
    incl float,
    lambda float,
    eta float,
    mu float,
    nu float
)
AS BEGIN
    DECLARE 
	@cx float, @cy float, @cz float,
	@qx float, @qy float, @qz float,
	@lambda float, @eta float, 
	@stripe int, @incl float,
	@mu float, @nu float,
        @stripeEta float;
    --
    SET @cx = cos(radians(@dec))* cos(radians(@ra-95.0));
    SET @cy = cos(radians(@dec))* sin(radians(@ra-95.0));
    SET @cz = sin(radians(@dec));
    --
    SET @lambda = -degrees(asin(@cx));
    IF (@cy = 0.0 and @cz = 0.0)
        SET @cy = 1e-16;
    SET @eta    =  degrees(atn2(@cz,@cy))-32.5;
    SET @stripeEta = @eta;
    --
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    IF ABS(@lambda) > 90.0
       BEGIN
           SET @lambda = 180.0-@lambda;
           SET @eta = @eta+180.0;
       END
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    IF @eta < 0.0 SET @eta = @eta+360.0;
    IF @eta >= 360.0 SET @eta = @eta-360.0;
    IF ABS(@lambda) = 90.0 SET @eta = 0.0;
    IF @eta < -180.0 SET @eta = @eta+360.0;
    IF @eta >= 180.0 SET @eta = @eta-360.0;
    IF @eta > 90.0-32.5
       BEGIN
           SET @eta = @eta-180.0;
           SET @lambda = 180.0-@lambda;
       END
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    --
    IF  @stripeEta<-180 SET @stripeEta = @stripeEta+360;
    SET @stripe = 23 + floor(@stripeEta/2.5+0.5);
    --
    SET @incl = (@stripe-10)*2.5;
    IF  @stripe>50 SET @incl = (@stripe-82)*2.5;
    --
    SET @qx = @cx;
    SET @qy = @cy*cos(radians(@incl))+@cz*sin(radians(@incl));
    SET @qz =-@cy*sin(radians(@incl))+@cz*cos(radians(@incl));
    --
    SET @mu = degrees(atn2(@qy,@qx))+95.0;
    SET @nu = degrees(asin(@qz));
    IF  @stripe>50 SET @mu = @mu+360;
    --
    INSERT @coords SELECT
	@ra, @dec, @stripe, @incl, @lambda, @eta, @mu, @nu;
    RETURN
END
GO


--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fEtaFromEq]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fEtaFromEq]
GO
--
CREATE FUNCTION fEtaFromEq(@ra float,@dec float)
------------------------------------------------------------
--/H Returns eta from ra,dec
------------------------------------------------------------
--/D This is the generic service function for SDSS specific
--/D coordinate conversions. It derives all the coordinates
--/D from the ra,dec, based on the definition of the primary
--/D areas of the stripes. For the Southern stripes, it returns
--/D a mu value shifted by 360 degrees, in order to have a
--/D non-negative and monotonic quantity.
------------------------------------------------------------
RETURNS float
AS BEGIN
    DECLARE 
	@cx float, @cy float, @cz float,
	@lambda float, @eta float, 
        @stripeEta float;
    --
    SET @cx = cos(radians(@dec))* cos(radians(@ra-95.0));
    SET @cy = cos(radians(@dec))* sin(radians(@ra-95.0));
    SET @cz = sin(radians(@dec));
    --
    SET @lambda = -degrees(asin(@cx));
    IF (@cy = 0.0 and @cz = 0.0)
        SET @cy = 1e-16;
    SET @eta    =  degrees(atn2(@cz,@cy))-32.5;
    SET @stripeEta = @eta;
    --
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    IF ABS(@lambda) > 90.0
       BEGIN
           SET @lambda = 180.0-@lambda;
           SET @eta = @eta+180.0;
       END
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    IF @eta < 0.0 SET @eta = @eta+360.0;
    IF @eta >= 360.0 SET @eta = @eta-360.0;
    IF ABS(@lambda) = 90.0 SET @eta = 0.0;
    IF @eta < -180.0 SET @eta = @eta+360.0;
    IF @eta >= 180.0 SET @eta = @eta-360.0;
    IF @eta > 57.5	-- 90.0-32.5
       BEGIN
           SET @eta = @eta-180.0;
       END
    --
    RETURN @eta
END
GO



--=======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fLambdaFromEq]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fLambdaFromEq]
GO
--
CREATE FUNCTION fLambdaFromEq(@ra float,@dec float)
------------------------------------------------------------
--/H Returns lambda from ra,dec
------------------------------------------------------------
--/D This is the generic service function for SDSS specific
--/D coordinate conversions. It derives all the coordinates
--/D from the ra,dec, based on the definition of the primary
--/D areas of the stripes. For the Southern stripes, it returns
--/D a mu value shifted by 360 degrees, in order to have a
--/D non-negative and monotonic quantity.
------------------------------------------------------------
RETURNS float
AS BEGIN
    DECLARE 
	@cx float, @cy float, @cz float,
	@lambda float, @eta float, 
        @stripeEta float;
    --
    SET @cx = cos(radians(@dec))* cos(radians(@ra-95.0));
    SET @cy = cos(radians(@dec))* sin(radians(@ra-95.0));
    SET @cz = sin(radians(@dec));
    --
    SET @lambda = -degrees(asin(@cx));
    IF (@cy = 0.0 and @cz = 0.0)
        SET @cy = 1e-16;
    SET @eta    =  degrees(atn2(@cz,@cy))-32.5;
    SET @stripeEta = @eta;
    --
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    IF ABS(@lambda) > 90.0
       BEGIN
           SET @lambda = 180.0-@lambda;
           SET @eta = @eta+180.0;
       END
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    IF @eta < 0.0 SET @eta = @eta+360.0;
    IF @eta >= 360.0 SET @eta = @eta-360.0;
    IF ABS(@lambda) = 90.0 SET @eta = 0.0;
    IF @eta < -180.0 SET @eta = @eta+360.0;
    IF @eta >= 180.0 SET @eta = @eta-360.0;
    IF @eta > 90.0-32.5
       BEGIN
           SET @eta = @eta-180.0;
           SET @lambda = 180.0-@lambda;
       END
    IF @lambda < -180.0 SET @lambda = @lambda+360.0;
    IF @lambda >= 180.0 SET @lambda = @lambda-360.0;
    --
    RETURN @lambda
END
GO

/*
--
select * from dbo.fCoordsFromEq(184.0,0.0)
-- {lambda   -1.00000000} {eta  -32.50000000}
select * from dbo.fCoordsFromEq(185.0,0.0)
-- {lambda   -0.00000000} {eta  -32.50000000}
select * from dbo.fCoordsFromEq(186.0,0.0)
-- {lambda    1.00000000} {eta  -32.50000000}
select * from dbo.fCoordsFromEq(4.0,0.0)
-- {lambda  179.00000000} {eta  -32.50000000}
select * from dbo.fCoordsFromEq(5.0,0.0)
-- {lambda -180.00000000} {eta  -32.50000000}
select * from dbo.fCoordsFromEq(6.0,0.0)
-- {lambda -179.00000000} {eta  -32.50000000}

*/


/*

select * from Rmatrix

select * from dbo.fRotateV3('J2S',1,0,0)
-- -0.84018208673472849	-0.53525502112187739	-8.7155742747658013E-2

select * from dbo.fGetLonLat('S2J',
   -0.84018208673472849,-0.53525502112187739,-8.7155742747658013E-2)

-- testing

DECLARE @x float, @y float, @z float
--
select @x=x, @y=y, @z=z from dbo.fRotateV3('J2S',1,0,0)
select * from dbo.fGetLonLat('S2J',@x,@y,@z)
--
select @x=x, @y=y, @z=z from dbo.fRotateV3('J2S',0,1,0)
select * from dbo.fGetLonLat('S2J',@x,@y,@z)
--
select @x=x, @y=y, @z=z from dbo.fRotateV3('J2S',0,0,1)
select * from dbo.fGetLonLat('S2J',@x,@y,@z)

*/

--======================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fEtaToNormal]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fEtaToNormal]
GO
--
CREATE FUNCTION fEtaToNormal(@eta float)
-------------------------------------------------------
--/H Compute the normal vector from an eta value
--  --------------------------------------------------
--/T 
--/T 
-------------------------------------------------------
RETURNS @v3 TABLE (x float, y float, z float)
AS BEGIN
    --
    DECLARE @x float, @y float, @z float;
    SET @x = SIN(RADIANS(@eta));
    SET @y = COS(RADIANS(@eta));
    SET @z = 0.0;
    --
    INSERT @v3 SELECT x, y, z 
	FROM dbo.fRotateV3('S2J',@x, @y, @z)
    RETURN
END
GO


--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fStripeToNormal]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fStripeToNormal]
GO
--
CREATE FUNCTION fStripeToNormal(@stripe int)
-------------------------------------------------------
--/H Compute the normal vector from an eta value
--  --------------------------------------------------
--/T 
--/T 
-------------------------------------------------------
RETURNS @v3 TABLE (x float, y float, z float)
AS BEGIN
    --
    DECLARE @x float, @y float, @z float, @eta float;
    --
    IF (@stripe < 0 or @stripe>86) return;
    IF @stripe is null SET @stripe = 10;	-- default is the equator
    --
    SET @eta = CASE 
	WHEN @stripe<50 THEN (@stripe-10)*2.5 -32.5
	ELSE (@stripe-82)*2.5 -32.5
	END;
    --
    SET @x = SIN(RADIANS(@eta));
    SET @y = COS(RADIANS(@eta));
    SET @z = 0.0;
    --
    INSERT @v3 SELECT x, y, z 
	FROM dbo.fRotateV3('S2J',@x, @y, @z)
    RETURN
END
GO




--============================================================
if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fWedgeV3]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fWedgeV3]
GO
--
CREATE FUNCTION fWedgeV3(@x1 float,@y1 float, @z1 float, @x2 float, @y2 float, @z2 float)
-------------------------------------------------------
--/H Compute the wedge product of two vectors
--  --------------------------------------------------
--/T 
--/T 
-------------------------------------------------------
RETURNS @v3 TABLE (x float, y float, z float)
AS BEGIN
    --
    INSERT @v3 
	SELECT 
	(@y1*@z2 - @y2*@z1) as x,
    	(@x2*@z1 - @x1*@z2) as y,
	(@x1*@y2 - @x2*@y1) as z;
    --
    RETURN
END
GO

--SELECT * FROM dbo.fEtaToNormal(-32.5)
-- -5.5511151231257827E-17	0.0	-1.0


------------------------------
-- Init the rotation matrix
------------------------------
DELETE RMatrix
EXEC spBuildRmatrix

--===========================================
PRINT '[spCoordinate.sql]: Coordinate related functions and procedures created'
--===========================================
