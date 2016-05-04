--==========================================================================================
-- spSetValues.sql
-- 2002-11-10	Alex Szalay
--------------------------------------------------------------------------------------------
-- sets and updates column values after the bulk loading
--------------------------------------------------------------------------------------------
-- History:
--* 2002-11-29	Alex: split off loadversion updates to simplify
--* 2002-12-10	Alex: removed TiledTarget patch
--* 2002-12-10	Alex: removed chunkid patch
--* 2002-12-10	Alex: removed ObjMask patch
--* 2002-12-10	Alex: added test for TargetInfo.targetobjid=0
--* 2003-05-05  Ani: Changed "reddening" to "extinction" for dered values,
--*		     as per PR #5277.
--* 2003-05-15 Alex: Changed PhotoObj-> PhotoObjAll
--* 2003-06-03 Alex: Changed count(*) to count_big(*), and @@rowcount 
--*                  to rowcount_big()
--* 2003-06-13 Adrian: added spTargetInfoTargetObjID 
--* 2003-07-17 Ani: Fixed bug in call to spTargetInfoTargetObjID (PR #5491)
--*              - procedure was being called without params taskid and stepid
--* 2003-07-17 Ani: Fixed bug in spTargetInfoTargetObjID (PR #5492),
--*		join on PhotoTag replaced with PhotoObjAll, because
--*             PhotoTag has not been created at this point
--* 2003-08-15 Ani: Fixed tiling table names as per PRs #5561 and 5565:
--*             Tile -> TileAll
--*             TiledTarget -> TiledTargetAll
--*             TileRegion -> TilingRun
--*             TileBoundary -> TilingGeometry
--*             TileInfo -> TilingInfo
--* 2004-08-27 Alex: added spFillMaskedObject and spSetInsideMask
--* 2004-08-30 Alex+Ani: moved spFillMaskedObject into spSetValues
--* 2004-11-11 Alex: repointed spNewPhase, spStartStep and spEndStep to 
--*                  local wrappers
--* 2004-11-14 Jim: added spSectorFillBest2Sector 
--* 2004-11-22 Alex: changed flag to 32 in spFillMaskedObject for PhotoObjAll.
--* 2004-12-03 Alex+Jim: changed spFillMaskedObject to take only those
--*		PhotoObj which are in the same field as the Mask. Also left
--*		maskType in MaskedObject as it is an Mask, and only 
--*             raise to 2^m in spSetInsideMask.
--* 2004-12-09 Jim+Alex: set the test in spFillMaskedObject to be == 
--*                      pattern, not != pattern
--* 2005-01-06 Ani: Added creation of PhotoObjAll.htmID index to
--*                 spFillMaskedObject to speed it up.
--* 2005-02-04 Alex: Updated spSectorFillBest2Sector 
--* 2005-04-15 Jim: removed comment on 	DROP TABLE BestTargetTable in
--*            spSectorFillBestToSector
--* 2005-05-17 Alex: moved spSectorFillBestToSector to spSector.sql
--* 2005-09-13 Ani: Fixed bugs in spSetInsideMask as per Tamas and Jim's
--*            changes (PR #6609).
--* 2007-04-18 Ani: Added code to spSetValues to set RA,dec errors and 
--*            galactic coordinates (PR #7267).
--* 2007-08-17 Ani: Fixed bug in call to fRegionGetObjectsFromString, it
--*            has a column called 'id' now, not 'objID' (PR #7365).
--* 2007-12-13 Svetlana: added option (maxdop 1) for UPDATE-stmt in 
--*            spSetInsideMask.
--* 2007-12-19 Ani: Fixed call to fRegionGetObjectsFromString in 
--*            spFillMaskedObject to add "J2000" to area string (fix for
--*            PR #7458).
--* 2008-08-06 Ani: Added spSetPhotoClean to set clean flag value in Photo
--*            tables (PR #7401).
--* 2008-09-18 Ani: Moved ra/dec error computation to new SP spComputeRaDecErr.
--* 2009-05-05 Ani: Removed spComputeRaDecErr for SDSS-III and removed 
--*                 references to nonexistent tables in spLoadVersion.
--* 2009-07-10 Ani: Added computation of PhotoObjAll htmID to spSetValues. 
--* 2009-08-12 Ani: Updated names of tiling tables for SDSS-III.
--* 2009-10-30 Ani: Added cases to spSetValues for plates and sspp.
--* 2009-11-10 Ani: Commented out ugriz and Err_ugriz code in the simplified
--*                 magnitudes section of spSetValues.  Updated log messages.
--* 2009-12-23 Ani: Removed code to set sppLines.specObjId and
--*                 sppParams.specObjId for sspp.
--* 2010-01-13 Victor: Updated Table name 'ObjMask' to 'AtlasOutline'
--* 2010-08-03 Ani: Removed sppTargets.objID setting from spSetValues.
--* 2010-11-10 Naren: Removed cast of AtlasOutline.span to varchar(1000) in
--*                  spSetValues - it is varchar(max) now.
--* 2010-11-22 Ani: Removed reference to HoleObj in spSetLoadversion.
--* 2010-12-23 Ani: Added PlateX.htmid setting to spSetValues.
--* 2012-06-05 Ani: Removed PhotoTag update and added Mask.htmID update
--*            to spSetInsideMask.
--* 2012-06-05 Ani: Moved Mask.htmID update to start of spSetInsideMask,
--*            and replaced cursor in spFillMaskedObject with CROSS APPLY.
--* 2012-06-05 Ani: Added Mask index drop/rebuild to spSetInsideMask.
--* 2012-06-05 Ani: Streamlined spSetInsideMask and removed outdated code.
--* 2012-06-06 Ani: Fixed typo in spSetInsideMask PhotoObjAll update query.
--* 2013-04-25 Ani: Added code to spSetValues to set apogeeStar.htmID.
--* 2013-10-18 Ani: Changed HTM computation for SpecObjAll to be done on
--*                 equatorial coordinates rather than Cartesian, because
--*                 the latter can be 0 for a small fraction of spectra.
--* 2016-04-26 Ani: Added code to spSetValues to set mangaDrpAll.htmID.
--------------------------------------------------------------------------
SET NOCOUNT ON;
GO

--==================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spFillMaskedObject]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spFillMaskedObject]
GO
--
CREATE PROCEDURE spFillMaskedObject(@taskid int, @stepid int)
------------------------------------------------
--/H Fills the MaskedObject table 
--/A -------------------------------------------
--/T Will loop through the Mask table, and
--/T for each mask with type<4 or seeing>1.7
--/T in the r filter will find all objects in
--/T PhotoObjAll that are inside a mask. These
--/T are inserted into the MaskedObject table.
------------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    DECLARE
	@maskid bigint,
	@count bigint, 
	@type int,
	@htmIndex int,
	@pattern bigint,
	@msg varchar(8000), 
	@area varchar(8000);
    --
    EXEC spIndexDropSelection @taskid, @stepid, 'F', 'MaskedObject';
    SELECT @htmIndex = indexmapid
	FROM IndexMap
	WHERE tablename='PhotoObjAll' AND fieldlist like 'htmID,cx%'
    EXEC spIndexCreate @taskid, @stepid, @htmIndex;
    --
    TRUNCATE TABLE MaskedObject
    --
    SET @count = 0;
    SET @pattern = ~cast(0x000000001000FFFF as bigint) 
    --
    --------------------------------
    -- get objects from PhotoPrimary and secondary,
    -- but only from those fields which contain the mask
    --------------------------------
    SET @count=@count+1;
    -- 
    INSERT MaskedObject
	SELECT p.id as objid, m.maskID, m.type as maskType
	FROM Mask m CROSS APPLY dbo.fRegionGetObjectsFromString(area,32,0.0) p
	WHERE (m.type in (0,1,2,3) or (m.type=4 and m.filter=2 and m.seeing>1.7))
		AND (m.maskid&@pattern) = (p.id&@pattern) 
    SET @count = @@ROWCOUNT

    ----------------------------------
    -- add diagnostic message
    ----------------------------------
    IF @@error<>0
    BEGIN
	SET @msg = 'Error in spFillMaskedObject'
	EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
	RETURN(1);
    END
    --------------------
    -- write phase log
    --------------------
    SET @msg = CAST(@count as varchar(10)) + ' masks loaded into MaskedObject'
    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', @msg;
    --
    RETURN(0);
END
GO


--=================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetInsideMask]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spSetInsideMask]
GO
--
CREATE PROCEDURE spSetInsideMask (@taskid int, @stepid int, @mode int)
------------------------------------------------
--/H Update the insideMask value in Photo tables
--/A -------------------------------------------
--/T @mode=0  -- run on the TaskDB
--/T @mode>0  -- run it on the whole PubDB, also update PhotoTag
------------------------------------------------
AS BEGIN
   SET NOCOUNT ON;
    DECLARE 
	@maxid  bigint,
	@count bigint, 
	@total bigint,
	@msg varchar(8000);

    -------------------------------------------------------
    -- Set the htmID column in Mask table first.
    -------------------------------------------------------
    IF @mode>0
	BEGIN
	    EXEC spIndexDropSelection @taskid, @stepid, 'I', 'Mask'
	    BEGIN TRANSACTION
		UPDATE Mask
		  SET htmID = dbo.fHtmXyz( cx, cy, cz )	    
	    COMMIT TRANSACTION
	    EXEC spIndexBuildSelection @taskid, @stepid, 'I', 'Mask'
	END
    SET @msg = 'Mask.htmID updated'
    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', @msg;

    -------------------------------------------------------
    -- build a distinct list of objid's into a temp table
    -------------------------------------------------------
    SELECT distinct objid, cast(0 as int) insideMask
	INTO #maskedObj
	FROM MaskedObject
    ----------------------------------------------
    -- then build the logical or of the maskTypes
    ----------------------------------------------
    -- update mask type 0...3 (Everything but seeing)
    UPDATE #maskedObj
	SET insideMask = insideMask | power(2,0) 
        FROM #maskedObj t JOIN MaskedObject m ON t.objid=m.objid
	WHERE m.maskType=0

    UPDATE #maskedObj
	SET insideMask = insideMask | power(2,1) 
        FROM #maskedObj t JOIN MaskedObject m ON t.objid=m.objid
	WHERE m.maskType=1

    UPDATE #maskedObj
	SET insideMask = insideMask | power(2,2) 
        FROM #maskedObj t JOIN MaskedObject m ON t.objid=m.objid
	WHERE m.maskType=2

    UPDATE #maskedObj
	SET insideMask = insideMask | power(2,3) 
        FROM #maskedObj t JOIN MaskedObject m ON t.objid=m.objid
	WHERE m.maskType=3

    -- poor seeing masks (r band seeing>1.7)
    UPDATE #maskedObj
	SET insideMask = insideMask | power(2,4) 
        FROM #maskedObj t, MaskedObject mo, Mask m
	WHERE t.objid=mo.objid and mo.maskid=m.maskid
		and m.type=4 and m.filter=2 and m.seeing>1.7
    -- bad seeing masks (r band seeing>2.0)
    UPDATE #maskedObj
	SET insideMask = insideMask | power(2,5) 
        FROM #maskedObj t, MaskedObject mo, Mask m
	WHERE t.objid=mo.objid and mo.maskid=m.maskid
		and m.type=4 and m.filter=2 and m.seeing>2.0
    --
    BEGIN TRANSACTION
	UPDATE p
	    SET p.insideMask = m.insideMask
	    FROM PhotoObjAll p JOIN #maskedObj m ON p.objid=m.objid
	SET @total = @@ROWCOUNT
    COMMIT TRANSACTION
	--
    --
    IF @@error<>0
    BEGIN
	SET @msg = 'Error in spSetInsideMask'
	EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
	RETURN(1);
    END
    SET @msg = CAST(@total as varchar(10)) + ' photoObj.insideMask updated.'
    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', @msg;
    --------------------
    -- write phase log
    --------------------
    SET @msg = 'Done setting PhotoObjAll.insideMask and Mask.htmID'
    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', @msg;
    --
    DROP TABLE #maskedObj
    RETURN(0);
END
GO


--=================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetPhotoClean]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spSetPhotoClean]
GO
--
CREATE PROCEDURE spSetPhotoClean (@taskid int, @stepid int)
------------------------------------------------
--/H Update the clean photometry flag for point sources in PhotoObjAll
--/A -------------------------------------------
--/T The PhotoObjAll.clean value is 1 if certain conditions are
--/T met for point source objects.  This signifies our best 
--/T judgement of "clean" photometry for these objects.  The
--/T same logic is not applicable to extended objects.
------------------------------------------------
AS BEGIN
    SET NOCOUNT ON;
    DECLARE @rows bigint,
            @msg varchar(1000),
            @status varchar(10);
    -----------------------------------------------------
    -- give phase start message 
    SET @msg =  'Starting to set clean photometry flag'
    EXEC spNewPhase @taskID, @stepID, 'Set PhotoObjAll.clean', 'OK', @msg;
    -----------------------------------------------------
    -- first reset flag to 0
    UPDATE PhotoObjAll SET clean = 0
    -- now set the flag
    UPDATE Star		-- apply only to point sources
    SET clean=1		-- set "clean photometry" to true
    WHERE
      (
       psfmag_i>14.5 AND psfmag_i-extinction_i<21.0
      ) AND (
        -- BRIGHT cut
        -- *all* BRIGHT objects are bad, no matter what
        (flags & 0x2) = 0
      ) AND (
        -- EDGE cuts
        -- reject EDGE & (COSMIC_RAY | DEBLEND_NOPEAK)
        -- also reject (flags_x & EDGE and flags_x & NOPROFILE)
       not ((flags & 0x4) > 0 AND ((flags & 0x1000) > 0 OR (flags & 0x400000000000) > 0))
       AND not ((flags_u & 0x4) > 0 AND (flags_u & 0x80) > 0)
       AND not ((flags_g & 0x4) > 0 AND (flags_g & 0x80) > 0)
       AND not ((flags_r & 0x4) > 0 AND (flags_r & 0x80) > 0)
       AND not ((flags_i & 0x4) > 0 AND (flags_i & 0x80) > 0)
       AND not ((flags_z & 0x4) > 0 AND (flags_z & 0x80) > 0)
      ) AND (
        -- SATUR_CENTER cut
        -- SATUR_CENTER is worse than SATUR, reject those
        -- and deal with additional bad SATUR objects later
        -- not ((flags & 0x80000000000) > 0)
        -- that didn't work, just reject SATURATED outright
        -- {saturated outright is commented out, back to satur center}
       not ((flags & 0x80000000000) > 0)	--    not ((flags & 0x40000) > 0)
      ) AND (
        -- BLENDED cuts
        -- keep blended objects if they are also NODEBLEND and DEBLEND_PRUNED
       ((flags & 0x8) = 0) OR ( ((flags & 0x8) > 0) AND ((flags & 0x40) > 0) AND ((flags & 0x4000000) > 0) )
      ) AND not (
        -- at least *one* band should be a 3 sigma detection!
    --       psfmagerr_u>0.333 AND psfmagerr_g>0.333 AND psfmagerr_r > 0.333 AND psfmagerr_i > 0.333 AND psfmagerr_z > 0.333
    --   )
       -- PSF_FLUX_INTERP cuts (2 independent sets)
       -- PSF_FLUX_INTERP TOO_FEW_GOOD_DETECTIONS, INTERP_CENTER, COSMIC_RAY, NOPETRO
    --   AND not (
    	(flags & 0x800000000000) > 0 AND (flags & 0x1000000000000) > 0 AND (flags & 0x100000000000) > 0 AND (flags & 0x1000) > 0 AND (flags & 0x100) > 0
      )
       -- PSF_FLUX_INTERP TOO_FEW_GOOD_DETECTIONS DEBLENDED_AS_PSF INTERP NOPETRO CHILD
      AND not (
    	(flags & 0x800000000000) > 0 AND (flags & 0x1000000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x100) > 0 AND (flags & 0x10) > 0 
      )
       -- {the next two are new}
      AND not (
    	(flags & 0x800000000000) > 0 AND (flags & 0x400000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x40000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x1000) > 0 AND (flags & 0x100) > 0 AND (flags & 0x10) > 0
      )
      AND not (
        (flags & 0x400000000000) > 0 AND (flags & 0x40000) > 0 AND (flags & 0x10) > 0
      )
       -- DEBLEND_NOPEAK cuts (2 sets)
       -- Reject DEBLEND_NOPEAK, CHILD without a 5-sigma detection in any band
      AND not (
        (flags & 0x400000000000) > 0 AND (flags & 0x10) > 0 AND
        psfmagerr_u>0.2 AND psfmagerr_g>0.2 AND psfmagerr_r > 0.2 AND psfmagerr_i > 0.2 AND psfmagerr_z > 0.2
      )
       -- Reject TOO_FEW_GOOD_DETECTIONS DEBLEND_NOPEAK DEBLENDED_AS_PSF INTERP NOPETRO CHILD (just because)
      AND not (
        (flags & 0x400000000000) > 0 AND (flags & 0x1000000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x100) > 0 AND (flags & 0x10) > 0
      )
       -- PEAKCENTER cut
       -- Reject PEAKCENTER DEBLEND_NOPEAK DEBLENDED_AS_PSF INTERP CHILD with large errors in all bands
      AND not (
        (flags & 0x20) > 0 AND (flags & 0x400000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x10) > 0 AND
        psfmagerr_u>0.1 AND psfmagerr_g>0.1 AND psfmagerr_r>0.1 AND psfmagerr_i>0.1 and psfmagerr_z>0.1
      )
      -- {this one is new}
      AND not (
        (flags & 0x20) > 0 AND (flags & 0x40000) > 0 AND (flags & 0x10) > 0
      )
       -- NOTCHECKED cut (2 sets)
       -- Reject DEBLEND_NOPEAK DEBLENDED_AT_EDGE DEBLENDED_AS_PSF NOTCHECKED INTERP COSMIC_RAY NOPETRO CHILD
      AND not (
        (flags & 0x400000000000) > 0 AND (flags & 0x200000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x80000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x1000) > 0 AND (flags & 0x100) > 0 AND (flags & 0x10) > 0	
      )
      AND not (
        (flags & 0x80000) > 0 AND (flags & 0x40000) > 0 AND (flags & 0x10) > 0	
      )
       -- Reject DEBLENDED_AT_EDGE DEBLENDED_AS_PSF NOTCHECKED INTERP CHILD
      AND not (
        (flags & 0x80000) > 0 AND (flags & 0x200000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x10) > 0
      )
       -- {this one is new}
      AND not (
      (flags & 0x1000000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x40000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x1000) > 0 AND (flags & 0x100) > 0 AND (flags & 0x10) > 0
      )
       -- For good measure, reject
       -- TOO_FEW_GOOD_DETECTIONS DEBLENDED_AT_EDGE STATIONARY DEBLENDED_AS_PSF INTERP COSMIC_RAY NOPETRO CHILD
      AND not (
        (flags & 0x1000000000000) > 0 AND (flags & 0x200000000000) > 0 AND (flags & 0x1000000000) > 0 AND (flags & 0x2000000) > 0 AND (flags & 0x20000) > 0 AND (flags & 0x1000) > 0 AND (flags & 0x100) > 0 AND (flags & 0x10) > 0
      )
       -- and objects with large errors and TOO_FEW_GOOD_DETECTIONS
      AND not (
        (flags & 0x1000000000000) > 0 AND
        psfmagerr_u>0.2 AND psfmagerr_g>0.2 AND psfmagerr_r>0.2 AND psfmagerr_i>0.2 AND psfmagerr_z>0.2
      )       
    -----------------------------------------------------
    --
    SELECT @rows = count_big(*) FROM PhotoObjAll WITH (nolock)
        WHERE clean=1
    IF @rows = 0
        BEGIN
            SET @status = 'WARNING';
            SET @msg = '0 rows with PhotoObjAll.clean=1'
        END
    ELSE
        BEGIN
            SET @status = 'OK';
            SET @msg = 'PhotoObjAll.clean updated: ' + cast(@rows as varchar(10)) + ' rows with clean=1'
        END
	-- give phase message telling of success.
    EXEC spNewPhase @taskID, @stepID, 'Set PhotoObjAll.clean', @status, @msg;
    -----------------------------------------------------
    RETURN(0);
END
GO


--====================================================
IF EXISTS (SELECT [name]FROM sysobjects 
	WHERE [name] = 'spTargetInfoTargetObjID' ) 
	DROP PROCEDURE spTargetInfoTargetObjID
GO
--
CREATE PROCEDURE spTargetInfoTargetObjID (
	@taskid int, 
	@stepid int 
)
-------------------------------------------------------------
--/H Set TargetInfo.targetObjID
--/A 
--/T Connect TargetInfo to photo objects in Target 
--/T Designed to run in the target database.
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <br>
--/T Sample call   <br>
--/T <br> <samp> 
--/T exec spTargetInfoTargetObjID @taskid , @stepid  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON;
	DECLARE @rows bigint,
		@msg varchar(1000),
		@status varchar(10),
		@mode tinyint,
		@firstfieldbit bigint;
	SET @firstfieldbit = dbo.ffirstfieldbit();
	-----------------------------------------------------
	-- give phase start message 
	SET @msg =  'Starting to set TargetInfo.targetObjID'
	EXEC spNewPhase @taskID, @stepID, 'Set TargetInfo.TargetObjID', 'OK', @msg;
	-----------------------------------------------------
	-- 
	SET @mode = 1;
	WHILE (@mode <= 4)
	BEGIN
		UPDATE TargetInfo
			SET targetObjId = p.objid, targetMode = @mode
			FROM TargetInfo t, PhotoObjAll p
			WITH (nolock)
			WHERE t.targetobjid = 0
			AND t.targetId = p.objid
			AND p.mode = @mode
		--
		UPDATE TargetInfo
			SET targetObjId = p.objid, targetMode = @mode
			FROM TargetInfo t, PhotoObjAll p
			WITH (nolock)
			WHERE t.targetobjid = 0
			AND p.objid = t.targetId + @firstfieldbit
			AND p.mode = @mode
		SET @mode = @mode + 1;
	END
	-----------------------------------------------------
	--
	SELECT @rows = count_big(*) FROM TargetInfo WITH (nolock)
		WHERE targetObjid = 0
	IF @rows > 0
	    BEGIN
		SET @status = 'WARNING';
		SET @msg = cast(@rows as varchar(20))+' rows with TargetInfo.targetobjid=0'
	    END
	ELSE
	    BEGIN
		SET @status = 'OK';
		SET @msg = 'TargetInfo.targetobjid updated'
	    END
	-- give phase message telling of success.
	EXEC spNewPhase @taskID, @stepID, 'Set TargetInfo.targetObjID', 'OK', @msg;
	-----------------------------------------------------
	RETURN(0);
END
GO


--========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetLoadVersion]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spSetLoadVersion]
GO
--
CREATE PROCEDURE spSetLoadVersion(@taskid int, @stepid int, @type varchar(32) )
-------------------------------------------------------------
--/H Update the loadVersion for various tables
--/A
--/T Part of the loading process
-------------------------------------------------------------
AS
BEGIN
    SET NOCOUNT On;
    --
    DECLARE
	@msg varchar(1024),
	@ret int;
    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Setting loadVersion';
    IF @type = 'PLATES'
      BEGIN
	------------------------------------------------
	-- plates
	------------------------------------------------
	UPDATE PlateX 		SET loadVersion = @taskid;
      END
    IF @type = 'TILES'
      BEGIN
	------------------------------------------------
	-- tiles
	------------------------------------------------
	UPDATE sdssTileAll 		SET loadVersion = @taskid;
	UPDATE sdssTilingGeometry 	SET loadVersion = @taskid;
	UPDATE sdssTiledTargetAll 	SET loadVersion = @taskid;
	UPDATE sdssTilingInfo	 	SET loadVersion = @taskid;
	UPDATE sdssTilingRun 		SET loadVersion = @taskid;
      END

    IF @type = 'WINDOW'
      BEGIN
	------------------------------------------------
	-- tiles
	------------------------------------------------
	UPDATE sdssImagingHalfSpaces 		SET loadVersion = @taskid;
	UPDATE sdssPolygons	SET loadVersion = @taskid;
	UPDATE sdssPolygon2Field 	SET loadVersion = @taskid;
      END

    IF @type IN ('BEST','TARGET', 'RUNS')
      BEGIN
	------------------------------------------------
	-- imaging (BEST, TARGET, RUNS)
	------------------------------------------------
	UPDATE Field 		SET loadVersion = @taskid;
	UPDATE Target 		SET loadVersion = @taskid;
	UPDATE TargetInfo 	SET loadVersion = @taskid;
      END
    ------------------------------------------------
	IF @@error<>0
	    BEGIN
		SET @msg = 'Error in setting loadVersion'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(1);
	    END

	-- write phase log
	EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'loadVersion updated';
END
GO



--========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetValues]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spSetValues]
GO
--
CREATE PROCEDURE spSetValues(@taskid int, @stepid int)
-------------------------------------------------------------
--/H Compute the remaining attributes after bulk insert
--/A
--/T Part of the loading process: it computes first
--/T the HTMID for the Frame table, then the easy magnitudes
--/T then sets the boundaries for a given chunk. Writes log
--/T into the loadadmin database.
-------------------------------------------------------------
AS
BEGIN
    --
    SET NOCOUNT On;
    --  
    DECLARE
	@msg varchar(1024),
	@status varchar(10),
	@type varchar(32),
	@count bigint,
	@ret int;

    -- get the Task type
    SELECT @type=type FROM loadsupport.dbo.Task
	WHERE taskid=@taskid;

    -- set the loadVersion
    EXEC @ret=dbo.spSetLoadVersion @taskid, @stepid, @type
    IF @ret>0	RETURN(1);

    ------------------------------------------------
    -- imaging data, one of (BEST, TARGET, RUNS)
    ------------------------------------------------
    ELSE
      IF (@type = 'PLATES')
	BEGIN
	  EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Un-escaping commas in PlateX.designComments';
	  -- reinstate the commas in designComments that were escaped for CSV
	  UPDATE PlateX
	    SET designComments = REPLACE( designComments, '%2C', ',' )
	  EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Done un-escaping commas in PlateX.designComments';
	  IF @@error<>0
	    BEGIN
		SET @msg = 'Error in updating PlateX.designComments'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(1);
	    END

	  EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Setting PlateX htmID';
	  UPDATE PlateX 
	    SET htmId = dbo.fHtmXYZ( cx, cy, cz )
          IF @@error<>0
	    BEGIN
		SET @msg = 'Error in setting PlateX htmID'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(1);
	    END

	  EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Setting SpecObjAll htmID and loadVersion';
	  UPDATE SpecObjAll 
	    SET htmId = dbo.fHtmEq( ra,dec ),
		loadVersion = @taskid
	  IF @@error<>0
	    BEGIN
		SET @msg = 'Error in setting specobjall htmID and loadVersion'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(1);
	    END

	END

      ELSE
	IF (@type IN ('BEST','TARGET','RUNS'))
	  BEGIN
	    ------------------------------------------------------
	    -- set Simplified magnitudes of all objects, and
	    -- also compute the dereddened magnitudes
	    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Setting PhotoObjAll dereddened magnitudes, loadVersion and htmID';
	    UPDATE PhotoObjAll
	      SET
	 	dered_u = CASE WHEN modelMag_u=-9999 THEN modelMag_u
			  ELSE modelMag_u - extinction_u
			  END,
	 	dered_g = CASE WHEN modelMag_g=-9999 THEN modelMag_g
			  ELSE modelMag_g - extinction_g
			  END,
	 	dered_r = CASE WHEN modelMag_r=-9999 THEN modelMag_r
			  ELSE modelMag_r - extinction_r
			  END,
	 	dered_i = CASE WHEN modelMag_i=-9999 THEN modelMag_i
			  ELSE modelMag_i - extinction_i
			  END,
	 	dered_z = CASE WHEN modelMag_z=-9999 THEN modelMag_z
			  ELSE modelMag_z - extinction_z
			  END,
		/* the ugriz and Err_ugriz should not be set for SDSS-III
		Err_u   = modelMagErr_u,
		Err_g   = modelMagErr_g,
		Err_r   = modelMagErr_r,
		Err_i   = modelMagErr_i,
		Err_z   = modelMagErr_z,
		u 	= modelMag_u,
		g 	= modelMag_g,
		r 	= modelMag_r,
		i 	= modelMag_i,
		z 	= modelMag_z,
		*/
		htmId = dbo.fHtmXYZ( cx, cy, cz ),
		loadVersion = @taskid
           
	    --
	    IF @@error<>0
	      BEGIN
		SET @msg = 'Error in setting PhotoObjAll dereddened magnitudes, loadVersion and htmID'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(1);
	      END

	    -- log the success
	    EXEC spNewPhase @taskid, @stepid, 'Set values','OK','PhotoObjAll dereddened magnitudes, loadVersion and htmID set';

	    -- remove AtlasOutline rows in hole fields
	    DELETE AtlasOutline
	      WHERE objid IN 
		(SELECT m.objid FROM AtlasOutline m,
		    (SELECT fieldid FROM Field
			WHERE quality=5) q
		    WHERE (m.objid & 0xFFFFFFFFFFFF0000) = q.fieldid
		)
		
		-- Replace '%2C' with comma in AtlasOutine span string
		UPDATE AtlasOutline 
		SET span=REPLACE(span,'%2C',',' )
		
	    -- log the result
	    SET @msg = 'Deleted ' + cast(ROWCOUNT_BIG() as varchar(20))+
		+ ' rows from the AtlasOutline table in HOLE fields';
	    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', @msg;
	    -----------------------------------------------------
	    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Starting Frame HTM computation';

	    -- now compute the htmid for the Frame table
	    EXEC @ret=dbo.spComputeFrameHTM
	    --
	    IF @@error<>0 OR @ret>0
	      BEGIN
		SET @msg = 'Error in spComputeFrameHTM'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(1);
	      END
	    -- write phase log
	    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Frame HTM computed';
	    -----------------------------------------------------
	    -- set TargetInfo.targetObjid

	    IF @type='TARGET'
	      BEGIN
		--
		EXEC @ret=dbo.spTargetInfoTargetObjid @taskid, @stepid
		--
		IF @@error<>0 OR @ret>0
		    BEGIN
			SET @msg = 'Error in spTargetInfoTargetObjid';

			EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
			RETURN(1);
		    END
		-- write phase log
		EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'TargetInfo.targetObjid set';
	      END
	    --
	    ------------------------------------------------------
	    -- update the Mask table
	    UPDATE Mask
	      SET cx  = COS(RADIANS(dec))*COS(RADIANS(ra)), 
		cy  = COS(RADIANS(dec))*SIN(RADIANS(ra)),
		cz  = SIN(RADIANS(dec)),
		area = REPLACE(area,'"','');
	    --
	    UPDATE Mask
	      SET htmId = dbo.fHtmXYZ(cx,cy,cz);
	    --		
	    IF @@error<>0
	      BEGIN
		SET @msg = 'Error in Mask HTM update'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(1);
	      END
	    -- write phase log
	    EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'Mask HTM computed';
	    -----------------------------------------------------
	    EXEC @ret=dbo.spFillMaskedObject @taskid, @stepid;
	    IF @ret<>0 OR @@error<>0
	      BEGIN
		SET @msg = 'Error in MaskedObject update'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(@ret);
	      END	
	    EXEC @ret=dbo.spSetInsideMask @taskid, @stepid, 0;
	    IF @ret<>0 OR @@error<>0
	      BEGIN
		SET @msg = 'Error in InsideMask update'
		EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		RETURN(@ret);
	      END	
	      -----------------------------------------------------
	  END
	ELSE
	  IF (@type = 'APOGEE')
	    BEGIN
	      UPDATE apogeeStar
		SET htmID = dbo.fHtmEq(ra, dec)
	      IF @@error<>0
		BEGIN
		  SET @msg = 'Error in apogeeStar htmID update'
		  EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		  RETURN(1);
		END
		-- write phase log
		EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'apogeeStar htmID computed';
 	    END
	ELSE
	  IF (@type = 'MANGA')
	    BEGIN
	      UPDATE mangaDrpAll
		SET htmID = dbo.fHtmEq(ifura, ifudec)
	      IF @@error<>0
		BEGIN
		  SET @msg = 'Error in mangaDrpAll htmID update'
		  EXEC spEndStep @taskID, @stepID, 'ABORTING', @msg, @msg;
		  RETURN(1);
		END
		-- write phase log
		EXEC spNewPhase @taskid, @stepid, 'Set values', 'OK', 'mangaDrpAll htmID computed';
 	    END
END
GO


PRINT '[spSetValues.qsl]:  Set values procedures created'
GO
