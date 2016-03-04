--=================================================================
--   spSphericalTest.sql
--	 2007-06-11 Tamas Budavari
-------------------------------------------------------------------
-- Tests whether something simple works
-------------------------------------------------------------------
-- History:
-------------------------------------------------------------------

--====================================================================
PRINT '*** TEST ***'
--
--PRINT Sph.fGetVersion();
--
declare @bin varbinary(max);
set @bin = null;
set @bin = Sph.fConvexAddHalfspace(@bin, 0, 1,0,0, 0.0);
set @bin = Sph.fConvexAddHalfspace(@bin, 0, 0,1,0, 0.0);
set @bin = Sph.fConvexAddHalfspace(@bin, 0, 0,0,1, 0.0);
set @bin = Sph.fConvexAddHalfspace(@bin, 0, 1,1,1, 0.0);

PRINT Sph.fGetRegionString(@bin);
set @bin = Sph.fSimplifyBinaryAdvanced(@bin, 0,0,0,0);
PRINT 'Area: ' + convert(nvarchar,Sph.fGetArea(@bin));
PRINT Sph.fGetRegionString(@bin);
--select * from dbo.fSphGetHalfspaces(@bin);
--select * from dbo.fSphGetPatches(@bin);

--select * from sph.fGetVersions()