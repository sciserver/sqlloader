USE [SphRegion]
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spAppendHtmRange') 
drop procedure fps.spAppendHtmRange
GO
CREATE PROC [fps].[spAppendHtmRange]
	@RegionID bigint,
	@FullOnly bit,
	@HtmIDStart bigint,
	@HtmIDEnd bigint
AS
	INSERT RegionHtm
		(RegionID, FullOnly, HtmIDStart, HtmIDEnd)
	VALUES
		(@RegionID, @FullOnly, @HtmIDStart, @HtmIDEnd)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'fSplit') 
drop function fps.fSplit
GO
CREATE FUNCTION [fps].[fSplit]
(
	@str varchar(max)
)
RETURNS 
@ret TABLE 
(
	ID bigint
)
AS
BEGIN

	DECLARE @start bigint
	DECLARE @end bigint

	SET @start = 0
	SET @end = CHARINDEX(',', @str, @start)
	
	WHILE (@end <> 0)
	BEGIN
		INSERT @ret
		VALUES (CAST(SUBSTRING(@str, @start, @end - @start) AS bigint))

		SET @start = @end + 1
		SET @end = CHARINDEX(',', @str, @start)
	END

	IF (@start <> 0)
	BEGIN
		INSERT @ret
		VALUES (CAST(SUBSTRING(@str, @start, LEN(@str) - @start + 1) AS bigint))		
	END
	
	RETURN 
END
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name =  N'fGetRegionGroupCacheID') 
drop function fps.fGetRegionGroupCacheID
GO
CREATE FUNCTION [fps].[fGetRegionGroupCacheID]
(
	@GroupID bigint
)
RETURNS bigint
AS
BEGIN
	DECLARE @id bigint

	SELECT @id = RegionID
	FROM RegionGroup
	WHERE GroupID = @GroupID

	RETURN @id
END
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spModifyRegion') 
drop procedure fps.spModifyRegion
go
CREATE PROC [fps].[spModifyRegion]
	@UserGUID uniqueidentifier,
	@RegionID bigint,
	@Public tinyint,
	@CustomID bigint,
	@Area float,
	@FillFactor float,
	@Type varchar(16),
	@Mask tinyint,
	@GroupType tinyint,
	@Comment ntext,
	@RegionString ntext,
	@RegionBinary varbinary(max)
AS

	UPDATE Region
	SET [Public] = @Public,
		CustomID = @CustomID,
		Area = @Area,
		[FillFactor] = @FillFactor,
		[Type] = @Type,
		Mask = @Mask,
		GroupType = @GroupType,
		Comment = @Comment,
		RegionString = @RegionString,
		RegionBinary = @RegionBinary
	WHERE RegionID = @RegionID AND UserGUID = @UserGUID
		

	RETURN @@ROWCOUNT
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'fCheckUserAccessRegionGroup') 
drop function fps.fCheckUserAccessRegionGroup
go
CREATE FUNCTION [fps].[fCheckUserAccessRegionGroup]
(
	@UserGUID uniqueidentifier,
	@GroupID bigint
)
RETURNS int
AS
BEGIN
	
	DECLARE @cnt int
	
	SELECT @cnt = COUNT(*) FROM RegionGroup
	WHERE GroupID = @GroupID AND UserGUID = @UserGUID

	RETURN @cnt

END
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spGetRegionGroup') 
drop procedure fps.spGetRegionGroup
go
CREATE PROC [fps].[spGetRegionGroup]
	@UserGUID uniqueidentifier,
	@GroupID bigint
AS
	SELECT * FROM RegionGroup
	WHERE
		GroupID = @GroupID
		AND (UserGUID = @UserGUID OR [Public] > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spFindRegionGroups') 
drop procedure fps.spFindRegionGroups
go
CREATE PROC [fps].[spFindRegionGroups]
	@Description nvarchar(256),
	@GroupType tinyint,
	@DateCreatedFrom datetime,
	@DateCreatedTo datetime,
	@DateModifiedFrom datetime,
	@DateModifiedTo datetime,
	@Comment nvarchar(256)
AS
	
	SELECT * FROM RegionGroup
	WHERE
		(Description LIKE '%' + @Description + '%' OR @Description = '')
		AND
		(GroupType = @GroupType OR @GroupType IS NULL)
		AND
		(@DateCreatedFrom <= DateCreated OR @DateCreatedFrom IS NULL)
		AND
		(@DateCreatedTo >= DateCreated OR @DateCreatedTo IS NULL)
		AND
		(@DateModifiedFrom <= DateModified OR @DateModifiedFrom IS NULL)
		AND
		(@DateModifiedTo >= DateModified OR @DateModifiedTo IS NULL)
		AND
		(Comment LIKE '%' + @Comment + '%' OR @Comment = '')
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'fCheckUserAccessRegion') 
drop function fps.fCheckUserAccessRegion
go
CREATE FUNCTION [fps].[fCheckUserAccessRegion]
(
	@UserGUID uniqueidentifier,
	@RegionID bigint
)
RETURNS int
AS
BEGIN
	
	DECLARE @cnt int
	
	SELECT @cnt = COUNT(*) FROM Region
	WHERE RegionID = @RegionID AND UserGUID = @UserGUID

	RETURN @cnt

END
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spQueryRegionGroupsByUserGUID') 
drop procedure fps.spQueryRegionGroupsByUserGUID
go
CREATE PROC [fps].[spQueryRegionGroupsByUserGUID]
	@UserGUID uniqueidentifier
AS
	SELECT * FROM RegionGroup
	WHERE UserGUID = @UserGUID
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spDeleteRegion') 
drop procedure fps.spDeleteRegion
go
CREATE PROC [fps].[spDeleteRegion]
	@UserGUID uniqueidentifier,
	@RegionID bigint
AS
	-- cache region won't update!

	-- user access check ***
	IF (fps.fCheckUserAccessRegion(@UserGUID, @RegionID) = 0)
	RETURN -1		-- access denied

	DELETE RegionGroupLink
	WHERE RegionID = @RegionID

	-- other delete things

	DELETE RegionHalfspace
	WHERE RegionID = @RegionID

	DELETE RegionHtm
	WHERE RegionID = @RegionID

	DELETE RegionPatch
	WHERE RegionID = @RegionID

	-- delete region

	DELETE Region
	WHERE RegionID = @RegionID
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spQueryRegionsByGroupID') 
drop procedure fps.spQueryRegionsByGroupID
go
CREATE PROC [fps].[spQueryRegionsByGroupID]
	@UserGUID uniqueidentifier,
	@GroupID bigint,
	@RecFrom int,
	@RecCount int,

	@AllCount int OUTPUT
AS
	
	WITH Regions AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY Region.RegionID) AS rn,
			   Region.*
		FROM Region
		INNER JOIN RegionGroupLink
		ON RegionGroupLink.RegionID = Region.RegionID
		WHERE
			RegionGroupLink.GroupID = @GroupID
			AND (Region.UserGUID = @UserGUID OR Region.[Public] > 0)
	)

		SELECT * FROM Regions
		WHERE (rn >= @RecFrom AND rn < @RecFrom + @RecCount) OR
				@RecFrom IS NULL

-- count
		SELECT @AllCount = COUNT(*)
		FROM Region
		INNER JOIN RegionGroupLink
		ON RegionGroupLink.RegionID = Region.RegionID
		WHERE
			RegionGroupLink.GroupID = @GroupID
			AND (Region.UserGUID = @UserGUID OR Region.[Public] > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spGetRegionGroupCache') 
drop procedure fps.spGetRegionGroupCache
go
CREATE PROC [fps].[spGetRegionGroupCache]
	@UserGUID uniqueidentifier,
	@GroupID bigint
AS
	-- user access check
	IF (fps.fCheckUserAccessRegionGroup(@UserGUID, @GroupID) = 0)
	RETURN -1		-- access denied

	-- cache lookup
	DECLARE @cacheId bigint

	SELECT @cacheId = RegionID
	FROM RegionGroup
	WHERE GroupID = @GroupID

	IF (@cacheID IS NULL)	-- no cache, single region
	BEGIN
		SELECT TOP 1 * FROM Region
		INNER JOIN RegionGroupLink
		ON RegionGroupLink.RegionID = Region.RegionID
		WHERE
			RegionGroupLink.GroupID = @GroupID
	END
	ELSE
	BEGIN
		SELECT * FROM Region WHERE RegionID = @cacheID
	END
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spGetRegionGroupCache_v2') 
drop procedure fps.spGetRegionGroupCache_v2
go
CREATE PROC [fps].[spGetRegionGroupCache_v2]
	@UserGUID uniqueidentifier,
	@GroupID bigint
AS
	-- user access check
	IF (fps.fCheckUserAccessRegionGroup(@UserGUID, @GroupID) = 0)
	RETURN -1		-- access denied

	-- cache lookup
	DECLARE @cacheId bigint

	SELECT @cacheId = RegionID
	FROM RegionGroup
	WHERE GroupID = @GroupID

	IF (@cacheID IS NULL)	-- no cache, single region
	BEGIN
		SELECT TOP 1 Region.RegionID, GroupType, UserGUID, [Public], DateCreated, CustomID,
			   Area, [FillFactor], [Type], Mask, Comment FROM Region
		INNER JOIN RegionGroupLink
		ON RegionGroupLink.RegionID = Region.RegionID
		WHERE
			RegionGroupLink.GroupID = @GroupID
	END
	ELSE
	BEGIN
		SELECT RegionID, GroupType, UserGUID, [Public], DateCreated, CustomID,
			   Area, [FillFactor], [Type], Mask, Comment
		FROM Region WHERE RegionID = @cacheID
	END
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spGetRegion') 
drop procedure fps.spGetRegion
go
CREATE PROC [fps].[spGetRegion]
	@UserGUID uniqueidentifier,
	@RegionID bigint
AS

	SELECT  Region.RegionID,
			Region.GroupType,
			Region.UserGUID,
			Region.[Public],
			Region.DateCreated,
			Region.CustomID,
			Region.Area,
			Region.[FillFactor],
			Region.[Type],
			Region.Mask,
			Region.Comment,
			Region.RegionString,
			Region.RegionBinary
	FROM Region
	WHERE
		RegionID = @RegionID
		AND (UserGUID = @UserGUID OR [Public] > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spGetRegionThumbnail') 
drop procedure fps.spGetRegionThumbnail
go
CREATE PROC [fps].[spGetRegionThumbnail]
	@UserGUID uniqueidentifier,
	@RegionID bigint
AS

	SELECT  Region.Thumbnail
	FROM Region
	WHERE
		RegionID = @RegionID
		AND (UserGUID = @UserGUID OR [Public] > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name =N'spSetRegionThumbnail') 
drop procedure fps.spSetRegionThumbnail
go
CREATE PROC [fps].[spSetRegionThumbnail]
	@UserGUID uniqueidentifier,
	@RegionID bigint,
	@Thumbnail varbinary(max)
AS

	UPDATE Region
	SET Thumbnail = @Thumbnail
	WHERE
		RegionID = @RegionID
		--AND (UserGUID = @UserGUID OR [Public] > 0)

	RETURN @@ROWCOUNT
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spSetRegionPublicFlag') 
drop procedure fps.spSetRegionPublicFlag
go
CREATE PROC [fps].[spSetRegionPublicFlag]
	@UserGUID uniqueidentifier,
	@RegionID bigint

AS
	DECLARE @pmax tinyint
	
	SELECT @pmax = MAX([Public])
	FROM RegionGroup
	INNER JOIN RegionGroupLink
		ON RegionGroupLink.GroupID = RegionGroup.GroupID
	WHERE
		RegionGroupLink.RegionID = @RegionID

	UPDATE Region
	SET [Public] = ISNULL(@pmax, 0)
	WHERE RegionID = @RegionID
		AND UserGUID = @UserGUID
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spQueryRegionsByGroupID_v2') 
drop procedure fps.spQueryRegionsByGroupID_v2
go
CREATE PROC [fps].[spQueryRegionsByGroupID_v2]
	@UserGUID uniqueidentifier,
	@GroupID bigint,
	@RecFrom int,
	@RecCount int,

	@AllCount int OUTPUT
AS
	
-- count
		SELECT @AllCount = COUNT(*)
		FROM Region
		INNER JOIN RegionGroupLink
		ON RegionGroupLink.RegionID = Region.RegionID
		WHERE
			RegionGroupLink.GroupID = @GroupID
			AND (Region.UserGUID = @UserGUID OR Region.[Public] > 0);


	WITH Regions AS
	(
		SELECT ROW_NUMBER() OVER (ORDER BY Region.RegionID) AS rn,
			   Region.*
		FROM Region
		INNER JOIN RegionGroupLink
		ON RegionGroupLink.RegionID = Region.RegionID
		WHERE
			RegionGroupLink.GroupID = @GroupID
			AND (Region.UserGUID = @UserGUID OR Region.[Public] > 0)
	)

		SELECT RegionID, GroupType, UserGUID, [Public], DateCreated, CustomID, Area,
			   [FillFactor], [Type], Mask, Comment
		FROM Regions
		WHERE (rn >= @RecFrom AND rn < @RecFrom + @RecCount) OR
				@RecFrom IS NULL
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spSetRegionPublicFlagByGroupID') 
drop procedure fps.spSetRegionPublicFlagByGroupID
go
CREATE PROC [fps].[spSetRegionPublicFlagByGroupID]
	@UserGUID uniqueidentifier,
	@GroupID bigint

AS
	DECLARE @pmax tinyint
	
	SELECT @pmax = [Public]
	FROM RegionGroup
	WHERE
		RegionGroup.GroupID = @GroupID

	UPDATE Region
	SET [Public] = ISNULL(@pmax, 0)
	WHERE
		RegionID IN (SELECT RegionID FROM RegionGroupLink WHERE GroupID = @GroupID)
		AND UserGUID = @UserGUID
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spGetRegionBinary') 
drop procedure fps.spGetRegionBinary
go
CREATE PROC [fps].[spGetRegionBinary]
	@UserGUID uniqueidentifier,
	@RegionID bigint
AS

	SELECT  Region.RegionBinary
	FROM Region
	WHERE
		RegionID = @RegionID
		AND (UserGUID = @UserGUID OR [Public] > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spGetRegion_v2') 
drop procedure fps.spGetRegion_v2
go
CREATE PROC [fps].[spGetRegion_v2]
	@UserGUID uniqueidentifier,
	@RegionID bigint
AS

	SELECT  Region.RegionID,
			Region.GroupType,
			Region.UserGUID,
			Region.[Public],
			Region.DateCreated,
			Region.CustomID,
			Region.Area,
			Region.[FillFactor],
			Region.[Type],
			Region.Mask,
			Region.Comment
			--Region.RegionString,
			--Region.RegionBinary
	FROM Region
	WHERE
		RegionID = @RegionID
		AND (UserGUID = @UserGUID OR [Public] > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spDeleteOrphanRegions') 
drop procedure fps.spDeleteOrphanRegions
go
CREATE PROC [fps].[spDeleteOrphanRegions]
AS

	DECLARE @ids TABLE ( ID bigint );

	-- collection ids of orphan regions
	INSERT INTO @ids
	SELECT r.RegionID
	FROM Region AS r
	LEFT OUTER JOIN 
		(SELECT RegionID, COUNT(*) AS cnt
		FROM RegionGroupLink
		GROUP BY RegionID) AS c
	ON r.RegionID = c.RegionID
	WHERE
		cnt IS NULL
		AND GroupType = 0	-- only no-cache regions

	DELETE RegionHalfspace
	WHERE RegionID IN (SELECT ID FROM @ids)

	DELETE RegionHtm
	WHERE RegionID IN (SELECT ID FROM @ids)

	DELETE RegionPatch
	WHERE RegionID IN (SELECT ID FROM @ids)

	DELETE Region
	WHERE RegionID IN (SELECT ID FROM @ids)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spFindRegionGroupsByHTMID_Multiple') 
drop procedure fps.spFindRegionGroupsByHTMID_Multiple
go
CREATE PROC [fps].[spFindRegionGroupsByHTMID_Multiple]
	@UserGUID uniqueidentifier,
	@Source int,
	@HTMIDs varchar(max),
	@Operator int
AS
	
	DECLARE @ids TABLE ( HTMID bigint PRIMARY KEY )
	INSERT @ids SELECT * FROM fps.fSplit(@HTMIDs);

	DECLARE @cnt int
	SELECT @cnt = COUNT(*) FROM @ids

	DECLARE @rids TABLE ( RegionID bigint PRIMARY KEY )
	
	IF (@Operator = 1)	-- AND
	BEGIN
		INSERT @rids
		SELECT RegionID FROM RegionHtm
		INNER JOIN @ids ON HTMID BETWEEN HtmIDStart AND HtmIDEnd AND RegionHtm.FullOnly = 0
		GROUP BY RegionID
		HAVING COUNT(*) = @cnt
	END
	ELSE
	BEGIN				-- OR
		INSERT @rids
		SELECT DISTINCT RegionID FROM RegionHtm
		INNER JOIN @ids ON HTMID BETWEEN HtmIDStart AND HtmIDEnd AND RegionHtm.FullOnly = 0
		--GROUP BY RegionID
		--HAVING COUNT(*) = @cnt		
	END

;

	WITH Groups AS
	(
		SELECT DISTINCT x.GroupID FROM
		(
			-- cached
			SELECT rg.GroupID
			FROM RegionGroup rg
			WHERE rg.RegionID IN
				(SELECT RegionID FROM @rids)

			UNION

			-- no cache
			-- DECLARE @HtmID bigint; SET @HtmID = 17042430230528;

			SELECT rg.GroupID
			FROM RegionGroup rg
			INNER JOIN RegionGroupLink rgl
				ON rgl.GroupID = rg.GroupID
			WHERE rgl.RegionID IN
				(SELECT RegionID FROM @rids)
			AND rg.RegionID IS NULL

		) x
	)
	SELECT RegionGroup.* FROM RegionGroup
	INNER JOIN Groups ON Groups.GroupID = RegionGroup.GroupID
	--- security
	WHERE
		-- public
		(UserGUID = '00000000-0000-0000-0000-000000000000' AND (@Source & 1) > 0)
		OR
		-- private
		(UserGUID = @UserGUID AND (@Source & 2) > 0)
		OR
		-- other public
		(UserGUID <> '00000000-0000-0000-0000-000000000000'
		 AND (UserGUID <> @UserGUID OR @UserGUID IS NULL)
		 AND [Public] > 0
		 AND (@Source & 4) > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'fCheckUserAccess') 
drop function fps.fCheckUserAccess
go
CREATE FUNCTION [fps].[fCheckUserAccess]
(
	@UserGUID uniqueidentifier
)
RETURNS int
AS
BEGIN
	
	DECLARE @cnt int

	SELECT @cnt = COUNT(*)
	FROM Users
	WHERE GUID = @UserGUID

	RETURN @cnt

END
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'sp_LoginUser') 
drop procedure fps.sp_LoginUser
go
CREATE PROC [fps].[sp_LoginUser]
	@Username nvarchar(50),
	@Password nvarchar(50)
AS
	SELECT *
	FROM Users
	WHERE   LOWER(Username) = LOWER(@Username) AND
		Password = @Password
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'sp_ModifyUser') 
drop procedure fps.sp_ModifyUser
go
CREATE PROC [fps].[sp_ModifyUser]
	@GUID uniqueidentifier,
	@GroupID int,
	@Username nvarchar(50),
	@Password nvarchar(50),
	@Name nvarchar(50),
	@Institute nvarchar(50),
	@Email nvarchar(50)
AS
	UPDATE Users
	SET	GroupID = @GroupID,
		Username = @Username,
		Password = @Password,
		Name = @Name,
		Institute = @Institute,
		Email = @Email
	WHERE GUID = @GUID
	
	RETURN @@ROWCOUNT
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'sp_CreateUser') 
drop procedure fps.sp_CreateUser
go
CREATE PROC [fps].[sp_CreateUser]
	@GroupID int,
	@Username nvarchar(50),
	@Password nvarchar(50),
	@Name nvarchar(50),
	@Institute nvarchar(50),
	@Email nvarchar(50),
	@NewGUID uniqueidentifier OUTPUT
AS
	SET @NewGUID = NEWID()
	INSERT Users
		(GUID, GroupID, Username, Password, Name, Institute, Email)
	VALUES
		(@NewGUID, @GroupID, @Username, @Password, @Name, @Institute, @Email)
	
	RETURN @@ROWCOUNT
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'sp_GetUser') 
drop procedure fps.sp_GetUser
go
CREATE PROC [fps].[sp_GetUser]
	@GUID uniqueidentifier
AS
	SELECT * FROM Users
	WHERE GUID = @GUID
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'sp_GetUserByUsername') 
drop procedure fps.sp_GetUserByUsername
go
CREATE PROC [fps].[sp_GetUserByUsername]
	@Username nvarchar(50)
AS
	SELECT * FROM Users
	WHERE Username = @Username
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spFindRegionGroupsByRegion') 
drop procedure fps.spFindRegionGroupsByRegion
go
CREATE PROC [fps].[spFindRegionGroupsByRegion]
	@UserGUID uniqueidentifier,
	@Source int,
	@Region varbinary(max),
	@Operator int
AS
	
	DECLARE @ids TABLE ( HtmIDStart bigint,
						 HtmIDEnd bigint,
							PRIMARY KEY
							(
								HtmIDStart ASC,
								HtmIDEnd ASC
							))
	INSERT @ids
	SELECT HtmIDStart, HtmIDEnd FROM sph.fGetHtmRanges(@Region)
	WHERE FullOnly = 0;
	

	DECLARE @cnt int
	SELECT @cnt = COUNT(*) FROM @ids

	DECLARE @rids TABLE ( RegionID bigint PRIMARY KEY )

	IF (@Operator = 0)  -- COVER
	BEGIN
		PRINT 'cover'
	END
	IF (@Operator = 1) -- INTERSECT
	BEGIN

		DECLARE @regionID bigint
		DECLARE regions CURSOR FAST_FORWARD READ_ONLY FOR
					
			SELECT RegionID
			FROM RegionGroup
			WHERE RegionID IS NOT NULL

			UNION

			SELECT rgl.RegionID
			FROM RegionGroup rg
			INNER JOIN RegionGroupLink rgl
				ON rgl.GroupID = rg.GroupID
			WHERE rg.RegionID IS NULL

		OPEN regions

		FETCH NEXT FROM regions INTO @regionID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT @rids
			SELECT TOP 1 a.RegionID FROM RegionHtm a
				INNER JOIN @ids b ON
					a.HtmIDStart BETWEEN b.HtmIDStart AND b.HtmIDEnd
				WHERE a.FullOnly = 0 AND a.RegionID = @regionId

			IF @@ROWCOUNT = 0
			BEGIN
				INSERT @rids
				SELECT TOP 1 a.RegionID FROM RegionHtm a
					INNER JOIN @ids b ON
						a.HtmIDEnd BETWEEN b.HtmIDStart AND b.HtmIDEnd
					WHERE a.FullOnly = 0 AND a.RegionID = @regionId

				IF @@ROWCOUNT = 0
				BEGIN

					INSERT @rids
					SELECT TOP 1 a.RegionID FROM RegionHtm a
						INNER JOIN @ids b ON
							a.HtmIDStart < b.HtmIDStart AND
							a.HtmIDEnd > b.HtmIDEnd
						WHERE a.FullOnly = 0 AND a.RegionID = @regionId

				END
			END

			FETCH NEXT FROM regions INTO @regionID
		END

		CLOSE regions
		DEALLOCATE regions

	END
	IF (@Operator = 2) -- CONTAIN
	BEGIN
		PRINT 'contain'
	END
	

;

	WITH Groups AS
	(
		SELECT DISTINCT x.GroupID FROM
		(
			-- cached
			SELECT rg.GroupID
			FROM RegionGroup rg
			WHERE rg.RegionID IN
				(SELECT RegionID FROM @rids)

			UNION

			-- no cache

			SELECT rg.GroupID
			FROM RegionGroup rg
			INNER JOIN RegionGroupLink rgl
				ON rgl.GroupID = rg.GroupID
			WHERE rgl.RegionID IN
				(SELECT RegionID FROM @rids)
			AND rg.RegionID IS NULL

		) x
	)
	SELECT RegionGroup.* FROM RegionGroup
	INNER JOIN Groups ON Groups.GroupID = RegionGroup.GroupID
	--- security
	WHERE
		-- public
		(UserGUID = '00000000-0000-0000-0000-000000000000' AND (@Source & 1) > 0)
		OR
		-- private
		(UserGUID = @UserGUID AND (@Source & 2) > 0)
		OR
		-- other public
		(UserGUID <> '00000000-0000-0000-0000-000000000000'
		 AND (UserGUID <> @UserGUID OR @UserGUID IS NULL)
		 AND [Public] > 0
		 AND (@Source & 4) > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spFindRegionGroupsByHTMID') 
drop procedure fps.spFindRegionGroupsByHTMID
go
CREATE PROC [fps].[spFindRegionGroupsByHTMID]
	@UserGUID uniqueidentifier,
	@Source int,
	@HTMID bigint
AS
	

	WITH Groups AS
	(
		SELECT DISTINCT x.GroupID FROM
		(
			-- cached
			SELECT rg.GroupID
			FROM RegionGroup rg
			WHERE rg.RegionID IN
				(SELECT RegionID FROM RegionHtm
				 WHERE @HTMID BETWEEN HtmIDStart AND HtmIDEnd)

			UNION

			-- no cache
			-- DECLARE @HtmID bigint; SET @HtmID = 17042430230528;

			SELECT rg.GroupID
			FROM RegionGroup rg
			INNER JOIN RegionGroupLink rgl
				ON rgl.GroupID = rg.GroupID
			WHERE rgl.RegionID IN
				(SELECT RegionID FROM RegionHtm
				 WHERE @HTMID BETWEEN HtmIDStart AND HtmIDEnd)
			AND rg.RegionID IS NULL

		) x
	)
	SELECT RegionGroup.* FROM RegionGroup
	INNER JOIN Groups ON Groups.GroupID = RegionGroup.GroupID
	--- security
	WHERE
		-- public
		(UserGUID = '00000000-0000-0000-0000-000000000000' AND (@Source & 1) > 0)
		OR
		-- private
		(UserGUID = @UserGUID AND (@Source & 2) > 0)
		OR
		-- other public
		(UserGUID <> '00000000-0000-0000-0000-000000000000'
		 AND (UserGUID <> @UserGUID OR @UserGUID IS NULL)
		 AND [Public] > 0
		 AND (@Source & 4) > 0)
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spRefreshRegionGroupCache') 
drop procedure fps.spRefreshRegionGroupCache
go
CREATE PROC [fps].[spRefreshRegionGroupCache]
	@UserGUID uniqueidentifier,
	@GroupID bigint
AS
	-- user access check
	IF (fps.fCheckUserAccessRegionGroup(@UserGUID, @GroupID) = 0)
	RETURN -1		-- access denied

	/*
	-- determining group type and cacheId
	DECLARE @cacheId bigint, @groupType tinyint
	SELECT @cacheID = RegionID, @groupType = GroupType
	FROM RegionGroup WHERE GroupID = @GroupID

	-- counting regions
	DECLARE	@cnt int
	
	SELECT @cnt = COUNT(*) FROM Region
	INNER JOIN RegionGroupLink
	ON RegionGroupLink.RegionID = Region.RegionID
	WHERE
		RegionGroupLink.GroupID = @GroupID

	-- if 1 or less regions, no caching is needed
	IF (@cnt <= 1)
	BEGIN
		IF (@cacheId IS NOT NULL)
		BEGIN
			-- deleting
			DELETE Region WHERE RegionID = @cacheID

			-- updating group table to represent no cache
			UPDATE RegionGroup
			SET RegionID = NULL
			WHERE GroupID = @GroupID
		END
	END
	ELSE
	BEGIN
		-- calculating cache
		DECLARE @cacheBinary varbinary(max), @tempBinary varbinary(max)
		SET @cacheBinary = NULL

		DECLARE regs CURSOR FAST_FORWARD FOR
			SELECT RegionBinary FROM Region
			INNER JOIN RegionGroupLink
			ON RegionGroupLink.RegionID = Region.RegionID
			WHERE
				RegionGroupLink.GroupID = @GroupID
		
		OPEN regs

		FETCH NEXT FROM regs
		INTO @cacheBinary
		
		FETCH NEXT FROM regs
		INTO @tempBinary
		
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (@groupType = 1)	-- union
			BEGIN
				SET @cacheBinary = sph.fRegionUnion(@cacheBinary, @tempBinary)
			END

			IF (@groupType = 2)	-- intersection
			BEGIN
				SET @cacheBinary = sph.fRegionIntersection(@cacheBinary, @tempBinary)
			END
		END

		CLOSE regs
		
		-- performing update
		IF (@cacheId IS NULL)
		BEGIN
			-- creating new cache
			INSERT Region
		END
		ELSE
		BEGIN
			-- updating cache
		END

	END
	*/
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spDeleteHtmRanges') 
drop procedure fps.spDeleteHtmRanges
go
CREATE PROC [fps].[spDeleteHtmRanges]
	@UserGUID uniqueidentifier,
	@RegionID bigint
AS

	-- user access check
	IF (fps.fCheckUserAccessRegion(@UserGUID, @RegionID) = 0)
	RETURN -1		-- access denied

	DELETE RegionHtm
	WHERE RegionID = @RegionID
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spModifyRegionGroup') 
drop procedure fps.spModifyRegionGroup
go
CREATE PROC [fps].[spModifyRegionGroup]
	@UserGUID uniqueidentifier,
	@GroupID bigint,
	@GroupType tinyint,
	@RegionID bigint,
	@Public tinyint,
	@Description nvarchar(256),
	@Comment ntext
AS
	IF (fps.fCheckUserAccessRegionGroup(@UserGUID, @GroupID) = 0)
		RETURN -1		-- access denied


	UPDATE RegionGroup
	SET	GroupType = @GroupType,
		RegionID = @RegionID,
		[Public] = @Public,
		DateModified = GETDATE(),
		Description = @Description,
		Comment = @Comment
	WHERE
		GroupID = @GroupID AND UserGUID = @UserGUID

	DECLARE @res int
	SET @res = @@ROWCOUNT

	-- updating public flag
	EXEC fps.spSetRegionPublicFlagByGroupID @UserGUID, @GroupID

	--updating cache public flag
	IF (@RegionID IS NOT NULL)
	BEGIN
		UPDATE Region
		SET [Public] = @Public
		WHERE RegionID = @RegionID
	END
	

	RETURN @res
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spDeleteRegionGroup') 
drop procedure fps.spDeleteRegionGroup
go
CREATE PROC [fps].[spDeleteRegionGroup]
	@UserGUID uniqueidentifier,
	@GroupID bigint
AS

	-- user access check
	IF (fps.fCheckUserAccessRegionGroup(@UserGUID, @GroupID) = 0)
		RETURN -1		-- access denied

	-- deleting cache region
	DECLARE @RegionID bigint
	
	SELECT @RegionID = RegionID
	FROM RegionGroup
	WHERE GroupID = @GroupID

	EXEC fps.spDeleteRegion @UserGUID, @RegionID

	-- updating public flag on remaining regions
	UPDATE RegionGroup
	SET [Public] = 0
	WHERE GroupID = @GroupID

	EXEC fps.spSetRegionPublicFlagByGroupID @UserGUID, @GroupID

	-- deleting region links
	DELETE RegionGroupLink
	WHERE GroupID = @GroupID

	-- deleting regions not belonging to any group
	EXEC fps.spDeleteOrphanRegions

	-- deleting group
	DELETE RegionGroup
	WHERE GroupID = @GroupID
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spCreateRegionGroupLink') 
drop procedure fps.spCreateRegionGroupLink
go
CREATE PROC [fps].[spCreateRegionGroupLink]
	@UserGUID uniqueidentifier,
	@GroupID bigint,
	@RegionID bigint
AS

	IF (fps.fCheckUserAccessRegionGroup(@UserGUID, @GroupID) = 0)
		RETURN -1		-- access denied

	DECLARE @res int

	INSERT RegionGroupLink
		(GroupID, RegionID)
	VALUES
		(@GroupID, @RegionID)

	SET @res = @@ROWCOUNT

	-- updating the public flag
	EXEC fps.spSetRegionPublicFlag @UserGUID, @RegionID

	RETURN @res
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spDeleteRegionGroupLink') 
drop procedure fps.spDeleteRegionGroupLink
go
CREATE PROC [fps].[spDeleteRegionGroupLink]
	@UserGUID uniqueidentifier,
	@GroupID bigint,
	@RegionID bigint
AS
	--- user access check
	IF (fps.fCheckUserAccessRegionGroup(@UserGUID, @GroupID) = 0)
		RETURN -1		-- access denied	

	DELETE RegionGroupLink
	WHERE GroupID = @GroupID AND RegionID = @RegionID

	-- region delete if required
	EXEC fps.spDeleteOrphanRegions

	-- updating the public flag
	EXEC fps.spSetRegionPublicFlag @UserGUID, @RegionID

	RETURN @@ROWCOUNT
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spCreateRegionGroup') 
drop procedure fps.spCreateRegionGroup
go
CREATE PROC [fps].[spCreateRegionGroup]
	@UserGUID uniqueidentifier,
	@GroupType tinyint,
	@Public tinyint,
	@Description nvarchar(256),
	@Comment ntext,

	@NewID bigint OUTPUT
AS

	-- User access check
	IF (fps.fCheckUserAccess(@UserGUID) > 0)
	BEGIN

		---

		INSERT RegionGroup
			(GroupType, RegionID, UserGUID, [Public],
			 DateCreated, DateModified, Description, Comment)
		VALUES
			(@GroupType, NULL, @UserGUID, @Public,
			 GETDATE(), GETDATE(), @Description, @Comment)

		SET @NewID = @@IDENTITY

		RETURN @@ROWCOUNT

	END
	ELSE

		RETURN -1		-- access denied
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spCreateRegion') 
drop procedure fps.spCreateRegion
go
CREATE PROC [fps].[spCreateRegion]
	@UserGUID uniqueidentifier,
	@Public tinyint,
	@CustomID bigint,
	@Area float,
	@FillFactor float,
	@Type varchar(16),
	@Mask tinyint,
	@GroupType tinyint,
	@Comment ntext,
	@RegionString ntext,
	@RegionBinary varbinary(max),
	
	@NewID bigint OUTPUT
AS

	-- User access check
	IF (fps.fCheckUserAccess(@UserGUID) > 0)
	BEGIN

		INSERT Region
			(UserGUID, [Public], DateCreated, CustomID, Area, [FillFactor],
			[Type], Mask, GroupType, Comment, RegionString, RegionBinary)
		VALUES
			(@UserGUID, @Public, GETDATE(), @CustomID, @Area, @FillFactor, 
			 @Type, @Mask, @GroupType, @Comment, @RegionString, @RegionBinary)

		SET @NewID = @@IDENTITY

		RETURN @@ROWCOUNT

	END
	ELSE

		RETURN -1	-- access denied
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spUpdateRegionGroupCache') 
drop procedure fps.spUpdateRegionGroupCache
go
CREATE PROC [fps].[spUpdateRegionGroupCache]
	@UserGUID uniqueidentifier,
	@GroupID bigint,
	@RegionID bigint
AS

	DECLARE
		@cacheId bigint,
		@groupType tinyint,
		@cacheBinary varbinary(max),
		@regionBinary varbinary(max)

	-- looking up type and cache region
	SELECT	@cacheId = RegionID,
			@groupType = GroupType
	FROM RegionGroup
	WHERE GroupID = @GroupID

	IF (@cacheId IS NULL)
	BEGIN
		SELECT @cacheBinary = Region.RegionBinary FROM Region
		INNER JOIN RegionGroupLink
		ON RegionGroupLink.RegionID = Region.RegionID
		WHERE
			RegionGroupLink.GroupID = @GroupID


		-- Creating an empty region for caching
		DECLARE @rc int
		EXECUTE @rc = fps.spCreateRegion
			@UserGUID,
			0,
			0, --@CustomID
			0, --@Area
			1.0, --@FillFactor
			'', --@Type
			0, --@Mask
			@GroupType,
			'cache', --@Comment
			'', --@RegionString
			@cacheBinary, --@RegionBinary
			@cacheId OUTPUT

		IF (@rc = -1) RETURN -1		-- access denied
		IF (@rc = 0) RETURN 0		-- cannot append region

		UPDATE RegionGroup
		SET RegionID = @cacheId
		WHERE GroupID = @GroupID
	END

	-- retrieving new region
	SELECT @regionBinary = RegionBinary
	FROM Region
	WHERE RegionID = @RegionID

	-- retrieving cache binary
	SELECT @cacheBinary = RegionBinary
	FROM Region
	WHERE RegionID = @cacheID


	-- computing new cache
	IF (@groupType = 1)	-- union
	BEGIN
		SET @cacheBinary = fps.fRegionUnion(@cacheBinary, @regionBinary)
	END

	IF (@groupType = 2)	-- intersection
	BEGIN
		SET @cacheBinary = fps.fRegionIntersection(@cacheBinary, @regionBinary)
	END

	-- updateing cache *** (other columns should be updated!)
	UPDATE Region
	SET	RegionBinary = @cacheBinary
	WHERE RegionID = @cacheId

	RETURN @@ROWCOUNT
GO
if exists (select * from INFORMATION_SCHEMA.ROUTINES
	where specific_catalog = 'SphRegion' 
		and specific_schema = 'fps'
		and specific_name = N'spSyncRegion') 
drop procedure fps.spSyncRegion
GO
CREATE PROC [fps].[spSyncRegion]
	@RegionID bigint
AS
	DELETE RegionHtm WHERE RegionID=@RegionID;
	DELETE RegionHalfspace WHERE RegionID=@RegionID;
	DELETE RegionPatch WHERE RegionID=@RegionID;
	--
	UPDATE Region SET Area = sph.fGetArea(RegionBinary),
		RegionString = 'N/A' --sph.fGetRegionString(RegionBinary)
	WHERE RegionID=@RegionID;
	--
	INSERT RegionHalfspace
	SELECT RegionID, c.*
	FROM Region r CROSS APPLY sph.fGetHalfspaces(RegionBinary) c
	WHERE regionid=@regionid;
	--
	INSERT RegionPatch
	SELECT RegionID, ConvexID, PatchID, Type, Radius, RA,Dec, X,Y,Z, C, HtmID
	FROM Region r CROSS APPLY sph.fGetPatches(RegionBinary) c
	WHERE regionid=@regionid;
	--
	INSERT RegionHtm
	SELECT RegionID, fullonly, htmidstart, htmidend
	FROM Region r CROSS APPLY sph.fGetHtmRanges(RegionBinary) c
	WHERE regionid=@regionid;
GO

