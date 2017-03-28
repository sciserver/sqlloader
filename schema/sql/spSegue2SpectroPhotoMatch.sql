--=========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSegue2SpectroPhotoMatch]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spSegue2SpectroPhotoMatch]
GO
--
CREATE PROCEDURE spSegue2SpectroPhotoMatch (
	@taskid int, 
	@stepid int 
)
-------------------------------------------------------------
--/H Computes PhotoObj corresponding to new SEGUE2 spectra
--/A --------------------------------------------------------
--/T Connect SEGUE2 spectra to photo objects in Best 
--/T Designed to run in the Best database.
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int,   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call   <br>
--/T <br> <samp> 
--/T exec spSegue2SpectroPhotoMatch @taskid , @stepid  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON
	-----------------------------------------------------
	-- local table variable to hold the specobjects
	CREATE TABLE #PhotoSpec (
		PhotoObjID 		bigint,
	 	mode			tinyint,
		specObjID       numeric(20,0) PRIMARY KEY,
		sciencePrimary	tinyint,
		ra				float,
		[dec]			float,
		cX				float,
		cY				float,
		cZ				float,
		Distance		float
	) 
	--
	DECLARE @rows bigint,
		@msg varchar(1000)
	-----------------------------------------------------
	-- give phase start message 
	SET @msg =  'Starting heuristic match of SEGUE2 '
	    + 'Spectro & Photo objects on BEST-PUB'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-----------------------------------------------------
	-- fill in spectro info for objects with positions
	INSERT 	#PhotoSpec
	SELECT 	NULL, 0,
		SpecObjID, sciencePrimary, ra, [dec],
		cx, cy, cz, -1
	FROM BESTSEGUE2.dbo.SpecObjAll WITH(nolock)
	WHERE BestObjID = 0
	AND ra between 0 and 360
	AND [dec] between -90 and 90
	-----------------------------------------------------
	-- give phase start message 
	SET @msg =  'Starting SEGUE2 spatial matchup'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-- find lowest mode, nearest objid within 2.0"
	DECLARE @mode tinyint;
	SET @mode = 1;
	WHILE (@mode <= 4)
	BEGIN
		UPDATE	#PhotoSpec
		SET 	PhotoObjID = dbo.fGetNearestObjIdEqMode(ra,[dec],2.0/60.0,@mode),
			mode = @mode
		WHERE	PhotoObjID IS NULL
		OPTION (MAXDOP 1)
		SET @mode = @mode + 1;
	END
	-----------------------------------------------------
	-- delete orphans (no match)
	DELETE #PhotoSpec
	    WHERE PhotoObjID IS NULL
	-----------------------------------------------------
	SET @msg =  'Starting SEGUE2 SpecObjAll update'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-- Set SpecObj.ObjID from PhotoSpectro
	BEGIN TRANSACTION
	    UPDATE BESTSEGUE2.dbo.SpecobjAll
		SET    BestObjId = PS.PhotoObjID
		FROM   SpecObjAll S, #PhotoSpec PS
		WHERE  S.SpecObjID = PS.SpecObjID
		OPTION (MAXDOP 1)
	COMMIT TRANSACTION
	-----------------------------------------------------
	-- Set PhotoObjAll.SpecObjID from PhotoSpectro
	SET @msg =  'Starting PhotoObjAll update for SEGUE2'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	--
	BEGIN TRANSACTION
	    UPDATE PhotoObjAll
		SET    	specObjID = PS.specObjID
		FROM   	photoObjAll P, #PhotoSpec PS
		WHERE  	P.objID = PS.PhotoObjID
		AND 	PS.sciencePrimary = 1
		OPTION (MAXDOP 1)
	COMMIT TRANSACTION
	-----------------------------------------------------
	-- Set PhotoTag.SpecObjID from PhotoSpectro
	SET @msg =  'Starting PhotoTag update for SEGUE2'
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	--
	BEGIN TRANSACTION
	    UPDATE PhotoTag
		SET    	specObjID = PS.specObjID
		FROM   	photoTag P WITH(NOLOCK), #PhotoSpec PS
		WHERE  	P.objID = PS.PhotoObjID
		AND 	PS.sciencePrimary = 1
		OPTION (MAXDOP 1)
	COMMIT TRANSACTION
	-----------------------------------------------------
	SELECT @rows = count_big(*) from #PhotoSpec
	SET @msg = 'spSegue2SpectroPhotoMatch found ' 
	    + cast(@rows as varchar(20)) + ' matches'
	-----------------------------------------------------
	-- give phase message telling of success.
	EXEC spNewPhase @taskID, @stepID, 'SEGUE2 PhotoSpec match', 'OK', @msg;
	-----------------------------------------------------
	DROP TABLE #PhotoSpec
	RETURN(0);
END	-- end spSegue2SpectroPhotoMatch
GO


