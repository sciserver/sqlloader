


/****** Object:  StoredProcedure [dbo].[spGetFiberList]    Script Date: 11/14/2016 3:23:46 PM ******/
DROP PROCEDURE [dbo].[spGetFiberList]
GO



/****** Object:  StoredProcedure [dbo].[spGetFiberList]    Script Date: 11/14/2016 2:40:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 
CREATE PROCEDURE [dbo].[spGetFiberList] (@plateid bigint)
-------------------------------------------------
--/H Return a list of fibers on a given plate.
-------------------------------------------------
AS 
	select cast(s.specObjID as varchar(20)), s.fiberId, c.name, str(s.z,5,3), s.bestobjid 
	from SpecObjAll s,SpecClass c 
	where s.specClass=c.value
	and plateID=@plateid
	order by s.fiberID;

GO


