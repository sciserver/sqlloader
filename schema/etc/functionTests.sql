----------------------------------------------
-- Code to test the SDSS functions.
-- It prints out errors for if a function is misbehaving.
-- The code needs the V3 SDSS database to have photo objects
-- at ra=185, dec=0 (aka xyz = -.996,-.1,0)
--
-----------------------------------------------------------
-- Test HTM code
declare @htm bigint, @msg varchar(256), @n int
set @htm =  0
select @htm = dbo.fHTM_Lookup('J2000  20 185 0')
if (@htm !=  10997281067137) print '***** dbo.fHTM_Lookup is not installed' 
--
select @msg = dbo.fHTM_Lookup_ErrorMessage('J2000  20 185 0')
if (@msg !=  'OK') print '***** dbo.fHTM_Lookup_ErrorMessage is not installed' 
--
SELECT @n=count(*) FROM fHTM_Cover('CIRCLE J2000 3 41.4 47.9 .1 ') -- (1021, 1022)
if (@n is null or @n !=1 )print '***** dbo.fHTM_Cover is not installed'
--
select @msg = dbo.fHTM_To_String(dbo.fHTM_Lookup('J2000 20 240.0 38.0'))
if (@msg != '3,1,3,2,2,2,0,2,2,1,2,2,0,1,2,3,3,2,0,3,3,3') print '***** dbo.fHTM_To_String is not installed'
print 'Tested HTM functions.'
GO
-- Test the Neighbor code
----------------------
--------
declare @n int
select @n=count(*) from dbo.fGetNearbyObjEq(185,0,5) 
if (@n is null or @n = 0) print '***** dbo.fGetNearbyObjEq returned zero objects'
--------
select @n=count(*) from dbo.fGetNearestObjEq(185,0,5) 
if (@n is null or @n = 0) print '***** dbo.fGetNearestObjEq returned zero objects'
--------
select @n=count(*) from dbo.fGetNearbyObjXyz(-.996,-.1,0,5) 
if (@n is null or @n = 0) print '***** dbo.fGetNearbyObjXyz returned zero objects'
--------
select @n=count(*) from dbo.fGetNearestObjXyz(-.996,-.1,0,5) 
if (@n is null or @n = 0) print '***** dbo.fGetNearestObjXyz returned zero objects'
--------
select @n=count(*) from  dbo.fGetNearestFrameEq(185,0,10)  
if (@n is null or @n = 0) print '***** dbo.fGetNearestFrameEq returned zero objects'
--------
select  @n=count(*) from  dbo.fGetNearestMosaicEq(185,0,30)  
if (@n is null or @n = 0) print '***** dbo.fGetNearestMosaicEq returned zero objects'
--------
print 'Tested proximity functions.'
go
-- Test the Web support code
----------------------
declare @n int
DECLARE @cmd VARCHAR(8000); 
SET @cmd = 'select TOP 2  * from PhotoType'; 
EXEC dbo.spExecuteSQL @cmd 
if (@@rowCount!=2) print '***** fExecuteSQL failed (probably a security problem) '
--
exec dbo.spGetFieldsObjects 2255029915222016  
if (@@rowCount= 0) print '***** spGetFieldsObjects failed (probably a security problem) '
--
exec dbo.spNearestObjEq 185,0,1
if (@@rowCount!=1) print '***** spNearestObjEq failed (probably a security problem) '
--
select @n = dbo.fIsNumbers('123;',1,3)	
if (@n != 1)  print '***** fIsNumbers failed (probably a security problem) '
--
select * from dbo.fMASTmatchPhotoObj('123,146.1,-0.01;456,147,.505;-1,-1,-1;')
if (@@rowCount<2) print '***** fMASTmatchPhotoObj failed (probably a security problem) '
--
select @n=count(*) from dbo.fGetObjFromRect(185,185.1,0,.1)
if (@n < 2) print '***** fGetObjFromRect failed (probably a security problem) '
-----------------------------------------------------
--- ran out of steam, no tests for SQL QA or for URLs.
go
-- Test the TimeX code
----------------------
declare @clock datetime, @cpu int, @physical_io int,  @elapsed int;
set @physical_io = -1
exec dbo.InitTimeX  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
-- .... do some SQL work....
exec dbo.EndTimeX @clock, @elapsed OUTPUT, @cpu OUTPUT, @physical_io OUTPUT, 'TimeX test worked', 1, 1, @@RowCount
if ( @physical_io < 0)  print '***** dbo.EndTimeX failed (probably a security problem))'
-----------------------
print 'all function and stored procedure tests completed'