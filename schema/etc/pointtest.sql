USE BoundaryTest
SET NOCOUNT ON
GO


/*

It would be nice to be able to hand this function a
set of areas, which is an area in itself. If we had
a table valued function that returns a subset of
the area table, in most cases in a single convex.


We plug those in to an internal temporary table,
then we can run the cursor over the temporary table.

An other function could do the fuzz, and return 
again a temporary table.


*/




if exists (select * from dbo.sysobjects 
    where id = object_id(N'[dbo].[fAreaPredicate]') 
    and xtype in (N'FN', N'IF', N'TF'))
    drop function [dbo].[fAreaPredicate]
GO

CREATE FUNCTION fAreaPredicate(@areaID bigint, @fuzz float)
RETURNS varchar(8000)
AS
BEGIN
    DECLARE @convexID bigint	-- the current convex
    DECLARE @oldConvexID bigint	-- the previous convex
    DECLARE @predicate varchar(8000); set @predicate = ''
    DECLARE @clause    varchar(8000); set @clause    = ''
    DECLARE @x float, @y float, @z float, @l float
    -------------------------------------------------------------
    -- this cursor reads all the edges of all the convexes of the area 
    DECLARE area cursor read_only for  
		select convexID,x,y,z,c 
		from Edge 
		where areaID = @areaID
    OPEN area
    --------------------------------------------------------------
    -- loop over the edges building an OR of each convex 
    -- and within a convex an AND of its edges containment.
    WHILE (1=1)
    BEGIN
	fetch next from area into  @convexID, @x, @y, @z, @l
	if (@@fetch_status <> 0) break	
	-- logic to handle a new convex (an OR)
	if ((@oldConvexID is not null) and (@convexID != @oldConvexID))
	    begin
		if (@predicate != '' )  set @predicate = @predicate + ' OR '
		set @predicate = @predicate + '(' + @clause + ')'
		set @clause = ''
	    end
	set @OldConvexID = @convexID
	-- add fuzz
	SET @l = COS(ACOS(@l) + RADIANS(@fuzz));
	-- logic to handle an edge within a convex (an AND)
	if (@clause != '' )  set @clause = @clause + ' AND '
	set @clause = @clause  + '((' 
		+ '('+STR(@x,15,20) + ')*cx+' + 
		+ '('+STR(@y,15,20) + ')*cy+' + 
		+ '('+STR(@z,15,20) + ')*cz)>=' 
		+ STR(@l,15,20) + ')' 
    END
    -- loop ended, now tack on last convex clause
    IF (@predicate != '' ) set @predicate = @predicate + ' OR '
    SET @predicate = '('+ @predicate + '(' + @clause + '))'
    -- close and deallocate the cursor
    CLOSE area; DEALLOCATE area
    -- return the result
    RETURN @predicate
END
GO


/*

declare @pred varchar(8000)
set @pred = 'select * from Points p where ' + dbo.fAreaPredicate(16384, 0.5)
exec (@pred)

-- 98 with fuzz=0.0
-- 178 with fuzz=0.5
-- 230 with fuzz=1.0


*/