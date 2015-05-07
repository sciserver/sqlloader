USE BoundaryTest;
SET NOCOUNT ON;
GO

if exists (select * from dbo.sysobjects 
    where id = object_id(N'[Points]') 
    and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [Points]
GO


CREATE TABLE Points (
	objid bigint PRIMARY KEY identity(1,1),
	ra	float,
	[dec]	float,
	cx	float,
	cy	float,
	cz	float
)
GO

DECLARE @cx float,@cy float,@cz float, 
@ra FLOAT, @dec float,@count int;
--
SET @count=100000;

--==============================================================
WHILE (@count>0)
    BEGIN
	SET @ra = 2*PI()*RAND();
	SET @dec = ASIN(2*RAND()-1);
	SET @cx  = cos(@dec)*cos(@ra);
	SET @cy  = cos(@dec)*sin(@ra);
	SET @cz  = sin(@dec);
	INSERT INTO Points Values(DEGREES(@ra),DEGREES(@dec),@cx,@cy,@cz);
	SET @count = @count-1;
    END;
--================================================================
GO

select count(*) from Points

select ra, dec from Points
  where ra between 150 and 250
   and dec between -1 and 1


