--=============================================================================
--   spPhoto.sql
--   2004-12-17 Ani Thakar and Alex Szalay
-------------------------------------------------------------------------------
--  Photo stored procedures and functions for SQL Server
--
--------------------------------------------------------------------
-- History:
--* 2004-12-17	Ani: Moved sps and functions here from PhotoTables.sql.
--* 2005-01-02  Ani: Added 'top 1' to fStrip[e]OfRun so they wont bomb
--*                  on runs that have multiple entries in Segment (fix
--*                  for PR #6289). 
--* 2005-04-08  Ani: Added fObjID.
--* 2005-10-11  Ani: Added fObjIdFromSDSSWithFF to include firstfield flag
--*                  in objid components.
--* 2006-01-31  Ani: Fixed sample calls to fHMSBase.
--* 2007-04-12  Ani: Added aperture mag functions (PR 7169).
--* 2007-04-24  Ani: Added fUberCal function to return UberCal corrected mags.
--* 2007-06-04  Ani: Fixed bug in fPhotoApMag* functions - missing objid.
--* 2007-12-31  Ani: Fixes to aperture mag functions to include aperture mags
--*                  in all bands (see PRs #7390 and 7426). 
--* 2208-01-10  Ani: Fixed typos in fGetPhotoApMag and fPhotoApMagErr.
--* 2008-08-16  Ani: Added fSDSSfromObjID to return a table of objid components.
--* 2008-09-05  Ani: Fixed typos in fSDSSfromObjID.
--* 2011-04-26  Ani: Fixed bugs in fStrip[e]OfRun (replaced Segment with Run).
--* 2012-07-27  Ani: Fixed errors in fObjidFromSDSS[WithFF] descriptions.
--* 2012-07-29  Ani: Deleted fGetPhotoApMag, fPhotoApMag and fPhotoApMagErr,
--*                  didnt work any more due to Field schema changes. Also
--*                  deleted fUbercalMag (no UberCal table).
--* 2012-11-15  Ani: Added new function from Alex: fGetWCS.
--* 2012-11-16  Ani: Updated fGetWCS to use ANSI JOIN syntax.
--* 2012-11-28  Ani: Fixed typo in fGetWCS.
--* 2012-12-17  Ani: Added sample call for fGetWCS and removed admin 
--*                  access restriction.
-------------------------------------------------------------------------------

--==============================
-- Utility functions
--==============================


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fSkyVersion]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fSkyVersion]
GO
--
CREATE FUNCTION fSkyVersion(@ObjID bigint)
-------------------------------------------------------------------------------
--/H Extracts SkyVersion from an SDSS Photo Object ID
--
--/T The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>
--/T <samp> select top 10 objId, dbo.fSkyVersion(objId) as fSkyVersion from Galaxy</samp>
-------------------------------------------------------------------------------
RETURNS INT
AS BEGIN
    RETURN ( cast( ((@ObjID / power(cast(2 as bigint),59)) & 0x0000000F) AS INT));
END
GO
--


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRerun]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fRerun]
GO
--
CREATE FUNCTION fRerun(@ObjID bigint)
-------------------------------------------------------------------------------
--/H Extracts Rerun from an SDSS Photo Object ID
--
--/T The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>
--/T <samp> select top 10 objId, dbo.fRerun(objId) as fRerun from Galaxy</samp>
-------------------------------------------------------------------------------
RETURNS INT
AS BEGIN
    RETURN ( cast( ((@ObjID / power(cast(2 as bigint),48)) & 0x000007FF) AS INT));
END
GO
--


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRun]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fRun]
GO
--
CREATE FUNCTION fRun(@ObjID bigint)
-------------------------------------------------------------------------------
--/H Extracts Run from an SDSS Photo Object ID
--
--/T The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>
--/T <samp> select top 10 objId, dbo.fRun(objId) as fRun from Galaxy</samp>
-------------------------------------------------------------------------------
RETURNS INT
AS BEGIN
    RETURN ( cast( ((@ObjID / power(cast(2 as bigint),32)) & 0x0000FFFF) AS INT));
END  
GO
--


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fCamcol]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fCamcol]
GO
--
CREATE FUNCTION fCamcol(@ObjID bigint)
-------------------------------------------------------------------------------
--/H Extracts Camcol from an SDSS Photo Object ID
--
--/T The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>
--/T <samp> select top 10 objId, dbo.fCamcol(objId) as fCamcol from Galaxy</samp>
-------------------------------------------------------------------------------
RETURNS INT
AS BEGIN
    RETURN ( cast( ((@ObjID / power(cast(2 as bigint),29)) & 0x00000007) AS INT));
END
GO
--


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fField]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fField]
GO
--
CREATE FUNCTION  fField(@ObjID bigint)
-------------------------------------------------------------------------------
--/H Extracts Field from an SDSS Photo Object ID.
--
--/T The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>
--/T <samp> select top 10 objId, dbo.fField(objId) as fField from Galaxy</samp>
-------------------------------------------------------------------------------
RETURNS INT
AS BEGIN
    RETURN ( cast( ((@ObjID / power(cast(2 as bigint),16)) & 0x00000FFF) AS INT));
END
GO
--


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fObj]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fObj]
GO

CREATE FUNCTION fObj(@ObjID bigint)
-------------------------------------------------------------------------------
--/H Extracts Obj from an SDSS Photo Object ID.
--
--/T The bit-fields and their lengths are: Skyversion[5] Rerun[11] Run[16] Camcol[3] First[1] Field[12] Obj[16]<br>
--/T <samp> select top 10 objId, dbo.fObj(objId) as fObj from Galaxy</samp>
-------------------------------------------------------------------------------
RETURNS INT
AS BEGIN
    RETURN ( cast( ((@ObjID / power(cast(2 as bigint),0)) & 0x0000FFFF) AS INT));
END
GO
--


IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fObjID' )
	DROP FUNCTION fObjID
GO
--
CREATE FUNCTION fObjID(@objID bigint)
-------------------------------------------------------------------------------
--/H Match an objID to a PhotoObj and set/unset the first field bit.
--
--/T Given an objID this function determines whether there is a
--/T PhotoObj with a matching (skyversion, run, rerun, camcol, field, 
--/T obj) and returns the objID with the first field bit set properly
--/T to correspond to that PhotoObj.  It returns 0 if there is
--/T no corresponding PhotoObj.  It does not matter whether the
--/T first field bit is set or unset in the input objID.
-------------------------------------------------------------------------------
RETURNS BIGINT
AS BEGIN
    DECLARE @firstfieldbit bigint;
    SET @firstfieldbit = 0x0000000010000000;
    SET @objID = @objID & ~@firstfieldbit;
    IF (select count_big(*) from PhotoTag WITH (nolock) where objID = @objID) > 0
        RETURN @objID
    ELSE
    BEGIN
        SET @objID = @objID + @firstfieldbit;
        IF (select count_big(*) from PhotoTag WITH (nolock) where objID = @objID) > 0
            RETURN @objID
    END
    RETURN cast(0 as bigint)
END
GO


--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fObjidFromSDSS]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fObjidFromSDSS]
GO
--
CREATE FUNCTION fObjidFromSDSS(@skyversion int, @run int, @rerun int, @camcol int, @field int, @obj int)
-------------------------------------------------------------------------------
--/H Computes the long objID from the 5-part SDSS numbers.
--
--/T The bit-fields and their lengths are skyversion[5] + rerun[11] + run[16] + Camcol[3] + firstfield[1] + field[12] + obj[16]<br>
--/T The firstfield is assumed to be 0, see also fObjidFromSDSSWithFF.<br>
--/T <samp> SELECT dbo.fObjidFromSDSS(2,94,301,1,11,9) AS fObjid</samp>
-------------------------------------------------------------------------------
RETURNS BIGINT
AS BEGIN
    DECLARE @two bigint, @sky int;
    SET @two = 2;
    SET @sky = @skyversion;
    IF @skyversion=-1 SET @sky=15;
    RETURN ( cast(@sky*power(@two,59) + @rerun*power(@two,48) + 
	@run*power(@two,32) + @camcol*power(@two,29) + 
	@field*power(@two,16)+@obj as bigint));
END
GO
--



--============================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fObjidFromSDSSWithFF]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fObjidFromSDSSWithFF]
GO
--
CREATE FUNCTION fObjidFromSDSSWithFF(@skyversion int, @run int, @rerun int, 
				     @camcol int, @field int, @obj int, 
				     @firstfield int = 0)
-------------------------------------------------------------------------------
--/H Computes the long objID from the 5-part SDSS numbers plus the firstfield flag.
--
--/T The bit-fields and their lengths are skyversion[5] + rerun[11] + run[16] + Camcol[3] + firstfield[1]+ field[12] + obj[16]<br>
--/T See also fObjidFromSDSS for version that assumes firstfield = 0.<br>
--/T <samp> SELECT dbo.fObjidFromSDSSWithFF(2,94,301,1,11,9,0) AS fObjid</samp>
-------------------------------------------------------------------------------
RETURNS BIGINT
AS BEGIN
    DECLARE @two bigint, @sky int;
    SET @two = 2;
    SET @sky = @skyversion;
    IF @skyversion=-1 SET @sky=15;
    RETURN ( cast(@sky*power(@two,59) + @rerun*power(@two,48) + 
	@run*power(@two,32) + @camcol*power(@two,29) + 
	@field*power(@two,16)+@firstfield*power(@two,28)+@obj as bigint));
END
GO



--===============================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSDSS' )
	DROP FUNCTION fSDSS
GO
--
CREATE FUNCTION fSDSS(@objid bigint)
-------------------------------------------------------------------------------
--/H Computes the 6-part SDSS numbers from the long objID
--
--/T The bit-fields and their lengths are skyversion[5] + rerun[11] + run[16] + camcol[3] + first[1] + field[12] + obj[16]<br>
--/T <samp> select top 5 dbo.fSDSS(objid) as SDSS from PhotoObj</samp>
-------------------------------------------------------------------------------
RETURNS varchar(64)
AS BEGIN
    RETURN (
	cast(dbo.fSkyVersion(@objid) as varchar(6))+'-'+
	cast(dbo.fRun(@objid) as varchar(6))+'-'+
	cast(dbo.fRerun(@objid) as varchar(6))+'-'+
	cast(dbo.fCamcol(@objid) as varchar(6))+'-'+
	cast(dbo.fField(@objid) as varchar(6))+'-'+
	cast(dbo.fObj(@objid) as varchar(6))
	);
END
GO
--


--===============================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSDSSfromObjID' )
	DROP FUNCTION fSDSSfromObjID
GO
--
CREATE FUNCTION fSDSSfromObjID(@objid bigint)
-------------------------------------------------------------------------------
--/H Returns a table pf the 6-part SDSS numbers from the long objID.
--
--/T The returned columns in the output table are: 
--/T	skyversion, rerun, run, camcol, firstField, field, obj<br>
--/T <samp> select * from dbo.fSDSSfromObjID(objid)</samp>
-------------------------------------------------------------------------------
RETURNS @sdssObjID TABLE (
	skyVersion TINYINT,
	run INT,
	rerun INT,
	camcol TINYINT,
	firstField TINYINT,
	field INT,
	obj INT
)
AS BEGIN
    DECLARE @ffMask BIGINT, @ffBit TINYINT
    SET @ffMask = 0x0000000010000000;
    IF (@objID & @ffMask) > 0
	SET @ffBit = 1
    ELSE
	SET @ffBit = 0;
    INSERT @sdssObjID 
	SELECT
	    cast( ((@ObjID / power(cast(2 as bigint),59)) & 0x0000000F) AS INT) AS skyVersion,
	    cast( ((@ObjID / power(cast(2 as bigint),32)) & 0x0000FFFF) AS INT) AS run,
	    cast( ((@ObjID / power(cast(2 as bigint),48)) & 0x000007FF) AS INT) AS rerun,
	    cast( ((@ObjID / power(cast(2 as bigint),29)) & 0x00000007) AS INT) AS camcol,
	    @ffBit AS firstField,
	    cast( ((@ObjID / power(cast(2 as bigint),16)) & 0x00000FFF) AS INT) AS field,
	    cast( ((@ObjID / power(cast(2 as bigint),0)) & 0x0000FFFF) AS INT) AS obj
    RETURN
END
GO
--


--============================================
IF EXISTS (SELECT name FROM sysobjects 
	   WHERE name = N'fStripeOfRun' )
  	   DROP FUNCTION fStripeOfRun
GO
--
CREATE FUNCTION fStripeOfRun(@run int)
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


--============================================
IF EXISTS (SELECT name FROM sysobjects 
	   WHERE name = N'fStripOfRun' )
  	   DROP FUNCTION fStripOfRun
GO
--
CREATE FUNCTION fStripOfRun(@run int)
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


----------------------------------------------
-- generating various IAU names, etc.
----------------------------------------------


IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fDMSbase' )
	DROP FUNCTION fDMSbase
GO
--
CREATE  FUNCTION fDMSbase(@deg float, @truncate int = 0, @precision int = 2)
-------------------------------------------------------------------------------
--/H Base function to convert declination in degrees to +dd:mm:ss.ss notation.
-------------------------------------------------------------------------------
--/T @truncate is 0 (default) if decimal digits to be rounded, 1 to be truncated.
--/T <br> @precision is the number of decimal digits, default 2.
--/T <p><samp> select dbo.fDMSbase(87.5,1,4) </samp> <br>
--/T <samp> select dbo.fDMSbase(87.5,default,default) </samp>
-------------------------------------------------------------------------------
RETURNS varchar(32)
AS BEGIN
    DECLARE	
	@s char(1), 
	@d float, 
	@nd int, 
	@np int, 
	@q varchar(32),
	@t varchar(32);
	--
	SET @s = '+';
 	IF  @deg<0 SET @s = '-';
	--
	SET @t = '00:00:00.0'
	IF (@precision < 1) SET @precision = 1;
	IF (@precision > 10) SET @precision = 10;
	SET @np = 0
	WHILE (@np < @precision-1) BEGIN
		SET @t = @t+'0'
		SET @np = @np + 1
	END
	SET @d = ABS(@deg);
	-- degrees
	SET @nd = FLOOR(@d);
	SET @q  = LTRIM(CAST(@nd as varchar(2)));
	SET @t  = STUFF(@t,3-LEN(@q),LEN(@q), @q);
	-- minutes
	SET @d  = 60.0 * (@d-@nd);
	SET @nd = FLOOR(@d);
	SET @q  = LTRIM(CAST(@nd as varchar(4)));
	SET @t  = STUFF(@t,6-LEN(@q),LEN(@q), @q);
	-- seconds
	SET @d  = ROUND( 60.0 * (@d-@nd),@precision,@truncate );
--	SET @d  = 60.0 * (@d-@nd);
	SET @q  = LTRIM(STR(@d,6+@precision,@precision));
	SET @t = STUFF(@t,10+@precision-LEN(@q),LEN(@q), @q);
	--
	RETURN(@s+@t);
END
GO
--


IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fHMSbase' )
	DROP FUNCTION fHMSbase
GO
--
CREATE  FUNCTION fHMSbase(@deg float, @truncate int = 0, @precision int = 2)
-------------------------------------------------------------------------------
--/H Base function to convert right ascension in degrees to +hh:mm:ss.ss notation.
-------------------------------------------------------------------------------
--/T @truncate is 0 (default) if decimal digits to be rounded, 1 to be truncated.
--/T <br> @precision is the number of decimal digits, default 2.
--/T <p><samp> select dbo.fHMSBase(187.5,1,3) </samp> <br>
--/T <samp> select dbo.fHMSBase(187.5,default,default) </samp>
-------------------------------------------------------------------------------
RETURNS varchar(32)
AS BEGIN
    DECLARE
	@d float,
	@nd int, 
	@np int, 
	@q varchar(10),
	@t varchar(16);
	--
	SET @t = '00:00:00.0'
	IF (@precision < 1) SET @precision = 1;
	IF (@precision > 10) SET @precision = 10;
	SET @np = 0
	WHILE (@np < @precision-1) BEGIN
		SET @t = @t+'0'
		SET @np = @np + 1
	END
	SET @d = ABS(@deg/15.0);
	-- degrees
	SET @nd = FLOOR(@d);
	SET @q  = LTRIM(CAST(@nd as varchar(2)));
	SET @t  = STUFF(@t,3-LEN(@q),LEN(@q), @q);
	-- minutes
	SET @d  = 60.0 * (@d-@nd);
	SET @nd = FLOOR(@d);
	SET @q  = LTRIM(CAST(@nd as varchar(4)));
	SET @t  = STUFF(@t,6-LEN(@q),LEN(@q), @q);
	-- seconds
	SET @d  = ROUND( 60.0 * (@d-@nd),@precision,@truncate );
	SET @q  = LTRIM(STR(@d,6+@precision,@precision));
	SET @t = STUFF(@t,10+@precision-LEN(@q),LEN(@q), @q);
--	SET @d  = 60.0 * (@d-@nd);
--	SET @q = LTRIM(STR(@d,9,3));
--	SET @t = STUFF(@t,13-LEN(@q),LEN(@q), @q);
	--
	RETURN(@t);
END
GO
--


--============================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'fDMS' )
	DROP FUNCTION fDMS
GO
--
CREATE FUNCTION fDMS(@deg float)
-------------------------------------------------------------------------------
--/H Convert declination in degrees to +dd:mm:ss.ss notation 
-------------------------------------------------------------------------------
--/T <i>NOTE: this function should not be used to generate SDSS IAU names,
--/T use fIAUFromEq instead. </i>
--/T <p><samp> select dbo.fDMS(87.5) </samp>
-------------------------------------------------------------------------------
RETURNS varchar(32)
AS BEGIN
    RETURN dbo.fDMSbase(@deg,default,default);
END
GO


--=============================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'fHMS' )
	DROP FUNCTION fHMS
GO
--
CREATE FUNCTION fHMS(@deg float)
-------------------------------------------------------------------------------
--/H Convert right ascension in degrees to +hh:mm:ss.ss notation <br>
-------------------------------------------------------------------------------
--/T <i>NOTE: this function should not be used to generate SDSS IAU names,
--/T use fIAUFromEq instead. </i>
--/T <p><samp> select dbo.fHMS(187.5) </samp>
-------------------------------------------------------------------------------
RETURNS varchar(32)
AS BEGIN
    RETURN dbo.fHMSbase(@deg,default,default);
END
GO


--=============================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'fIAUFromEq' )
	DROP FUNCTION fIAUFromEq
GO
--
CREATE FUNCTION fIAUFromEq(@ra float, @dec float)
-------------------------------------------------------------------------------
--/H Convert ra, dec in degrees to extended IAU name
-------------------------------------------------------------------------------
--/T Will create a 25 char IAU name as SDSS Jhhmmss.ss+ddmmss.s
--/T <p><samp> select dbo.fIAUFromEq(182.25, -12.5) </samp>
-------------------------------------------------------------------------------
RETURNS varchar(64)
AS BEGIN
	RETURN('SDSS J'+REPLACE(dbo.fHMSbase(@ra,1,2)+dbo.fDMSbase(@dec,1,1),':',''));
END
GO



--=============================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fFirstFieldBit]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fFirstFieldBit]
GO
--
CREATE FUNCTION fFirstFieldBit()
-------------------------------------------------------------------------------
--/H Returns the bit that indicates whether an objID is in the first field of a run
--
--/T This bit can be added to an objID created with fObjidFromSDSS
--/T to create the correct objID for the case where a PhotoObj
--/T is in the first field of a run.<br>
--/T <samp> select dbo.fObjidFromSDSS(0,752,8,6,100,300) + dbo.fFirstFieldBit() </samp>
-------------------------------------------------------------------------------
RETURNS BIGINT
AS BEGIN
    RETURN cast(0x0000000010000000 as bigint);
END  
GO



--=============================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fPrimaryObjID]') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function [dbo].[fPrimaryObjID]
GO
--
CREATE FUNCTION fPrimaryObjID(@objID bigint)
-------------------------------------------------------------------------------
--/H Match an objID to a PhotoPrimary and set/unset the first field bit.
--
--/T Given an objID this function determines whether there is a
--/T PhotoPrimary with a matching
--/T (skyversion, run, rerun, camcol, field, obj)
--/T and returns the objID with the first field bit set properly
--/T to correspond to that PhotoPrimary.  It returns 0 if there is
--/T no corresponding PhotoPrimary.  It does not matter whether the
--/T first field bit is set or unset in the input objID.
-------------------------------------------------------------------------------
RETURNS BIGINT
AS BEGIN
    DECLARE @firstfieldbit bigint;
    SET @firstfieldbit = 0x0000000010000000;
    SET @objID = @objID & ~@firstfieldbit;
    IF (select count_big(*) from PhotoPrimary WITH (nolock) where objID = @objID) > 0
        RETURN @objID
    ELSE
    BEGIN
        SET @objID = @objID + @firstfieldbit;
        IF (select count_big(*) from PhotoPrimary WITH (nolock) where objID = @objID) > 0
            RETURN @objID
    END
    RETURN cast(0 as bigint)
END
GO


-----------------------------------
-- more unit conversion functions
-----------------------------------

--=============================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fMagToFlux' )
	DROP FUNCTION fMagToFlux
GO
--
CREATE FUNCTION fMagToFlux(@mag real, @band int)
-------------------------------------------------------------------------------
--/H Convert Luptitudes to AB flux in nJy
-------------------------------------------------------------------------------
--/T  Computes the AB flux for a magnitude given in the
--/T  sinh system. The flux is expressed in nanoJy.
--/T  Needs the @mag value for the specific band. 
--/T  @band is 0..4 for u'..z''.
--/T  <br><samp>dbo.fMagToFlux(21.576975,2)</samp>
--/T <br> see also fMagToFluxErr
-------------------------------------------------------------------------------
RETURNS real
AS
BEGIN
    DECLARE @counts1 float, @counts2 float, @bparm float;
    SET @bparm = (CASE @band
	WHEN 0 THEN 1.4E-10
	WHEN 1 THEN 0.9E-10
	WHEN 2 THEN 1.2E-10
	WHEN 3 THEN 1.8E-10
	WHEN 4 THEN 7.4E-10
	END);
    IF (@mag < -99.0 ) 
	SET @mag = 1.0;
    SET @counts1 = (@mag/ -1.0857362048) - LOG(@bparm);
    SET @counts2 = @bparm * 3630.78 * (EXP(@counts1) - EXP(-@counts1));  -- implement SINH()
    RETURN 1.0E9* @counts2;
END
GO
--


--=============================================================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fMagToFluxErr' )
	DROP FUNCTION fMagToFluxErr
GO
--
CREATE FUNCTION fMagToFluxErr(@mag real, @err real, @band int)
-------------------------------------------------------------------------------
--/H Convert the error in luptitudes to AB flux in nJy
-------------------------------------------------------------------------------
--/T  Computes the flux error for a magnitude and its error
--/T  expressed in the sinh system. Returns the error in nJy units.
--/T  Needs the @mag value as well as the error for the
--/T  specific band. @band is 0..4 for u'..z''.
--/T  <br><samp>dbo.fMagToFluxErr(21.576975,0.17968324,2)
--/T  </samp>
--/T <br> see also fMagToFlux
-------------------------------------------------------------------------------
RETURNS real
AS
BEGIN
    DECLARE @flux real, @bparm float;
    SET @bparm = (CASE @band
	WHEN 0 THEN 1.4E-10
	WHEN 1 THEN 0.9E-10
	WHEN 2 THEN 1.2E-10
	WHEN 3 THEN 1.8E-10
	WHEN 4 THEN 7.4E-10
	END);
    IF (@mag < -99.0 )
	SET @err = 1.0;
    SET @flux = (SELECT dbo.fMagToFlux(@mag,@band));
    RETURN @err*SQRT(power(@flux,2)+ 4.0E18*power(3630.78*@bparm,2))/1.0857362048;
END
GO
--



--=============================================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'fGetWCS') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function fGetWCS
GO
--
CREATE FUNCTION fGetWCS(@fieldid bigint)
-------------------------------------------------------------------------------
--/H Builds the relevant part of the FITS header with the WCS info
-------------------------------------------------------------------------------
--/T Input parameter is the fieldid
--/T <samp>
--/T       PRINT dbo.fGetWCS(1237671956445462528)
--/T <br>  SELECT TOP 10 dbo.fGetWCS( fieldid ) FROM Field
--/T </samp>
-------------------------------------------------------------------------------
RETURNS varchar(2000)
AS BEGIN
	DECLARE @out varchar(2000)
	SELECT @out  = '	NAXIS   =                    2
	NAXIS1  =                 2048
	NAXIS2  =                 1489
	ORIGIN  = ''SDSS    ''
	TELESCOP= ''2.5m    ''
	OBSERVER= ''observer''           / Observer
	EQUINOX =              2000.00 /	
	CTYPE1  = ''RA---TAN''           /Coordinate type
	CTYPE2  = ''DEC--TAN''           /Coordinate type
	CRPIX1  =        1025.00000000 /X of reference pixel
	CRPIX2  =        745.000000000 /Y of reference pixel';
	------------------------------------------
	-- append the ra and dec of the center
	------------------------------------------
	SELECT @out =  @out
			+CHAR(10)
			+'    CRVAL1  ='+STR(b.ra,22,10)
			+' /RA of reference pixel (deg)'
			+CHAR(10)
			+'    CRVAL2  ='+STR(b.dec,22,10)
			+' /Dec of reference pixel (deg)'
			+CHAR(10)
	FROM (
		SELECT	
			a_r+b_r*744.5+c_r*1024.5 mu,
			d_r+e_r*744.5+f_r*1024.5 nu,
			r.node, r.incl
		FROM Field f
		    JOIN Run r ON f.run=r.run
		WHERE 
		    f.fieldID=@fieldid
	) a CROSS APPLY dbo.fEqFromMuNu(mu,nu,node,incl) b
	--
	RETURN @out;
END
GO



IF EXISTS (SELECT [name] FROM dbo.sysobjects 
	WHERE [name] = N'spSetDefaultFileGroup') 
     EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[spPhoto.sql]: Photo procedures and functions created'
GO
