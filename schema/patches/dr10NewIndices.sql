-- Patch to add new indices to improve query performance for DR10.

USE BestDR10
GO

-- Add the new indices to the IndexMap table first
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w1mpro'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w2mpro'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w3mpro'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w4mpro'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'n_2mass'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'tmass_key'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'ra,dec'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'j_m_2mass'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'h_m_2mass'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'k_m_2mass'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w1rsemi'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'blend_ext_flags'		,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w1cc_map'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w2cc_map'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w3cc_map'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'WISE_allsky',	 'w4cc_map'			,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'zooMirrorBias', 	'dr7objid'		,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'zooMonochromeBias', 	'dr7objid'		,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'zooNoSpec', 		'dr7objid'		,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'zooVotes', 		'dr7objid'		,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'zoo2MainPhotoz', 	'dr7objid'		,'','PHOTO');
INSERT IndexMap Values('K','primary key', 'apogeeStarVisit', 	 	'visit_id'		,'','SPECTRO');
INSERT IndexMap Values('K','primary key', 'apogeeStarAllVisit', 	'visit_id,apstar_id'		,'','SPECTRO');
INSERT IndexMap Values('K','primary key', 'zooSpec', 			'specObjID'		,'','SPECTRO');
INSERT IndexMap Values('K','primary key', 'zooConfidence',		'specObjID'		,'','SPECTRO');
INSERT IndexMap Values('I','index', 'WISE_xmatch',	 'wise_cntr'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'zooNoSpec', 	 'objID'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'zooVotes', 	 'objID'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'zooMirrorBias', 	 'objID'			,'','PHOTO');
INSERT IndexMap Values('I','index', 'zooMonochromeBias', 'objID'			,'','PHOTO');


-- Update the spIndexBuildList SP code (to include bug fix).
--========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spIndexBuildList]')) 
	drop procedure spIndexBuildList
GO
--
CREATE PROCEDURE spIndexBuildList(@taskid int, @stepid int)
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
		EXEC @ret = spIndexCreate @taskid,@stepid,@nextindex;

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


-- Create the new indices
EXEC spIndexBuildSelection 0, 0, 'K,I,F', 'META'
EXEC spIndexBuildSelection 0, 0, 'K,I,F', 'PHOTO'
EXEC spIndexBuildSelection 0, 0, 'K,I,F', 'SPECTRO'



--=======================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fPolygonsContainingPointXYZ]') 
	and xtype in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	drop function [dbo].[fPolygonsContainingPointXYZ]
GO
--
CREATE FUNCTION fPolygonsContainingPointXYZ(@x float, @y float, @z float, @buffer_arcmin float)
--------------------------------------------------------
--/H Returns regions containing a given point 
--/U ---------------------------------------------------
--/T The parameters
--/T <li>@x, @y, @z are unit vector of the point on the J2000 celestial sphere. </li>
--/T <li>@buffer_arcmin </li>
--/T <br>Returns empty table if input params are bad.
--/T <br>Returns a table with the columns
--/T <br>RegionID BIGINT NOT NULL PRIMARY KEY
--/T <samp>
--/T SELECT * from fPolygonsContainingPointXYZ(1,0,0)
--/T </samp>
--------------------------------------------------------
RETURNS @region TABLE(RegionID bigint PRIMARY KEY)
AS BEGIN
	DECLARE @arcmin float=7.85 + @buffer_arcmin; -- max radius of polygons
	DECLARE @degree float=@buffer_arcmin/60;
	--
	DECLARE @htmTemp TABLE (
		HtmIdStart bigint,
		HtmIdEnd bigint
	);

	INSERT @htmTemp SELECT * FROM dbo.fHtmCoverCircleXyz(@x,@y,@z,@arcmin)
	DECLARE @found table (regionid bigint not null, 
		x float not null, y float not null, z float not null, 
		c float not null, dec float not null);
	--
	INSERT @found 
	SELECT regionid, x, y, z, c, dec 
	FROM @htmTemp c 
	INNER JOIN RegionPatch p ON p.HtmID BETWEEN c.HtmIDStart and c.HtmIDEnd;
	--
	DELETE @found WHERE x*@x + y*@y + z*@z < c;
	--
	INSERT @region SELECT p.regionid
	FROM @found p inner join Region r on r.regionid=p.regionid
	WHERE dbo.fSphRegionContainsXYZ(dbo.fSphGrow(r.regionBinary,@degree),@x,@y,@z)=1;
	
	RETURN
END
GO



-- Update the spSetVersion SP code (include bug fix).
--==================================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spSetVersion]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[spSetVersion]
GO
--
CREATE PROCEDURE spSetVersion(@taskid int, @stepid int,
		@release varchar(8)='4', 
		@dbversion varchar(128)='v4_18', 
		@vname varchar(128)='Initial version of DR', 
		@vnum varchar(8)='.0',
                @vdesc varchar(128)='Incremental load',
                @vtext varchar(4096)=' ',
		@vwho varchar(128) = ' ')
---------------------------------------------------
--/H Update the checksum and set the version info for this DB.
--/A -------------------------------------------------
--/T 
--/T 
--/T 
--/T 
---------------------------------------------------
AS
BEGIN
	-- Check schema skew
	EXEC spCheckDBObjects
	EXEC spCheckDBColumns
	EXEC spCheckDBIndexes

	-- Update statistics for all tables
	EXEC spUpdateStatistics

	-- generate diagnostics and checksum
	EXEC spMakeDiagnostics
	EXEC spUpdateSkyServerCrossCheck
	EXEC spCompareChecksum

	DECLARE @curtime VARCHAR(64), @prev VARCHAR(32)

	SET @curtime=CAST( GETDATE() AS VARCHAR(64) );

	-- update SiteConstants table
	UPDATE siteconstants SET value='http://data.sdss3.org/' WHERE name='DataServerURL'
	UPDATE siteconstants SET value='http://skyserver.sdss3.org/dr'+@release+'/en/' WHERE name='WebServerURL'
	UPDATE siteconstants SET value=@dbversion WHERE name='DB Version'
	UPDATE siteconstants SET value='DR'+@release+' SkyServer' WHERE name='DB Type'
	UPDATE siteconstants SET value=@curtime WHERE name='DB Version Date'

	-- get checksum from site constants and add new entry to Versions
	DECLARE @checksum VARCHAR(64)
	SELECT @checksum=value FROM siteconstants WHERE [name]='Checksum'
	SELECT TOP 1 @prev=version from Versions order by convert (datetime,[when]) desc

	-- update Versions table with latest version
	INSERT Versions
		VALUES( @vname+@release,@prev,@checksum,@release+@vnum,
			@vdesc, @vtext, @vwho, @curtime)
END
GO




-- Now update the DB version
EXECUTE spSetVersion
  0
  ,0
  ,'10'
  ,'150500'
  ,'Update DR'
  ,'.6'
  ,'DR10 indices patch'
  ,'Add new indices for performance and fixed footprint bug'
  ,'D.Medvedev,D.Muna,A.Thakar'
GO

