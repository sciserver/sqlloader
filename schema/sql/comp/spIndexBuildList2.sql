

/****** Object:  StoredProcedure [dbo].[spIndexBuildList2]    Script Date: 11/10/2016 2:05:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--
CREATE PROCEDURE [dbo].[spIndexBuildList2](@taskid int, @stepid int)
-------------------------------------------------------------
--/H Builds the indices from a selection, based upon the #indexmap table
--/A --------------------------------------------------------
--/T It also assumes that we created before an #indexmap temporary table
--/T that has three attributes: id int, indexmapid int, status int.
--/T status values are 0:READY, 1:STARTED, 2:DONE.
-------------------------------------------------------------
AS BEGIN
	SET NOCOUNT ON;
	--
	DECLARE @nextindex int,
		@ret int,
		@type varchar(100),
		@code char(1),
		@tableName varchar(100),
		@fieldList varchar(1000),
		@foreignKey varchar(1000),
		@fileGroup varchar(100),
		@group varchar(100);
	--
	WHILE (1=1)
	BEGIN
		----------------------------------
		-- get the next index to create
		----------------------------------
		SET @nextindex=NULL;
		SELECT @nextindex=indexmapid
		    FROM #indexmap
		    WHERE id in (
			select min(id) from #indexmap WHERE status=0
			);
		----------------------------------
		-- exit if error
		----------------------------------
		IF @@error>0 RETURN(1);
		IF @nextindex IS NULL  RETURN(2);

		----------------------------------
		-- set status to STARTED(1)
		----------------------------------
		UPDATE #indexmap
		    SET status=1
		    WHERE indexmapid=@nextindex;

		--------------------------------------------------
		-- call spIndexCreate
		--------------------------------------------------
		EXEC @ret = spIndexCreate2 @taskid,@stepid,@nextindex;

		--------------------------------------
		-- if all OK, update status to DONE(2)
		--------------------------------------
		IF @ret=0 
		    UPDATE #indexmap
			SET status=2
			WHERE indexmapid=@nextindex;
		-------------------------------------------------
	END
	RETURN(0);
END


GO

