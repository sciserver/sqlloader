-- Patch to update Region and RegionPatch tables for DR13 polygons.


-- First update the spSdssPolygonRegions procedure to include a call to
-- spRegionSync to sync RegionPatch with Region
--========================================================
IF  EXISTS (SELECT * FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].[spSdssPolygonRegions]') 
		AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[spSdssPolygonRegions]
GO
--
CREATE PROCEDURE spSdssPolygonRegions(	
	@taskid int, 
	@stepid int 
)
--------------------------------------------------------------------------
--/H Create regions of a type 'POLYGON' during FINISH stage
--/A ---------------------------------------------------------------------
--/T Create the polygon regions for main survey and set the areas
--/T using regionBinary.
------------------------------------------------------
AS
BEGIN
	DECLARE @msg varchar(1000)
	-----------------------------------------------------
	-- give phase start message 
	SET @msg =  'Starting creation of SDSS polygon regions '
	EXEC spNewPhase @taskID, @stepID, 'spSdssPolygonRegions', 'OK', @msg;
	-----------------------------------------------------
	EXEC dbo.spIndexDropSelection @taskID, @stepID, 'F', 'REGION'
	EXEC dbo.spIndexDropSelection @taskID, @stepID, 'F', 'SECTOR'
	TRUNCATE TABLE Region
	INSERT Region WITH (tablock)
	    SELECT sdsspolygonid AS id, 'POLYGON' AS TYPE, '' AS comment,
		   0 AS ismask, -1 AS area, NULL AS regionstring,
		   sph.fSimplifyQueryAdvanced('SELECT 0, X,Y,Z, C FROM SdssImagingHalfspaces WHERE SdssPolygonID=' + convert(varchar(128),SdssPolygonID), 0,0,0,0) AS regionBinary
--		   dbo.fSphSimplifyQueryAdvanced('SELECT 0, X,Y,Z, C FROM SdssImagingHalfspaces WHERE SdssPolygonID=' + convert(varchar(128),SdssPolygonID), 0,0,0,0) AS regionBinary
		FROM sdssPolygons WITH (NOLOCK)
	UPDATE Region SET area = COALESCE(sph.fGetArea(regionbinary), -1)
--	UPDATE Region SET area = COALESCE(dbo.fSphGetArea(regionbinary), -1)

	-- Sync the RegionPatch table with Region
	EXEC spRegionSync 'POLYGON'
  
	EXEC dbo.spIndexBuildSelection @taskID, @stepID, 'F', 'SECTOR'
	EXEC dbo.spIndexBuildSelection @taskID, @stepID, 'F', 'REGION'
	------------------------------------------------------
	-- generate completion message.
	SET @msg = 'Created SDSS Polygon regions';
	EXEC spNewPhase @taskid, @stepid, 'spSdssPolygonRegions', 'OK', @msg;
	------------------------------------------------------
    RETURN(0);
END
GO


-- Now run the updated procedure to fix Region/RegionPatch for DR13 polygons
EXEC spSdssPolygonRegions 0, 0


-- Update schema version date in SiteConstants
update SiteConstants
set value='Aug 16 2016 11:00PM'
where name='Schema Version Date'


-- Set the DB version to 13.5
DELETE FROM Versions WHERE verson='13.5'
EXECUTE spSetVersion
  0
  ,0
  ,'13'
  ,'af04a1baa0209cbf0209c7def35e565f75c0b55b'
  ,'Update DR'
  ,'.5'
  ,'Fixed bug in f[In]FootprintEq'
  ,'Added call to spRegionSync in spSdssPolygonRegions and ran it to update the Region table with DR13 polygons'
  ,'T.Budavari, A.Thakar'
GO
