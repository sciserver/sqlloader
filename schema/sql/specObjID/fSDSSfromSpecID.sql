CREATE FUNCTION fSDSSfromSpecID(@specID numeric(20,0))
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
	fiber INT
)
AS BEGIN


	declare @mjd int;
	declare @fiber int;
	declare @s bigint;


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

	
    INSERT @sdssSpecID 
	SELECT
	    cast( (@specID / power(cast(2 as bigint),50)) AS INT ) AS plate,
	    @mjd AS mjd,
	    @fiber AS fiber
    RETURN
END
GO