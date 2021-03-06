USE [BestDR13]
GO
/****** Object:  StoredProcedure [dbo].[spSynchronize]    Script Date: 03/03/2016 14:03:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--
ALTER PROCEDURE [dbo].[spSynchronize] (
	@taskid int, 
	@stepid int
)
-------------------------------------------------------------
--/H  Finish Spectro object (do photo Spectro matchup)
--/A --------------------------------------------------------
--/T <p> parameters:   
--/T <li> taskid int,   		-- Task identifier
--/T <li> stepid int	   		-- Step identifier
--/T <li> returns  0 if OK, non zero if something wrong  
--/T <br>
--/T Sample call:<br>
--/T <samp> 
--/T <br> exec  spSynchronize @taskid , @stepid  
--/T </samp> 
--/T <br>  
------------------------------------------------------------- 
AS BEGIN
	SET NOCOUNT ON
	------------------------------------------------------
	--- Globals
	DECLARE @start datetime,
		@ret int, 
		@cmd varchar(8000),
		@msg varchar(1024),
		@targetDBname varchar(1000),
		@rows  bigint,
		@ttDupCount int 
	SET @start  = current_timestamp;
	IF (@taskid != 0) EXEC loadsupport.dbo.spSetFinishPhase 'syncSpectro'
	------------------------------------------------------
	-- Put out step greeting.
	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', 'spSynchronize called';
	------------------------------------------------------
	--- First set PhotoObjAll.specobjid to 0 
	BEGIN TRANSACTION
	    UPDATE p
		SET p.specobjid=0
		FROM PhotoObjAll p WITH (tablock)
		WHERE 
		    p.specobjid != 0
		OPTION (MAXDOP 1)	
	    SET  @rows = ROWCOUNT_BIG();
	COMMIT TRANSACTION
	SET  @msg = 'Set specobjid to 0 for ' + str(@rows) + ' PhotoObjAll rows.'
	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;
	BEGIN TRANSACTION
		SELECT p.objID, MAX(s.specObjID) as specobjID
		INTO #specuniq
		FROM PhotoObjAll p JOIN SpecObjAll s ON p.objID=s.bestObjID
		GROUP BY p.objID
		HAVING COUNT(p.objID) = 1

		SELECT p.objID
		INTO #specdup
		FROM PhotoObjAll p JOIN SpecObjAll s ON p.objID=s.bestObjID
		GROUP BY p.objID
		HAVING COUNT(p.objID) > 1

		SELECT p.objid, q.ra as pra, q.dec as pdec, s.specobjid, s.sciencePrimary, s.ra as sra, s.dec as sdec, 
			dbo.fDistanceArcMinEq(q.ra, q.dec, s.ra, s.dec) as dist
		INTO #specinfo
		FROM #specdup p join PhotoObjAll q ON p.objID=q.objID join SpecObjAll s ON p.objID=s.bestObjID
		ORDER BY q.objID, s.sciencePrimary DESC, dist ASC

		SELECT distinct p.objid, 
			(SELECT TOP 1 q.specobjid FROM #specinfo q WHERE q.objID=p.objID ORDER BY q.sciencePrimary DESC, q.dist ASC) as specobjid
		INTO #specresolve
		FROM #specdup p 

		INSERT #specuniq
		SELECT objID, specObjID
		FROM #specresolve

	    UPDATE p
		SET p.specobjid=s.specobjid
		FROM PhotoObjAll p WITH (tablock)
		     JOIN #specuniq s ON p.objid=s.objid
		OPTION (MAXDOP 1)	
	    SET  @rows = ROWCOUNT_BIG();
	COMMIT TRANSACTION
	IF (@rows = 0)
	   SELECT @rows=COUNT(*) FROM PhotoObjAll WHERE specobjid != 0
	SET  @msg = 'Updated unset specObjID links for ' + str(@rows) + ' PhotoObjAll rows.'
	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;
	-----------------------------------------------------
	EXEC spBuildSpecPhotoAll @taskid, @stepid

	-- generate completion message.
	SET @msg = 'spSynchronize finished in '  
	    + cast(dbo.fDatediffSec(@start, current_timestamp) as varchar(30))
	    + ' seconds';

	EXEC spNewPhase @taskid, @stepid, 'Synchronize', 'OK', @msg;
	------------------------------------------------------
	RETURN(0);
END	-- End spSynchronize()
