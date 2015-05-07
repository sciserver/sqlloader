

---- Create Functions
USE BESTDR9
GO
/****** Object:  UserDefinedFunction [dbo].[fRegionsIntersectingBinary]    Script Date: 10/23/2012 12:35:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SELECT GETDATE()
GO
--
IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionsIntersectingBinary]'))
	drop function [dbo].[fRegionsIntersectingBinary]
GO
--
CREATE FUNCTION fRegionsIntersectingBinary(@types varchar(1000), @rBinary varbinary(max))
-------------------------------------------------------------
--/H Search for regions intersecting a given region,
--/H specified by a regionBinary.
-------------------------------------------------------------
--/T Regions are found within the RegionPatch table using the HTM 
--/T index. If @rBinary is present, @rString is ignored.
--/T Returns the regionid and the type.
--/T <samp>
--/T select * from dbo.fRegionsIntersectingBinary('STRIPE, STAVE, TILE', @bin)
--/T </samp>
-------------------------------------------------
RETURNS @out TABLE (
	regionid bigint NOT NULL, 
	isMask tinyint NOT NULL,
	type varchar(16) NOT NULL,
	comment varchar(1024) NOT NULL
	)
AS BEGIN
	--
	DECLARE @bin varbinary(max), @a float, @radius float;
	------------------------------
	-- check if region valid
	------------------------------
	IF (@rBinary is not null)
	BEGIN
		IF (coalesce(dbo.fSphGetArea(@rBinary),0) = 0) RETURN;
	END
	---------------------------
	-- parse the types
	---------------------------
	DECLARE @typesTable TABLE (
		type varchar(16) 
		COLLATE SQL_Latin1_General_CP1_CI_AS 
		NOT NULL  PRIMARY KEY,
		radius float NOT NULL
	);
	----------------------------------------------------
	SET @types = REPLACE(@types,',',' ');
	INSERT @typesTable (type, radius)
	    SELECT *, 0 FROM dbo.fTokenStringToTable(@types) 
	IF (@@rowcount = 0) RETURN
	--
	UPDATE @typesTable
		SET radius = q.radius
	FROM @typesTable t, RegionTypes q
	WHERE t.type=q.type
	--
	DECLARE @htm TABLE (
		HtmIdStart bigint not null,
		HtmIdEnd bigint not null
	);

	DECLARE @region TABLE (
		regionid bigint NOT NULL
		);

	----------------------------------------
	-- fetch the POLYGONs through HTM
	----------------------------------------
	IF EXISTS (select * from @typesTable where type='POLYGON')
	BEGIN
		SELECT @radius = radius/60 
		FROM RegionTypes
		WHERE type='POLYGON'
		--
		SELECT @bin = dbo.fSphGrow(@rBinary,@radius);
		--
		DELETE @htm;
		--
		INSERT @htm 
		SELECT htmIdStart, htmIdEnd 
		FROM dbo.fHtmCoverBinaryAdvanced(@rBinary)
		--
		INSERT @region
		SELECT distinct r.regionid
		FROM @htm h, RegionPatch r WITH (nolock)
		WHERE htmid BETWEEN h.htmIdStart AND h.htmIdEnd
		  and r.type='POLYGON'
		--
		DELETE @typesTable where type='POLYGON';
		--
	END
	----------------------------------------
	-- fetch the TILE etc through HTM
	----------------------------------------
	IF EXISTS (select * from @typesTable where type in ('PLATE', 'PLATEALL', 'TILE', 'TILEALL'))
	BEGIN
		--
		SELECT @radius = radius/60 
		FROM RegionTypes
		WHERE type='TILE'
		--
		SELECT @bin = dbo.fSphGrow(@rBinary,@radius);
		--
		DELETE @htm;
		--
		INSERT @htm 
		SELECT htmIdStart, htmIdEnd 
		FROM dbo.fHtmCoverBinaryAdvanced(@rBinary)
		--
		INSERT @region
		SELECT distinct r.regionid
		FROM @htm h, RegionPatch r WITH (nolock)
		WHERE htmid BETWEEN h.htmIdStart AND h.htmIdEnd
		  and r.type in ('PLATE', 'PLATEALL', 'TILE', 'TILEALL')
		  and r.type in (select type from @typesTable)
		--
		DELETE @typesTable where type in ('PLATE', 'PLATEALL', 'TILE', 'TILEALL');
	END
	--------------------------------------------------
	-- Insert the remaining region types to be tested
	-- Use RegionPatch because of the type index.
	--------------------------------------------------
	INSERT @region
	SELECT distinct r.regionid
	FROM RegionPatch r, @typesTable t
	WHERE r.type=t.type
	-------------------------------
	-- add the remaining types
	-- to be searched
	-------------------------------
	INSERT @out
	SELECT r.regionid, r.isMask, r.type, r.comment
	FROM @region h, Region r
	WHERE r.regionid=h.regionid
		  and dbo.fSphIntersect(r.regionBinary,@rBinary) is not null
	
	RETURN
END

GO
USE BESTDR9
GO
/****** Object:  UserDefinedFunction [dbo].[fRegionsIntersectingString]    Script Date: 10/23/2012 12:37:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (select * from dbo.sysobjects 
	where id = object_id(N'[dbo].[fRegionsIntersectingString]'))
	drop function [dbo].[fRegionsIntersectingString]
GO
--
CREATE FUNCTION fRegionsIntersectingString(@types varchar(1000), @rString varchar(max))
-------------------------------------------------------------
--/H Search for regions intersecting a given region,
--/H specified by a regionString.
-------------------------------------------------------------
--/T Regions are found within the RegionPatch table using the HTM 
--/T index. If @rBinary is present, @rString is ignored.
--/T Returns the regionid and the type.
--/T <samp>
--/T select * from dbo.fRegionsIntersectingString('STRIPE, STAVE, TILE', @str)
--/T </samp>
-------------------------------------------------
RETURNS @out TABLE (
	regionid bigint PRIMARY KEY, 
	isMask tinyint,
	type varchar(16),
	comment varchar(1024)
	)
AS BEGIN
	--
	DECLARE @rBinary varbinary(max), @a float;
	------------------------------
	-- check if region valid
	------------------------------
	IF (@rString = '') RETURN;
	--
	SELECT @rBinary = dbo.fSphSimplifyString(@rString);
	IF (@rBinary is not null)
	BEGIN
		SELECT @a = dbo.fSphGetArea(@rBinary);
		IF (@a is null or @a=0) RETURN;
	END
	-----------------------------------------------------
	-- call the function with the regionBinary argument
	-----------------------------------------------------
	INSERT @out
	SELECT * FROM dbo.fRegionsIntersectingBinary(@types, @rBinary);
	--
	RETURN
END

GO

----- create table RegionTypes


USE BESTDR9
GO
/****** Object:  Table [dbo].[RegionTypes]    Script Date: 10/26/2012 16:29:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[RegionTypes](
	[type] [varchar](16) NOT NULL,
	[radius] [float] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING ON
GO
