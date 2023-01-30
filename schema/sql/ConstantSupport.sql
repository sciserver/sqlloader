--=========================================================
--  ConstantSupport.sql
--  2001-11-07 Alex Szalay
-----------------------------------------------------------
--  Various Constants and enumerated types for SkyServer
--  Unit conversions also go here
--
--  Views
--	PhotoFlags		bits	binary(8)
--	PhotoStatus		bits	binary(4)
--	CalibStatus		bits	binary(2)
--      InsideMask              bits    binary(1)
--	ImageStatus		bits	binary(4)
--	ResolveStatus		bits	binary(4)
--	PrimTarget		bits	binary(4)
--	SecTarget		bits	binary(4)
--	SpecialTarget1		bits	binary(4)
--	SpecialTarget2		bits	binary(4)
--	Segue1Target1		bits	binary(4)
--	Segue2Target1		bits	binary(4)
--	Segue1Target2		bits	binary(4)
--	Segue2Target2		bits	binary(4)
--	BossTarget1		bits	binary(4)
--	AncillaryTarget1	bits	binary(4)
--	AncillaryTarget2	bits	binary(4)
--	ApogeeTarget1		bits	binary(4)
--	ApogeeTarget2		bits	binary(4)
--	ApogeeStarFlag		bits	binary(4)
--	ApogeeAspcapFlag	bits	binary(4)
--	ApogeeParamFlag		bits	binary(4)
--	ApogeeExtraTarg		bits	binary(4)
--	eBossTarget0		bits	binary(4)
--	SpecZWarning		bits	binary(4)
--	ImageMask		bits	binary(4)
--	SpecPixMask		bits	binary(4)
--	TiMask			bits	binary(4)
--	sdssvBossTarget0	bits	binary(8)
--	PhotoType		enum	int
--	MaskType		enum	int
--	FieldQuality		enum	int
--	PspStatus		enum	int
--	FramesStatus		enum	int
--	HoleType		enum	int
--	SourceType		enum	int
--	ProgramType		enum	int
--	CoordType		enum	int
--
----------------------------------------------------------------------------------
-- History:
--* 2001-11-09 Jim: changed the order of fields for SpecLineNames
--* 2001-11-10 Alex: added functions to support primTarget and secTarget
--* 2001-11-10 Alex: reinserted the SDSSConstants and StripeDefs
--* 2001-11-19 Alex: fixed bugs in PhotoFlags values and added missing items
--* 2001-11-23 Alex: changed the DataConstants value type to binary(8),
--*		and SDSSConstants value to float, and added views,
--*		plus more access functions. revised fPhotoDescription.
--* 2001-11-23 Jim+Alex: include fMjdToGMT time conversion routine
--* 2001-12-02 Alex: changed PrimTargetFlags->primTarget, SecTargetFlags->SecTarget 
--*		and fixed the leading zeroes in SpecZWarning.
--* 2001-12-27 Alex: separated the tables from the functions and views
--* 2002-04-09 Jim: added sample calls to functions, fixed fSpecDescription bug
--* 2002-08-10 Adrian: added bits/enums views/functions for tiling changes
--* 2002-08-22 Ani: Removed duplicate fSpecZWarningN definition, and also
--*                  fixed some errors in the descriptions/comments.
--* 2002-08-26 Ani: Added descriptions to tiling views/functions.
--* 2002-10-22 Alex: Added support to PhotoMode functions
--* 2003-01-27 Ani: Renamed TileInfo to TilingInfo as per PR# 4702,
--*	     and renamed TileBoundary (table) to TilingBoundary (view).
--* 2003-02-19 Alex: added support for FramesStatus
--* 2003-02-20 Alex: added support for MaskType
--* 2003-06-04 Alex: added support for InsideMask
--*                  added 'coalesce' to functions returning names indexed by value 
--* 2003-07-18 Ani: Fixed example for fInsideMask (param missing)
--* 2005-04-21 Ani: Fixed ImageMask view (needed cast to binary(4), not (2)).
--* 2006-12-01 Ani: Fix for PR #6119, fSpecZWarningN not handling 0 and NULL
--*                 zwarning values correctly.
--* 2007-03-30 Ani: Added view UberCalibStatus for ubercal calib status values.
--* 2007-04-25 Ani: Fixed bug in fUberCalibStatusN (overflow).
--* 2008-08-08 Ani: Fixed examples for fMaskType and fMaskTypeN (PR #6554).
--* 2008-08-08 Ani: Fixed fInsideMask doc (PR #6555).
--* 2011-10-03 Ani: Added ImageStatus, SpecialTarget1, Segue1Target1, 
--*                 Segue2Target1, and SpecPixMask.  Deleted FieldMask, 
--*                 SpecClass, SpecLineNames, and SpecZStatus.
--* 2011-10-04 Ani: Fixed references to Ubercal from CalibStatus functions.
--*                 Added ResolveStatus view and support functions.
--* 2011-10-05 Ani: Updated all views to exclude rows with name='', which
--*                 is a special row for each constant field containing
--*                 the description of that field.  Also changed
--*                 ResolveStatus view and functions to bits from enum.
--* 2012-05-23 Ani: Replaced "ObjType" with "SourceType".
--* 2013-06-06 Ani: Added SpecialTarget2, Segue*Target2, and all the BOSS
--*                 and APOGEE target flag support functions and views.
--* 2013-06-12 Ani: Fixed examples for APOGEE flags.
--* 2013-07-05 Ani: Fixed views so they will display 64-bit values correctly
--*                 even when the flags they represent are 32 bits.
--* 2014-02-07 Ani: Updated descriptions of fApogeePixMask* functions to
--*                 reflect that there is no actual column for this mask.
--* 2014-04-17 Ani: Changed value param to type bigint for flag functions
--*                 that display flag names (see PR #2032).
--* 2014-10-23 Ani: Removed functions fApogeePixMask* as per PR #1979.
--* 2014-10-23 Ani: Removed view ApogeePixMask as per PR #1979.
--* 2014-11-25 Ani: Added ApogeeExtraTarg for DR12.
--* 2014-11-25 Ani: Added references to SAS algorithms pages where applicable..
--* 2014-12-05 Ani: Added functions for ApogeeExtraTarg.
--* 2015-01-21 Ani: Fixed bug in f*Target? functions - the cast needs to be
--*                 to bigint, not int (PR #2258).
--* 2015-02-09 Ani: Added functions for EbossTarget0.
--* 2015-02-15 Ani: Fixed EBossTarget0 function examples.
--* 2015-03-16 Ani: Fixed column names for AncillaryTarget? examples.
--* 2015-03-25 Ani: Fixed AncillaryTarget2 view (needs to be 64-bit).
--* 2016-07-30 Ani: Fixed APOGEE flag function descriptions.
--* 2023-01-12 Ani: Added sdssvBossTarget0 view and functions.
--=================================================================================
SET NOCOUNT ON
GO

--%%%%%%%%%%%%%%%%%%%%%%%
-- Flags first
--%%%%%%%%%%%%%%%%%%%%%%%

--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'PhotoFlags' )
DROP VIEW PhotoFlags
GO
--
CREATE VIEW PhotoFlags
------------------------------------------
--/H Contains the PhotoFlags flag values from DataConstants as binary(8).
------------------------------------------
--/T Please see the FLAGS1 and FLAGS2 entries in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT 
	name, 
	value, 
	description
    FROM DataConstants
    WHERE field='PhotoFlags' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'PhotoStatus' )
DROP VIEW PhotoStatus
GO
--
CREATE VIEW PhotoStatus
------------------------------------------
--/H Contains the PhotoStatus flag values from DataConstants as binary(4).
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='PhotoStatus' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'CalibStatus' )
DROP VIEW CalibStatus
GO
--
CREATE VIEW CalibStatus
------------------------------------------
--/H Contains the CalibStatus flag values from DataConstants as binary(2).
------------------------------------------
--/T Please see the CALIB_STATUS entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast(value as binary(2)) as value, 
	description
    FROM DataConstants
    WHERE field='CalibStatus' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'InsideMask' )
DROP VIEW InsideMask
GO
--
CREATE VIEW InsideMask
------------------------------------------
--/H Contains the InsideMask flag values from DataConstants as binary(1)
------------------------------------------
AS
SELECT name, 
       convert(char(4),cast(value/power((cast(2 as bigint)),56) as binary(1)),1) as value,
       --	cast(value as binary(1)) as value, 
       description
    FROM DataConstants
    WHERE field='InsideMask' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'ImageStatus' )
	DROP VIEW ImageStatus
GO
--
CREATE VIEW ImageStatus
------------------------------------------
--/H Contains the ImageStatus flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the IMAGE_STATUS entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ImageStatus' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'ResolveStatus' )
	DROP VIEW ResolveStatus
GO
--
CREATE VIEW ResolveStatus
------------------------------------------
--/H Contains the ResolveStatus flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the RESOLVE_STATUS entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ResolveStatus' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'PrimTarget' )
DROP VIEW PrimTarget
GO
--
CREATE VIEW PrimTarget
------------------------------------------
--/H Contains the PrimTarget flag values from DataConstants as binary(4)
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='PrimTarget' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SecTarget' )
DROP VIEW SecTarget
GO
--
CREATE VIEW SecTarget
------------------------------------------
--/H Contains the SecTarget flag values from DataConstants as binary(4)
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='SecTarget' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'SpecialTarget1' )
DROP VIEW SpecialTarget1
GO
--
CREATE VIEW SpecialTarget1
------------------------------------------
--/H Contains the SpecialTarget1 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the SPECIAL_TARGET1 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
       value,
       description
    FROM DataConstants
    WHERE field='SpecialTarget1' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'SpecialTarget2' )
DROP VIEW SpecialTarget2
GO
--
CREATE VIEW SpecialTarget2
------------------------------------------
--/H Contains the SpecialTarget2 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the SPECIAL_TARGET2 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='SpecialTarget2' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'Segue1Target1' )
DROP VIEW Segue1Target1
GO
--
CREATE VIEW Segue1Target1
------------------------------------------
--/H Contains the Segue1Target1 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the SEGUE1_TARGET1 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='Segue1Target1' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'Segue2Target1' )
DROP VIEW Segue2Target1
GO
--
CREATE VIEW Segue2Target1
------------------------------------------
--/H Contains the Segue2Target1 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the SEGUE2_TARGET1 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='Segue2Target1' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'Segue1Target2' )
DROP VIEW Segue1Target2
GO
--
CREATE VIEW Segue1Target2
------------------------------------------
--/H Contains the Segue1Target2 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the SEGUE1_TARGET2 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='Segue1Target2' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'Segue2Target2' )
DROP VIEW Segue2Target2
GO
--
CREATE VIEW Segue2Target2
------------------------------------------
--/H Contains the Segue2Target2 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the SEGUE2_TARGET2 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='Segue2Target2' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'BossTarget1' )
DROP VIEW BossTarget1
GO
--
CREATE VIEW BossTarget1
------------------------------------------
--/H Contains the BossTarget1 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the BOSS_TARGET1 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
       value,
       description
    FROM DataConstants
    WHERE field='BossTarget1' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'AncillaryTarget1' )
DROP VIEW AncillaryTarget1
GO
--
CREATE VIEW AncillaryTarget1
------------------------------------------
--/H Contains the AncillaryTarget1 flag values from DataConstants as binary(8).
------------------------------------------
--/T Please see the ANCILLARY_TARGET1 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
       value,
       description
    FROM DataConstants
    WHERE field='AncillaryTarget1' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'AncillaryTarget2' )
DROP VIEW AncillaryTarget2
GO
--
CREATE VIEW AncillaryTarget2
------------------------------------------
--/H Contains the AncillaryTarget2 flag values from DataConstants as binary(8).
------------------------------------------
--/T Please see the ANCILLARY_TARGET2 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
        value,
	description
    FROM DataConstants
    WHERE field='AncillaryTarget2' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'ApogeeTarget1' )
DROP VIEW ApogeeTarget1
GO
--
CREATE VIEW ApogeeTarget1
------------------------------------------
--/H Contains the ApogeeTarget1 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the APOGEE_TARGET1 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ApogeeTarget1' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'ApogeeTarget2' )
DROP VIEW ApogeeTarget2
GO
--
CREATE VIEW ApogeeTarget2
------------------------------------------
--/H Contains the ApogeeTarget2 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the APOGEE_TARGET2 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ApogeeTarget2' AND name != ''
GO



--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'ApogeeStarFlag' )
DROP VIEW ApogeeStarFlag
GO
--
CREATE VIEW ApogeeStarFlag
------------------------------------------
--/H Contains the ApogeeStarFlag flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the APOGEE_STARFLAG entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ApogeeStarFlag' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'ApogeeAspcapFlag' )
DROP VIEW ApogeeAspcapFlag
GO
--
CREATE VIEW ApogeeAspcapFlag
------------------------------------------
--/H Contains the ApogeeAspcapFlag flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the APOGEE_ASPCAPFLAG entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ApogeeAspcapFlag' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'ApogeeParamFlag' )
DROP VIEW ApogeeParamFlag
GO
--
CREATE VIEW ApogeeParamFlag
------------------------------------------
--/H Contains the ApogeeParamFlag flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the APOGEE_PARAMFLAG entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ApogeeParamFlag' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'ApogeeExtraTarg' )
DROP VIEW ApogeeExtraTarg
GO
--
CREATE VIEW ApogeeExtraTarg
------------------------------------------
--/H Contains the ApogeeExtraTarg flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the APOGEE_EXTRATARG entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='ApogeeExtraTarg' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'eBossTarget0' )
DROP VIEW eBossTarget0
GO
--
CREATE VIEW eBossTarget0
------------------------------------------
--/H Contains the eBossTarget0 flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the EBOSS_TARGET0 entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
       value,
       description
    FROM DataConstants
    WHERE field='eBossTarget0' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SpecZWarning' )
DROP VIEW SpecZWarning
GO
--
CREATE VIEW SpecZWarning
------------------------------------------
--/H Contains the SpecZWarning flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the ZWARNING entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='SpecZWarning' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'SpecPixMask' )
DROP VIEW SpecPixMask
GO
--
CREATE VIEW SpecPixMask
------------------------------------------
--/H Contains the SpecPixMask flag values from DataConstants as binary(4).
------------------------------------------
--/T Please see the SPPIXMASK entry in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT name, 
	cast((value^power(cast(2 as bigint),32)) as binary(4)) as value, 
	description
    FROM DataConstants
    WHERE field='SpecPixMask' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects
        WHERE  name = N'TiMask' )
	DROP VIEW TiMask
GO
--
CREATE VIEW TiMask
------------------------------------------
--/H Contains the TiMask flag values from DataConstants as binary(4)
------------------------------------------
AS
SELECT name,
        cast((value^power(cast(2 as bigint),32)) as binary(4)) as value,
        description
    FROM DataConstants
    WHERE field='TiMask' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'sdssvBossTarget0' )
DROP VIEW sdssvBossTarget0
GO
--
CREATE VIEW sdssvBossTarget0
------------------------------------------
--/H Contains the sdssvBossTarget0 flag values from DataConstants as binary(8).
------------------------------------------
--/T Please see the FLAGS1 and FLAGS2 entries in Algorithms under Bitmasks
--/T for further information.
------------------------------------------
AS
SELECT 
	name, 
	value, 
	description
    FROM DataConstants
    WHERE field='sdssvBossTarget0' AND name != ''
GO




--%%%%%%%%%%%%%%%%%%%%%%%%%
-- enumerated values
--%%%%%%%%%%%%%%%%%%%%%%%%%
--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'PhotoMode' )
	DROP VIEW PhotoMode
GO
--
CREATE VIEW PhotoMode
------------------------------------------
--/H Contains the PhotoMode enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	cast(value as int) as value, 
	description
    FROM DataConstants
    WHERE field = 'PhotoMode' AND name != ''
GO
 


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'PhotoType' )
	DROP VIEW PhotoType
GO
--
CREATE VIEW PhotoType
------------------------------------------
--/H Contains the PhotoType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	cast(value as int) as value, 
	description
    FROM DataConstants
    WHERE field='PhotoType' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'MaskType' )
	DROP VIEW MaskType
GO
--
CREATE VIEW MaskType
------------------------------------------
--/H Contains the MaskType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	cast(value as int) as value, 
	description
    FROM DataConstants
    WHERE field='MaskType' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'FieldQuality' )
	DROP VIEW FieldQuality
GO
--
CREATE VIEW FieldQuality
------------------------------------------
--/H Contains the FieldQuality enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	cast(value as int) as value, 
	description
    FROM DataConstants
    WHERE field='FieldQuality' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'PspStatus' )
	DROP VIEW PspStatus
GO
--
CREATE VIEW PspStatus
------------------------------------------
--/H Contains the PspStatus enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	cast(value as int) as value, 
	description
    FROM DataConstants
    WHERE field='PspStatus' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'FramesStatus' )
	DROP VIEW FramesStatus
GO
--
CREATE VIEW FramesStatus
------------------------------------------
--/H Contains the FramesStatus enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name, 
	cast(value as int) as value, 
	description
    FROM DataConstants
    WHERE field='FramesStatus' AND name != ''
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects
           WHERE  name = N'HoleType' )
DROP VIEW HoleType
GO
--
CREATE VIEW HoleType
------------------------------------------
--/H Contains the HoleType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name,
        cast(value as int) as value,
        description
    FROM DataConstants
    WHERE field='HoleType' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects
           WHERE  name = N'SourceType' )
	DROP VIEW SourceType
GO
--
CREATE VIEW SourceType
------------------------------------------
--/H Contains the SourceType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name,
        cast(value as int) as value,
        description
    FROM DataConstants
    WHERE field='SourceType' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects
           WHERE  name = N'ProgramType' )
	DROP VIEW ProgramType
GO
--
CREATE VIEW ProgramType
------------------------------------------
--/H Contains the ProgramType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name,
        cast(value as int) as value,
        description
    FROM DataConstants
    WHERE field='ProgramType' AND name != ''
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects
           WHERE  name = N'CoordType' )
	DROP VIEW CoordType
GO
--
CREATE VIEW CoordType
------------------------------------------
--/H Contains the CoordType enumerated values from DataConstants as int
------------------------------------------
AS
SELECT name,
        cast(value as int) as value,
        description
    FROM DataConstants
    WHERE field='CoordType' AND name != ''
GO


--%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Access functions for Enums
--%%%%%%%%%%%%%%%%%%%%%%%%%%

--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoMode' )
	DROP FUNCTION fPhotoMode
GO
--
CREATE FUNCTION fPhotoMode(@name varchar(40))
-------------------------------------------------------------------------------
--/H Returns the Mode value, indexed by name (Primary, Secondary, Family, Outside)
-------------------------------------------------------------------------------
--/T the Mode names can be found with 
--/T <br>       Select * from PhotoMode 
--/T <br>
--/T Sample call to fPhotoMode
--/T <samp> 
--/T <br> select top 10 *  
--/T <br> from photoObj
--/T <br> where mode =  dbo.fPhotoMode('PRIMARY')
--/T </samp> 
--/T <br> see also fPhotoModeN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
RETURN ( SELECT value
	FROM PhotoMode
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoModeN' )
	DROP FUNCTION fPhotoModeN
GO
--
CREATE FUNCTION fPhotoModeN(@value int)
-------------------------------------------------------------------------------
--/H Returns the Mode name, indexed by value ()
-------------------------------------------------------------------------------
--/T the Mode names can be found with 
--/T <br>       Select * from PhotoMode 
--/T <br>
--/T Sample call to fPhotoModeN
--/T <samp> 
--/T <br> select top 10 *  
--/T <br> from photoObj
--/T <br> where mode =  dbo.fPhotoMode('PRIMARY')
--/T </samp> 
--/T <br> see also fPhotoModeN
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
RETURN ( SELECT name
	FROM PhotoMode
	WHERE value = @value
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoType' )
	DROP FUNCTION fPhotoType
GO
--
CREATE FUNCTION fPhotoType(@name varchar(40))
-------------------------------------------------------------------------------
--/H Returns the PhotoType value, indexed by name (Galaxy, Star,...)
-------------------------------------------------------------------------------
--/T the PhotoType names can be found with 
--/T <br>       Select * from PhotoType 
--/T <br>
--/T Sample call to fPhotoType.
--/T <samp> 
--/T <br> select top 10 *  
--/T <br> from photoObj
--/T <br> where type =  dbo.fPhotoType('Star')
--/T </samp> 
--/T <br> see also fPhotoTypeN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
RETURN ( SELECT value
	FROM PhotoType
	WHERE name = UPPER(@name)
	)
END
GO
--

--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fMaskType' )
	DROP FUNCTION fMaskType
GO
--
CREATE FUNCTION fMaskType(@name varchar(40))
-------------------------------------------------------------------------------
--/H Returns the MaskType value, indexed by name 
-------------------------------------------------------------------------------
--/T the MaskType names can be found with 
--/T <br>       Select * from MaskType 
--/T <br>
--/T Sample call to fMaskType.
--/T <samp> 
--/T <br> select top 10 *  
--/T <br> from Mask
--/T <br> where type =  dbo.fMaskType('Star')
--/T </samp> 
--/T <br> see also fMaskTypeN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
RETURN ( SELECT value
	FROM MaskType
	WHERE name = UPPER(@name)
	)
END
GO
--

--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fMaskTypeN' )
	DROP FUNCTION fMaskTypeN
GO
--
CREATE FUNCTION fMaskTypeN(@value int)
-------------------------------------------------------------------------------
--/H Returns the MaskType name, indexed by value (0=Bleeding Mask, 1=Bright Star Mask, etc.)
-------------------------------------------------------------------------------
--/T the MaskType values can be found with 
--/T <br>       Select * from MaskType 
--/T <br>
--/T Sample call to fMaskTypeN.
--/T <samp> 
--/T <br> select top 10 m.maskID, o.objID, dbo.fMaskTypeN(m.type) as type 
--/T <br> from Mask m JOIN MaskedObject o ON m.maskID=o.maskID
--/T </samp> 
--/T <br> see also fMaskType
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
RETURN ( SELECT name
	FROM MaskType
	WHERE value = @value
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoTypeN' )
	DROP FUNCTION fPhotoTypeN
GO
--
CREATE FUNCTION fPhotoTypeN(@value int)
-------------------------------------------------------------------------------
--/H Returns the PhotoType name, indexed by value (3-> Galaxy, 6-> Star,...)
-------------------------------------------------------------------------------
--/T the PhotoType values can be found with 
--/T <br>       Select * from PhotoType 
--/T <br>
--/T Sample call to fPhotoTypeN.
--/T <samp> 
--/T <br> select top 10 objID, dbo.fPhotoTypeN(type) as type 
--/T <br> from photoObj
--/T </samp> 
--/T <br> see also fPhotoType
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
RETURN ( SELECT name
	FROM PhotoType
	WHERE value = @value
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fFieldQuality' )
	DROP FUNCTION fFieldQuality
GO
--
CREATE FUNCTION fFieldQuality(@name varchar(40))
-------------------------------------------------------------
--/H Returns bitmask of named field quality (e.g. ACCEPTABLE, BAD, GOOD, HOLE, MISSING)
-------------------------------------------------------------
--/T the fFieldQuality names can be found with 
--/T <br>       Select * from FieldQuality 
--/T <br>
--/T Sample call to fFieldQuality.
--/T <samp> 
--/T <br> select top 10 *  
--/T <br> from field
--/T <br> where quality =  dbo.fFieldQuality('ACCEPTABLE')
--/T </samp> 
--/T <br> see also fFieldQualityN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
RETURN ( SELECT value
	FROM FieldQuality
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fFieldQualityN' )
	DROP FUNCTION fFieldQualityN
GO
--
CREATE FUNCTION fFieldQualityN(@value int)
-------------------------------------------------------------
--/H Returns description of quality value (e.g. ACCEPTABLE, BAD, GOOD, HOLE, MISSING)
-------------------------------------------------------------
--/T the fFieldQuality values can be found with 
--/T <br>       Select * from FieldQuality
--/T <br>
--/T Sample call to fFieldQualityN.
--/T <samp> 
--/T <br> select top 10 dbo.fFieldQualityN(quality) as quality
--/T <br> from field
--/T </samp> 
--/T <br> see also fFieldQuality
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
RETURN ( SELECT name
	FROM FieldQuality
	WHERE value = @value
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPspStatus' )
	DROP FUNCTION fPspStatus
GO
--
CREATE FUNCTION fPspStatus(@name varchar(40))
-------------------------------------------------------------------------------
--/H Returns the PspStatus value, indexed by name
-------------------------------------------------------------------------------
--/T the  PspStatus values can be found with 
--/T <br>       Select * from PspStatus  
--/T <br>
--/T Sample call to fPspStatus.
--/T <samp> 
--/T <br> select top 10 *
--/T <br> from field
--/T <br> where status_r = dbo.fPspStatus('PSF_OK')
--/T </samp> 
--/T <br> see also fPspStatusN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
RETURN ( SELECT value
	FROM PspStatus
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPspStatusN' )
	DROP FUNCTION fPspStatusN
GO
--
CREATE FUNCTION fPspStatusN(@value int)
-------------------------------------------------------------------------------
--/H Returns the PspStatus name, indexed by value
-------------------------------------------------------------------------------
--/T the  PspStatus values can be found with 
--/T <br>       Select * from PspStatus 
--/T <br>
--/T Sample call to fPspStatusN.
--/T <samp> 
--/T <br> select top 10 dbo.fPspStatusN(status_r) as status_r
--/T <br> from field
--/T </samp> 
--/T <br> see also PspStatus
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
RETURN ( SELECT name
	FROM PspStatus
	WHERE value = @value
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fFramesStatus' )
	DROP FUNCTION fFramesStatus
GO
--
CREATE FUNCTION fFramesStatus(@name varchar(40))
-------------------------------------------------------------------------------
--/H Returns the FramesStatus value, indexed by name
-------------------------------------------------------------------------------
--/T the  FramesStatus values can be found with 
--/T <br>       Select * from FramesStatus  
--/T <br>
--/T Sample call to fFramesStatus.
--/T <samp> 
--/T <br> select top 10 *
--/T <br> from field
--/T <br> where status_r = dbo.fFramesStatus('OK')
--/T </samp> 
--/T <br> see also fFramesStatusN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
RETURN ( SELECT value
	FROM FramesStatus
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fFramesStatusN' )
	DROP FUNCTION fFramesStatusN
GO
--
CREATE FUNCTION fFramesStatusN(@value int)
-------------------------------------------------------------------------------
--/H Returns the FramesStatus name, indexed by value
-------------------------------------------------------------------------------
--/T the  FramesStatus values can be found with 
--/T <br>       Select * from FramesStatus 
--/T <br>
--/T Sample call to fFramesStatusN.
--/T <samp> 
--/T <br> select top 10 dbo.fFramesStatusN(framesstatus) as framesstatus
--/T <br> from field
--/T </samp> 
--/T <br> see also FramesStatus
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
RETURN ( SELECT name
	FROM FramesStatus
	WHERE value = @value
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fHoleType' )
	DROP FUNCTION fHoleType
GO
--
CREATE FUNCTION fHoleType(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the HoleType value, indexed by name
-------------------------------------------------------------------------------
--/T the HoleTypes can be found with 
--/T <br>       Select * from HoleType
--/T <br>
--/T Sample call to fHoleType.
--/T <samp> 
--/T <br> select top 10  *
--/T <br> from HoleObj
--/T <br> where holeType = dbo.fHoleType('OBJECT')
--/T </samp> 
--/T <br> see also fHoleTypeN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
    RETURN ( SELECT value
	FROM HoleType
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fHoleTypeN' )
	DROP FUNCTION fHoleTypeN
GO
--
CREATE FUNCTION fHoleTypeN(@value int)
-------------------------------------------------------------------------------
--/H Return the HoleType name, indexed by value
-------------------------------------------------------------------------------
--/T the HoleTypes can be found with 
--/T <br>       Select * from HoleType
--/T <br>
--/T Sample call to fHoleTypeN.
--/T <samp> 
--/T <br> select top 10 dbo.fHoleTypeN(holeType) as holeType
--/T <br> from HoleObj
--/T </samp> 
--/T <br> see also fHoleType
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
    RETURN ( SELECT name
	FROM HoleType
	WHERE value = @value
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSourceType' )
	DROP FUNCTION fSourceType
GO
--
CREATE FUNCTION fSourceType(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the SourceType value, indexed by name
-------------------------------------------------------------------------------
--/T the SourceTypes can be found with 
--/T <br>       Select * from SourceType
--/T <br>
--/T Sample call to fSourceType.
--/T <samp> 
--/T <br> select top 10  *
--/T <br> from TiledTarget
--/T <br> where sourceType = dbo.fSourceType('GALAXY')
--/T </samp> 
--/T <br> see also fSourceTypeN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
    RETURN ( SELECT value
	FROM SourceType
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSourceTypeN' )
	DROP FUNCTION fSourceTypeN
GO
--
CREATE FUNCTION fSourceTypeN(@value int)
-------------------------------------------------------------------------------
--/H Return the SourceType name, indexed by value
-------------------------------------------------------------------------------
--/T the SourceTypes can be found with 
--/T <br>       Select * from SourceType
--/T <br>
--/T Sample call to fSourceTypeN.
--/T <samp> 
--/T <br> select top 10 dbo.fSourceTypeN(sourceType) as sourceType
--/T <br> from TiledTarget
--/T </samp> 
--/T <br> see also fSourceType
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
    RETURN ( SELECT name
	FROM SourceType
	WHERE value = @value
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fProgramType' )
	DROP FUNCTION fProgramType
GO
--
CREATE FUNCTION fProgramType(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the ProgramType value, indexed by name
-------------------------------------------------------------------------------
--/T the ProgramTypes can be found with 
--/T <br>       Select * from ProgramType
--/T <br>
--/T Sample call to fProgramType.
--/T <samp> 
--/T <br> select top 10  *
--/T <br> from Tile
--/T <br> where programType = dbo.fProgramType('MAIN')
--/T </samp> 
--/T <br> see also fProgramTypeN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
    RETURN ( SELECT value
	FROM ProgramType
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fProgramTypeN' )
	DROP FUNCTION fProgramTypeN
GO
--
CREATE FUNCTION fProgramTypeN(@value int)
-------------------------------------------------------------------------------
--/H Return the ProgramType name, indexed by value
-------------------------------------------------------------------------------
--/T the ProgramTypes can be found with 
--/T <br>       Select * from ProgramType
--/T <br>
--/T Sample call to fProgramTypeN.
--/T <samp> 
--/T <br> select top 10 dbo.fProgramTypeN(programType) as programType
--/T <br> from Tile
--/T </samp> 
--/T <br> see also fProgramType
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
    RETURN ( SELECT name
	FROM ProgramType
	WHERE value = @value
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fCoordType' )
	DROP FUNCTION fCoordType
GO
--
CREATE FUNCTION fCoordType(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the CoordType value, indexed by name
-------------------------------------------------------------------------------
--/T the CoordTypes can be found with 
--/T <br>       Select * from CoordType
--/T <br>
--/T Sample call to fCoordType.
--/T <samp> 
--/T <br> select top 10  *
--/T <br> from TilingBoundary
--/T <br> where coordType = dbo.fCoordType('RA_DEC')
--/T </samp> 
--/T <br> see also fCoordTypeN
-------------------------------------------------------------
RETURNS INTEGER
AS BEGIN
    RETURN ( SELECT value
	FROM CoordType
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fCoordTypeN' )
	DROP FUNCTION fCoordTypeN
GO
--
CREATE FUNCTION fCoordTypeN(@value int)
-------------------------------------------------------------------------------
--/H Return the CoordType name, indexed by value
-------------------------------------------------------------------------------
--/T the CoordTypes can be found with 
--/T <br>       Select * from CoordType
--/T <br>
--/T Sample call to fCoordTypeN.
--/T <samp> 
--/T <br> select top 10 dbo.fCoordTypeN(coordType) as coordType
--/T <br> from TilingBoundary
--/T </samp> 
--/T <br> see also fCoordType
-------------------------------------------------------------
RETURNS varchar(40)
AS BEGIN
    RETURN ( SELECT name
	FROM CoordType
	WHERE value = @value
	)
END
GO
--


--%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Access functions for Flags
--%%%%%%%%%%%%%%%%%%%%%%%%%%


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fFieldMask' )
	DROP FUNCTION fFieldMask
GO
--
CREATE FUNCTION fFieldMask(@name varchar(40))
-------------------------------------------------------------
--/H Returns mask value for a given name (e.g. "seeing")
-------------------------------------------------------------
--/T the FieldMask values can be found with Select * from FieldMask. 
--/T <br>
--/T Sample call to find fields with good seeing.
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from field 
--/T <br> where goodMask & dbo.fFieldMask('Seeing') > 0 
--/T </samp> 
--/T <br> see also fFieldMaskN
-------------------------------------------------------------
RETURNS int
AS BEGIN
RETURN ( SELECT cast(value as int)
	FROM FieldMask
	WHERE name = UPPER(@name)
	)
END
GO


----------------------------------------
-- Describe the flags for a given field's vector of flags
----------------------------------------

--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fFieldMaskN' )
	DROP FUNCTION fFieldMaskN
GO
--
CREATE FUNCTION fFieldMaskN(@value int)
-------------------------------------------------------------
--/H Returns description of mask value (e.g. "SEEING PSF")
-------------------------------------------------------------
--/T the FieldMask values can be found with Select * from FieldMask. 
--/T <br>
--/T Sample call to field masks.
--/T <samp> 
--/T <br> select top 10 
--/T <br> 	dbo.fFieldMaskN(goodMask) as good,
--/T <br> 	dbo.fFieldMaskN(acceptableMask) as acceptable, 
--/T <br> 	dbo.fFieldMaskN(badMask) as bad  
--/T <br> from field
--/T </samp> 
--/T <br> see also fFieldMask
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from FieldMask where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoFlags' )
	DROP FUNCTION fPhotoFlags
GO
--
CREATE FUNCTION fPhotoFlags(@name varchar(40))
-------------------------------------------------------------
--/H Returns the PhotoFlags value corresponding to a name
-------------------------------------------------------------
--/T the photoFlags can be shown with Select * from PhotoFlags 
--/T <br>
--/T Sample call to find photo objects with saturated pixels is
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from photoObj 
--/T <br> where flags & dbo.fPhotoFlags('SATURATED') > 0 
--/T </samp> 
--/T <br> see also fPhotoDescription
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM PhotoFlags
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoFlagsN' )
	DROP FUNCTION fPhotoFlagsN
GO
--
CREATE FUNCTION fPhotoFlagsN(@value bigint)
---------------------------------------------------
--/H Returns the expanded PhotoFlags corresponding to the status value as a string
---------------------------------------------------
--/T the photoFlags can be shown with Select * from PhotoFlags 
--/T <br>
--/T Sample call to display the flags of some photoObjs
--/T <samp> 
--/T <br> select top 10 objID, dbo.fPhotoFlagsN(flags) as flags
--/T <br> from photoObj 
--/T </samp> 
--/T <br> see also fPhotoFlags
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=63;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from PhotoFlags where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoStatus' )
	DROP FUNCTION fPhotoStatus
GO
--
CREATE FUNCTION fPhotoStatus(@name varchar(40))
-------------------------------------------------------------
--/H Returns the PhotoStatus flag value corresponding to a name
-------------------------------------------------------------
--/T the photoStatus values can be shown with Select * from PhotoStatus 
--/T <br>
--/T Sample call to find "good" photo objects is
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from photoObj 
--/T <br> where status & dbo.fPhotoStatus('GOOD') > 0 
--/T </samp> 
--/T <br> see also fPhotoStatusN
-------------------------------------------------------------
RETURNS int
AS BEGIN
RETURN ( SELECT cast(value as int)
	FROM PhotoStatus
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoStatusN' )
	DROP FUNCTION fPhotoStatusN
GO
--
CREATE FUNCTION fPhotoStatusN(@value int)
---------------------------------------------------
--/H Returns the string describing to the status flags in words
---------------------------------------------------
--/T the photoStatus values can be shown with Select * from PhotoStatus  
--/T <br>
--/T Sample call to fPhotoStatusN: 
--/T <samp> 
--/T <br> select top 10 dbo.fPhotoStatusN(status) as status
--/T <br> from photoObj
--/T </samp> 
--/T <br> see also fPhotoStatus
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from PhotoStatus where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fCalibStatus' )
	DROP FUNCTION fCalibStatus
GO
--
CREATE FUNCTION fCalibStatus(@name varchar(40))
-------------------------------------------------------------
--/H Returns the CalibStatus flag value corresponding to a name
-------------------------------------------------------------
--/T The CalibStatus values can be shown with Select * from CalibStatus 
--/T <br>
--/T Sample call to find photometric objects is
--/T <samp> 
--/T <br> select top 10 modelMag_r 
--/T <br> from PhotoObj  
--/T <br> where 
--/T <br> <dd><dd>(calibStatus_r & dbo.fCalibStatus('PHOTOMETRIC') > 0) 
--/T </samp> 
--/T <br> see also fCalibStatusN
-------------------------------------------------------------
RETURNS int
AS BEGIN
RETURN ( SELECT cast(value as int)
	FROM CalibStatus
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fCalibStatusN' )
	DROP FUNCTION fCalibStatusN
GO
--
CREATE FUNCTION fCalibStatusN(@value smallint)
---------------------------------------------------
--/H Returns the string describing to the calibration status flags in words
---------------------------------------------------
--/T The CalibStatus values can be shown with Select * from CalibStatus  
--/T <br>
--/T Sample call to fCalibStatusN: 
--/T <samp> 
--/T <br> select top 10 dbo.fCalibStatusN(calibStatus_r) as calstatus_r
--/T <br> from PhotoObj
--/T </samp> 
--/T <br> see also fCalibStatus
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask smallint, @out varchar(2000);
    SET @bit=15;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(2,@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from CalibStatus where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'fInsideMask' )
	DROP FUNCTION fInsideMask
GO
--
CREATE FUNCTION fInsideMask(@name varchar(40))
-------------------------------------------------------------
--/H Returns the InsideMask value corresponding to a name
-------------------------------------------------------------
--/T The InsideMask values can be shown with Select * from InsideMask 
--/T <br>
--/T Sample call to find photo objects which are masked
--/T <samp> 
--/T <br> select top 10 objID, insideMask 
--/T <br> from PhotoObj 
--/T <br> where (dbo.fInsideMask('INMASK_BLEEDING') & insideMask) > 0 
--/T </samp> 
--/T <br> see also fInsideMaskN
-------------------------------------------------------------
RETURNS tinyint
AS BEGIN
RETURN ( SELECT cast(value as tinyInt)
	FROM InsideMask
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	WHERE  name = N'fInsideMaskN' )
	DROP FUNCTION fInsideMaskN
GO
--
CREATE FUNCTION fInsideMaskN(@value tinyint)
---------------------------------------------------
--/H Returns the expanded InsideMask corresponding to the bits, as a string
---------------------------------------------------
--/T the InsideMask can be shown with Select * from InsideMask
--/T <br>
--/T Sample call to display the insideMask setting of some photoObjs
--/T <samp> 
--/T <br> select top 10 objID, dbo.fInsideMaskN(insideMask) as mask
--/T <br> from PhotoObj 
--/T </samp> 
--/T <br> see also fInsideMask
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit tinyint, @mask tinyint, @out varchar(2000);
    SET @bit=7;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(2,@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from InsideMask where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fImageStatus' )
	DROP FUNCTION fImageStatus
GO
--
CREATE FUNCTION fImageStatus(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the ImageStatus flag value, indexed by name
-------------------------------------------------------------------------------
--/T the ImageStatus values can be shown with Select * from ImageStatus 
--/T <br>
--/T Sample call to fImageStatus
--/T <samp> 
--/T <br> select top 10 ???
--/T <br> from   ????? 
--/T <br> where  ??? = dbo.fImageStatus('SUBTRACTED')  
--/T </samp> 
--/T <br> see also fImageStatusN
-------------------------------------------------------------
RETURNS int
AS BEGIN
    RETURN ( SELECT cast(value as int)
	FROM ImageStatus
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fImageStatusN' )
	DROP FUNCTION fImageStatusN
GO
--
CREATE FUNCTION fImageStatusN(@value int)
-------------------------------------------------------------------------------
--/H Return the expanded ImageStatus corresponding to the flag value as a string
-------------------------------------------------------------------------------
--/T the ImageStatus values can be shown with Select * from ImageStatus 
--/T <br>
--/T Sample call to fImageStatusN
--/T <samp> 
--/T <br> select top 10 objID, dbo.fImageStatus(mask) as mask
--/T <br> from   ????? 
--/T </samp> 
--/T <br> see also fImageStatus 
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ImageStatus where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fResolveStatus' )
	DROP FUNCTION fResolveStatus
GO
--
CREATE FUNCTION fResolveStatus(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the ResolveStatus flag value, indexed by name
-------------------------------------------------------------------------------
--/T the ResolveStatus values can be shown with Select * from ResolveStatus 
--/T <br>
--/T Sample call to fResolveStatus
--/T <samp> 
--/T <br> select top 10 objID, dbo.fResolveStatusN(resolveStatus)
--/T <br> from   PhotoObj
--/T <br> where  resolveStatus & dbo.fResolveStatus('RUN_EDGE') > 0  
--/T </samp> 
--/T <br> see also fResolveStatusN
-------------------------------------------------------------
RETURNS int
AS BEGIN
    RETURN ( SELECT cast(value as int)
	FROM ResolveStatus
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fResolveStatusN' )
	DROP FUNCTION fResolveStatusN
GO
--
CREATE FUNCTION fResolveStatusN(@value int)
-------------------------------------------------------------------------------
--/H Return the expanded ResolveStatus corresponding to the flag value as a string
-------------------------------------------------------------------------------
--/T the ResolveStatus values can be shown with Select * from ResolveStatus 
--/T <br>
--/T Sample call to fResolveStatusN
--/T <samp> 
--/T <br> select top 10 objID, dbo.fResolveStatus(mask) as rstatus
--/T <br> from  PhotoObj
--/T </samp> 
--/T <br> see also fResolveStatus 
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ResolveStatus where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPrimTarget' )
	DROP FUNCTION fPrimTarget
GO
--
CREATE FUNCTION fPrimTarget(@name varchar(40))
-------------------------------------------------------------
--/H Returns the PrimTarget value corresponding to a name
-------------------------------------------------------------
--/T the photo and spectro primTarget flags can be shown with Select * from PrimTarget 
--/T <br>
--/T Sample call to find photo objects that are Galaxy primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from photoObj 
--/T <br> where primTarget & dbo.fPrimTarget('TARGET_GALAXY') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM PrimTarget
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPrimTargetN' )
DROP FUNCTION fPrimTargetN
GO
--
CREATE FUNCTION fPrimTargetN(@value bigint)
---------------------------------------------------
--/H Returns the expanded PrimTarget corresponding to the flag value as a string
---------------------------------------------------
--/T the photo and spectro primTarget flags can be shown with Select * from PrimTarget 
--/T <br>
--/T Sample call to show the target flags of some photoObjects is
--/T <samp> 
--/T <br> select top 10 objId, dbo.fPriTargetN(secTarget) as priTarget
--/T <br> from photoObj 
--/T </samp> 
--/T <br> see also fPrimTarget, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from PrimTarget where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSecTarget' )
DROP FUNCTION fSecTarget
GO
--
CREATE FUNCTION fSecTarget(@name varchar(40))
-------------------------------------------------------------
--/H Returns the SecTarget value corresponding to a name
-------------------------------------------------------------
--/T the photo and spectro secTarget flags can be shown with Select * from SecTarget 
--/T <br>
--/T Sample call to find photo objects that are Galaxy primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from photoObj 
--/T <br> where secTarget & dbo.fsecTarget('TARGET_SPECTROPHOTO_STD') > 0 
--/T </samp> 
--/T <br> see also fPrimTarget, fSecTargetN
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM SecTarget
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSecTargetN' )
	DROP FUNCTION fSecTargetN
GO
--
CREATE FUNCTION fSecTargetN(@value bigint)
---------------------------------------------------
--/H Returns the expanded SecTarget corresponding to the flag value as a string
---------------------------------------------------
--/T the photo and spectro secTarget flags can be shown with Select * from SecTarget 
--/T <br>
--/T Sample call to find photo objects that are Galaxy primary targets
--/T <samp> 
--/T <br> select top 10 objId, dbo.fSecTargetN(secTarget) as secTarget
--/T <br> from photoObj 
--/T </samp> 
--/T <br> see also fSecTarget, fPrimTarget
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from SecTarget where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecialTarget1' )
	DROP FUNCTION fSpecialTarget1
GO
--
CREATE FUNCTION fSpecialTarget1(@name varchar(40))
-------------------------------------------------------------
--/H Returns the SpecialTarget1 value corresponding to a name
-------------------------------------------------------------
--/T the spectro specialTarget1 flags can be shown with Select * from SpecialTarget1 
--/T <br>
--/T Sample call to find spec objects that are low-redshift galaxy special primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where specialTarget1 & dbo.fSpecialTarget1('LOWZ_GALAXY') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM SpecialTarget1
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecialTarget1N' )
DROP FUNCTION fSpecialTarget1N
GO
--
CREATE FUNCTION fSpecialTarget1N(@value bigint)
---------------------------------------------------
--/H Returns the expanded SpecialTarget1 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro specialTarget1 flags can be shown with Select * from SpecialTarget1 
--/T <br>
--/T Sample call to show the special target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fSpecialTarget1N(specialTarget1) as specialTarget1
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSpecialTarget1, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from SpecialTarget1 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecialTarget2' )
	DROP FUNCTION fSpecialTarget2
GO
--
CREATE FUNCTION fSpecialTarget2(@name varchar(40))
-------------------------------------------------------------
--/H Returns the SpecialTarget2 value corresponding to a name
-------------------------------------------------------------
--/T the spectro specialTarget2 flags can be shown with Select * from SpecialTarget2 
--/T <br>
--/T Sample call to find spec objects that are low-redshift galaxy special primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where specialTarget2 & dbo.fSpecialTarget2('GUIDE_STAR') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM SpecialTarget2
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecialTarget2N' )
DROP FUNCTION fSpecialTarget2N
GO
--
CREATE FUNCTION fSpecialTarget2N(@value bigint)
---------------------------------------------------
--/H Returns the expanded SpecialTarget2 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro specialTarget2 flags can be shown with Select * from SpecialTarget2 
--/T <br>
--/T Sample call to show the special target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fSpecialTarget2N(specialTarget2) as specialTarget2
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSpecialTarget2, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from SpecialTarget2 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fBossTarget1' )
	DROP FUNCTION fBossTarget1
GO
--
CREATE FUNCTION fBossTarget1(@name varchar(40))
-------------------------------------------------------------
--/H Returns the BossTarget1 value corresponding to a name
-------------------------------------------------------------
--/T the spectro specialTarget1 flags can be shown with Select * from BossTarget1 
--/T <br>
--/T Sample call to find spec objects that are low-redshift galaxy special primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where BossTarget1 & dbo.fBossTarget1('LOWZ_GALAXY') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM BossTarget1
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fBossTarget1N' )
DROP FUNCTION fBossTarget1N
GO
--
CREATE FUNCTION fBossTarget1N(@value bigint)
---------------------------------------------------
--/H Returns the expanded BossTarget1 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro BossTarget1 flags can be shown with Select * from BossTarget1 
--/T <br>
--/T Sample call to show the special target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fBossTarget1N(specialTarget1) as specialTarget1
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fBossTarget1, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=63;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from BossTarget1 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fAncillaryTarget1' )
	DROP FUNCTION fAncillaryTarget1
GO
--
CREATE FUNCTION fAncillaryTarget1(@name varchar(40))
-------------------------------------------------------------
--/H Returns the AncillaryTarget1 value corresponding to a name
-------------------------------------------------------------
--/T the spectro ancillaryTarget1 flags can be shown with Select * from AncillaryTarget1 
--/T <br>
--/T Sample call to find spec objects that are low-redshift galaxy ancillary primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where ancillary_target1 & dbo.fAncillaryTarget1('LOWZ_GALAXY') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM AncillaryTarget1
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fAncillaryTarget1N' )
DROP FUNCTION fAncillaryTarget1N
GO
--
CREATE FUNCTION fAncillaryTarget1N(@value bigint)
---------------------------------------------------
--/H Returns the expanded AncillaryTarget1 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro ancillaryTarget1 flags can be shown with Select * from AncillaryTarget1 
--/T <br>
--/T Sample call to show the ancillary target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fAncillaryTarget1N(ancillary_target1) as ancillaryTarget1
--/T <br> from specObj 
--/T <br> where ancillary_target1 > 0
--/T </samp> 
--/T <br> see also fAncillaryTarget1, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from AncillaryTarget1 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fAncillaryTarget2' )
	DROP FUNCTION fAncillaryTarget2
GO
--
CREATE FUNCTION fAncillaryTarget2(@name varchar(40))
-------------------------------------------------------------
--/H Returns the AncillaryTarget2 value corresponding to a name
-------------------------------------------------------------
--/T the spectro ancillaryTarget2 flags can be shown with Select * from AncillaryTarget2 
--/T <br>
--/T Sample call to find high-z quasar candidate spec objects that are BOSS ancillary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where ancillary_target2 & dbo.fAncillaryTarget2('HIZQSOIR') > 0 
--/T </samp> 
--/T <br> see also fAncillaryTarget1
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM AncillaryTarget2
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fAncillaryTarget2N' )
DROP FUNCTION fAncillaryTarget2N
GO
--
CREATE FUNCTION fAncillaryTarget2N(@value bigint)
---------------------------------------------------
--/H Returns the expanded AncillaryTarget2 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro ancillaryTarget2 flags can be shown with Select * from AncillaryTarget2 
--/T <br>
--/T Sample call to show the ancillary target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fAncillaryTarget2N(ancillary_target2) as ancillaryTarget2
--/T <br> from specObj 
--/T <br> where ancillary_target2 > 0
--/T </samp> 
--/T <br> see also fAncillaryTarget2, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from AncillaryTarget2 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue1Target1' )
	DROP FUNCTION fSegue1Target1
GO
--
CREATE FUNCTION fSegue1Target1(@name varchar(40))
-------------------------------------------------------------
--/H Returns the Segue1Target1 value corresponding to a name
-------------------------------------------------------------
--/T the spectro Segue1Target1 flags can be shown with Select * from Segue1Target1 
--/T <br>
--/T Sample call to find spec objects that are cool white dwarf Segue1 primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where Segue1Target1 & dbo.fSegue1Target1('SEGUE1_CWD') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM Segue1Target1
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue1Target1N' )
DROP FUNCTION fSegue1Target1N
GO
--
CREATE FUNCTION fSegue1Target1N(@value bigint)
---------------------------------------------------
--/H Returns the expanded Segue1Target1 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro Segue1Target1 flags can be shown with Select * from Segue1Target1 
--/T <br>
--/T Sample call to show the Segue1 target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fSegue1Target1N(Segue1Target1) as Segue1Target1
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSegue1Target1, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from Segue1Target1 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue2Target1' )
	DROP FUNCTION fSegue2Target1
GO
--
CREATE FUNCTION fSegue2Target1(@name varchar(40))
-------------------------------------------------------------
--/H Returns the Segue2Target1 value corresponding to a name
-------------------------------------------------------------
--/T the spectro Segue2Target1 flags can be shown with Select * from Segue2Target1 
--/T <br>
--/T Sample call to find spec objects that are red K-giant star SEGUE-2 primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where Segue2Target1 & dbo.fSegue2Target1('SEGUE2_REDKG') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM Segue2Target1
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue2Target1N' )
DROP FUNCTION fSegue2Target1N
GO
--
CREATE FUNCTION fSegue2Target1N(@value bigint)
---------------------------------------------------
--/H Returns the expanded Segue2Target1 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro Segue2Target1 flags can be shown with Select * from Segue2Target1 
--/T <br>
--/T Sample call to show the SEGUE-2 target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fSegue2Target1N(Segue2Target1) as segue2Target1
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSegue2Target1, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from Segue2Target1 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue1Target2' )
	DROP FUNCTION fSegue1Target2
GO
--
CREATE FUNCTION fSegue1Target2(@name varchar(40))
-------------------------------------------------------------
--/H Returns the Segue1Target2 value corresponding to a name
-------------------------------------------------------------
--/T the spectro Segue1Target2 flags can be shown with Select * from Segue1Target2 
--/T <br>
--/T Sample call to find spec objects that are cool white dwarf Segue1 primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where Segue1Target2 & dbo.fSegue1Target2('SEGUE1_REDDENING') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM Segue1Target2
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue1Target2N' )
DROP FUNCTION fSegue1Target2N
GO
--
CREATE FUNCTION fSegue1Target2N(@value bigint)
---------------------------------------------------
--/H Returns the expanded Segue1Target2 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro Segue1Target2 flags can be shown with Select * from Segue1Target2 
--/T <br>
--/T Sample call to show the Segue1 target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fSegue1Target2N(Segue1Target2) as Segue1Target2
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSegue1Target2, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from Segue1Target2 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue2Target2' )
	DROP FUNCTION fSegue2Target2
GO
--
CREATE FUNCTION fSegue2Target2(@name varchar(40))
-------------------------------------------------------------
--/H Returns the Segue2Target2 value corresponding to a name
-------------------------------------------------------------
--/T the spectro Segue2Target2 flags can be shown with Select * from Segue2Target2 
--/T <br>
--/T Sample call to find spec objects that are red K-giant star SEGUE-2 primary targets
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where Segue2Target2 & dbo.fSegue2Target2('SEGUE2_REDDENING') > 0 
--/T </samp> 
--/T <br> see also fSecTarget
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM Segue2Target2
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSegue2Target2N' )
DROP FUNCTION fSegue2Target2N
GO
--
CREATE FUNCTION fSegue2Target2N(@value bigint)
---------------------------------------------------
--/H Returns the expanded Segue2Target2 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro Segue2Target2 flags can be shown with Select * from Segue2Target2 
--/T <br>
--/T Sample call to show the SEGUE-2 target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fSegue2Target2N(Segue2Target2) as segue2Target2
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSegue2Target2, fSecTargetN
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from Segue2Target2 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeTarget1' )
	DROP FUNCTION fApogeeTarget1
GO
--
CREATE FUNCTION fApogeeTarget1(@name varchar(40))
-------------------------------------------------------------
--/H Returns the ApogeeTarget1 value corresponding to a name
-------------------------------------------------------------
--/T the spectro apogeeTarget1 flags can be shown with Select * from ApogeeTarget1 
--/T <br>
--/T Sample call to find APOGEE extended objects
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from apogeeStar 
--/T <br> where apogee_target1 & dbo.fApogeeTarget1('APOGEE_EXTENDED') > 0 
--/T </samp> 
--/T <br> see also fApogeeTarget1N. fApogeeTarget2
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM ApogeeTarget1
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeTarget1N' )
DROP FUNCTION fApogeeTarget1N
GO
--
CREATE FUNCTION fApogeeTarget1N(@value bigint)
---------------------------------------------------
--/H Returns the expanded ApogeeTarget1 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro apogeeTarget1 flags can be shown with Select * from ApogeeTarget1 
--/T <br>
--/T Sample call to show the apogee target flags of some APOGEE objects is
--/T <samp> 
--/T <br> select top 10 apogee_id, dbo.fApogeeTarget1N(apogee_target1) as apogeeTarget1
--/T <br> from apogeeVisit
--/T </samp> 
--/T <br> see also fApogeeTarget1, fApogeeTarget2
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ApogeeTarget1 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeTarget2' )
	DROP FUNCTION fApogeeTarget2
GO
--
CREATE FUNCTION fApogeeTarget2(@name varchar(40))
-------------------------------------------------------------
--/H Returns the ApogeeTarget2 value corresponding to a name
-------------------------------------------------------------
--/T the spectro ApogeeTarget2 flags can be shown with Select * from ApogeeTarget2 
--/T <br>
--/T Sample call to find radial velocity standard apogee spectra
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from apogeeStar
--/T <br> where apogee_target2 & dbo.fApogeeTarget2('APOGEE_RV_STANDARD') > 0 
--/T </samp> 
--/T <br> see also fApogeeTarget2N, fApogeeTarget1
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM ApogeeTarget2
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeTarget2N' )
DROP FUNCTION fApogeeTarget2N
GO
--
CREATE FUNCTION fApogeeTarget2N(@value bigint)
---------------------------------------------------
--/H Returns the expanded ApogeeTarget2 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro apogeeTarget2 flags can be shown with Select * from ApogeeTarget2 
--/T <br>
--/T Sample call to show the apogee target flags of some APOGEEobjects is
--/T <samp> 
--/T <br> select top 10 aogee_id, dbo.fApogeeTarget2N(apogee_target2) as apogeeTarget2
--/T <br> from apogeeVisit
--/T </samp> 
--/T <br> see also fApogeeTarget2, fApogeeTarget1N
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ApogeeTarget2 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--



--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeStarFlag' )
	DROP FUNCTION fApogeeStarFlag
GO
--
CREATE FUNCTION fApogeeStarFlag(@name varchar(40))
-------------------------------------------------------------
--/H Returns the ApogeeStarFlag value corresponding to a name
-------------------------------------------------------------
--/T the spectro ApogeeStarFlag flags can be shown with Select * from ApogeeStarFlag 
--/T <br>
--/T Sample call to find APOGEE 
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from apogeeStar
--/T <br> where starFlag & dbo.fApogeeStarFlag('LOW_SNR') > 0 
--/T </samp> 
--/T <br> see also fApogeeTarget1
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM ApogeeStarFlag
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeStarFlagN' )
DROP FUNCTION fApogeeStarFlagN
GO
--
CREATE FUNCTION fApogeeStarFlagN(@value bigint)
---------------------------------------------------
--/H Returns the expanded ApogeeStarFlag corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro apogeeTarget2 flags can be shown with Select * from ApogeeStarFlag 
--/T <br>
--/T Sample call to show the apogee target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 apstar_id, dbo.fApogeeStarFlagN(apogee_starflag) as apogeeStarFlag
--/T <br> from apogeeStar
--/T </samp> 
--/T <br> see also fApogeeStarFlag, fApogeeTarget1N
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ApogeeStarFlag where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeAspcapFlag' )
	DROP FUNCTION fApogeeAspcapFlag
GO
--
CREATE FUNCTION fApogeeAspcapFlag(@name varchar(40))
-------------------------------------------------------------
--/H Returns the ApogeeAspcapFlag value corresponding to a name
-------------------------------------------------------------
--/T the spectro ApogeeAspcapFlag flags can be shown with Select * from ApogeeAspcapFlag 
--/T <br>
--/T Sample call to find APOGEE 
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from aspcapStar
--/T <br> where ApogeeAspcapFlag & dbo.fApogeeAspcapFlag('CHI2_BAD') > 0 
--/T </samp> 
--/T <br> see also fApogeeTarget1
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM ApogeeAspcapFlag
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeAspcapFlagN' )
DROP FUNCTION fApogeeAspcapFlagN
GO
--
CREATE FUNCTION fApogeeAspcapFlagN(@value bigint)
---------------------------------------------------
--/H Returns the expanded ApogeeAspcapFlag corresponding to the flag value as a string
---------------------------------------------------
--/T The APOGEE ASPCAP flags can be shown with Select * from ApogeeAspcapFlag 
--/T <br>
--/T Sample call to show the APOGEE ASPCAP flags of some APOGEE objects is
--/T <samp> 
--/T <br> select top 10 apstar_id, dbo.fApogeeAspcapFlagN(aspcap_flag) as apogeeAspcapFLag
--/T <br> from aspcapStar
--/T </samp> 
--/T <br> see also fApogeeAspcapFlag, fApogeeTarget1N
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ApogeeAspcapFlag where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeParamFlag' )
	DROP FUNCTION fApogeeParamFlag
GO
--
CREATE FUNCTION fApogeeParamFlag(@name varchar(40))
-------------------------------------------------------------
--/H Returns the ApogeeParamFlag value corresponding to a name
-------------------------------------------------------------
--/T The spectro ApogeeParamFlag flags can be shown with Select * from ApogeeParamFlag 
--/T <br>
--/T Sample call to find APOGEE aspcapStar objects with one of the parameters
--/T (alpha_m) might have unreliable calibration:
--/T <samp> 
--/T <br> select top 10 apStar_id, dbo.fApogeeParamFlagN(alpha_m_flag) as flags
--/T <br> from aspcapStar
--/T <br> where alpha_m_flag & dbo.fApogeeParamFlag('CALRANGE_WARN') > 0 
--/T </samp> 
--/T <br> see also fApogeeParamFlagN
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM ApogeeParamFlag
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeParamFlagN' )
DROP FUNCTION fApogeeParamFlagN
GO
--
CREATE FUNCTION fApogeeParamFlagN(@value int)
---------------------------------------------------
--/H Returns the expanded ApogeeParamFlag names corresponding to the flag
--/H value as a string
---------------------------------------------------
--/T The spectro ApogeeParamFlag flags can be shown with Select * from ApogeeParamFlag 
--/T <br>
--/T Sample call to show the param flags of aspcapStar objects:
--/T <samp> 
--/T <br> select top 10 apstar_id, dbo.fApogeeParamFlagN(alpha_m_flag) as a
--/T <br> from aspcapStar
--/T </samp> 
--/T <br> see also fApogeeParamFlag
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ApogeeParamFlag where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeExtraTarg' )
	DROP FUNCTION fApogeeExtraTarg
GO
--
CREATE FUNCTION fApogeeExtraTarg(@name varchar(40))
-------------------------------------------------------------
--/H Returns the ApogeeExtraTarg value corresponding to a name
-------------------------------------------------------------
--/T the spectro ApogeeExtraTarg flags can be shown with Select * from ApogeeExtraTarg 
--/T <br>
--/T Sample call to find APOGEE 
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from apogeeVisit
--/T <br> where extraTarg & dbo.fApogeeExtraTarg('TELLURIC') > 0 
--/T </samp> 
--/T <br> see also fApogeeExtraTargN, fApogeeTarget1
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM ApogeeExtraTarg
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fApogeeExtraTargN' )
DROP FUNCTION fApogeeExtraTargN
GO
--
CREATE FUNCTION fApogeeExtraTargN(@value int)
---------------------------------------------------
--/H Returns the expanded ApogeeExtraTarg corresponding to the flag value as a string
---------------------------------------------------
--/T The APOGEE extraTarg flags can be shown with Select * from ApogeeExtraTarg 
--/T <br>
--/T Sample call to show the apogee target flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 visit_id, dbo.fApogeeExtraTargN(extraTarg) as apogeeTarget2
--/T <br> from apogeeVisit
--/T </samp> 
--/T <br> see also fApogeeExtraTarg, fApogeeTarget1N
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from ApogeeExtraTarg where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fEbossTarget0' )
	DROP FUNCTION fEbossTarget0
GO
--
CREATE FUNCTION fEbossTarget0(@name varchar(40))
-------------------------------------------------------------
--/H Returns the EbossTarget0 value corresponding to a name
-------------------------------------------------------------
--/T the spectro EbossTarget0 flags can be shown with Select * from EbossTarget0 
--/T <br>
--/T Sample call to find spec objects that are known QSOs from previous surveys is
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from specObj 
--/T <br> where eboss_target0 & dbo.fEbossTarget0('QSO_KNOWN') > 0 
--/T </samp> 
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM EbossTarget0
	WHERE name = UPPER(@name)
	)
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fEbossTarget0N' )
DROP FUNCTION fEbossTarget0N
GO
--
CREATE FUNCTION fEbossTarget0N(@value bigint)
---------------------------------------------------
--/H Returns the expanded EbossTarget0 corresponding to the flag value as a string
---------------------------------------------------
--/T The spectro EbossTarget0 flags can be shown with Select * from EbossTarget0 
--/T <br>
--/T Sample call to show the EBOSS target0 flags of some spec objects is
--/T <samp> 
--/T <br> select top 10 specObjId, dbo.fEbossTarget0N(eboss_target0) as EbossTarget0
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fEbossTarget0
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=63;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from EbossTarget0 where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecZWarning' )
	DROP FUNCTION fSpecZWarning
GO
--
CREATE FUNCTION fSpecZWarning(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the SpecZWarning value, indexed by name
-------------------------------------------------------------------------------
--/T the specZWarning values can be shown with Select * from SpecZWarning 
--/T <br>
--/T Sample call to find spec objects that do not have warnings
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from   specObj 
--/T <br> where  zWarning = dbo.fSpecZWarning('OK')  
--/T </samp> 
--/T <br> see also fSpecZWarningN
-------------------------------------------------------------
RETURNS INT AS BEGIN
    RETURN ( SELECT cast(value as int)
	FROM SpecZWarning
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecZWarningN' )
	DROP FUNCTION fSpecZWarningN
GO
--
CREATE FUNCTION fSpecZWarningN(@value int)
-------------------------------------------------------------------------------
--/H Return the expanded SpecZWarning corresponding to the flag value as a string
-------------------------------------------------------------------------------
--/T the specZWarning values can be shown with Select * from SpecZWarning 
--/T <br>
--/T Sample call to find the warnings of some Spec objects   
--/T <samp> 
--/T <br> select top 10 objID,  dbo.fSpecZWarningN(zWarning) as warning
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSpecZWarning
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    IF @value IS NULL
	RETURN 'NULL';
    IF @value = 0
	RETURN 'OK';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from SpecZWarning where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecPixMask' )
	DROP FUNCTION fSpecPixMask
GO
--
CREATE FUNCTION fSpecPixMask(@name varchar(40))
-------------------------------------------------------------------------------
--/H Return the SpecPixMask value, indexed by name
-------------------------------------------------------------------------------
--/T the specPixMask values can be shown with Select * from SpecPixMask 
--/T <br>
--/T Sample call to find spec objects that do not have any pixel with a bit set in its ANDMASK.
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from   specObj 
--/T <br> where  anyAndMask = dbo.fSpecPixMask('OK')  
--/T </samp> 
--/T <br> see also fSpecPixMaskN
-------------------------------------------------------------
RETURNS INT AS BEGIN
    RETURN ( SELECT cast(value as int)
	FROM SpecPixMask
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecPixMaskN' )
	DROP FUNCTION fSpecPixMaskN
GO
--
CREATE FUNCTION fSpecPixMaskN(@value int)
-------------------------------------------------------------------------------
--/H Return the expanded SpecPixMask corresponding to the flag value as a string
-------------------------------------------------------------------------------
--/T the specPixMask values can be shown with Select * from SpecPixMask 
--/T <br>
--/T Sample call to find which pixels have bits set in the ORMASK of some Spec objects   
--/T <samp> 
--/T <br> select top 10 objID,  dbo.fSpecPixMaskN(anyOrMask) as warning
--/T <br> from specObj 
--/T </samp> 
--/T <br> see also fSpecPixMask
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    IF @value IS NULL
	RETURN 'NULL';
    IF @value = 0
	RETURN 'OK';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from SpecPixMask where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fTiMask' )
	DROP FUNCTION fTiMask
GO
--
CREATE FUNCTION fTiMask(@name varchar(40))
-------------------------------------------------------------
--/H Returns the TiMask value corresponding to a name
-------------------------------------------------------------
--/T the TiMask values can be found with 
--/T <br>       Select * from TiMask
--/T <br>
--/T Sample call to fTiMask.
--/T <samp> 
--/T <br> select top 10  *
--/T <br> from TilingInfo
--/T <br> where tiMask = dbo.fTiMask('AR_TMASK_TILED')
--/T </samp> 
--/T <br> see also fTiMaskN
-------------------------------------------------------------
RETURNS int
AS BEGIN
RETURN ( SELECT cast(value as int)
	FROM TiMask
	WHERE name = UPPER(@name)
	)
END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fTiMaskN' )
	DROP FUNCTION fTiMaskN
GO
--
CREATE FUNCTION fTiMaskN(@value int)
---------------------------------------------------
--/H Returns the expanded TiMask corresponding to the flag value as a string
---------------------------------------------------
--/T the TiMask values can be found with 
--/T <br>       Select * from TiMask
--/T <br>
--/T Sample call to fTiMaskN.
--/T <samp> 
--/T <br> select top 10 dbo.fTiMaskN(tiMask) as tiMask
--/T <br> from TilingInfo
--/T </samp> 
--/T <br> see also fTiMask
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=32;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from TiMask where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO
--



--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSdssVBossTarget0' )
	DROP FUNCTION fSdssVBossTarget0
GO
--
CREATE FUNCTION fSdssVBossTarget0(@name varchar(40))
-------------------------------------------------------------
--/H Returns the sdssvBossTarget0 value corresponding to a name
-------------------------------------------------------------
--/T the sdssvBossTarget0 values can be shown with Select * from sdssvBossTarget0
--/T <br>
--/T Sample call to find photo objects with saturated pixels is
--/T <samp> 
--/T <br> select top 10 * 
--/T <br> from spAll 
--/T <br> where sdssv_boss_target0 & dbo.fSdssVBossTarget0('OPS_STD_BOSS') > 0 
--/T </samp> 
--/T <br> see also fSdssVBossTarget0N
-------------------------------------------------------------
RETURNS bigint
AS BEGIN
RETURN ( SELECT cast(value as bigint)
	FROM sdssvBossTarget0
	WHERE name = UPPER(@name)
	)
END
GO




--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSdssVBossTarget0N' )
	DROP FUNCTION fSdssVBossTarget0N
GO
--
CREATE FUNCTION fSdssVBossTarget0N(@value bigint)
---------------------------------------------------
--/H Returns the expanded sdssvBossTarget0 corresponding to the status value as a string
---------------------------------------------------
--/T the photoFlags can be shown with Select * from sdssvBossTarget0 
--/T <br>
--/T Sample call to display the flags of some photoObjs
--/T <samp> 
--/T <br> select top 10 objID, dbo.fSdssVBossTarget0N(sdssv_boss_target0) as targetflags
--/T <br> from spAll 
--/T </samp> 
--/T <br> see also fSdssVBossTarget0
-------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
    DECLARE @bit int, @mask bigint, @out varchar(2000);
    SET @bit=63;
    SET @out ='';
    WHILE (@bit>0)
	BEGIN
	    SET @bit = @bit-1;
	    SET @mask = power(cast(2 as bigint),@bit);
	    SET @out = @out + (CASE 
		WHEN (@mask & @value)=0 THEN '' 
		ELSE coalesce((select name from PhotoFlags where value=@mask),'')+' '
	    	END);
	END
    RETURN @out;
END
GO







IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fPhotoDescription' )
	DROP FUNCTION fPhotoDescription
GO
--
CREATE FUNCTION fPhotoDescription(@ObjectID bigint)
-------------------------------------------------------------------------------
--/H Returns a string indicating Object type and object flags
-------------------------------------------------------------------------------
--/T <PRE> select top 10 dbo.fPhotoDescription(objID) from PhotoObj </PRE>
-------------------------------------------------------------------------------
RETURNS varchar(1000)
BEGIN
	DECLARE @itStatus bigint;
	DECLARE @itFlags bigint ;
	--
	SET @itStatus = (SELECT resolveStatus FROM PhotoObjAll WHERE [objID] = @ObjectID);
	SET @itFlags  = (SELECT  flags FROM PhotoObjAll WHERE [objID] = @ObjectID); 
	RETURN 	(select dbo.fPhotoStatusN(@itSTatus)) +'| '
		+(select dbo.fPhotoFlagsN(@itFlags))+'|';
	END
GO
--


--===========================================
IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fSpecDescription' )
	DROP FUNCTION fSpecDescription
GO
--
CREATE FUNCTION fSpecDescription(@specObjID bigint)
-------------------------------------------------------------------------------
--/H Returns a string indicating class, status and zWarning for a specObj
-------------------------------------------------------------------------------
--/T <PRE> select top 10 dbo.fSpecDescription(specObjID) from SpecObjAll </PRE>
-------------------------------------------------------------------------------
--- fix by Jim: convert to fSpecZWarningN, fSpecPixMaskN so get strings out.
RETURNS varchar(1000)
BEGIN
	DECLARE @itClass varchar(32), @itZWarning int, @itAnyAndMask int, @itAnyOrMask int;
	--
	SET @itClass  = (SELECT class  FROM SpecObjAll WHERE specObjId=@specObjId);
	SET @itZWarning  = (SELECT zWarning  FROM SpecObjAll WHERE specObjId=@specObjId);
	SET @itAnyAndMask = (SELECT anyAndMask  FROM SpecObjAll WHERE specObjId=@specObjId);
	SET @itAnyOrMask = (SELECT anyOrMask  FROM SpecObjAll WHERE specObjId=@specObjId);
	RETURN 	(select @itClass) +'| '
		+(select dbo.fSpecZWarningN(@itZWarning))+'|'
		+(select dbo.fSpecPixMaskN(@itAnyAndMask))+'|'
		+(select dbo.fSpecPixMaskN(@itAnyOrMask))+'|';
	END
GO
--

PRINT '[ConstantSupport.sql]: Constant support views and functions created'
GO
