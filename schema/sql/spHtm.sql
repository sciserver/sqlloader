--========================================================================
--   spHTM.sql
--   2003-07-01 Alex Szalay, Jim Gray, George Fekete
--------------------------------------------------------------------------
--  Install HTM V2 stored procedures in SkyServer DB.
--
--  fHTM installation instructions
--  Move the xp_SQL_HTM_dll.dll file to the 
--  C:\Program Files\Microsoft SQL Server\MSSQL\Binn directory
--  Then execute the spHTMmaster.sql script
--  in the SQL Query Analyzer (in the master database).
--  then run the attached script that defines the procedures.
--------------------------------------------------------------------------
-- History:
--* 2003-07-17 Ani: Added HTM V2 stuff for Jim/Alex/George
--*                  This is after all the V1 functions
--* 2003-07-29 Alex+Jim: Added V37 functions toPoint, toVertices.
--* 2003-07-31 Alex+Jim: Moved from  fHTM2_xxx to fHtmxxx for function names.
--*            converted fHtmToString from 15,3,1,.. format to (N|S)[0..3]*
--* 2003-08-18 Ani: Added HTM V2 updates from Jim/Alex/George (PR #5589).
--* 2003-12-05 Jim: fixed +1 bug in fHtmCover() on HtmEnd
--*                  moved V1 HTM code to end of file and commented it out.
--* 2004-08-10 Ani: Reset L20 to 20 in HTM call in fHTMLookupXyz, the new
--*                  interface didnt work on DR2 testload.
--* 2005-03-08   Jim:  Fixed string bug in version (intialize strings to ' ')  
--========================================================================
SET NOCOUNT ON;
GO


--=======================================================
IF EXISTS (SELECT * FROM   sysobjects 
	   WHERE  name = N'fHtmLookup') 
	DROP FUNCTION fHtmLookup 
GO
--
CREATE FUNCTION  fHtmLookup(@Coordinate VARCHAR(1000))
---------------------------------------------------------------------
--/H  Find the htmID of the specified point on the celestial sphere
---------------------------------------------------------------------
--/T  Coordinate syntax is: 
--/T  <li>J2000 [depth] ra dec <i>in spherical coordinates</i><br>
--/T  Example: <samp>J2000 20 240.0 38.0</samp>
--/T  <li>CARTESIAN [depth] x y z <i>where x, y, z are numbers giving the position of the point 
--/T  on the sphere, depth is an integer in the range 2..14 giving the mesh depth, 
--/T  Example: <samp>CARTESIAN 1 0 0</samp>
--/T  <br> x y zra, dec, x, y, z are floats. </i><br>
--/T  <br> Default depth is 20.
--/T  <li>Example: 
--/T  <samp>select dbo.fHtmLookup('J2000 20 185 0')</samp>
--/T  <br>
----------------------------------------------------- 
RETURNS BIGINT
AS
BEGIN
	DECLARE @HTM        BIGINT	-- the answer
	DECLARE @HTM_KLUDGE BINARY(8) 	-- a workaround for the fact that 
				      	-- external stored procs do not take BIGINT params
	DECLARE @retcode    INT		--
	DECLARE @ErrorMsg   VARCHAR(1000) -- error messsage from lookup (if coordinate has syntax error)
	SET @ErrorMsg = ' '		
	EXECUTE @retcode = master.dbo.xp_HTM2_Lookup @Coordinate, @HTM_KLUDGE OUTPUT, @ErrorMsg OUTPUT
	IF (@retcode = 0)   		-- got bytes, cast them as an INT64
		BEGIN
		SET @HTM = CAST(substring(@HTM_KLUDGE, 1, 8) AS BIGINT)
		END
	ELSE
	   BEGIN SET @HTM = -@retcode END
	RETURN(@HTM) 
END					-- end of HTM 
GO	


--=======================================================
IF EXISTS (SELECT *  FROM   sysobjects 
           WHERE  name = N'fHtmLookupError') 
	DROP FUNCTION fHtmLookupError 
GO
--
CREATE FUNCTION   fHtmLookupError  (@Coordinate VARCHAR(1000))
----------------------------------------------------------------
--/H  Returns the error message that fHtmLookup generated
----------------------------------------------------------------
--/T  If there was no error, returns the string 'OK'.
--/T  <samp>select dbo.fHtmLookupError ('J2000  L60 185 0')</samp>
--/T  <br> see fHtmLookup for definition of input param
--------------------------------------------------
RETURNS VARCHAR(1000)
AS
BEGIN
	DECLARE @HTM_KLUDGE BINARY(8) 	-- a workaround for the fact that 
				      	-- external stored procs do not take BIGINT params
	DECLARE @retcode    INT		--
	DECLARE @ErrorMsg   VARCHAR(1000) -- error messsage from lookup (if coordinate has syntax error)
	SET @ErrorMsg = ' '		
	EXECUTE  @retcode = master.dbo.xp_HTM2_Lookup @Coordinate, @HTM_KLUDGE OUTPUT, @ErrorMsg OUTPUT
	IF (@retcode != 0)   
		BEGIN
		SET @ErrorMsg = 'Call to master.dbo.xp_HTM2_Lookup failed completely.  ' +
				'Retcode ' + cast(@retcode as int) 
		END
	RETURN(@ErrorMsg) 
END
GO	 


--=======================================================
IF EXISTS (SELECT * FROM   sysobjects 
           WHERE  name = N'fHtmCover') 
	DROP FUNCTION fHtmCover 
GO
--
CREATE FUNCTION fHtmCover (@Region VARCHAR(8000))
---------------------------------------------------------------------
--/H  Return table of HTM range pairs covering the region
-------------------------------------------------------------
--/T The region has the syntax
--/T <pre>
--/T circleSpec  =>     CIRCLE J2000   [Ln] ra dec radArcMin  
--/T            |       CIRCLE  CARTESIAN [ln] x y z  radArcMin
--/T rectSpec    =>     RECT J2000     {ra dec}4
--/T            |       RECT CARTESIAN {x y z }4
--/T polySpec    =>     POLY [J2000]     {ra dec}
--/T            |       POLY CARTESIAN {x y z}3+
--/T hullSpec    =>     CHULL J2000 {ra dec}3+
--/T                           Cartesian not implemented currently
--/T coverSpec	 =>     circleSpec |rectSpec | polySpec | hullSpec
--/T convexSpec	 =>     CONVEX { x y z D}+
--/T regionSpec	 =>     REGION {coverSpec}+  
--/T </pre><br> 
--/T <p>returned table:  
--/T <li> HTMIDstart bigint not null primary key, -- Start of htm range (20 deep HTMs)
--/T <li> HTMIDend   bigint not null,             -- end of htm range   
--/T <br> Sample call to find ht m triangles covering area withn 5 arcminutes of xyz -.0996,-.1,0
--/T <br><samp>
--/T <br>select * from fHtmCover('CIRCLE CARTESIAN -.996 -.1 0 5')  
--/T </samp>  
--/T <br>see also fHtmCoverError 
---------------------------------------------------------------------
RETURNS @Triangles TABLE (
		HTMIDstart BIGINT NOT NULL PRIMARY KEY,  
		HTMIDend   BIGINT NOT NULL)
AS
BEGIN
   DECLARE @Vector 	VARBINARY(8000)	-- the outpvector from xp_HTM 
   DECLARE @Elements 	INT		-- size of output vector (in bigints)
   DECLARE @Cell     	INT		-- index to output vector cell
   DECLARE @StartHTM 	BIGINT		-- value of first htm cell
   DECLARE @EndHTM 	BIGINT		-- value of second htm cell
   DECLARE @Retcode 	INT		-- retcode from xp_HTM.
   DECLARE @ErrorMsg	VARCHAR(1000)   -- error message from HTM code
   -- get a vector of up to 1,000 triangles covering the desired area (input params missing at present).
   SET @ErrorMsg = ' '		

   EXECUTE  @retcode = master.dbo.xp_HTM2_Cover @Region, @Vector OUTPUT, @ErrorMsg OUTPUT

   SET @Elements = DATALENGTH(@Vector)/8		-- each element is 8 bytes
   IF ((@Elements % 2) != 0) SET @Elements = 0  -- error if an odd number of elements
   SET @Cell = 0				--
   WHILE (@Cell < @Elements)			-- loop over array
	BEGIN					-- extracting pairs of cells
	SET @StartHTM = CAST (substring(@Vector, (8 * @Cell)+1, 8) AS BIGINT)
	SET @EndHTM = CAST (substring(@Vector, (8 * (@Cell+1))+1, 8) AS BIGINT) -1
--                                       **** NOTE THE "-1" here fixes a bug in the linkage proc
   	INSERT @Triangles VALUES(@StartHTM, @EndHTM+1)	-- insert pair in answer table
 	SET @Cell = @Cell + 2			-- go to next pair
	END					-- end of loop to get 
   RETURN					--
END						-- end of fHtmCover
GO


--=======================================================
IF EXISTS (SELECT * FROM   sysobjects 
           WHERE  name = N'fHtmCoverError') 
	DROP FUNCTION fHtmCoverError 
GO
--
CREATE FUNCTION fHtmCoverError (@Region VARCHAR(8000))
---------------------------------------------------------------------
--/H  Return error mesage for FhtmCover call telling what is wrong with Region definition.
---------------------------------------------------------------------
--/T <br>Example:  (missing radius)
--/T  <samp>select dbo.fHtmCoverError('CIRCLE J2000 190 0   ')</samp>
--/T  <br>
----------------------------------------------------- 
RETURNS VARCHAR(1000)
AS
BEGIN
   DECLARE @Vector 	VARBINARY(8000)	-- the outpvector from xp_HTM 
   DECLARE @retcode 	INT		-- retcode from xp_HTM.
   DECLARE @ErrorMesssage VARCHAR(1000)   -- error message from HTM code
   SET @ErrorMesssage = ' '		
   EXECUTE  @retcode = master.dbo.xp_HTM2_Cover @Region, @Vector OUTPUT, @ErrorMesssage OUTPUT
	IF ((@retcode != 0) and (@retcode != 20001))   
	BEGIN
	SET @ErrorMesssage = 'Call to master.dbo.xp_HTM2_Cover failed completely.  ' +
				'Retcode ' + cast(@retcode as int)
	END 
   RETURN(@ErrorMesssage) 
END						-- end of fHtmCoverError
GO


--=======================================================
IF EXISTS (SELECT * FROM   sysobjects 
           WHERE  name = N'fHtmToString') 
	DROP FUNCTION fHtmToString 
GO
--
CREATE FUNCTION   fHtmToString (@HTM BIGINT)
---------------------------------------------------------------------
--/H  Converts an HTM to a string representaion of that HTM
---------------------------------------------------------------------
--/T  The string format is (N|S)[0..3]* 
--/T  <br> For example S130000013 is on the second face of the southern hemisphere.
--/T  <br> i.e. ra is between 6h and 12h  
--/T  <li>Example: 
--/T  <samp>select dbo.fHtmToString(dbo.fHtmLookup('J2000 20 185 0'))</samp>
--/T  <br>
----------------------------------------------------- 
RETURNS VARCHAR(1000)
AS
	 BEGIN
	 DECLARE @HTMtemp BIGINT  	-- eat away at @HTM as you parse it.
	 DECLARE @Answer  VARCHAR(1000) -- the answer string.
	 DECLARE @Triangle  INT  	-- the triangle id (0..3)
	 SET @Answer = ' '   		--
	 SET @HTMtemp = @HTM   		--
	 ------------------------------------------
	 -- loop over the HTM pulling off a triangle till we have a faceid left (1...8)
	 WHILE (@HTMtemp > 0)
	  BEGIN
	  IF (@HTMtemp <= 4)   		-- its a face  
	   BEGIN   -- add face to string.
	     IF (@HTMtemp=3) SET @Answer='N'+@Answer;
	     IF (@HTMtemp=2) SET @Answer='S'+@Answer;
	     SET @HTMtemp  = 0
	   END   			-- end face case
	  ELSE
	   BEGIN   				-- its a triangle
	     SET @Triangle = @HTMtemp % 4 	-- get the id into answer
	     SET @Answer =  CAST(@Triangle as VARCHAR(4)) + @Answer
	     SET @HTMTemp = @HTMtemp / 4  	-- move on to next triangle
	   END   			-- end triangle case
	  END    			-- end loop
	 RETURN(@Answer)     			
END			
GO	


--=======================================================
IF EXISTS (SELECT * FROM   sysobjects 
           WHERE  name = N'fHtmToNormalForm') 
	DROP FUNCTION fHtmToNormalForm 
GO
--
CREATE FUNCTION fHtmToNormalForm (@Region VARCHAR(8000))
---------------------------------------------------------------------
--/H  Returns normal form of a region definition.
---------------------------------------------------------------------
--/T The region has the syntax
--/T <pre>
--/T coverSpec	 =>     polySpec | rectSpec | circleSpec | regionSpec | hullSpec | coverSpec
--/T circleSpec  =>     CIRCLE J2000   [n] ra dec radArcMin  
--/T            |       CIRCLE  CARTESIAN [n] x y z  radArcMin
--/T coverSpec	 =>     polySpec | rectSpec | circleSpec | regionSpec | hullSpec
--/T circleSpec  =>      CIRCLE J2000     [i] ra dec rad  
--/T  	        |       CIRCLE CARTESIAN [i] x y z  rad 
--/T rectSpec    =>     RECT J2000     {ra dec}4
--/T            |       RECT CARTESIAN {x y z }4
--/T polySpec    =>     POLY [J2000]     {ra dec}
--/T            |       POLY CARTESIAN {x y z}3+
--/T hullSpec    =>     CHULL J2000 {ra dec}3+
--/T                           CARTESIAN not implemented currently
--/T convexSpec	 =>     CONVEX { x y z D }+
--/T regionSpec	 =>     REGION { coverSpec }+  
--/T </pre><br> 
--/T  <li>Example: 
--/T  <samp>select dbo.fHtmToNormalForm('CIRCLE CARTESIAN -.996 -.1 0 2')</samp>
--/T  <br>
----------------------------------------------------- 
RETURNS VARCHAR(8000)
AS
BEGIN
   DECLARE @NForm 	VARCHAR(8000)	-- the outpvector from xp_HTM 
   DECLARE @Retcode 	INT		-- retcode from xp_HTM.
   DECLARE @ErrorMsg	VARCHAR(1000)   -- error message from HTM code
   SET @ErrorMsg = ' '	
   -- get a vector of up to 1,000 triangles covering the desired area (input params missing at present).

   EXECUTE  @retcode = master.dbo.xp_HTM2_toNormalForm @Region, @NForm OUTPUT, @ErrorMsg OUTPUT

   RETURN(@NForm)					--
END						-- end of fHtmToNormalForm
GO


--=======================================================
IF EXISTS (SELECT * FROM   sysobjects 
           WHERE  name = N'fHtmToNormalFormError') 
DROP FUNCTION fHtmToNormalFormError 
GO
--
CREATE FUNCTION fHtmToNormalFormError  (@Region VARCHAR(8000))
---------------------------------------------------------------------
--/H  Returns fHtmToNormalForm Error message
---------------------------------------------------------------------
--/T  returns error mesagage for a call to fHtmToNormalForm(@Region) or 'OK' if there is no error.
--/T  <li>Example: 
--/T  <samp>select dbo.fHtmToNormalFormError('CIRCLE CARTESIAN -.996 -.1 0 a')</samp>
--/T  <br>
----------------------------------------------------- 
RETURNS VARCHAR(1000)
AS
BEGIN
   DECLARE @Vector 	VARCHAR(8000)	-- the outpvector from xp_HTM 
   DECLARE @retcode 	INT		-- retcode from xp_HTM.
   DECLARE @ErrorMesssage VARCHAR(1000)   -- error message from HTM code
   SET @ErrorMesssage = ' '	
   EXECUTE  @retcode = master.dbo.xp_HTM2_toNormalForm @Region, @Vector OUTPUT, @ErrorMesssage OUTPUT
	IF ((@retcode != 0) and (@retcode != 20001))   
	BEGIN
	SET @ErrorMesssage = 'Call to master.dbo.xp_HTM2_toNormalForm failed completely.  ' +
				'Retcode ' + cast(@retcode as int)
	END 
   RETURN(@ErrorMesssage) 
END						-- end of fHtmToNormalFormError
GO


--=======================================================
IF EXISTS (SELECT *  FROM   sysobjects 
	WHERE  name = N'fHtmToVertices') 
	DROP FUNCTION fHtmToVertices 
GO
--
CREATE FUNCTION   fHtmToVertices (@HTM BIGINT)
---------------------------------------------------------------------
--/H  Returns returns (xyz)3 of an HTM triangle
---------------------------------------------------------------------
--/T  Given an HtmID, it returns the xyz of the three corner points.
--/T  <li> input is a bigint that is the HtmID.
--/T  <li> output is a string in the form x1 y1 z1 x2 y2 z2 x3 y3 z3
--/T
--/T  <li>Example: 
--/T  <samp>select dbo.fHtmToVertices(14844514541634)</samp>
--/T  <br> see also fHtmToPoint
--/T  <br>
----------------------------------------------------- 
RETURNS VARCHAR(1000)
AS
	BEGIN
	DECLARE @retcode	INT
	DECLARE @HTM_KLUDGE BINARY(8)
	DECLARE @Coordinate	VARCHAR(1000)
	DECLARE @Answer		VARCHAR(1000)	-- the answer string.
	DECLARE @ErrorMsg	VARCHAR(1000)
	SET @Answer = ' '		--
	SET @ErrorMsg = ' '
	SET @Coordinate = ' '
	SET @HTM_KLUDGE = CAST(@HTM AS BINARY(8))
	EXECUTE  @retcode = master.dbo.xp_HTM2_toVertices @HTM_KLUDGE, @Coordinate OUTPUT, @ErrorMsg OUTPUT
	IF ((@retcode != 0) and (@retcode != 20001)) 
	BEGIN
	    SET @ErrorMsg = 'Retcode ' + cast(@retcode as int)  + ' nonzero'
	    RETURN (@ErrorMsg)
	END
	RETURN(@Coordinate) 			
END			
GO


--=======================================================
IF EXISTS (SELECT *  FROM   sysobjects 
	WHERE  name = N'fHtmToPoint') 
	DROP FUNCTION fHtmToPoint 
GO
--
CREATE FUNCTION   fHtmToPoint (@HtmID BIGINT)
---------------------------------------------------------------------
--/H  Returns (xyz) of midpoint of an HTM triangle
---------------------------------------------------------------------
--/T  Given an HtmID,  
--/T  <li> input is a bigint that is the HtmID.
--/T  <li> output is a string in the form x1 y1 z1  
--/T
--/T  <li>Example: 
--/T  <samp>select dbo.fHtm_toPoint(14844514541634)</samp>
--/T  <br> see also fHtmToVertices
--/T  <br>
----------------------------------------------------- 
RETURNS VARCHAR(1000)
AS
	BEGIN
	DECLARE @retcode	INT
	DECLARE @HtmKludge BINARY(8)
	DECLARE @Coordinate	VARCHAR(1000)
	DECLARE @Answer		VARCHAR(1000)	-- the answer string.
	DECLARE @ErrorMsg	VARCHAR(1000)
	SET @Answer = ' '		--	
	SET @ErrorMsg = ' '
	SET @Coordinate = ' '
	SET @HtmKludge = CAST(@HtmID AS BINARY(8))
	EXECUTE  @retcode = master.dbo.xp_HTM2_toPoint @HtmKludge, @Coordinate OUTPUT, @ErrorMsg OUTPUT
	IF ((@retcode != 0) and (@retcode != 20001)) 
	BEGIN
	    SET @ErrorMsg = 'Retcode ' + cast(@retcode as int)  + ' nonzero'
	    RETURN (@ErrorMsg)
	END
	RETURN(@Coordinate) 			
END			
GO


--=======================================================
IF EXISTS (SELECT * FROM   sysobjects 
           WHERE  name = N'fHtmVersion') 
DROP FUNCTION fHtmVersion 
GO
--
CREATE  FUNCTION   fHtmVersion ()
---------------------------------------------------------------------
--/H  Returns HTM (Hierarchical Triangular Mesh) version string.
---------------------------------------------------------------------
--/T  <li>Example: (returns 'HTM_V2.DLL (build R37)' or something.
--/T  <samp>select dbo.fHtmVersion()</samp>
--/T  <br>
----------------------------------------------------- RETURNS VARCHAR(1000)

RETURNS VARCHAR(1000)
AS
	BEGIN
	DECLARE @retcode	INT
	DECLARE @Answer		VARCHAR(1000)	-- the answer string.
	DECLARE @ErrorMsg	VARCHAR(1000)
   	SET @ErrorMsg = ' '	
	SET @Answer = ' '		--
	EXECUTE  @retcode = master.dbo.xp_HTM2_Version @Answer OUTPUT, @ErrorMsg OUTPUT
	RETURN(@Answer) 			
END
GO


--=======================================================
IF EXISTS (SELECT *  FROM   sysobjects 
	WHERE  name = N'fHtmLookupXyz') 
	DROP FUNCTION fHtmLookupXyz 
GO
--
CREATE  FUNCTION fHtmLookupXyz(@x float, @y float, @z float) 
------------------------------------------------------------- 
--/H Returns HTM ID of a J2000  xyz point (@x,@y, @z). 
------------------------------------------------------------- 
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin. 
--/T <br> x,y,z is a unit vector on the celestial sphere. 
--/T <p> returned HTM ID is a bigint:  
--/T <li> x float NOT NULL,          -- x,y,z of unit vector to this object 
--/T <li> y float NOT NULL, 
--/T <li> z float NOT NULL, 
--/T <br> 
--/T Sample call to compute the HTM<br> 
--/T <samp> 
--/T <br> select objID, dbo.fHtmXyz(x,y,z) as HTMID 
--/T <br> from Galaxy 
--/T </samp> 
--/T <br> see also fHtmLookupEq, fHtmToString, fGetNearestObjXYZ 
---------------------------------------------------------
RETURNS bigint 
AS BEGIN 
	DECLARE @cmd varchar(100) 
        SET @cmd = 'CARTESIAN 20 ' 
             +str(@x,22,15)+' '+str(@y,22,15)+' '+str(@z,22,15) 
	RETURN dbo.fHtmLookup(@cmd)  
END 
GO


--=======================================================
IF EXISTS (SELECT *  FROM   sysobjects 
	WHERE  name = N'fHtmLookupEq') 
	DROP FUNCTION fHtmLookupEq 
GO
--
CREATE  FUNCTION fHtmLookupEq(@ra float, @dec float)
RETURNS bigint
------------------------------------------------------------- 
--/H Returns 20-deep HTM ID of a given J2000 Equatorial point (@ra,@dec) 
------------------------------------------------------------- 
--/T <br> ra, dec are in degrees. 
--/T <p> returned HTM ID is a bigint:  
--/T <li> ra float NOT NULL,          -- ra,dec of the point 
--/T <li> dec float NOT NULL, 
--/T <br> 
--/T Sample call to compute the HTM<br> 
--/T <samp> 
--/T <br> select objID, dbo.fHtmLookupEq(ra,dec) as HTMID 
--/T <br> from Galaxy 
--/T </samp> 
--/T <br> see also fHtmLookupXyz, fHtmToString, fGetNearestObjXYZ 
------------------------------------------------------------- 
AS BEGIN
	DECLARE @x float, @y float, @z float 
	SET @x  = COS(RADIANS(@dec))*COS(RADIANS(@ra)) 
	SET @y  = COS(RADIANS(@dec))*SIN(RADIANS(@ra)) 
	SET @z  = SIN(RADIANS(@dec)) 
	RETURN dbo.fHtmLookupXyz(@x, @y, @z) 
END 
GO

--=======================================================
if exists(select * from sysobjects 
	where name = N'fHtmEq')
	drop function fHtmEq 
GO
--
CREATE FUNCTION fHtmEq(@ra float, @dec float)
------------------------------------------------------------- 
--/H Returns 20-deep HTM ID of a given J2000 Equatorial point (@ra,@dec) 
------------------------------------------------------------- 
--/T <br> ra, dec are in degrees. 
--/T <p> returned HTM ID is a bigint:  
--/T <li> ra float NOT NULL,          -- ra,dec of the point 
--/T <li> dec float NOT NULL, 
--/T <br> 
--/T Sample call to compute the HTM<br> 
--/T <samp> 
--/T <br> select objID, dbo.fHtmEq(ra,dec) as HTMID 
--/T <br> from Galaxy 
--/T </samp> 
--/T <br> see also fHtmXyz, fHtmToString, fGetNearestObjXYZ 
------------------------------------------------------------- 
RETURNS bigint
AS BEGIN
	RETURN dbo.fHtmLookupEq(@ra,@dec)
END 
GO


--======================================= 
if exists(select * from   sysobjects 
	where name = N'fHtmXyz')
	drop function fHtmXyz 
GO 
--
CREATE FUNCTION fHtmXyz(@x float, @y float, @z float) 
RETURNS bigint 
------------------------------------------------------------- 
--/H Returns HTM ID of a pint a J2000  xyz point (@x,@y, @z). 
------------------------------------------------------------- 
--/T There is no limit on the number of objects returned, but there are about 40 per sq arcmin. 
--/T <br> x,y,z is a unit vector on the celestial sphere. 
--/T <p> returned HTM ID is a bigint:  
--/T <li> x float NOT NULL,          -- x,y,z of unit vector to this object 
--/T <li> y float NOT NULL, 
--/T <li> z float NOT NULL, 
--/T <br> 
--/T Sample call to compute the HTM<br> 
--/T <samp> 
--/T <br> select objID, dbo.fHtmXyz(x,y,z) as HTMID 
--/T <br> from Galaxy 
--/T </samp> 
--/T <br> see also fHtmEq, fHtmToString, fGetNearestObjXYZ 
---------------------------------------------------------
AS BEGIN  
	RETURN dbo.fHtmLookupXyz(@x, @y, @z) 
END 
GO
--

/* 
-- the north pole: 9345848836096 
select dbo.fHtmXyz(0,1,0) 
select dbo.fHtmEq(90,0) 
*/ 

PRINT '[spHTM.sql]: HTM functions created for database ' + DB_NAME(  )  
GO


/* basic tests
select dbo.fHtmVersion()ShouldBeHtmV2DllBldxx
select dbo.fHtmToString(dbo.fHtmLookup('J2000 185 0'))          ShouldBe1320001002001002001002
select dbo.fHtmToString(dbo.fHtmLookup('CARTESIAN -.996 -.1 0'))ShouldBe1320012000012010021002
select dbo.fHtmToString(dbo.fHtmLookup('J2000 0 185 0'))        ShouldBe13
select dbo.fHtmLookupError('J2000 1 185 a') errorMsg
select * from  dbo.fHtmCover('CIRCLE CARTESIAN -.996 -.1 0 5') ShouldBe14Rows
select         dbo.fHtmCoverError('CIRCLE CARTESIAN -.996 -.1 0 a') ShouldBeError
select dbo.fHtmToNormalForm     ('CIRCLE CARTESIAN -.996 -.1 0 5') ShouldBeRegionConvex
select dbo.fHtmToNormalFormError('CIRCLE CARTESIAN -.996 -.1 0 a') errorMsg
*/
--
