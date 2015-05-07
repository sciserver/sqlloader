
------------------------------------------------------------------
--- Personal SkyServer -- takes 10 minutes
declare 
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100) 
set @SourceDbVersion = 'DR6'
set @SourceDbDataClass = 'BEST'
set @NewDbName = 'MyBestDR6'
set @AreaRestriction = 'ra between 193.75 and 196.25 and dec between 1.25 and 3.75'
set @SourceDbName = 'BESTDR6'
set @NewDbDirectory =   'f:\' -- will go to directory d:\MyBestDr6\
set @NewLogDirectory =  'f:\' -- will drop old db and/or create directory
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass, @sourceDbName, @NewDbName, 
 @NewDbDirectory, @NewLogDirectory, 
 @AreaRestriction, 0
go
------------------------------------------------------------------
-- wrap-around tests edge-cases in zone algorithm -- about 1GB
declare 
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100) 
set @SourceDbVersion = 'DR5'
set @SourceDbDataClass = 'BEST'
set @NewDbName = 'BestDR5WrapAround'
set @AreaRestriction = '((ra between 0 and 1)  or (ra between 359 and 360)) and dec between -1 and 1'
set @SourceDbName = 'BestDR5'
set @NewDbDirectory =   'd:\' -- will go to directory f:\BestDR5WrapAround\
set @NewLogDirectory =  'd:\' 
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass, @sourceDbName, @NewDbName, 
 @NewDbDirectory, @NewLogDirectory, 
 @AreaRestriction, 0
go
---------------------------------------------------------------
-- 10 GB subset -- 3 volume version (takes an hour)
declare  
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100) 
set @SourceDbVersion = 'DR5'
set @SourceDbDataClass = 'BEST'
set @NewDbName       = 'BestDR5_10GB_EFG'
set @AreaRestriction = 'ra between 190 and 200 and dec between 0 and 6'
set @SourceDbName    = 'BestDR5'
set @NewDbDirectory  = 'E:\,F:\,G:\'  
set @NewLogDirectory = 'E:\,F:\,G:\'  
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass,@sourceDbName, @NewDbName, 
 			@NewDbDirectory, @NewLogDirectory, 
 			@AreaRestriction, 0
go
---------------------------------------------------------------
-- 10 GB subset -- 1 file version (takes 1/2 hour)
declare  
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100) 
set @SourceDbVersion = 'DR5'
set @SourceDbDataClass = 'BEST'
set @NewDbName       = 'BestDR5_10GB'
set @AreaRestriction = ''	-- null predicate
set @SourceDbName    = 'BestDR5_10GB_EFG'
set @NewDbDirectory  = 'G:\'  
set @NewLogDirectory = 'D:\'  
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass,@sourceDbName, @NewDbName, 
 			@NewDbDirectory, @NewLogDirectory, 
 			@AreaRestriction, 0
go
---------------------------------------------------------------
-- 100 GB subset -- 3 volume version (takes an 11.3 hrs)
declare  
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100) 
set @SourceDbVersion = 'DR5'
set @SourceDbDataClass = 'BEST'
set @NewDbName       = 'BestDR5_100GB_EFG'
set @AreaRestriction = 'ra between 180 and 215 and dec between -5 and 15'
set @SourceDbName    = 'BestDR5'
set @NewDbDirectory  = 'E:\,F:\,G:\'  
set @NewLogDirectory = 'E:\,F:\,G:\'  
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass, @sourceDbName, @NewDbName, 
 			@NewDbDirectory, @NewLogDirectory, 
 			@AreaRestriction, 0
go

---------------------------------------------------------------
-- 100 GB subset -- 1 volume version (takes an 11.3 hrs)
declare  
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100) 
set @SourceDbVersion = 'DR5'
set @SourceDbDataClass = 'BEST'
set @NewDbName       = 'BestDR5_100GB'
set @AreaRestriction = ''
set @SourceDbName    = 'BestDR5_100GB_EFG'
set @NewDbDirectory  = 'D:\'  
set @NewLogDirectory = 'D:\'  
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass, @sourceDbName, @NewDbName, 
 			@NewDbDirectory, @NewLogDirectory, 
 			@AreaRestriction, 0
go
---------------------------------------------------------------
-- SpecObj subset -- all spectro info and corresponding photo info. 
set nocount on
declare  
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100) 
set @SourceDbVersion = 'DR5'
set @SourceDbDataClass = 'BEST'
set @NewDbName       = 'BestDR5_Spec'
set @AreaRestriction = 'specObjID > 0'
set @SourceDbName    = 'BestDR5'
set @NewDbDirectory  = 'd:\'  
set @NewLogDirectory = 'd:\'  
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass, @sourceDbName, @NewDbName, 
 			@NewDbDirectory, @NewLogDirectory, 
 			@AreaRestriction, 0
insert BestDR5_Spec.dbo.holeObj select * from bestDR5.dbo.holeObj
go
---------------------------------------------------------------
-- Full copy  -- 3 volume Multi-file  version  
declare  
 @SourceDbVersion varchar(10),
 @SourceDbDataClass varchar(10),
 @NewDbName varchar(100),
 @AreaRestriction varchar(1000),
 @SourceDbName varchar(100),
 @NewDbDirectory varchar(100),
 @NewLogDirectory varchar(100),
 @MultiFile int  
set @SourceDbVersion = 'DR5'
set @SourceDbDataClass = 'BEST'
set @NewDbName       = 'BestDR5_EFG'
set @AreaRestriction = ''
set @SourceDbName    = 'BestDR5'
set @NewDbDirectory  = 'E:\,F:\,G:\'  
set @NewLogDirectory = 'E:\,F:\,G:\' 
set @MultiFile = 1 
exec spCopyDbSubset @SourceDbVersion, @SourceDbDataClass, @sourceDbName, @NewDbName, 
 			@NewDbDirectory, @NewLogDirectory, 
 			@AreaRestriction, @MultiFile
 