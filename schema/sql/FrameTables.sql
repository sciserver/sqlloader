------------------------------------------------------------------------
--   FrameTables.sql
--   2001-02-14 Alex Szalay
------------------------------------------------------------------------
-- Schema for the Frame related tables in SkyServer
------------------------------------------------------------------------
-- History:
--* 2001-04-10	Jim: Moved index creation to happen after load.
--* 2001-05-15	Alex: changed spMakeFrame to join to Segment
--* 2001-11-06	Alex: added bunch of comments, plus separate PRIMARYKEYs
--* 2001-11-10	Alex+Jan: changed SP's from fXXX to spXX, also fixed 
--*		TilingPlan primary key constraint
--* 2001-12-02	Alex: moved the Globe table here
--* 2002-09-10	Alex: changed fTileFileName and spMakeFrame
--* 2002-09-20	Alex: changed tile in Globe, Frame and Mosaic to img to avoid confusion
--* 2002-09-20	Alex: fixed units, added UCDs
--* 2002-10-26	Alex: moved PK's to separate file
--* 2002-11-26	Alex: removed Mosaic related functions and Tables
--* 2003-01-26   Jim:  added Frame File group mapping
--* 2003-05-15	Alex: added reset filegroup to primary to the end
--* 2003-05-25	Alex: moved fEqFromMuNu and fMuNuFromEq to boundary.sql
--* 2003-05-28	Alex: removed Globe table
--* 2003-12-04   Jim: for SQL best practices  
--*              put FOR UPDATE clause in frames_cursor of spComputeFrame
--* 2010-04-20  Ani/Naren: SDSS-III updates - Frame table schema changes, spMakeFrame
--*             replaced with JPEG 2000 version and fTileFileName updated (do not use
--*             DTS any more).
--* 2010-12-11  Ani: Removed "dbo." from fTileFileName.
--* 2012-10-31  Ani: Commented out upper left hand corner ra,dec and mu,nu
--*             calculation from spComputeFrameHTM as requested by Alex.
--*             This was resulting in incorrect mu,nu values in Frame.
------------------------------------------------------------------------
SET NOCOUNT ON
GO


--===========================================================
IF EXISTS (SELECT name FROM sysobjects 
	WHERE name = 'Frame') 
	DROP TABLE Frame
GO
EXEC spSetDefaultFileGroup 'Frame'
GO
--
CREATE TABLE Frame (
-------------------------------------------------------------------------------
--/H Contains JPEG images of fields at various zoom factors, and their astrometry.
--
--/T The frame is the basic image unit. The table contains 
--/T false color JPEG images of the fields, and their most
--/T relevant parameters, in particular the coefficients of
--/T the astrometric transformation, and position info. 
--/T The images are stored at several zoom levels.
-------------------------------------------------------------------------------

	fieldID		bigint 	NOT NULL,	--/D Link to the field table --/K ID_FIELD
	zoom		int  	NOT NULL,	--/D Zoom level 2^(zoom/10) --/K INST_SCALE
	run		int  	NOT NULL,	--/D Run number --/K OBS_RUN
	rerun		int  	NOT NULL,	--/D Rerun number --/K ID_NUMBER
	camcol 		int  	NOT NULL,	--/D Camera column --/K INST_ID
	field		int  	NOT NULL,	--/D Field number --/K ID_FIELD
	[stripe]	int  	NOT NULL,	--/D Stripe number --/K ID_AREA
	strip		[varchar](32)  	NOT NULL,	--/D Strip number (N or S) --/K ID_AREA
	a 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg --/K POS_TRANS_PARAM
	b 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg/pix --/K POS_TRANS_PARAM
	c 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg/pix --/K POS_TRANS_PARAM
	d 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg --/K POS_TRANS_PARAM
	e 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg/pix --/K POS_TRANS_PARAM
	f 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg/pix  --/K POS_TRANS_PARAM
	node 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg --/K POS_TRANS_PARAM
	incl 		float 	NOT NULL,	--/D Astrometric coefficient --/U deg --/K POS_INCLIN
	raMin 		float 	NOT NULL,	--/D Min of ra --/U deg --/K POS_EQ_RA_OTHER
	raMax 		float 	NOT NULL,	--/D Max of ra --/U deg --/K POS_EQ_RA_OTHER
	decMin 		float 	NOT NULL,	--/D Min of dec	--/U deg --/K POS_EQ_DEC_OTHER
	decMax 		float 	NOT NULL,	--/D Max of dec --/U deg --/K POS_EQ_DEC_OTHER
	mu		float 	NOT NULL default 0,  --/D Survey mu of frame center--/U deg --/K POS_SDSS_MU
	nu		float 	NOT NULL default 0,  --/D Survey nu of frame center --/U deg --/K POS_SDSS_NU
	ra		float 	NOT NULL default 0,  --/D Ra of frame center --/U deg --/K POS_EQ_RA_MAIN
	[dec]		float 	NOT NULL default 0,  --/D Dec of frame center --/U deg --/K POS_EQ_RA_MAIN
	cx 		float 	NOT NULL default 0,  --/D Cartesian x of frame center --/K POS_EQ_CART_X
	cy 		float 	NOT NULL default 0,  --/D Cartesian y of frame center --/K POS_EQ_CART_Y
	cz 		float 	NOT NULL default 0,  --/D Cartesian z of frame center --/K POS_EQ_CART_Z
	htmID		bigint 	NOT NULL default 0,  --/D The htmID for point at frame center --/K CODE_MISC
	img 		[varbinary](max)	NOT NULL default 0x1111 --/D The image in JPEG format --/K IMAGE?  
)  
GO
--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


--=========================================================
-- STORED PROCEDURES AND FUNCTIONS
--=========================================================


--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spComputeFrameHTM]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spComputeFrameHTM]
GO
--
CREATE PROCEDURE spComputeFrameHTM
-------------------------------------------------------------------------------
--/H Compute the HTM and the other params for a Frame.
--/A
--/T Needs to be run as the last step of the Frame loading.
--/T It should be executed automatically by a DTS script.
-------------------------------------------------------------------------------
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
	@a FLOAT, @b FLOAT, @c FLOAT, 
	@d FLOAT, @e FLOAT, @f FLOAT, 
	@node FLOAT, @incl FLOAT,
	@stripe INT,
	-- new computed quantities 
	@ra FLOAT, @dec FLOAT, 
	@mu FLOAT, @nu FLOAT,
	@cx FLOAT, @cy FLOAT, @cz FLOAT,
	@ra1 FLOAT, @dec1 FLOAT, 
	@node1 FLOAT, @incl1 FLOAT
    ------------------------------------
    -- frames_cursor scans Frame table
    DECLARE frames_cursor CURSOR
	FOR SELECT a, b, c, d, e, f, node, incl, [stripe]
       	    FROM dbo.Frame
	    FOR UPDATE OF ra, [dec], cx, cy, cz, mu, nu, htmID  
    OPEN frames_cursor;
    -------------------------------------------------------------
    -- Now for each record, do the computation and update the record.
    WHILE (1 = 1) 		-- do till end of  table.
   	BEGIN
	FETCH NEXT FROM frames_cursor
		INTO  	@a, @b, @c, @d, @e, @f, 
			@node, @incl, @stripe
  	IF (@@FETCH_STATUS != 0) BREAK;
	--
	-- compute the quantities for the frame center
	--
	SET @mu = @a + @b*744.5 + @c*1024;
	SET @nu = @d + @e*744.5 + @f*1024;
	SELECT @ra=ra, @dec=[dec], @cx=cx, @cy=cy, @cz=cz
	    FROM dbo.fEqFromMuNu(@mu,@nu,@node,@incl);
/*	Commented out as per Alex's request 10/31/12 
	--
	-- do the ra,dec of the upper left hand corner
	--
	SET @mu = @a;
	SET @nu = @d;
	SELECT @ra1=ra, @dec1=[dec]
	    FROM dbo.fEqFromMuNu(@a,@d,@node,@incl);
	--
	-- the idealized stripe has node1=95.0 and incl1 tied to the stripe
	--
	SET @node1 = 95.0;
	SET @incl1 = 2.5*(@stripe-10);
	IF @incl1>150 SET @incl1 = @incl1 - 180.0;
	--
	SELECT @mu=mu, @nu=nu 
	    FROM dbo.fMuNuFromEq(@ra1,@dec1,@stripe,@node1,@incl1);
*/
	-------------------------------------------
	UPDATE Frame 
	    SET [ra]  = @ra, 
		[dec] = @dec, 
		cx    = @cx, 
		cy    = @cy, 
		cz    = @cz,
		mu    = @mu,
		nu    = @nu,
		htmID = 0
	WHERE CURRENT OF frames_cursor;
 	END
    --================================================================
    -- cleanup, close and deallocate the cursor.   
    CLOSE frames_cursor;
    DEALLOCATE frames_cursor;
    --
    UPDATE Frame
	SET htmid = dbo.fHtmXyz(cx,cy,cz);
    --
END
GO





--===========================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[spMakeFrame]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	drop procedure [dbo].[spMakeFrame]
GO
--
CREATE PROCEDURE spMakeFrame(  @dbname varchar(256)
, @Dir Varchar(256)
, @run int
)
-------------------------------------------------------------------------------
--/H Build the the Frame from the Field table for a given run
--/A 
--/T A support procedure, only used by spLoadZoom.
-------------------------------------------------------------------------------
AS
BEGIN
SET NOCOUNT ON;

Declare 
  @sql nvarchar(max)
, @TableName varchar(20)
, @FilePath varchar(1000)
, @rowcount int
, @i int
, @j int
, @fieldid BIGint
, @ImgZoom int;

Set @rowcount =0;
Set @i = 1;
Set @j = 1;
--Set @run = 4623;
--Set @dir = '\\sdss3a\data\staging\4623\137\Zoom\';
Set @TableName = @dbname+'.'+'dbo.Frame';


Declare @TempFrame TABLE(
	[fieldID] [bigint] NOT NULL,
	[zoom] [int] NOT NULL,
	[run] [int] NOT NULL,
	[rerun] [int] NOT NULL,
	[camcol] [int] NOT NULL,
	[field] [int] NOT NULL,
	[stripe] [int] NOT NULL,
	[strip] [varchar](32) NOT NULL,
	[a] [float] NOT NULL,
	[b] [float] NOT NULL,
	[c] [float] NOT NULL,
	[d] [float] NOT NULL,
	[e] [float] NOT NULL,
	[f] [float] NOT NULL,
	[node] [float] NOT NULL,
	[incl] [float] NOT NULL,
	[raMin] [float] NOT NULL,
	[raMax] [float] NOT NULL,
	[decMin] [float] NOT NULL,
	[decMax] [float] NOT NULL,
	[img] [varbinary](max) NULL,
	[FileName][varchar](1000) not null,
	[FilePath][varchar](1000) nul)


--Inserting the Frames data from Field and Run Tables for different Zoom Levels into the Temp Frame Table

INSERT INTO @TempFrame
           ([fieldID] ,[zoom] ,[run]  ,[rerun]  ,[camcol] ,[field]  ,[stripe] ,[strip] ,[a]  ,[b] ,[c] ,[d] ,[e],[f]  ,[node]  ,[incl] ,[raMin] ,[raMax]  ,[decMin]  ,[decMax]  ,[FileName])

SELECT 		fieldID ,0 as zoom ,f.run ,f.rerun ,f.camcol  ,f.field  ,r.stripe ,r.strip ,f.a_r ,f.b_r ,f.c_r ,f.d_r ,f.e_r ,f.f_r ,r.node ,r.incl ,f.raMin ,f.raMax ,f.decMin ,f.decMax ,dbo.fTileFileName(0, r.run, r.rerun, f.camcol, f.field, @dir) as FileName
 FROM Field f , Run r    WHERE    f.run=r.run and r.run = @run

UNION ALL

SELECT 		fieldID ,12 as zoom ,f.run ,f.rerun ,f.camcol  ,f.field  ,r.stripe ,r.strip ,f.a_r ,f.b_r ,f.c_r ,f.d_r ,f.e_r ,f.f_r ,r.node ,r.incl ,f.raMin ,f.raMax ,f.decMin ,f.decMax ,dbo.fTileFileName(12, r.run, r.rerun, f.camcol, f.field, @dir) as FileName
 FROM Field f , Run r    WHERE    f.run=r.run and r.run = @run
 
UNION ALL

SELECT 		fieldID ,25 as zoom ,f.run ,f.rerun ,f.camcol  ,f.field  ,r.stripe ,r.strip ,f.a_r ,f.b_r ,f.c_r ,f.d_r ,f.e_r ,f.f_r ,r.node ,r.incl ,f.raMin ,f.raMax ,f.decMin ,f.decMax ,dbo.fTileFileName(25, r.run, r.rerun, f.camcol, f.field, @dir) as FileName
 FROM Field f , Run r    WHERE    f.run=r.run and r.run = @run

UNION ALL

SELECT 		fieldID ,50 as zoom ,f.run ,f.rerun ,f.camcol  ,f.field  ,r.stripe ,r.strip ,f.a_r ,f.b_r ,f.c_r ,f.d_r ,f.e_r ,f.f_r ,r.node ,r.incl ,f.raMin ,f.raMax ,f.decMin ,f.decMax ,dbo.fTileFileName(50, r.run, r.rerun, f.camcol, f.field, @dir) as FileName
 FROM Field f , Run r    WHERE    f.run=r.run and r.run = @run

 
 -- Inserting data from the @TempFrame data into Frame Table

INSERT INTO Frame
           ([fieldID] ,[zoom] ,[run]  ,[rerun]  ,[camcol] ,[field]  ,[stripe] ,[strip] ,[a]  ,[b] ,[c] ,[d] ,[e],[f]  ,[node]  ,[incl] ,[raMin] ,[raMax]  ,[decMin]  ,[decMax] )
     
Select [fieldID]    ,[zoom]   ,[run]   ,[rerun] ,[camcol] ,[field]  ,[stripe] ,[strip] ,[a]  ,[b] ,[c] ,[d] ,[e],[f]  ,[node]  ,[incl] ,[raMin] ,[raMax]  ,[decMin]  ,[decMax]
     from @TempFrame 
 

--Updating the @TempFrame table for the FileName Sql Statement

Update @TempFrame 
Set FilePath = '(SELECT * FROM OPENROWSET(BULK N'''+FileName+''', SINGLE_BLOB) AS Document)' 

-- Reading the Frame data into a temp table for the Update Img Path

Select rowid = identity(int,1,1),fieldid,zoom, 'UPDATE '+@TableName+' Set img = '+''+FilePath+''  as SqlStatement
into #FieldImg
from @TempFrame

Select @rowcount = @@ROWCOUNT

-- Uploading the images from the FileSystem by the row-row updation.

While(@i<=@rowcount)
Begin

Select 
@fieldid = CAST(fieldid AS BIGINT)
,@ImgZoom = CAST(zoom AS INT)
,@sql = SqlStatement + ' WHERE FIELDID = '+''''+ CAST (FIELDID AS VARCHAR)+ '''' +' AND ZOOM = '+ CAST (ZOOM AS VARCHAR)
from 
#FieldImg
Where rowid = @i

EXEC (@sql)

Set @i = @i + 1
End

-- Droping the Temp Table.
Drop Table #FieldImg
END
GO
--





--===========================================================

if exists (select * from dbo.sysobjects 
	where id = object_id(N'fTileFileName') 
	and xtype in (N'FN', N'IF', N'TF'))
	drop function fTileFileName
GO

CREATE FUNCTION fTileFileName (@zoom int, 
	@run int, @rerun int,@camcol int, @field int,@imagedir varchar(max))  
-------------------------------------------------------------------------------
--/H Builds the filename for Frame, used in spMakeFrame.
--/A 
--/T Another one of the service functions, used only when loading the database.
-------------------------------------------------------------------------------
RETURNS nvarchar(1000)
AS BEGIN
    DECLARE @TheName nVARCHAR(1000), @field4 char(4), 
	@run6 char(6), @c1 char(1), @z2 char(2),@img varbinary(max),@sql varchar(max);
	-----------------------------------------
	SET @field4 = cast( @field as varchar(4));
	SET @field4 = substring('0000',1,4-len(@field4)) + @field4;
	SET @run6 = cast( @run as varchar(6));
	SET @run6 = substring('000000',1,6-len(@run6)) + @run6;
	SET @z2 = cast( @zoom as varchar(2));
	SET @z2 = substring('00',1,2-len(@z2)) + @z2;
	SET @c1   = cast(@camcol as char(1));
	--
	SET @TheName = @imagedir + @c1 + '\' + 'frame-' + @run6 +'-'
			+ @c1+'-'+cast(@rerun as varchar(4))+'-'
			+ @field4 +'-z'+@z2+ '.jp2';
			

   
	RETURN @TheName;
END
GO
--


PRINT '[FrameTables.sql]: Frame table and related procedures created'
GO
