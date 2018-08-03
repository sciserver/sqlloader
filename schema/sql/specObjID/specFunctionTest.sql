CREATE FUNCTION fSDSSfromSpecID2(@specID numeric(20,0))
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
    INSERT @sdssSpecID 
	SELECT
	    cast( (@specID / power(cast(2 as bigint),50)) AS INT ) AS plate,
	    cast( (((cast(@specID as binary) & cast(0x0000003FFFFFFFFF as bigint))/ power(cast(2 as bigint),24)) + 50000) AS INT ) AS mjd,
	    cast( (((cast(@specID as binary) & cast(0x0003FFFFFFFFFFFF as bigint)) / power(cast(2 as bigint),38))) AS INT) AS fiber
    RETURN
END
GO
--



declare @s numeric(20,0)

set @s = 10000000000000000000

select cast (@s as binary) & cast( 0x0000003FFFFFFFFF as bigint) 


select top 10 * from 
SpecObjAll
where plate < 10000


--299489676975171584
--11259136630626164736
declare @s2 numeric(20,0) = 11259136630626164736
select * from fSDSSfromSpecID2(299489676975171584)
select * from fSDSSfromSpecID(299489676975171584)


select plate, mjd, fiberID
from specObjAll
where specObjID=11259136630626164736


select * from SpecObjAll
where specObjID=11259136630626164736
