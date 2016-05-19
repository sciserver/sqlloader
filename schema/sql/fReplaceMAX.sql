IF EXISTS (SELECT name FROM   sysobjects 
	   WHERE  name = N'fReplaceMax' )
	DROP FUNCTION fReplaceMax
GO

CREATE FUNCTION fReplaceMax(@oldstr VARCHAR(max), @pattern VARCHAR(1000), @replacement VARCHAR(1000))
------------------------------------------------
--/H Case-insensitve string replacement
------------------------------------------------
--/T Used by the SQL parser stored procedures.
------------------------------------------------
RETURNS varchar(max) 
AS
BEGIN 
	-------------------------------------
	DECLARE @newstr varchar(max);
	SET @newstr = '';
	IF (LTRIM(@pattern) = '') GOTO done;
	-----------------------------------
	DECLARE @offset int,
			@patlen int,
			@lowold varchar(max),
			@lowpat varchar(max);
	SET @lowold = LOWER(@oldstr);
	SET @lowpat = LOWER(@pattern);
	SET @patlen = LEN(@pattern);
	SET @offset = 0
	--
	WHILE (CHARINDEX(@lowpat,@lowold, 1) != 0 )
	BEGIN
		SET @offset	= CHARINDEX(@lowpat, @lowold, 1);
		SET @newstr	= @newstr + SUBSTRING(@oldstr,1,@offset-1) + @replacement;
		SET @oldstr	= SUBSTRING(@oldstr, @offset+@patlen, LEN(@oldstr)-@offset+@patlen);
		SET @lowold	= SUBSTRING(@lowold, @offset+@patlen, LEN(@lowold)-@offset+@patlen);
	END
	-----------------------------------------
done:	RETURN( @newstr + @oldstr);
END
GO
