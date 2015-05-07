--=================================================================
-- FileGroups.sql
-- Author: Jim Gray, 2003-01-21
--
-- create table for filegroup mapping
-------------------------------------------------
-- History:
--
--* 2003-05-15 Alex: added truncate command for now
--* 2003-05-22 Alex: fixed a bunch of updates to Tiling, 
--*		separated off the index assignments
--* 2003-05-28 Alex: added support for indexFileGroup
--* 2004-09-15 Alex: filled in the values for the PartitionMap table
--* 2005-02-02 Alex: reduced the size of PhotoProfile from 0.900 to 0.450
--* 2005-12-13  Ani: Commented out Photoz table, not loaded any more.
--* 2006-02-01  Ani: Put Photoz table back in, tho' there will likely be
--*                  more than one now so this will have to be changed.
--* 2006-05-15  Ani: Added Photoz2, TargRunQA and QSO tables.
--* 2007-01-17  Ani: Added foreign key deletions for the tables to 
--*                  error when the tables are dropped.
--=================================================================
SET NOCOUNT ON;
GO

--=================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[PartitionMap ]')) 
    BEGIN
	IF EXISTS (select * from dbo.sysobjects 
		where id = object_id(N'[dbo].[spIndexDropSelection]')) 
	    EXEC spIndexDropSelection 0,0,'F','PartitionMap'
	drop table PartitionMap
    END
GO
--
CREATE TABLE PartitionMap (
-------------------------------------------------------------------------------
--/H Shows the names of partitions/filegroups and their relative sizes
--/A --------------------------------------------------------------------------
--/T 
-------------------------------------------------------------------------------
	fileGroupName 	varchar(100) NOT NULL,  	--/D name of table or index
	size		real NOT NULL,			--/D size in GB/million objects
	comment		varchar(4000),			--/D explanation
)
GO
--
INSERT PartitionMap values ('PRIMARY',		0.010	,'');
INSERT PartitionMap values ('PhotoObj',		1.907	,'');
INSERT PartitionMap values ('PhotoOther',	0.026	,'');
INSERT PartitionMap values ('PhotoTag',		0.293	,'');
INSERT PartitionMap values ('PhotoIndex',	0.708	,'');
INSERT PartitionMap values ('PhotoTagIndex',	0.635	,'');
INSERT PartitionMap values ('PhotoProfile',	0.450	,'');
INSERT PartitionMap values ('ObjMask',		0.241	,'');
INSERT PartitionMap values ('Frame',		0.409	,'');
INSERT PartitionMap values ('SpecObj',		0.086	,'');
INSERT PartitionMap values ('Neighbors',	0.322	,'');
GO



--=================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[FileGroupMap]')) 
    BEGIN
	IF EXISTS (select * from dbo.sysobjects 
		where id = object_id(N'[dbo].[spIndexDropSelection]')) 
	    EXEC spIndexDropSelection 0,0,'F','FileGroupMap'
	drop table FileGroupMap
    END
GO
--
CREATE TABLE FileGroupMap (
-------------------------------------------------------------------------------
--/H For "big" databases, maps big tables to their own file groups
--/A --------------------------------------------------------------------------
--/T In big databases we only put core objects in the primary file group.
--/T Other objects are grouped into separate file groups.
--/T For really big files, the indices are put in even different groups.
--/T This table is truncated in the Task databases.
-------------------------------------------------------------------------------
	tableName 	varchar(128) NOT NULL,  		--/D name of table or index
	tableFileGroup	varchar(100) NOT NULL,			--/D name of filegroup
	indexFileGroup	varchar(100) NOT NULL,			--/D name of the index filegroup
	comment		varchar(4000),				--/D explanation
)
GO
--
INSERT FileGroupMap values ('PrimaryFileGroup',	'PRIMARY'	,'PRIMARY'	,'');
INSERT FileGroupMap values ('PartitionMap',	'PRIMARY'	,'PRIMARY'	,'');
INSERT FileGroupMap values ('FileGroupMap',	'PRIMARY'	,'PRIMARY'	,'');
INSERT FileGroupMap values ('IndexMap',		'PRIMARY'	,'PRIMARY'	,'');
--
INSERT FileGroupMap values ('PhotoObjAll',	'PhotoObj'	,'PhotoIndex'	,'');
INSERT FileGroupMap values ('PhotoTag',		'PhotoTag'	,'PhotoTagIndex','');
INSERT FileGroupMap values ('PhotoProfile',	'PhotoProfile'	,'PhotoProfile'	,'');
INSERT FileGroupMap values ('ObjMask',		'ObjMask'	,'ObjMask'	,'');
INSERT FileGroupMap values ('Frame',		'Frame'		,'Frame'	,'');
--
INSERT FileGroupMap values ('PhotoZ',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('Photoz2',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('Chunk',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('Segment',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('Field',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('FieldProfile',	'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('Mask', 		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('MaskedObject',	'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('First',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('Rosat',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('USNO',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('ProfileDefs',	'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('StripeDefs',	'PhotoOther'	,'PhotoOther'	,'');
--
INSERT FileGroupMap values ('PlateX',		'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('SpecObjAll',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('SpecLineAll',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('SpecLineIndex',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('ElRedShift',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('XCRedshift',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('HoleObj',		'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('SpecPhotoAll',	'SpecObj'	,'SpecObj'	,'');
--
INSERT FileGroupMap values ('Target',		'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('TargetInfo',	'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('TargetParam',	'PhotoOther'	,'PhotoOther'	,'');
INSERT FileGroupMap values ('TargRunQA',	'PhotoOther'	,'PhotoOther'	,'');
--
INSERT FileGroupMap values ('TileAll',		'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('TilingRun',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('TilingNote',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('TilingGeometry',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('TiledTargetAll',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('TilingInfo',	'SpecObj'	,'SpecObj'	,'');
--
INSERT FileGroupMap values ('QsoBunch',		'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('QsoBest',		'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('QsoSpec',		'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('QsoTarget',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('QsoCatalogAll',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('QsoConcordanceAll','SpecObj'	,'SpecObj'	,'');
--
INSERT FileGroupMap values ('Sector',		'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('Sector2Tile',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('Best2Sector',	'SpecObj'	,'SpecObj'	,'');
INSERT FileGroupMap values ('Target2Sector',	'SpecObj'	,'SpecObj'	,'');
--
INSERT FileGroupMap values ('Neighbors',	'Neighbors'	,'Neighbors'	,'');
INSERT FileGroupMap values ('Zone',		'Neighbors'	,'Neighbors'	,'');
INSERT FileGroupMap values ('Match',		'Neighbors'	,'Neighbors'	,'');
INSERT FileGroupMap values ('MatchHead',	'Neighbors'	,'Neighbors'	,'');
go


--=========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[spTruncateFileGroupMap]')) 
	drop procedure spTruncateFileGroupMap
GO
--
CREATE PROCEDURE spTruncateFileGroupMap 
-----------------------------------------------------------
--/H Clear the values in the FileGroupMap table
--/A
--/T <PRE> EXEC spTruncateFileGroupMap 1</PRE>
-----------------------------------------------------------
AS
BEGIN
	TRUNCATE TABLE FileGroupMap
	RETURN
END
GO



--=========================================================
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[spSetDefaultFileGroup]')) 
	drop procedure spSetDefaultFileGroup
GO
--
CREATE PROCEDURE spSetDefaultFileGroup(@tableName nvarchar(100), @mode char(1)='T')
-----------------------------------------------------------
--/H Set default file group for table taken from the FileGroupMap table
--/A
--/T The stored procedure looks up the tableName in the FileGroupMap table.
--/T If it finds a match it sets the default file group as specified 
--/T for that table or index. If no mapping is found, the procedure 
--/T sets PRIMARY as the default.<br>
--/T If the @mode parameter is 'I', then it sets the DEFAULT to the
--/T indexFileGroup value for the table, otherwise to the filegroup 
--/T of the table itself.<br>
--/T <PRE> EXEC spSetDefaultFileGroup 'photoObjAll' </PRE>
-----------------------------------------------------------
AS BEGIN
	DECLARE	@cmd nvarchar(300),
		@fgroup varchar(300),
		@default varchar(300);
	--
	-- get the name of the current default filegroup
	--
	SELECT @default=UPPER(groupname)
	    FROM sysfilegroups
	    WHERE (status & 0x10)>0
	--
	-- get the name that we would like to set to,
	-- depending on the value of @mode
	--
	IF (@mode='T')
	    SELECT @fgroup = UPPER(tableFileGroup)
		FROM FileGroupMap WITH (nolock)
		WHERE tableName = @tableName
	ELSE
	    SELECT @fgroup = UPPER(indexFileGroup)
		FROM FileGroupMap WITH (nolock)
		WHERE tableName = @tableName
	--
	-- if none found, set it to PRIMARY
	--
	IF (@fgroup is null) SET @fgroup = 'PRIMARY';
	--
	-- build the command
	--
	SET @cmd = 'alter database '+  db_Name()
		+ ' modify filegroup ['+ @fgroup + '] default'
	--
	-- only execute if different from current default
	--
	IF (@default != @fgroup)  EXEC sp_executesql @cmd
	--
	RETURN
END
GO
-- tests
-- set to PhotoObj file group
-- EXEC spSetDefaultFileGroup 'photoObjAll'
--         generates alter database BESTDR1 modify filegroup photoObj default
-- return to primary
-- EXEC spSetDefaultFileGroup 'primary'
--   generates  alter database BESTDR1 modify filegroup [primary] default

PRINT '[FileGroup.sql]: PartitionMap, FileGroupMap tables and procs created'
GO
