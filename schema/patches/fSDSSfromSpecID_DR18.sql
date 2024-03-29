
/****** Object:  UserDefinedFunction [dbo].[fSDSSfromSpecID]    Script Date: 1/9/2023 1:11:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--
ALTER FUNCTION [dbo].[fSDSSfromSpecID](@specID numeric(20,0))
-------------------------------------------------------------------------------
--/H Returns a table pf the 3-part SDSS numbers from the long specObjID.
--
--/T The returned columns in the output table are: 
--/T	plate, mjd, fiber<br>
--/T <samp> select * from dbo.fSDSSfromSpecID(865922932356966400)</samp>
-------------------------------------------------------------------------------
RETURNS @sdssSpecID TABLE (
	plate INT,
	mjd INT,
	fiber INT,
	run2d VARCHAR(16)
)
AS BEGIN


	declare @mjd int;
	declare @fiber int;
	declare @s bigint;
	declare @run2dnum int;
	declare @run2d VARCHAR(16) = '';


	DECLARE @sum bigint = 0
	DECLARE @cnt INT = cast(ceiling(log(cast(0x0000003FFFFFFFFF as bigint),2)) as int)
	Declare @max  int = floor(log(@specID,2))
	WHILE @cnt < @max
	BEGIN
		set @sum = @sum + power(cast(2 as bigint), @cnt)
		SET @cnt = @cnt + 1;
	END;

	set @s = @specID - @sum
	set @mjd = cast( (((@s & 0x0000003FFFFFFFFF)/ power(cast(2 as bigint),24)) + 50000) AS INT )


	set @sum = 0
	set @cnt = cast(ceiling(log(cast(0x0003FFFFFFFFFFFF as bigint),2)) as int)
	WHILE @cnt < @max
	BEGIN
		set @sum = @sum + power(cast(2 as bigint), @cnt)
		SET @cnt = @cnt + 1;
	END;

	set @s = @specID - @sum
	set @fiber = cast( (((cast(@s as bigint) & 0x0003FFFFFFFFFFFF)/ power(cast(2 as bigint),38))) AS INT)

	set @run2dnum = cast( (((cast(@s as bigint) & 0x0000000000FFFC00)/ power(cast(2 as bigint),10))) AS INT)
	IF @run2dnum > 104 
	    BEGIN
			SET @run2d = CONCAT( 'v', cast((@run2dnum/10000)+5 AS VARCHAR),'_', cast(((@run2dnum%10000)/100) as VARCHAR), '_', cast(@run2dnum % 100 AS VARCHAR) );
		END
	ELSE
		SET @run2d = CAST( @run2dnum AS VARCHAR);

    INSERT @sdssSpecID 
	SELECT
	    cast( (@specID / power(cast(2 as bigint),50)) AS INT ) AS plate,
	    @mjd AS mjd,
	    @fiber AS fiber,
		@run2d as run2d
    RETURN
END
