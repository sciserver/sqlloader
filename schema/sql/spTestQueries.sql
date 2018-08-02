--=======================================================================
--   spTestQueries.sql
--   2001-11-13 Jim Gray
-------------------------------------------------------------------------
--  Test Query Harness For SkyServer Database
--
--  Defines spTestQueries to test the 37 queries. 
--  Defines two support routines spTestTimeStart, spTestTimeEnd.
-------------------------------------------------------------------------
-- History:
--* 2003-06-03 Alex: changed row_count from int to bigint,
--*                  changed row_count() to rowcount_big().
--* 2004-08-30 Alex: move QueryResults to MetadataTables.sql
--* 2004-08-31 Jim+Alex: adapted ad hoc script to a sp
--* 2005-03-09 Jim: fixed radians() bug in query 12, 
--*                 moved other queies to Personal Skyserver Area.
--* 2005-12-13 Ani: Commented out Q19 since Photoz not loaded any more.
--* 2006-05-17 Ani: Reinstated Q19, Photoz back in for DR5.
--* 2007-06-10 Ani: Changed fHtmCover to fHtmCoverRegion.
--* 2008-02-10 Ani: Added ABS in Query 2 (needed for SEGUE queries).
--* 2009-05-05 Ani: Commented out queries usiing isophotal columns for SDSS-III.
--* 2009-08-13 Ani: Replaced specClass with class for specobj.
--* 2010-08-24 Ani: Removed reference to zconf from Query #9.
--* 2012-01-08 Ani: Removed calls to dbo.fSpecClass, commented out Q19 for now.
--=======================================================================

--===============================================
if  exists (select * from sysobjects
	where name =  N'spTestTimeStart') 
	drop procedure spTestTimeStart
GO
--
CREATE PROCEDURE spTestTimeStart(	
	@clock 	     datetime	OUTPUT,
	@cpu 	     bigint     OUTPUT, 
        @physical_io bigint	OUTPUT
)
----------------------------------------------------------------------
--/H Starts the wall, cpu, and IO clocks for performance testing 
--/A 
--/T  parameters are:
--/T	  <li> clock (output):		current 64bit wallclock datetime
--/T      <li> cpu (output):		 bigint of cpu milliseconds (wraps frequently so gives bogus answers)
--/T      <li> physical_Io (output): bigint count of disk reads and writes
--/T  <br>
--/T  Here is an example that uses spTestTimeStart and spTestTimeEnd to record the cost of 
--/T  some SQL statements. The example both records the results in the QueryResults table
--/T  and also prints out a message summarizing the test (that is what the 1,1 flags are for.)
--/T  <samp>
--/T  <br>declare @clock datetime, @cpu bigint, @physical_io bigint,  @elapsed bigint;
--/T  <br>exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
--/T  <br>  .... do some SQL work....
--/T  <br>exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 
--/T  <br>                           'Q10', '1GB buffer pool, read committed', 1, 1, @@RowCount_big
--/T  </samp><p>
--/T  see also spTestTimeEnd
---------------------------------------------------
AS
BEGIN
	SELECT	@clock	= getdate(), 
		@cpu	= @@CPU_BUSY, 
       		@physical_io = @@TOTAL_READ + @@TOTAL_WRITE
	RETURN
END
GO


--===================================================
if  exists (select * from sysobjects 
	where name = N'spTestTimeEnd') 
	drop procedure spTestTimeEnd
GO
--
CREATE PROCEDURE [dbo].[spTestTimeEnd](
	@clock 	     datetime,
	@elapsed     bigint        OUTPUT,
	@cpu 	     bigint        OUTPUT, 
        @physical_io bigint	   OUTPUT,
	@query	     varchar(10)  = '',
        @comment     varchar(100) = '', 
	@print       int        =0,
	@table       int        =0,
	@row_count   bigint     =0
)
---------------------------------------------------
--/H Stops the clock for performance testing and optionally records stats in QueryResults and in sysOut. 
--/A 
--/T  <p>parameters are (inputs should be set with spTestTimeStart as shown in example):
--/T       <li> clock datetime (input)       : current 64bit wallclock datetime
--/T       <li> elapsed float (output)       : elapsed milliseconds of wall clock time  
--/T       <li> cpu fkiat (input, output)    : an int of milliseconds of cpu time (wraps frequently so gives bogus answers)
--/T       <li> physical_Io bigint (input, output): count of disk reads and writes
--/T       <li> query varchar(10) (input)    : short text string describing the query
--/T       <li> commment varchar(100) (input) : longer text string describing the experiment
--/T       <li> print (input)       	      : flag, if true prints the output statistics on the console (default =no)
--/T       <li> table (input)                 : flag, if true inserts the statistics in the QueryResults table (default = no)
--/T       <li> row_Count(input)              : passed in RowCount_big for statistics
--/T  Here is an example that uses spTestTimeStart and spTestTimeEnd to record the cost of 
--/T  some SQL statements. The example both records the results in the QueryResults table
--/T  and also prints out a message summarizing the test (that is what the 1,1 flags are for.)
--/T  <samp>
--/T  <br>declare @clock datetime, @cpu bigint, @physical_io bigint,  @elapsed bigint;
--/T  <br>exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
--/T  <br>  .... do some SQL work....
--/T  <br>exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 
--/T  <br>                          'Q10', '1GB buffer pool, read committed', 1, 1, @@RowCount_big
--/T  </samp><p>
--/T  see also spTestTimeStart
---------------------------------------------------
AS	
BEGIN
	set nocount on;
	--
	select  @elapsed = datediff(ms, @clock, getdate()),
		@cpu = (@@CPU_BUSY - @cpu) * @@TIMETICKS, -- scale by ticks per microsecond
       		@physical_io = (@@TOTAL_READ + @@TOTAL_WRITE) - @physical_io
	-- treat wraparound of counters as a zero value
	if @cpu < 0			set @cpu = 0
	if @physical_io < 0 set @physical_io = 0
	-- printout
	if (@print >0)
           begin
           print @query
               + ' cpu: '              + str(@cpu/1000000.0, 8,2)   
               + ' sec, elapsed: '     + str(@elapsed/1000.0,8,2) 
               + ' sec, physical_io: ' + cast(@physical_io as varchar(20))
               + ' row_count: '        + cast(@row_count as varchar(20))
	       + ' comment: ' + @comment 
           end
	-- table record
	if (@table > 0)
           begin
		   if exists (select * from weblog.sys.tables where name = 'QueryResults')
		      insert weblog.dbo.QueryResults
              values(@query, @cpu/1000000.0, @elapsed/1000.0, @physical_io, @row_count,CURRENT_TIMESTAMP, db_name(), @comment);
           else
			  print concat('no weblog.dbo.QueryResults:',@query, @cpu/1000000.0, @elapsed/1000.0, @physical_io, @row_count,CURRENT_TIMESTAMP, db_name(), @comment)		  
           end          
	return
END
GO



--===============================================
if  exists (select * from sysobjects 
	where name =  N'spTestQueries') 
	drop procedure spTestQueries
GO
--
CREATE PROCEDURE spTestQueries(@n int, @comment varchar(100))
----------------------------------------------------------------------
--/H Runs the standard 37 SDSS queries and records their performance in QueryResults. 
--/A 
--/A Each querie's cpu time, elapsed time, physical IOs, and rows found is recorded. 
--/A In the end a statistical report is printed to sysOut. 
--/T  parameters are:
--/T	  <li> @n					The number of times to repeat the query run. 
--/T  <br>
--/T  <samp>
--/T  run the queries ten times:
--/T  <br>exec spTestQueries 10
--/T  </samp><p>
 
---------------------------------------------------
AS
BEGIN
	set nocount on
	-- Change History
	-- Query 1 change fGetNearbyObjEq(185,-0.5, 1) 
	--              to fGetNearbyObjEq(260,60, 1)
	-- Query 2 change ra between 170 and 190 and dec < 0 
	--             to ra between 193 and 197 and dec < 60
	--             to fit in personal best region. 
	-- Query 10A: there are 20 candidates with weak Halpha lines, but none qualify(Halpha/Hbeta > 20)
	-- Query 12: fixed rectangle to fit within personal BestDr2 region ('RECT J2000 193 5 197 -5')
	-- Query 12: added radians() for the cos()
	------------------------------------------------------------------------
	declare @cpu			bigint, 
			@physical_io	bigint, 
			@clock			datetime, 
			@elapsed		bigint,
			@i				bigint,
			@startTime		dateTime;
	------------------------------------------------------------------------
	-- Do the query set @n times. 	
	set @i = 1;
	set @startTime = getdate();
	while (@i <= @n)
		begin
 		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS 
 		--=====================================================================
		--Query 1: Find all galaxies without saturated pixels 
		--        within 1' of a given point of ra=75.327, dec=21.023
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		declare @saturated bigint;							-- initialized “saturated” flag
		set     @saturated = dbo.fPhotoFlags('saturated');	-- avoids SQL2K optimizer problem
		select	G.objID, GN.distance  				-- return Galaxy Object ID and 
	  	into 	##results1   					-- angular distance (arc minutes)
		from 	Galaxy                     as G  		-- join Galaxies with
		join	fGetNearbyObjEq(195,2.5, 1) as GN             	-- objects within 1’ of ra=195 & dec=2
						on G.objID = GN.objID	-- connects G and GN
		where (G.flags & @saturated) = 0  			-- not saturated
		order by distance					-- sorted nearest first
		---------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q01', @comment, 1, 1, @@RowCount 
		drop table ##results1
		--=====================================================================
 		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 2: Find all galaxies with blue surface brightness between and 23 and 25 mag 
		--         per square arcseconds, and -10<super galactic latitude (sgb) <10, 
		--         and declination less than zero. 
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		select ObjID
		into ##results2
		from Galaxy
		where mRrCc_r > 0			-- make sure the log is OK (size = SQRT(mRrCc_r/2.0))
		and 5*log10(SQRT(ABS(mRrCc_r)/2.0)*0.992574664)+modelMag_g between 23 and 25 -- surface brightness in g
		and ra between 150 and 270 	-- live with ra/dec till we get galactic coordinates
		and dec < 60 			-- declination less than 60.
		-- 0.39598* sqrt(2 *PI()) = 0.992574664 is the conversion from pixels to arcsec. 
		-- sqrt(2*PI()) is there for the area of a circular aperture.
		---------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q02', @comment, 1, 1, @@RowCount   
		drop table ##results2
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 3: Find all galaxies brighter than magnitude 22, 
		--         where the local extinction is >0.75. 
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select objID				-- put objIDs into ##results
		into ##results3
		from Galaxy G    			-- join Galaxies with Extinction table
		where  	r < 22 				-- where brighter than 22 magnitude
		and  	extinction_r> 0.120  		-- extinction more than 0.175
		---------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q03', @comment, 1, 1, @@RowCount 
		drop table ##results3
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
/*
		--=====================================================================
		--Query 4: Find galaxies with an isophotal surface brightness (SB) 
		--         larger than 24 in the red band, with an ellipticity>0.5, 
		--         and with the major axis of the ellipse having a declination 
		--         of between 30” and 60”arc seconds.
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select ObjID		   	 -- put the qualifying galaxies in a table
		into ##results4
		from Galaxy       		 -- select galaxies   
		where r + rho < 24   	    	 -- brighter than magnitude 24 in the red spectral band  
		and  isoA_r between 30 and 60  -- major axis between 30" and 60"
		and  (power(q_r,2) + power(u_r,2)) > 0.25 -- square of ellipticity is > 0.5 squared. 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q04', @comment, 1, 1, @@RowCount 
		drop table ##results4
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
*/
		--=====================================================================
		--Query 5: Find all galaxies with a deVaucouleours profile (r¼ falloff 
		--         of intensity on disk) and the photometric colors consistent 
		--         with an elliptical galaxy.     NO COLOR TESTS YET
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		declare @binned    bigint;			 	-- initialized “binned” literal
		set     @binned = 	dbo.fPhotoFlags('BINNED1') +	-- avoids SQL2K optimizer problem
   					dbo.fPhotoFlags('BINNED2') +
   					dbo.fPhotoFlags('BINNED4') ;
		declare @blended   bigint;			 	-- initialized “blended” literal
		set     @blended = 	dbo.fPhotoFlags('BLENDED');  	-- avoids SQL2K optimizer problem
		declare @noDeBlend bigint;			 	-- initialized “noDeBlend” literal
		set     @noDeBlend = 	dbo.fPhotoFlags('NODEBLEND'); -- avoids SQL2K optimizer problem
		declare @child     bigint;			 	-- initialized “child” literal
		set     @child = 	dbo.fPhotoFlags('CHILD');  	-- avoids SQL2K optimizer problem
		declare @edge      bigint;			 	-- initialized “edge” literal
		set     @edge = 	dbo.fPhotoFlags('EDGE');  	-- avoids SQL2K optimizer problem
		--declare @saturated bigint;			 	-- initialized “saturated” literal
		--set     @saturated = 	dbo.fPhotoFlags('SATURATED'); -- avoids SQL2K optimizer problem
		select objID
		into ##results5  
		from Galaxy as G 		-- count galaxies
		where	lnlDev_r > log(.1) + lnlExp_r -- red DeVaucouler fit likelihood greater than disk fit 
		and 	lnlExp_r > 0		-- exponential disk fit likelihood in red band > 0
		-- Color cut for an ellipical galaxy courtesy of James Annis of Fermilab
		and (G.flags & @binned) > 0  
		and (G.flags & ( @blended + @noDeBlend + @child)) != @blended
		and (G.flags & (@edge + @saturated)) = 0  
		and G.petroMag_i > 17.5
		and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
		and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
		and ((G.petroMag_r-G.extinction_r) < 19.2
		and ((G.petroMag_r - G.extinction_r) < (13.1 +     	-- deRed_r < 13.1 +
							(7/3)*(G.g - G.r) + 		-- 0.7 / 0.3 * deRed_gr
								4 *(G.r - G.i) -4 * 0.18 )) 	-- 1.2 / 0.3 * deRed_ri          
					and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 ) 
					)
			or (((G.petroMag_r - G.extinction_r) < 19.5 )
					and (( G.r - G.i -(G.g - G.r)/4 -.18) >    -- - deRed_gr/4 - 0.18 -- cperp = deRed_ri             
								(0.45 - 4*( G.g - G.r)))  	-- 0.45 - deRed_gr/0.25
					and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)))          
					) 
		---------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'Q05', @comment, 1, 1, @@RowCount 
		drop table ##results5
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 6: Find galaxies that are blended with a star, output the 
		--         deblended galaxy magnitudes.   
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select G.ObjID, G.u,G.g,G.r,G.i,G.z  			-- output galaxy and magnitudes.
		into   ##results6
		from 	Galaxy G, Star S  				-- for each galaxy and star
		where	G.parentID > 0					-- galaxy has a “parent”
		and   G.parentID = S.parentID				-- star has the same parent 
		---------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q06', @comment, 1, 1, @@RowCount 
		drop table ##results6
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 7: Provide a list of star-like objects that are 1% rare.   
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		-----------------------------------------------------------------------
		select 	cast(round((u-g),0) as int) as UG, 
			cast(round((g-r),0) as int) as GR, 
			cast(round((r-i),0) as int) as RI, 
			cast(round((i-z),0) as int) as IZ,
			count(*) as pop
		into 	##results7 
		from 	Star
		where (u+g+r+i+z) < 150   -- exclude bogus magnitudes (== 999) 
		group by cast(round((u-g),0) as int), cast(round((g-r),0) as int), 
 				cast(round((r-i),0) as int), cast(round((i-z),0) as int) 
		order by count(*)   
		-- without the having clause, found  14,681 buckets, 
		-- first 140 buckets have 99%  time 104 seconds
		-- So, used having as a filter to return rare stars.
		--Common bucktes have 500 or more members, so delete them.
		delete  ##results7
		where pop > 500   
		/*
		select top 100 distinct dbo.fPhotoDescription(objID) as info  
		from  Star s,
			##results f
		where f.ug = round((s.u-s.g),0) 
		and f.gr = round((s.g-s.r),0)
		and f.ri = round((s.r-s.i),0)
		and f.iz = round((s.i-s.z),0)  */
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q07', @comment, 1, 1, @@RowCount 
		drop table ##results7
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 8:  Find all objects with unclassified spectra.   
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select specObjID
		into   ##results8
		from   SpecObj
		where  class = 'UNKNOWN'  
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'Q08', @comment, 1, 1, @@RowCount 
		drop table ##results8
		--=====================================================================
/* Commented out because SpecLine doesn't exist any more [ART]
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 9:  Find quasars with a line width >2000 km/s and 2.5<redshift<2.7.   
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select  s.specObjID, max(l.sigma*300000.0/l.wave) kmps,  avg(s.z) as z  
		into    ##results9 
		from    SpecObj s, specLine l          -- from the spectrum table. 
		where  s.specObjID=l.specObjID 
		and ( (s.class = 'QSO')    -- quasar 
		and  s.z between 2.5 and 2.7   -- redshift of 2.0 to 2.2
		and  l.sigma*300000.0/l.wave >2000.0     -- convert sigma to km/s
		group by s.specObjID
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q09', @comment, 1, 1, @@RowCount 
		drop table ##results9
*/
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 10:  Find galaxies with spectra that have an equivalent width in Ha >40Å 
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select G.ObjID 						-- return qualifying galaxies
		into  ##results10
		from	Galaxy as G 					-- G is the galaxy
 		   join	SpecObj as S on G.ObjID = S.BestObjID 		-- S is the spectra of galaxy G
 		   join	galSpecLine as L on L.SpecObjID=S.SpecObjID	-- L is a line of S
		where  		-- connect the galaxy to the spectrum    
			L.h_alpha_reqw > 40				-- H alpha is at least 40 angstroms wide. 
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'Q10', @comment, 1, 1, @@RowCount 
		drop table ##results10
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 10A: That was easy, so lets also find objects with a weak Hbeta 
		--   line (Halpha/Hbeta > 20.)
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select G.ObjID 				-- return qualifying galaxies
		into  ##results10A
		from	Galaxy   as G 			-- G is the galaxy
 		   join	SpecObj as S on G.ObjID = S.BestObjID 		-- S is the spectra of galaxy G
 		   join	galSpecLine as L on S.SpecObjID = L.SpecObjID 		-- L is a line of S
		where
			L.h_alpha_reqw > 200				-- BIG Halpha
			and L.h_beta_reqw > 10				-- significant Hbeta emission line 
			and L.h_beta_reqw * 5 < L.h_alpha_reqw 			-- Hbeta is comparatively small
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q10A', @comment, 1, 1, @@RowCount 
		drop table ##results10A
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 11:  Find all elliptical galaxies with spectra that have an anomalous emission line.
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		--------------------------------------------------------------------------
		select	distinct G.ObjID 			-- return qualifying galaxies
  		into   ##results11
		from	Galaxy       as G, 		-- G is the galaxy
 			SpecObj	       as S, 		-- S is the spectra of galaxy G
 			SpecLine       as L, 		-- L is a line of S
 			specLineNames  as LN,		-- the type of line
 			XCRedshift     as XC		-- the template cross-correlation 
		where G.ObjID = S.BestObjID   		-- connect galaxy to the spectrum 
		and S.SpecObjID = L.SpecObjID		-- L is a line of S
		and S.SpecObjID = XC.SpecObjID 		-- CC is a cross-correlation with templates 
		and XC.tempNo = 8                  	-- Template('Elliptical') -- CC says "elliptical"
		and L.LineID = LN.value			-- line type is found  
 		and LN.Name = 'UNKNOWN'			--       but not identified
		and L.ew > 10				-- a prominent (wide) line
		and S.SpecObjID not in (		-- insist that there are no other lines
			select S.SpecObjID		-- insist that there are no other lines
			from   	SpecLine as L1,		-- L1 is another line 
				specLineNames as LN1	
			where S.SpecObjID = L1.SpecObjID -- for this object 
  			and abs(L.wave - L1.wave) <.01 	-- at nearly the same wavelength
  			and  L1.LineID = LN1.value	-- line found and  
 			and LN1.Name != 'UNKNOWN' 	--       it IS identified
			)      
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q11 ', @comment, 1, 1, @@RowCount 
		drop table ##results11
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		-- Query 12: Create a grided count of galaxies with u-g>1 and r<21.5 over
		--          60<declination<70, and 200<right ascension<210, 
		--          on a grid of 2’, and create a map of masks over the same grid.  
		--          Scan the table for galaxies and group them in cells 2 arc-minutes
		--          on a side. Provide predicates for the color restrictions on u-g 
		--          and r and to limit the search to the portion of the sky defined 
		--          by the right ascension and declination conditions.  
		--          Return the count of qualifying galaxies in each cell. 
		--          Run another query with the same grouping, but with a predicate 
		--          to include only objects such as satellites, planets, and airplanes 
		--          that obscure the cell.  The second query returns a list of cell 
		--          coordinates that serve as a mask for the first query. The mask may 
		--          be stored in a temporary table and joined with the first query.      
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		--- First find the grided galaxy count (with the color cut)
		--- In local tangent plane, ra/cos(dec) is a “linear” degree.
 		select cast((ra/cos(radians(cast(dec*30 as int)/30.0)))*30 as int)/30.0 as raCosDec, 
			cast(dec*30 as int)/30.0                                as dec, 
			count(*)                                                as pop
		into ##GalaxyGrid
		from   Galaxy as G, 
			dbo.fHtmCoverRegion('RECT J2000 193 5 197 -5') as T
		where  htmID  between T.HTMIDstart and T. HTMIDend  
		and  ra between 193 and 197
		and  dec between -5 and 5
		and  u-g > 1
		and  r < 21.5
		group by  cast((ra/cos(radians(cast(dec*30 as int)/30.0)))*30 as int)/30.0, 
				cast(dec*30 as int)/30.0    
		--- now build mask grid.
		select 	cast((ra/cos(radians(cast(dec*30 as int)/30.0)))*30 as int)/30.0 as raCosDec, 
			cast(dec*30 as int)/30.0                                as dec, 
			count(*)                                                as pop
		into ##MaskGrid                                                
		from    photoObjAll as PO, 
			dbo.fHtmCoverRegion('RECT J2000 193 5 197 -5') as T,
			PhotoType as PT
		where  htmID between T. HTMIDstart and T. HTMIDend 
		and  ra between 193 and 197
		and  dec between -5 and 5
		and PO.type = PT.value
		and PT.name in ('COSMIC_RAY', 'DEFECT', 'GHOST', 'TRAIL', 'UNKNOWN')
		group by  cast((ra/cos(radians(cast(dec*30 as int)/30.0)))*30 as int)/30.0, 
				cast(dec*30 as int)/30.0    
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q12', @comment, 1, 1, @@RowCount 
		drop table ##MaskGrid
		drop table ##GalaxyGrid
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 13:  Create a count of galaxies for each of the HTM triangles 
		--           which satisfy a certain color cut,  
		--           like 0.7u-0.5g-0.2i<1.25 && r<21.75, output it in a form 
		--           adequate for visualization.     
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		declare @RightShift12 bigint;
		set @RightShift12 = power(2,24);
		select (htmID /@RightShift12) as htm_8 , 	-- group by 8-deep HTMID (rshift HTM by 12)
 			avg(ra) as ra, 
			avg(dec) as [dec], 
				count(*) as pop			-- return center point and count for display
		into  ##results13				-- put the answer in the results set.
		from  Galaxy	 				-- only look at galaxies
		where  (0.7*u - 0.5*g - 0.2*i) < 1.25 		-- meeting this color cut
		and  r < 21.75					-- brightr than 21.75 magnitude in red band.
		group by  (htmID /@RightShift12)		-- group into 8-deep HTM buckets.
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q13', @comment, 1, 1, @@RowCount 
		drop table ##results13
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 14:  Find stars with multiple measurements that have magnitude 
		--           variations >0.1.     
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		-- hack for SQL Server 2000 optimizer bookmark bug.
		--drop index photoObj.ugriz
		--go
		--create index ugriz on photoObj(objID,run,type, status, flags, u,g,r,i,z, Err_u, Err_g, Err_r, Err_i, Err_z)
		--  6:59 == 420 sec
		--48245 row(s) affected)
		-- Q14 with ugriz index cpu:   288.27 sec, elapsed:   228.91 sec, physical_io: 520793 row_count: 48245
		--  so with index build it is 288+420 = 708 sec (10 min vs 50 minutes 3110 sec with bookmark bug)
		---------------------------------------------------------------------------
		---------------------------------------------------------------------------
		declare @star int;			    	-- initialized “star” literal
		set     @star = dbo.fPhotoType('Star'); 	-- avoids SQL2K optimizer problem
		select s1.objID as objID1, s2.objID as ObjID2	-- select object IDs of star and its pair	
		into ##results14
		from   Star     as   s1,			-- the primary star
			photoObj  as   s2,			-- the second observation of the star
			neighbors as   N			-- the neighbor record
		where s1.objID = N.objID			-- insist the stars are neighbors
		and s2.objID = N.neighborObjID			-- using precomputed neighbors table
		and distance < 0.5/60				-- distance is ½ arc second or less
		and s1.run != s2.run				-- observations are two different runs
		and s2.type = @star				-- s2 is indeed a star
		and  s1.u between 1 and 27			-- S1 magnitudes are reasonable
		and  s1.g between 1 and 27
		and  s1.r between 1 and 27
		and  s1.i between 1 and 27
		and  s1.z between 1 and 27
		and  s2.u between 1 and 27			-- S2 magnitudes are reasonable.
		and  s2.g between 1 and 27
		and  s2.r between 1 and 27
		and  s2.i between 1 and 27
		and  s2.z between 1 and 27
		and (    	                       	-- and one of the colors is  different.
				abs(S1.u-S2.u) > .1 + (abs(S1.Err_u) + abs(S2.Err_u))  		
				or abs(S1.g-S2.g) > .1 + (abs(S1.Err_g) + abs(S2.Err_g)) 	
				or abs(S1.r-S2.r) > .1 + (abs(S1.Err_r) + abs(S2.Err_r)) 
				or abs(S1.i-S2.i) > .1 + (abs(S1.Err_i) + abs(S2.Err_i)) 
				or abs(S1.z-S2.z) > .1 + (abs(S1.Err_z) + abs(S2.Err_z)) 
			)
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q14', @comment, 1, 1, @@RowCount 
		drop table ##results14
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 15: Provide a list of moving objects consistent with an asteroid.     
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select	objID,  											-- return object ID
 				sqrt( power(rowv,2) + power(colv, 2) ) as velocity	-- velocity
		into  ##results15A
		from	PhotoObj  											-- check each object.
		where (power(rowv,2) + power(colv, 2)) between 50 and 1000	-- square of velocity (units?)
    																-- big values indicate error
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'Q15A', @comment, 1, 1, @@RowCount 
		drop table ##results15A
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
/*
		--=====================================================================
		--Query 15B:  redo Q15 in a different way.
		---------------look for two different objects that are streaks that line up with one another.
		---------------in red, blue, and green.
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		create index NEO on photoObj(run, camcol, field, parentID, 
 			q_r,q_g,u_r,u_g, isoA_r, isoB_r,  
 			FiberMag_u,FiberMag_g,FiberMag_r,FiberMag_i,FiberMag_z)
		SELECT r.objID as rId, g.objId as gId, 
			r.run, r.camcol, 
			r.field as field, g.field as gField,
			r.ra as ra_r, r.dec as dec_r, 
			g.ra as ra_g, g.dec as dec_g, --(note acos(x) ~ x for x~1)
			sqrt( power(r.cx -g.cx,2)+ power(r.cy-g.cy,2)+power(r.cz-g.cz,2) )*((180*60)/PI()) as distance,
			dbo.fGetUrlExpId(r.objID) as rURL, 
			dbo.fGetUrlExpId(g.objID) as gURL 
			into ##results15B
			FROM PhotoObj r, PhotoObj g
			WHERE 
			r.run = g.run and r.camcol=g.camcol and abs(g.field-r.field)<2  -- the match criteria
			-- the red selection criteria
			and ((power(r.q_r,2) + power(r.u_r,2)) > 0.111111 )
			and r.fiberMag_r between 6 and 22 and r.fiberMag_r < r.fiberMag_g and r.fiberMag_r < r.fiberMag_i
			and r.parentID=0 and r.fiberMag_r < r.fiberMag_u and r.fiberMag_r < r.fiberMag_z
			and r.isoA_r/r.isoB_r > 1.5 and r.isoA_r>2.0
			-- the green selection criteria
			and ((power(g.q_g,2) + power(g.u_g,2)) > 0.111111 )
			and g.fiberMag_g between 6 and 22 and g.fiberMag_g < g.fiberMag_r and g.fiberMag_g < g.fiberMag_i
			and g.fiberMag_g < g.fiberMag_u and g.fiberMag_g < g.fiberMag_z
			and g.parentID=0 and g.isoA_g/g.isoB_g > 1.5 and g.isoA_g > 2.0
			-- the matchup of the pair (note acos(x) ~ x for x~1)
			and sqrt(power(r.cx -g.cx,2)+ power(r.cy-g.cy,2)+power(r.cz-g.cz,2))*((60*180)/PI())< 4.0
			and abs(r.fiberMag_r-g.fiberMag_g)< 2.0
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed , @cpu , @physical_io ,'Q15B', @comment, 1, 1, @@RowCount 
		drop table ##results15B
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
*/
		--=====================================================================
		--Query 16: Find all objects similar to the colors of a quasar at 5.5<redshift<6.5.   	
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select count(*) 					as 'total', 	
		sum( case when (Type=3) then 1 else 0 end) 		as 'Galaxies',
		sum( case when (Type=6) then 1 else 0 end) 		as 'Stars',
		sum( case when (Type not in (3,6)) then 1 else 0 end) 	as 'Other'
		into ##results16
		from 	PhotoPrimary					-- for each object		 		
		where (( u - g > 2.0) or (u > 22.3) ) 			-- apply the quasar color cut.
		and ( i between 0 and 19 ) 
		and ( g - r > 1.0 ) 
		and ( (r - i < 0.08 + 0.42 * (g - r - 0.96)) or (g - r > 2.26 ) )
		and 	( i - z < 0.25 )
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q16', @comment, 1, 1, @@RowCount 
		drop table ##results16
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 17: Find binary stars where at least one of them has the colors 
		--          of a white dwarf.   
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		--declare @star int;			    	-- initialized “star” literal
		--set     @star = dbo.fPhotoType('Star'); 	-- avoids SQL2K optimizer problem
		select	s1.objID as s1, s2.objID as s2		-- just count them
		into ##results17
		from	Star S1,				-- S1 is the white dwarf
 			Neighbors N,				-- N is the precomputed neighbors links
			Star S2					-- S2 is the second star
		where S1.objID = N. objID 			-- S1 and S2 are neighbors-within 30 arc sec
			and S2.objID = N.NeighborObjID  
			and N.NeighborType = @star       	-- and S2 is a star
			and N.distance < .05			-- the 3 arcsecond test
			and ((S1.u - S1.g) < 0.4 )		-- and S1 meets Paul Szkody’s color cut for
			and (S1.g - S1.r) < 0.7 		-- white dwarfs.
			and (S1.r - S1.i) > 0.4 
			and (S1.i - S1.z) > 0.4     
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q17', @comment, 1, 1, @@RowCount 
		--=====================================================================
		drop table ##results17
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query 18: Find all objects within 30 arcseconds of one another that 
		--          have very similar colors: that is where the color ratios
		--          u-g, g-r, r-I are less than 0.05m.      
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select distinct P.ObjID 		-- distinct cases  
		into ##results18			-- the oid compare eliminats dups
		From	PhotoPrimary   P,		-- P is the primary object
			Neighbors      N, 		-- N is the neighbor link
			PhotoPrimary   L		-- L is the lens candidate of P
		where P.ObjID = N.ObjID			-- N is a neighbor record
		and L.ObjID = N.NeighborObjID  		-- L is a neighbor of P
		and P.ObjID < L. ObjID 			-- avoid duplicates
		and abs((P.u-P.g)-(L.u-L.g))<0.05 	-- L and P have similar spectra.
		and abs((P.g-P.r)-(L.g-L.r))<0.05
		and abs((P.r-P.i)-(L.r-L.i))<0.05  
		and abs((P.i-P.z)-(L.i-L.z))<0.05  
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q18', @comment, 1, 1, @@RowCount 
		drop table ##results18
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================
		--Query 19: Find quasars with a broad absorption line in their spectra 
		--          and at least one galaxy within 10 arcseconds. 
		--          Return both the quasars and the galaxies.      
/*
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		select Q.BestObjID as Quasar_candidate_ID , G.ObjID as Galaxy_ID, N.distance
		into ##results19   
		from SpecObj       	as Q, 		-- Q is the specObj of the quasar candidate
			Neighbors       as N,	-- N is the Neighbors list of Q
			Galaxy          as G,		-- G is the nearby galaxy
			class  		as SC,	-- Spec Class
			galSpecLine     as L, 	-- L is the broad line we are looking for 
		where Q.class =SC.value	  	-- Q is a QSO
			and SC.name  in ('QSO', 'HIZ_QSO') -- Spectrum says "QSO"
			and Q.SpecObjID = L.SpecObjID	-- L is a spectral line of Q.
			and L.ew < -10			-- but its a prominent absorption line
			and Q.BestObjID = N.ObjID	-- N is a neighbor record
			and G.ObjID = N.NeighborObjID  	-- G is a neighbor of Q
			and N.distance < 10.0/60	-- and it is within 10 arcseconds of the Q. 
		--------------------------------------------------------------------------

		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q19', @comment, 1, 1, @@RowCount 
		drop table ##results19
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
*/
		--=====================================================================
		--Query 20: : For each galaxy in the BCG data set (brightest color galaxy), 
		--            in 160<right ascension<170, -25<declination<35 count the number of 
		--            galaxies within 30" of it that have a photoz within 0.05 
		--            of that galaxy.
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		--declare @binned    bigint;			 	-- initialized “binned” literal
		set     @binned = 	dbo.fPhotoFlags('BINNED1') +	-- avoids SQL2K optimizer problem
   				dbo.fPhotoFlags('BINNED2') +
   				dbo.fPhotoFlags('BINNED4') ;
		--declare @blended   bigint;			 	-- initialized “blended” literal
		set     @blended = 	dbo.fPhotoFlags('BLENDED');  	-- avoids SQL2K optimizer problem
		--declare @noDeBlend bigint;			 	-- initialized “noDeBlend” literal
		set     @noDeBlend = 	dbo.fPhotoFlags('NODEBLEND'); 	-- avoids SQL2K optimizer problem
		--declare @child     bigint;			 	-- initialized “child” literal
		set     @child = 	dbo.fPhotoFlags('CHILD');  	-- avoids SQL2K optimizer problem
		--declare @edge      bigint;			 	-- initialized “edge” literal
		set     @edge = 	dbo.fPhotoFlags('EDGE');  	-- avoids SQL2K optimizer problem
		--declare @saturated bigint;			 	-- initialized “saturated” literal
		set     @saturated = 	dbo.fPhotoFlags('SATURATED'); 	-- avoids SQL2K optimizer problem
		select  G.objID, count(N.NeighborObjID) as pop
		into    ##results20
		from 	Galaxy   as G,    	-- first gravitational lens candidate   
 			Neighbors  as N,   	-- precomputed list of neighbors
  			Galaxy   as U, 		-- a neighbor galaxy of G
			photoZ	   as Gpz,	-- photoZ of G.
				photoZ     as Npz -- Neighbor photoZ
		where G.ra between 190 and 200	-- changed range so matches perspnal DB.
			and G.dec between -5 and 5	--
			and G.objID = N.objID		-- connect G and U via the neighbors table
			and U.objID = N.neighborObjID 	-- so that we know G and U are within 
			and N.objID < N.neighborObjID 	-- 30 arcseconds of one another.
			and G.objID = Gpz.objID
			and U.objID = Npz.objID
			and abs(Gpz.Z - Npz.Z) < 0.05	-- restrict the photoZ differences
		-- Color cut for an BCG courtesy of James Annis of Fermilab
		and (G.flags & @binned) > 0  
		and (G.flags & ( @blended + @noDeBlend + @child)) != @blended
		and (G.flags & (@edge + @saturated)) = 0  
		and G.petroMag_i > 17.5
		and (G.petroMag_r > 15.5 OR G.petroR50_r > 2)
		and (G.petroMag_r < 30 and G.g < 30 and G.r < 30 and G.i < 30)
		and  (G.r < 19.2 
			and ( 1=1 or
					(G.r < (13.1 + (7/3)*(G.g - G.r) +  	-- deRed_r < 13.1 + 0.7 / 0.3 * deRed_gr
					4 *(G.r - G.i - 0.18 )) 		-- 1.2 / 0.3 * deRed_ri          
				and (( G.r - G.i - (G.g - G.r)/4 - 0.18) BETWEEN -0.2 AND  0.2 )
			and ((G.r +  	                        -- petSB - deRed_r + 2.5 log10(2Pi*petroR50^2)
					2.5 * LOG( 2 * 3.1415 * G.petroR50_r * G.petroR50_r )) < 24.2 )  
				)
				or 
				(      (G.r < 19.5 )
				and (( G.r - G.i -(G.g - G.r)/4 -.18) >    	-- - deRed_gr/4 - 0.18      									-- cperp = deRed_ri             
								(0.45 - 4*( G.g - G.r)))  		-- 0.45 - deRed_gr/0.25
				and ((G.g - G.r) > ( 1.35 + 0.25 *(G.r - G.i)))
				and ((G.r  + 	-- petSB - deRed_r + 2.5 log10(2Pi*petroR50^2)          
						2.5 * LOG( 2 * 3.1415 * G.petroR50_r * G.petroR50_r )) < 23.3 )
				))  )
		group by G.objID        
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q20', @comment, 1, 1, @@RowCount 
		--=====================================================================
		DROP TABLE ##results20
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX1: Cataclysmic variables 
		-- Paula Szkody <szkody@alicar.astro.washington.edu>
		-- Search for Cataclysmic Variables and pre-CVs with White Dwarfs and
		-- very late secondaries:
		-- u-g < 0.4
		-- g-r < 0.7
		-- r-i > 0.4
		-- i-z > 0.4
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT  run,               
				camCol,
			rerun,
			field,
			objID,
			u,g,r,i,z,
			ra,  dec
		INTO ##resultsX01
		FROM PhotoPrimary
		WHERE 	u - g < 0.4 and
			g - r < 0.7 and
    			r - i > 0.4 and
    			i - z > 0.4
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX01', @comment, 1, 1, @@RowCount 
		drop table ##resultsX01
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX2: Velocities and errors ============================
		-- (Robert H. Lupton <rhl@astro.princeton.edu>)
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT  run,
			camCol,
			field,
			objID,
			rowC,colC,rowV,colV,rowVErr,colVErr,
			flags,
			psfMag_u,psfMag_g,psfMag_r,psfMag_i,psfMag_z,
			psfMagErr_u,psfMagErr_g,psfMagErr_r,psfMagErr_i,psfMagErr_z
		INTO ##resultsX02
		FROM PhotoPrimary
		WHERE  rowvErr > 0 and colvErr> 0 
		and ((rowv * rowv) / (rowvErr * rowvErr) + 
			(colv * colv) / (colvErr * colvErr) > 4)
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'QSX02', @comment, 1, 1, @@RowCount 
		drop table ##resultsX02
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX3: Coordinate cut 
		-- (Robert H. Lupton <rhl@astro.princeton.edu>)
		-- coordinate cut --> cut in ra --> 40:100
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT colc_g, colc_r
		INTO ##resultsX03
		FROM  PhotoObj
		WHERE (-0.2 * cx + 0.766044 * cy>=0) 
		AND (-0.16 * cx +0.63648 * cy <0) 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'QSX03', @comment, 1, 1, @@RowCount 
		drop table ##resultsX03
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX4: Searching objects and fields by ID 
		-- (Robert H. Lupton <rhl@astro.princeton.edu>)
		-- Searching for a particular object in a particular field.
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT  objID,
			field, ra, dec
		INTO ##resultsX04
		FROM PhotoObj
		WHERE  obj = 13 AND  field = 521
 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX04', @comment, 1, 1, @@RowCount 
		drop table ##resultsX04
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX5: Galaxies with bluer centers 
		-- Michael Strauss <strauss@astro.princeton.edu>
		-- For all galaxies with r_Petro < 18, not saturated, not bright, not
		-- edge, give me those whose centers are appreciably bluer than their
		-- outer parts. That is, define the center color as: u_psf - g_psf And
		-- define the outer color as: u_model - g_model Give me all objects
		-- which have (u_model - g_model) - (u_psf - g_psf) < -0.4
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		DECLARE @flags  BIGINT;
		SET @flags = 	dbo.fPhotoFlags('SATURATED') +
				dbo.fPhotoFlags('BRIGHT')    +
				dbo.fPhotoFlags('EDGE') 
		SELECT colc_u, colc_g,  objID       --or whatever you want from each object
		INTO ##resultsX05
		FROM  Galaxy
		WHERE (Flags &  @flags )= 0  
		and petroRad_r < 18
		and ((colc_u - colc_g) - (psfMag_u - psfMag_g)) < -0.4 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX05', @comment, 1, 1, @@RowCount 
		drop table ##resultsX05
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX6:  PSF colors of stars 
		-- Michael Strauss <strauss@astro.princeton.edu>
		-- Give me the PSF colors of all stars brighter than 20th (rejecting on
		-- various flags) that have PSP_STATUS = 2
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT  s.psfMag_g,         -- or whatever you want from each object
			s.run,
			s.camCol,
			s.rerun,
			s.field
		INTO ##resultsX06
		FROM Star s, Field f
		WHERE  s.fieldID = f.fieldID
		AND  s.psfMag_g < 20 
		AND  f.pspStatus = 2  
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'QSX06', @comment, 1, 1, @@RowCount 
		drop table ##resultsX06
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		-----------------------------------------------------------------------
		--Query SX7:  Cluster finding 
		-- (James Annis <annis@fnal.gov>)
		-- if {AR_DFLAG_BINNED1 || AR_DFLAG_BINNED2 || AR_DFLAG_BINNED4} {
		--    if {! ( AR_DFLAG_BLENDED AND !( AR_DFLAG_NODEBLEND || AR_DFLAG_CHILD))} {
		--       if { galaxy } { ;# not star, asteroid, or bright
		--           if { primary_object} {
		--             if {petroMag{i} < 23 } { accept }
		--           }
		--       }
		--    }
		-- }
		
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		--DECLARE @binned BIGINT
		SET @binned = 	dbo.fPhotoFlags('BINNED1') +
				dbo.fPhotoFlags('BINNED2') +
				dbo.fPhotoFlags('BINNED4') 
		DECLARE @deblendedChild BIGINT
		SET @deblendedChild =	dbo.fPhotoFlags('BLENDED')   +
					dbo.fPhotoFlags('NODEBLEND') +
					dbo.fPhotoFlags('CHILD')
		--DECLARE @blended BIGINT
		SET @blended = dbo.fPhotoFlags('BLENDED')
		SELECT  camCol,
				run,
			rerun,
				field,
				objID, ra, dec
		INTO ##resultsX07
		FROM Galaxy                             -- select galaxy and primary only
		WHERE (flags &  @binned )> 0  
		AND (flags &  @deblendedChild ) !=  @blended 
		AND petroMag_i < 23 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'QSX07', @comment, 1, 1, @@RowCount 
		drop table ##resultsX07
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX8: Diameter-limited sample of galaxies 
		-- (James Annis <annis@fnal.gov>)
		-- if {AR_DFLAG_BINNED1 || AR_DFLAG_BINNED2 || AR_DFLAG_BINNED4} {
		--   if {! ( AR_DFLAG_BLENDED AND !( AR_DFLAG_NODEBLEND || AR_DFLAG_CHILD)} {
		--      if { galaxy } { ;# not star, asteroid, or bright
		--         if (!AR_DFLAG_NOPETRO) {
		--           if { petrorad > 15 } { accept }
		--         } else {
		--           if { petror50 > 7.5 } { accept }
		--         }
		--         if (AR_DFLAG_TOO_LARGE AND petrorad > 2.5 ) { accept }
		--         if ( AR_DFLAG_SATUR AND petrorad < 17.5) { don't accept }
		--      }
		--    }
		--  }
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		--DECLARE @binned BIGINT
		SET @binned = 	dbo.fPhotoFlags('BINNED1') +
				dbo.fPhotoFlags('BINNED2') +
				dbo.fPhotoFlags('BINNED4') 
		--DECLARE @deblendedChild BIGINT
		SET @deblendedChild =	dbo.fPhotoFlags('BLENDED')   +
					dbo.fPhotoFlags('NODEBLEND') +
					dbo.fPhotoFlags('CHILD')
		--DECLARE @blended BIGINT
		SET @blended = dbo.fPhotoFlags('BLENDED')
		DECLARE @noPetro BIGINT
		SET @noPetro = dbo.fPhotoFlags('NOPETRO')
		DECLARE @tooLarge BIGINT
		SET @tooLarge = dbo.fPhotoFlags('TOO_LARGE')
		--DECLARE @saturated BIGINT
		SET @saturated = dbo.fPhotoFlags('SATURATED')
		SELECT run,
			camCol,
			rerun,
			field,
			objID, 
			ra, 
			dec
		INTO ##resultsX08
		FROM Galaxy
		WHERE (flags &  @binned )> 0  
		AND (flags &  @deblendedChild ) !=  @blended
		AND (  (( flags & @noPetro = 0) 
				AND petroRad_i > 15)
			OR ((flags & @noPetro > 0) 
				AND petroRad_i > 7.5)
			OR ((flags & @tooLarge > 0) 
				AND petroRad_i > 2.5)
			OR --note, Gray changed this and to an or, becuase it did not make sense as an and.
				((flags & @saturated  = 0 )
				AND petroRad_i > 17.5)
			) 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'QSX08', @comment, 1, 1, @@RowCount 
		drop table ##resultsX08
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX9: Extremely red galaxies: 
		-- (James Annis <annis@fnal.gov>)
		-- if {AR_DFLAG_BINNED1 || AR_DFLAG_BINNED2 || AR_DFLAG_BINNED4} {
		--    if {! ( AR_DFLAG_BLENDED AND !( AR_DFLAG_NODEBLEND || AR_DFLAG_CHILD)} {
		--        if { galaxy } { ;# not star, asteroid, or bright
		--           if { primary_object} {
		--               if {!AR_DFLAG_CR AND !R_DFLAG_INTERP}
		--                   if { frame_seeing < 1.5" } {
		--                       if { Mag_model<i>-Mag_model<z> - 
		--                              (extinction<i> - extinction<z>) > 1.0 } {
		--                          accept
		--                       }
		--                   }
		--               }
		--           }
		--        }
		--     }
		-- }
		
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		--DECLARE @binned BIGINT
		SET @binned = 	dbo.fPhotoFlags('BINNED1') +
				dbo.fPhotoFlags('BINNED2') +
				dbo.fPhotoFlags('BINNED4') 
		--DECLARE @deblendedChild BIGINT
		SET @deblendedChild =	dbo.fPhotoFlags('BLENDED')   +
					dbo.fPhotoFlags('NODEBLEND') +
					dbo.fPhotoFlags('CHILD')
		--DECLARE @blended BIGINT
		SET @blended = dbo.fPhotoFlags('BLENDED')
		DECLARE @crIntrp BIGINT
		SET @crIntrp = 	dbo.fPhotoFlags('COSMIC_RAY')  +
				dbo.fPhotoFlags('INTERP')
		SELECT g.run,
			g.camCol,
			g.rerun,
			g.field,
			g.objID, g.ra, g.dec
		INTO ##resultsX09
		FROM Galaxy g, Field f
		WHERE g.fieldID = f.fieldID
		AND (flags &  @binned )> 0  
		AND (flags &  @deblendedChild ) !=  @blended
		AND (flags &  @crIntrp ) = 0
		AND f.psfWidth_r < 1.5 
		AND (i - z > 1.0 )
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX09', @comment, 1, 1, @@RowCount 
		drop table ##resultsX09
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX10: The BRG sample 
		-- (James Annis <annis@fnal.gov>)
		-- if {AR_DFLAG_BINNED1 || AR_DFLAG_BINNED2 || AR_DFLAG_BINNED4} {
		--    if {! ( AR_DFLAG_BLENDED AND !( AR_DFLAG_NODEBLEND || AR_DFLAG_CHILD)} {
		--       if {!AR_DFLAG_EDGE & !AR_DFLAG_SATUR} {
		--          if { galaxy} { ;# not star, asteroid, or bright
		--            if { primary_object} {
		--               if {! (petroMag<2> < 15.5 AND petror50<2> < 2) } {
		--                 if {petroMag<r> > 0 AND Mag_model<g> > 0 AND
		--                       Mag_model<r> > 0 AND Mag_model<i> > 0 } {
		--                     petSB = deRed_r + 2.5*log10(2*3.1415*petror50<r>^2)
		--                     deRed_g = petroMag<g> - extinction<g>
		--                     deRed_r = petroMag<r> - extinction<r>
		--                     deRed_i = petroMag<i> - extinction<i>
		--                     deRed_gr = deRed_g - deRed_r
		--                     deRed_ri = deRed_r - deRed_i
		--                     cperp = deRed_ri - deRed_gr/4.0 - 0.18
		--                     cpar = 0.7*deRed_gr + 1.2*(deRed_ri -0.18)
		--                     if {(deRed_r < 19.2 AND deRed_r < 13.1 + cpar/0.3 AND
		--                          abs(cperp) < 0.2 AND petSB < 24.2 ) ||
		--                          (deRed_r < 19.5 AND cperp > 0.45 - deRed_gr/0.25 AND
		--                           deRed_gr > 1.35 + deRed_ri*0.25 AND petSB < 23.3) {
		--                          accept ;# whew!!!
		--                      }
		--                   }
		--                }
		--             }
		--           }
		--        }
		--     }
		--  }
		--
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		--DECLARE @binned BIGINT
		SET @binned = 	dbo.fPhotoFlags('BINNED1') +
				dbo.fPhotoFlags('BINNED2') +
				dbo.fPhotoFlags('BINNED4') 
		--DECLARE @deblendedChild BIGINT
		SET @deblendedChild =	dbo.fPhotoFlags('BLENDED')   +
					dbo.fPhotoFlags('NODEBLEND') +
					dbo.fPhotoFlags('CHILD')
		--DECLARE @blended BIGINT
		SET @blended = dbo.fPhotoFlags('BLENDED')
		DECLARE @edgedSaturated BIGINT
		SET @edgedSaturated =	dbo.fPhotoFlags('EDGE') +
		 			dbo.fPhotoFlags('SATURATED')
		SELECT	run,
			camCol,
			rerun,
			field,
			objID,
			ra,
			dec
		into ##resultsX10
		FROM Galaxy
		WHERE (flags &  @binned)> 0  
		AND (flags &  @deblendedChild) !=  @blended
		AND (flags &  @edgedSaturated)  = 0  
			AND petroMag_i > 17.5
			AND (petroMag_r > 15.5 OR petroR50_r > 2)
			AND (petroMag_r > 0 AND g>0 AND r>0 AND i>0)
			AND (petroR50_r > 0 ) -- petroR50 value is valid, need to avoid log(0)
			AND ((   (petroMag_r-extinction_r) < 19.2
					AND (petroMag_r - extinction_r < 
				(13.1 + (7/3)*( g - r) + 4 *( r  - i) - 4 * 0.18 ) )          
					AND ( ( (r - i) - (g -  r )/4 - 0.18 ) <  0.2 ) 
					AND ( ( (r - i)  - (g  - r)/4 - 0.18 ) > -0.2 ) 
					AND -- petSB - deRed_r + 2.5 log10(2Pi*petroR50^2)
					( (petroMag_r - extinction_r +         
						2.5 * LOG( 2 * 3.1415 * petroR50_r * petroR50_r )) < 24.2 
					)      
				OR
					(  (petroMag_r - extinction_r < 19.5) 
					AND ( ( (r - i) - (g - r)/4 - 0.18 ) > (0.45 - 4*( g - r)) )  -- 0.45 - deRed_gr/0.25       
					AND ( (g - r) > ( 1.35 + 0.25 *( r - i ) ) )
					AND  -- petSB - deRed_r + 2.5 log10(2Pi*petroR50^2)
					( (petroMag_r - extinction_r  +  2.5 * LOG( 2 * 3.1415 * petroR50_r * petroR50_r )) < 23.3 ) 
			) )
			)  
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX10', @comment, 1, 1, @@RowCount 
		drop table ##resultsX10
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX11:  Low-z QSO candidates 
		-- Gordon Richards <richards@oddjob.uchicago.edu>
		-- Low-z QSO candidates using the following cuts:
		--
		-- -0.27 <= u-g < 0.71
		-- -0.24 <= g-r < 0.35
		-- -0.27 <= r-i < 0.57
		-- -0.35 <= i-z < 0.70
		-- g <= 22
		-- objc_type == 3
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT g, objID    -- or whatever you want returned
		into ##resultsX11
		FROM Galaxy         -- takes care of objc_type == 3
		WHERE (
		(g <= 22) AND
		(u-g >= -0.27) AND (u-g < 0.71) AND
		(g-r >= -0.24) AND (g-r < 0.35) AND
		(r-i >= -0.27) AND (r-i < 0.57) AND
		(i-z >= -0.35) AND (i-z < 0.70)
		) 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX11', @comment, 1, 1, @@RowCount 
		drop table ##resultsX11
		--===================================================================== 
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX12: Errors on moving objects 
		-- Gordon Richards <richards@oddjob.uchicago.edu>
		-- Another useful query is to see if the errors on moving (or apparently
		-- moving objects) are correct. For example it used to be that some
		-- known QSOs were being flagged as moving objects. One way to look for
		-- such objects is to compare the velocity to the error in velocity and
		-- see if the "OBJECT1_MOVED" or "OBJECT2_BAD_MOVING_FIT" is set. So
		-- return objects with
		--
		-- objc_type == 3
		-- sqrt(rowv*rowv + colv*colv) >= sqrt(rowvErr*rowvErr + colvErr*colvErr)
		--
		-- then output, the velocity, velocity errors, i' magnitude, and the
		-- relevant "MOVING" object flags.	
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		DECLARE @moved BIGINT
		SET @moved =	dbo.fPhotoFlags('MOVED') 
		DECLARE @badMove BIGINT
		SET @badMove =	dbo.fPhotoFlags('BAD_MOVING_FIT') 
		SELECT rowv,
			colv,
			rowvErr,
			colvErr,
			i,
			(flags & @moved) as MOVED,
			(flags & @badMove) as BAD_MOVING_FIT
		INTO ##resultsX12
		FROM photoObj
		WHERE  (flags & (@moved + @badMove)) > 0 
		AND (rowv * rowv + colv * colv) >= 
							(rowvErr * rowvErr + colvErr * colvErr) 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX12', @comment, 1, 1, @@RowCount 
		drop table ##resultsX12
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX13: A random sample of the data 
		-- Karl Glazebrook <kgb@pha.jhu.edu>
		-- So as a newcomer I might want to do something like 'give me the colours
		-- of 100,000 random objects from all fields which are survey quality' so
		-- then I could plot up colour-colour diagrams and play around with
		-- more sophisticated cuts. How would I do that?
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT u,g,r,i,z
		INTO ##resultsX13
		FROM Galaxy 
		WHERE  (obj  % 100 )= 1	 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'QSX13', @comment, 1, 1, @@RowCount 
		drop table ##resultsX13
		--=====================================================================
		--DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX14:--  (Dan VandenBerk <danvb@fnal.gov>)
		-- We have a list of objects -- RA and DEC -- for which we would like
		-- matches and all of the Obj data. Can I send you the list?	
		--exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------	 
		--------------------------------------------------------------------------
		--exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'QSX14***  Match a list from another survey', @comment, 1, 1, @@RowCount 
		--drop table ##resultsX14
		--=====================================================================
		DBCC DROPCLEANBUFFERS WITH NO_INFOMSGS  
		--=====================================================================
		--Query SX15:  Find quasars 
		-- (Xiaohui Fan et.al. <fan@astro.princeton.edu>) 
		exec spTestTimeStart  @clock OUTPUT, @cpu OUTPUT, @physical_io OUTPUT
		---------------------------------------------------------------------------
		SELECT  run,
				camCol,
				rerun,
				field,
				objID,
				u,g,r,i,z,
				ra,
				dec
		into ##resultsX15
		FROM Star       -- or sxGalaxy 
		WHERE ( u - g > 2.0 OR u > 22.3 ) 
		AND ( i < 19 ) 
		AND ( i > 0 ) 
		AND ( g - r > 1.0 ) 
		AND ( r - i < (0.08 + 0.42 * (g - r - 0.96))
			OR g - r > 2.26 ) 
		AND  ( i - z < 0.25 ) 
		--------------------------------------------------------------------------
		exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io,'QSX15', @comment, 1, 1, @@RowCount 
		drop table ##resultsX15
		--=====================================================================
		--
		-- bottom of query loop, increment @i to @n
		set @i = @i + 1
		end
		--=====================================================================
		-- Generate a summary report and return
		print 'Ran the 36 queries ' + cast(@n as varchar(10)) + ' times. Elapsed time was: ' 
			+ convert(varchar(30), getdate()-@startTime,108) + ' hh:mm:ss.'
		select cast(query as char(8)) query
				, min(cpu_sec) mincpu, avg(Cpu_sec) cpu,max(cpu_sec) maxcpu 
				, min(elapsed_time) minElapsed, avg(elapsed_time) elapsed, max(elapsed_time) max_elapsed
				, min(physical_IO) minIO, avg(physical_IO) IO , max(physical_IO) maxIO
				, varp(Cpu_sec) vcpu, varp(elapsed_time) velapsed, varp(physical_IO) vIO
 		from queryResults  
		where time >= @startTime
		group by query 
		order by query
END
GO

---------------------------------------------------------------------------------
-- TEST: 
/*
        	truncate table QueryResults -- clean house.
		exec sp_createStats
		exec spReorg
		set transaction isolation level read uncommitted
		exec spTestQueries 5, 'read uncommitted'
		set transaction isolation level read committed
		exec spTestQueries 5, 'read committed'
*/ 
------------------------------------------------------------------

PRINT '[spTestQueries.sql]: Testing harness installed'
GO




