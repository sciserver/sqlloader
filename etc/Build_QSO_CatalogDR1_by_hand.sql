--=========================================================================================================
-- Create QsoConcordance table
-- This is still a work in prgress
-- Jim Gray  7 June 2003 
--==================================================

drop table QSO_specObj
create table QSO_specObj(	htmID 		bigint not null,
	 		specObjID 		bigint not null,
			cx float, cy float, cz float,
			zone int,ra float,dec float,
			visitor int,
			sciencePrimary int,
			primary key (zone,ra,specObjID)
			)
drop table QSO_PhotoObj
create table QSO_PhotoObj(htmID 		bigint not null,
	 		ObjID 		bigint not null,
			cx float, cy float, cz float,
			zone int,ra float,dec float,
			visitor int,
			mode int,
			primary key (zone,ra,ObjID)
			)
drop table QSO_TargetObj
create table QSO_TargetObj(htmID 		bigint not null,
	 		ObjID 		bigint not null,
			cx float, cy float, cz float,
			zone int,ra float,dec float,
			visitor int,
			mode int,
			primary key (zone,ra,ObjID)
			)
go
--=================================================================================
-- build a unique list of SpecObjs that are QSO candidates.
-- class is QSO or HiZ_QSO.
-- this is a 1/2 arcminute zone table used for joins and dup elimination
truncate table  QSO_specObj
insert QSO_specObj
select htmID, specObjID,cx,cy,cz, cast((dec+90)*1800 as int), ra, dec,0, sciencePrimary
from  specObjAll
where specClass in (3,4)
-- or objTypeName = 'QSO' or --- This clause deleted after much discussion
--51,027  -- 1 seconds
insert QSO_specObj  -- add in the right margin for zone calculations.
select htmID, specObjID,cx,cy,cz, cast((dec+90)*1800 as int), ra+360, dec,1,sciencePrimary
from QSO_specObj
where ra between 0 and (4.0/3600.0)/(abs(cos(radians(dec)))+1e-6)
-- 0 rows
--=================================================================
-- eliminate duplicates
-- Delete specObjs where there is a nearby one (1 arc second) that is science primary.
-- or if there is a pair with no primary, delete the smaller objID
declare @delta float, @epsilon float
set     @delta = 1.0/3600.0	-- the 1 arcsecond radius for duplicate serrch
set     @epsilon = 1e-7		-- avoids underflow
declare @zoneDelta int
set     @zoneDelta = -1		-- do elimination for zone -1, 0, 1
again:
delete QSO_specObj
where specObjID in (		-- these are the losers.
	select distinct s1.specObjID
	from QSO_specObj s1 join QSO_specObj s2 	-- a nearby pair
		on s1.zone = s2.zone +@zoneDelta 	-- same zone
		and s2.ra between s1.ra-@delta/(abs(cos(radians(s1.dec)))+ @epsilon)
			  and     s1.ra+@delta/(abs(cos(radians(s1.dec)))+ @epsilon)
		and abs(s2.dec-s1.dec) < @delta 	-- manhattan distance
		and ( (     s2.sciencePrimary = 1       -- s2 is  primary
			and s1.sciencePrimary = 0      )-- s1 is not or  
                    or(     s1.sciencePrimary = s1.sciencePrimary  -- both same        
			and s1.specObjID <  s2.specObjID )  -- but winner is bigger
                     )                 
		)  
set @zoneDelta = @zoneDelta+1
if @zoneDelta <= 1 goto again
select count(*) from QSO_specObj
-- 49,518 objects survive -- strike 5, 1,504, 0 rows
/* --- SANITY TEST
declare @delta float, @epsilon float
set @delta = 1.0/3600.0
set @epsilon = 1e-7
declare @zoneDelta int
set @zoneDelta = - 1
select top 10 s1.specObjID,s1.sciencePrimary, s2.SciencePrimary,
	60*dbo.fDistanceArcMinEq(s1.ra,s1.dec, s2.ra,s2.dec)
from QSO_specObj s1 join QSO_specObj s2 
	on s1.zone = s2.zone --+ @zoneDelta
	and s2.ra between s1.ra-@delta/(abs(cos(radians(s1.dec)))+ @epsilon)
		  and     s1.ra+@delta/(abs(cos(radians(s1.dec)))+ @epsilon)
	and abs(s2.dec-s1.dec) < @delta 
	and s1.specObjID != s2.specObjID
-- 0 rows.	
*/
go
--=========================================================================
-- Now build the PhotoObj candidates. 
-- Same idea. Primary or secondary PhotoObjAll with target flags set to 
-- catch TARGET_QSO_HIZ,       TARGET_QSO_CAP,        TARGET_QSO_SKIRT, 
--       TARGET_QSO_FIRST_CAP, TARGET_QSO_FIRST_SKIRT 
truncate table  QSO_photoObj
insert QSO_photoObj
select htmID, ObjID,cx,cy,cz, cast((dec+90)*1800 as int), ra, dec,0, mode
from  photoObjAll
where   mode in (1,2)  
 and    type in (0,3,6)
 and    primtarget & 0x0000001F != 0 -- the flags in comment above
--133,164 in 34 minutes
-- this is a zone table so add in the right margin.
insert QSO_photoObj  -- add in the right margin
select htmID,  ObjID,cx,cy,cz, cast((dec+90)*1800 as int), ra+360, dec,1,mode
from  QSO_photoObj
where  ra between 0 and (4.0/3600.0)/(abs(cos(radians(dec)))+1e-6)
-- 0 rows
--=================================================================
-- eliminate duplicates
-- Delete photoObjs where there is a nearby one (1 arc second) that is primary.
-- or if there is a pair with no primary, delete the smaller objID
declare @delta float, @epsilon float
set     @delta = 1.0/3600.0	-- the 1 arcsecond radius for duplicate serrch
set     @epsilon = 1e-7		-- avoids underflow
declare @zoneDelta int
set     @zoneDelta = -1		-- do elimination for zone -1, 0, 1
again:
delete QSO_photoObj
where  ObjID in (
	select distinct p1.ObjID
	from QSO_photoObj p1 join QSO_photoObj p2 
		on p1.zone = p2.zone +@zoneDelta 
		and p2.ra between p1.ra-@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
			  and     p1.ra+@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
		and abs(p2.dec-p1.dec) < @delta 
		and (   (  p1.mode = 2 and p2.mode = 1)
		     or (  p1.mode = p2.mode and p1.ObjID <  p2.ObjID )
                     )                 
		)  
set @zoneDelta = @zoneDelta+1
if @zoneDelta <= 1 goto again
-- in 3 seconds strike 113, 9,075, 103 rows*/
--select count(*) from QSO_photoObj
-- 123,873 objects
/* SANITY TEST, should return zero rows
declare @delta float, @epsilon float
set @delta = 1.0/3600.0
set @epsilon = 1e-7
select top 1000 p1.ObjID,p2.objID,p1.mode, p2.mode,60*dbo.fDistanceArcMinEq(p1.ra,p1.dec, p2.ra,p2.dec)
from QSO_photoObj p1 join QSO_photoObj p2 
	on p1.zone = p2.zone 
	and p2.ra between p1.ra-@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
		  and     p1.ra+@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
	and abs(p2.dec-p1.dec) < @delta 
	and p1.ObjID != p2.ObjID
-- 0 rows.	
*/
--=============================================================================
-- build the Target QSO list with the same logic as Best PhotoObj QSO list.
truncate table  QSO_TargetObj
go
sp_configure 'remote query timeout', 6000
RECONFIGURE
go
insert QSO_TargetObj
select htmID,  ObjID,cx,cy,cz, cast((dec+90)*1800 as int), ra, dec,0, mode
from  targDr3.dbo.photoObjAll
where   mode in (1,2)  
  and type in (0,3,6)
  and primtarget & 0x0000001F != 0
--49,738 in 18 minutes
insert QSO_TargetObj  -- add in the right margin
select htmID,  ObjID,cx,cy,cz, cast((dec+90)*1800 as int), ra+360, dec,1,mode
  from QSO_TargetObj
 where ra between 0 and (4.0/3600.0)/(abs(cos(radians(dec)))+1e-6)
-- 0 rows
declare @delta float, @epsilon float
set @delta = 1.0/3600.0
set @epsilon = 1e-7
declare @zoneDelta int
set @zoneDelta = -1
again:
delete QSO_TargetObj
where  ObjID in (
	select distinct p1.ObjID
	from QSO_TargetObj p1 join QSO_TargetObj p2 
		on p1.zone = p2.zone +@zoneDelta 
		and p2.ra between p1.ra-@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
			  and     p1.ra+@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
		and abs(p2.dec-p1.dec) < @delta 
		and (   (  p1.mode = 2 and p2.mode = 1)
		     or (  p1.mode = p2.mode and p1.ObjID <  p2.ObjID )
                     )                 
		)  
set @zoneDelta = @zoneDelta+1
if @zoneDelta <= 1 goto again
-- strike 60, 3746, 61 rows, -- 84,347 objects in the end 8 minutes
 
/** sanity test
declare @delta float, @epsilon float
set @delta = 1.0/3600.0
set @epsilon = 1e-7
select top 1000 p1.ObjID,p2.objID,p1.mode, p2.mode,60*dbo.fDistanceArcMinEq(p1.ra,p1.dec, p2.ra,p2.dec)
from QSO_TargetObj p1 join QSO_TargetObj p2 
	on p1.zone = p2.zone 
	and p2.ra between p1.ra-@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
		  and     p1.ra+@delta/(abs(cos(radians(p1.dec)))+ @epsilon)
	and abs(p2.dec-p1.dec) < @delta 
	and p1.ObjID != p2.ObjID
-- 0 rows.	
*/
--================================================================
-- now build up the triples table, pairs first.
-- build pairs of spec-photo objects that are close.
drop table QSO_pairs
go
create table QSO_pairs (specObjID bigint, bestObjID bigint, 
			zone int,ra float,dec float,
			primary key (zone, ra, specObjID,bestObjID))
declare @delta float, @epsilon float
set @delta = 1.0/3600.0
set @epsilon = 1e-7
insert QSO_pairs
select   coalesce(specObjID,0) as specObjID, 			-- spec ID
	 coalesce(p.objID,0) as bestObjID,			-- photo ID
	(coalesce(p.zone,s.zone)+coalesce(s.zone,p.zone)+1)/2,  -- min zone number
	(coalesce(p.ra,s.ra)+coalesce(s.ra,p.ra))/2,		-- avg ra
	(coalesce(p.dec,s.dec)+coalesce(s.dec,p.dec))/2 	-- avg dec
from (QSO_specObj s full outer join QSO_photoObj p 
  on s.zone between p.zone-1 and p.zone+1
		and s.ra between p.ra-@delta/(abs(cos(radians(p.dec)))+ @epsilon)
			  and     p.ra+@delta/(abs(cos(radians(p.dec)))+ @epsilon)
		and abs(s.dec-p.dec) < @delta )
-- 91,509 rows in 23.25 minutes
--select count(*) from QSO_pairs where specObjid != 0 and bestObjID != 0
-- 22,996 rows
--go
--=================================================================================
-- now compute the table of tripples.
-- SpecObj, bestObj, Target obj where at least one is a QSO candidate.
-- We have a 0 in the field if the corresponding object in the other catalog was 
-- not flagged as a QSO.
-- Later we will build QSO-all to fill in the best "zero" for the partial objects.
--
go
drop table QSO_triples
create table QSO_triples(SpecObjID 	bigint not null,
	 		bestObjID 		bigint not null,
	 		TargetObjID 		bigint not null,
			zone int, 
			ra float,dec float,
			primary key (zone,ra,SpecObjID, bestObjID,TargetObjID)
			)
declare @delta float, @epsilon float
set @delta = 1.0/3600.0
set @epsilon = 1e-7
Insert QSO_triples
select  coalesce(specObjID,0)  as SpecObjID, 
	coalesce(bestObjID,0) as bestObjID, 
	coalesce(t.objID,0)    as TargetObjID,
	(coalesce(p.zone,T.zone)+coalesce(T.zone,p.zone)+1)/2,  -- min zone number
	(coalesce(p.ra,T.ra)+coalesce(T.ra,p.ra))/2,		-- avg ra
	(coalesce(p.dec,T.dec)+coalesce(T.dec,p.dec))/2 	-- avg dec
from QSO_pairs p full outer join QSO_targetobj t
  on p.zone between t.zone-1 and t.zone+1
 and p.ra between t.ra-@delta/(abs(cos(radians(t.dec)))+ @epsilon)
 and t.ra+@delta/(abs(cos(radians(t.dec)))+ @epsilon)
 and abs(p.dec-t.dec) < @delta
go
-- (119,264 row(s) affected) in 64 minutes
--------------------------------------------------------------------
-- take  census of how things are going
select 	case   specObjID when 0 then 1 else 0 end as   specObj,
 	case  bestObjID when 0 then 1 else 0 end as  bestObj,
 	case targetObjID when 0 then 1 else 0 end as targetObj,
	count(*) as pop
from QSO_triples
group by case specObjID  when 0 then 1 else 0 end,
 	case bestObjID  when 0 then 1 else 0 end,
 	case targetObjID when 0 then 1 else 0 end
order by count(*) desc
/*  bestDR1
SpecObj     bestObj    targetObj   pop         
----------- ----------- ----------- ----------- 
1           0           1           20225
1           1           0           17513
1           0           0           16518
0           0           0           11517
0           1           1           4044
0           1           0           2350
0           0           1           152
BestDR2
specObj     bestObj     targetObj   pop         
----------- ----------- ----------- ----------- 
1           0           1           30611
1           1           0           27754
1           0           0           26085
0           0           0           22760
0           1           1           7935
0           1           0           3882
0           0           1           237
*/
create table QsoCatalogAll(
			SpecObjID 	bigint not null,
	 		bestObjID 		bigint not null,
	 		TargetObjID 		bigint not null,
			zone int, 
			ra float,dec float,
			confidence 	float not null,
			specObjQso	tinyInt not null,
			bestObjQso	tinyInt not null,
			targetObjQso	tinyInt not null,
			primary key (zone,ra,SpecObjID, bestObjID,TargetObjID)
			)
go
truncate table QsoCatalogAll
insert QsoCatalogAll
select specObjID, bestObjID, TargetObjID, zone, ra, dec, 0, 
	case when specObjID = 0 then 0 else 1 end,
	case when specObjID = 0 then 0 else 1 end, 
	case when specObjID = 0 then 0 else 1 end  
from   QSO_triples  
-- 119,264 rows
--=============================
-- the 1,1,1 case  -- 11,517 
--
--=============================
-- the 0,1,* case  -- 10826 rows  0 rows second time 
update QSoCatalogAll
  set  SpecObjID   = p.SpecObjID   
from QsoCatalogAll q join photoObjAll p on q.bestObjID = p.ObjID
where q.specObjID = 0 and  q.bestObjID != 0 and p.specObjID != 0 
--=============================
-- the 1,*,* case  -- 12,962 rows 53 rows second time   
update QSoCatalogAll
  set   bestObjID  =  case q.bestObjID  when 0 then s.bestObjID else q.bestObjID end,
	targetObjID  = case q.targetObjID when 0 then s.targetID else q.targetObjID end
from QsoCatalogAll q join SpecObjALL s on q.SpecObjID = s.SpecObjID
where q.specObjID != 0 and  ( q.bestObjID  = 0 or  q.TargetObjID = 0)  
--=============================
-- the 0,0,1 case   23,517 rows, 219 rows,  (1,319 zeros survive)
update QSoCatalogAll
  set  SpecObjID   = t.SpecObjID , 
       bestObjID =  t.bestObjID
from QsoCatalogAll q join target t on q.targetObjID = t.targetID  
where q.specObjID = 0 and q.bestObjID = 0 and q.TargetObjID != 0     
--=============================
-- compute confidence
--- If we have a spectrogram then confidnce is zConf
update QSoCatalogAll  -- 45,640
  set  confidence   =  case specObjQso when 1 then zConf else 1-zConf end
from QsoCatalogAll q join SpecObjAll s on q.specObjID = s.specObjID 
-- elese use 30% per catalog
update QSoCatalogAll   -- 73,624
  set  confidence   =  0.3 * (bestObjQso + targetObjQso)
where specObjID = 0 

==========================================================
-- Now lets deal with the "missing photo and target objects
select 	case   specObjID when 0 then 0 else 1 end as   specObj,
 	case  bestObjID when 0 then 0 else 1 end as  bestObj,
 	case targetObjID when 0 then 0 else 1 end as targetObj,
	count(*) as pop
from QsoCatalogAll
group by case specObjID  when 0 then 0 else 1 end,
 	case bestObjID  when 0 then 0 else 1 end,
 	case targetObjID when 0 then 0 else 1 end
order by count(*) desc
/*
BestDr1
specObj     bestObj    targetObj   pop         
----------- ----------- ----------- ----------- 
1           1           1           29744
0           1           0           19750
0           1           1           19740
0           0           1           3008
1           0           1           76
1           0           0           1

BestDr2
specObj     bestObj     targetObj   pop         
----------- ----------- ----------- ----------- 
1           1           1           45587
0           1           1           39465
0           1           0           29703
0           0           1           4456
1           0           1           52
1           0           0           1
*/

--------------------
-- fix the problem that 3084 Target are missing Photo entries (worked in 1717 objects)
-- for bestDr2 2802
update QSoCatalogAll		-- primary gets 2802 rows
  set  bestObjID =  coalesce(dbo.fGetNearestObjIdEq(ra,dec,.03),0)
from QsoCatalogAll  
where bestObjID = 0 and dbo.fGetNearestObjIdEq(ra,dec,.03) != 0
update QSoCatalogAll		-- primary gets 1453 rows
  set  bestObjID =  coalesce(dbo.fGetNearestObjIdEqMode(ra,dec,.03,2),0)
from QsoCatalogAll  
where bestObjID = 0 and dbo.fGetNearestObjIdEqMode(ra,dec,.03,2) != 0

update QSoCatalogAll		-- 0 rows   
  set  bestObjID =  coalesce(dbo.fGetNearestObjIdEq(ra,dec,.03),0) 
from QsoCatalogAll  
where bestObjID = 0 and dbo.fGetNearestObjIdEq(ra,dec,.03) != 0
update QSoCatalogAll		-- 0 rows   
  set  bestObjID =  coalesce(dbo.fGetNearestObjIdEqMode(ra,dec,.03,2),0) 
from QsoCatalogAll  
where bestObjID = 0 and dbo.fGetNearestObjIdEqMode(ra,dec,.03,2) != 0

update QsoCatalogAll
set targetObjID =  T.targetID	-- 1 row
from  QsoCatalogAll q join targDr3.dbo.Target T
   on q.bestObjID = T.bestObjID
where q.targetObjID=0
/*
BestDr1
specObj     bestObj     targetObj   pop         
----------- ----------- ----------- ----------- 
0           1           1           35023
1           1           1           29798
0           1           0           6075
0           0           1           1346
1           0           1           76
1           0           0           1

BestDr2
specObj     bestObj     targetObj   pop         
----------- ----------- ----------- ----------- 
1           1           1           45587
0           1           1           43720
0           1           0           29703
0           0           1           201
1           0           1           53
*/

--------------------------------------------------
-- OK, lets build it.


--=========================================================================================================
-- QsoConcordance table 
--==================================================
if exists (select * from dbo.sysobjects where id = object_id(N'QsoConcodance')) drop table [QsoConcodance]
GO
CREATE TABLE QsoConcodance (
-------------------------------------------------------------------------------
--/H A concordance of all the objects from Spectro, Best, or Target that "smell" like a QSO
--/A
--/
--/T This table is derived from the SpecObj, Best.PhotoObj, and Target.PhotoObj tables.
--/T Any SpecObj with SpecClass in QSO or HiZ_QSO is recorded
--/T Any PhotoObj in Best or Target with and of the following primary Target Flags set
--/T                       QSO_HIZ, QSO_CAP, QSO_SKIRT, QSO_FIRST_CAP,QSO_FIRST_SKIRT
--/T this list is first "culled" to discard objects that have multiple observations.
--/T The "primary" (photoObj) or sciencePrimary (SpecObj) is retained.
--/T Then the three lists are merged into a single list, matching by (ra,dec) with a 1 arcsecond radius.
--/T That is, if a photo and spectro object have centers that are within 1 arcsecond, 
--/T then they are considered to be observations of the same object. 	
--/T This step produces 72319 items on the SdssDr2 dataset with the following population statistics:
--/T <code>
--/T   SpecObj     bestObj    targetObj   pop         
--/T  ----------- ----------- ----------- ----------- 
--/T     1           0           1        20225
--/T     1           1           0        17513
--/T     1           0           0        16518
--/T     0           0           0        11517
--/T     0           1           1        4044
--/T     0           1           0        2350
--/T     0           0           1        152
--/T </code>
--/T Now a sequence of spatial lookups tries to identify the 20,225 best objects 
--/T that are missing from the first row.
--/T Those objects were probably observed, but were not flagged as QSO candidates.
--/T After a fair amount of heuristics, most of these corresponding entries are identified.
--/T We end up with counts that look more like:
--/T <code>
--/T   SpecObj     bestObj    targetObj   pop         
--/T  ----------- ----------- ---------- ------- 
--/T     0           1           1       35023
--/T     1           1           1       29798
--/T     0           1           0        6075
--/T     0           0           1        1346
--/T     1           0           1          76
--/T     1           0           0           1
--/T </code>
--/T The first two rows are great: SpecObjs with matching Best and Target objects.
--/T or a matching best and target pair that are likely a QSO 
--/T but have not yet observed with the spectrograph.
--/T The remaining rows are a reminder that this is real data.
--/T For example the last row represents a spectrogram with unknown ra,dec.
--/T The third and second to last rows represent processing holes 
--/T in the Best database output (target areas not included in Best.)
--/T 
--/T All this information is recorded in the QsoCatalogAll table along with
--/T <ul> 
--/T <li> Confidence: a confidence indicator whihc is Specobj.Zconf if it is SpecClass QSO or HiZ_QSO and 1-Zconf if it is in some other SpecClass.
--/T <li> ra, dec: the average ra,dec of the group.
--/T <li> zone: the 1 arcminute zone size used for quick spatial searches.
--/T <li> specObjQso, bestObjQso, targetObjOso: flags that indicate if the corresponding object was flagged as a QSO.
--/T      (some objIDs are added because other observations of the object "said" QSO, but the objID did not.
--/T </ul>
--/T <br>
--/T Now the QsoConcordence is built from QSOCatalogAll.  
--/T It is a collection of popular fields from the three different databases (Spectro, Best, Target).
--/T Its fields are itemized and documented below.
--/T See also the QsoCatalogAll  table description. 
-------------------------------------------------------------------------------
	       RowC 		real not null,	--/D Row center position (r' coordinates)     		--/U pixels
               ColC 		real not null,  --/D Column center position (r' coordinates) 		--/U pixels
               RowC_i 		real not null,  --/D i band Row center position (r' coordinates) 	--/U pixels
               ColC_i 		real not null,  --/D i band Column center position (r' coordinates) 	--/U pixels
               extinction_u 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_g 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_r 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_i 	real not null,  --/D Reddening in each filter 				--/U magnitudes
               extinction_z 	real not null,  --/D Reddening in each filter				--/U magnitudes
               bestObjID 	bigint not null, --/D Unique SDSS identifier in Best DB composed from [rerun,run,camcol,field,obj], or 0 if there is none.
               targetObjID 	bigint not null, --/D Unique SDSS identifier in Target DB composed from [rerun,run,camcol,field,obj], or 0 if there is none.
               SpecObjID 	bigint not null, --/D Unique ID of spectrographic object
               zone 		int not null,	 --/D 1 arcminute zone used for spatial joins floor((dec+90)*60*60)
               ra 		float not null,  --/D J2000 right ascension (r') 			--/U degrees in J2000
               dec 		float not null,  --/D J2000 right declination (r') 			--/U degrees in J2000
               QsoConfidence 	float not null,  --/D a number between 0..1. If this has a SpecObj, then it is the QSO Zconf (see table definition). If no specobj, it is .3*(BestObjFlagedQso+TargetObjFlagedQso)
               SpecObjFlagedQso tinyint not null, --/D Flag (0 / 1): 1 means this SpecObj is SpecClass QSO or HiX_QSO
               BestObjFlagedQso tinyint not null, --/D Flag (0 / 1): 1 PhotoObjID was flagged as a QSO in the target flags.
               TargetObjFlagedQso tinyint not null, --/D Flag (0 / 1): 1 PhotoObjID was flagged as a QSO in the target flags.

	       sZ    		real 	not null, --/D 0 or specObj.Z Final Redshift
	       sZerr		real 	not null, --/D 0 or specObj.Zerr  Redshift error
	       szConf		real 	not null, --/D 0 or specObj.zConf  Redshift confidence
	       szWarning	int 	not null, --/D 0 or specObj.Warning Flags --/R SpeczWarning
	       sZStatus 	int not null,     --/D 0 or specObj.Zstatus  Redshift status --/R SpecZStatus
               sSpecClass 	int not null,	  --/D 0 or specObj.SpecClass Spectral Classification --/R SpecClass 
	       splate 		int 	not null, --/D 0 or specObj.plate Link to plate on which the spectrum was taken
               SFiberID 	int 	not null, --/D 0 or specObj.Fiber ID
	       sMjd		int 	not null, --/D 0 or specObj.MJD of observation
               sPrimTarget 	int not null,     --/D 0 or specObj.PrimTarget Bit mask of primary target categories the object was selected in. --/R PrimTarget 
	      
               bType 		int not null,	  --/D 0 or best PhotoObj.type Morphological type classification of the object. --/R PhotoType
               tType 		int not null,	  --/D 0 or target PhotoObj.type Morphological type classification of the object. --/R PhotoType
               bFlags 		bigint not null,  --/D 0 or best PhotoObj.Flags    Object detection flags  --/R PhotoFlags
               tFlags 		bigint not null,  --/D 0 or target PhotoObj.flags  Object detection flags  --/R PhotoFlags
               bPrimTarget 	int not null,     --/D 0 or best PhotoObj.PrimTarget  Bit mask of primary target categories the object was selected in. --/R PrimTarget
               tPrimTarget 	int not null,     --/D 0 or target PhotoObj.PrimTarget Bit mask of primary target categories the object was selected in. --/R PrimTarget
               bPsfMag_u 	real not null,    --/D 0 or best PhotoObj.PsfMag_u PSF flux  --/U luptitudes
               bPsfMag_g 	real not null,    --/D 0 or best PhotoObj.PsfMag_g PSF flux  --/U luptitudes
               bPsfMag_r 	real not null,    --/D 0 or best PhotoObj.PsfMag_r PSF flux  --/U luptitudes
               bPsfMag_i 	real not null,    --/D 0 or best PhotoObj.PsfMag_i PFS flux  --/U luptitudes
               bPsfMag_z 	real not null,    --/D 0 or best PhotoObj.PsfMag_z PFS flux  --/U luptitudes
               bPsfMagErr_u 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_u PSF flux error --/U luptitudes
               bPsfMagErr_g 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_g PSF flux error --/U luptitudes
               bPsfMagErr_r 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_r PSF flux error --/U luptitudes
               bPsfMagErr_i 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_i PSF flux error --/U luptitudes
               bPsfMagErr_z 	real not null,    --/D 0 or best PhotoObj.PsfMagErr_z PSF flux error --/U luptitudes
               tPsfMag_u 	real not null,    --/D 0 or target PhotoObj.PsfMag_u PSF flux  --/U luptitudes
               tPsfMag_g 	real not null,    --/D 0 or target PhotoObj.PsfMag_g PSF flux  --/U luptitudes
               tPsfMag_r 	real not null,    --/D 0 or target PhotoObj.PsfMag_r PSF flux  --/U luptitudes
               tPsfMag_i 	real not null,    --/D 0 or target PhotoObj.PsfMag_i PSF flux  --/U luptitudes
               tPsfMag_z 	real not null,    --/D 0 or target PhotoObj.PsfMag_z PSF flux  --/U luptitudes
               tPsfMagErr_u 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_u PSF flux error --/U luptitudes
               tPsfMagErr_g 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_g PSF flux error --/U luptitudes
               tPsfMagErr_r 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_r PSF flux error --/U luptitudes
               tPsfMagErr_i 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_i PSF flux error --/U luptitudes
               tPsfMagErr_z 	real not null,    --/D 0 or target PhotoObj.PsfMagErr_z PSF flux error --/U luptitudes
	       primary key(zone,ra,dec,specObjID, bestObjID, targetObjID)
		)

-------------------------
--=======================
-- THE ACTUAL BUILD STEP
---------------------------

INSERT QsoConcordance
SELECT -- best estimate
	coalesce (b.rowC, t.rowC, 0)   		as RowC,
	coalesce (b.colC, t.colC, 0)   		as ColC,
	coalesce (b.RowC_i, t.RowC_i, 0) 	as RowC_i,
	coalesce (b.ColC_i, t.ColC_i, 0) 	as ColC_i,
	coalesce (b.extinction_u,t.extinction_u, 0) as extinction_u,
	coalesce (b.extinction_g,t.extinction_g, 0) as extinction_g,
	coalesce (b.extinction_r,t.extinction_r, 0) as extinction_r,
	coalesce (b.extinction_i,t.extinction_i, 0) as extinction_i,
	coalesce (b.extinction_z,t.extinction_z, 0) as extinction_z,
	-- IDs of each
	qc.bestObjID	   	   		as bestObjID,
	qc.targetObjID      			as targetObjID,
	qc.SpecObjID   	   			as SpecObjID,
	-- spatial infomation
	qc.zone 	   			as zone, 
	qc.ra		   			as ra,
	qc.[dec]	   			as dec, 
	-- flags from QSO search
	qc.confidence 	   			as QsoConfidence,
	qc.specObjQso	   			as SpecObjFlagedQso,
	qc.bestObjQso	   			as BestObjFlagedQso,
	qc.targetObjQso	   			as TargetObjFlagedQso,
	-- spectrographic data
	coalesce (s.z, 0)     			as sZ,
	coalesce (s.zErr, 0)     		as sZerr,
	coalesce (s.zConf, 0)     		as sZConf,
	coalesce (s.zWarning, 0)     		as sZWarning,
	coalesce (s.zStatus, 0)     		as sZStatus,
	coalesce (s.specClass, 0)     		as sSpecClass,
	coalesce (s.plate, 0)     		as SPlate,
	coalesce (s.fiberID, 0)     		as SFiberID,
	coalesce (s.mjd, 0)     		as SMjd,
	coalesce (s.primTarget, 0)     		as sPrimTarget,
	-- best & target types and flags
	coalesce (b.type, 0)     		as bType,
	coalesce (t.type, 0)     		as tType,
	coalesce (b.flags, 0)     		as bFlags,
	coalesce (t.flags, 0)     		as tFlags,
	coalesce (b.primTarget, 0)     		as bPrimTarget,
	coalesce (t.primTarget, 0)     		as tPrimTarget,
	-- b psf magnitues
	coalesce (b.psfMag_u, 0)     		as bPsfMag_u,
	coalesce (b.psfMag_g, 0)     		as bPsfMag_g,
	coalesce (b.psfMag_r, 0)     		as bPsfMag_r,
	coalesce (b.psfMag_i, 0)     		as bPsfMag_i,
	coalesce (b.psfMag_z, 0)     		as bPsfMag_z,
	coalesce (b.psfMagErr_u, 0)     	as bPsfMagErr_u,
	coalesce (b.psfMagErr_g, 0)     	as bPsfMagErr_g,
	coalesce (b.psfMagErr_r, 0)     	as bPsfMagErr_r,
	coalesce (b.psfMagErr_i, 0)     	as bPsfMagErr_i,
	coalesce (b.psfMagErr_z, 0)     	as bPsfMagErr_z,
	-- t psf magnitues
	coalesce (t.psfMag_u, 0)     		as tPsfMag_u,
	coalesce (t.psfMag_g, 0)     		as tPsfMag_g,
	coalesce (t.psfMag_r, 0)     		as tPsfMag_r,
	coalesce (t.psfMag_i, 0)     		as tPsfMag_i,
	coalesce (t.psfMag_z, 0)     		as tPsfMag_z,
	coalesce (t.psfMagErr_u, 0)     	as tPsfMagErr_u,
	coalesce (t.psfMagErr_g, 0)     	as tPsfMagErr_g,
	coalesce (t.psfMagErr_r, 0)     	as tPsfMagErr_r,
	coalesce (t.psfMagErr_i, 0)     	as tPsfMagErr_i,
	coalesce (t.psfMagErr_z, 0)     	as tPsfMagErr_z
	/*
	sl.measured{*}.wave,
	sl.measured{*}.restWave,
	sl.measured{*}.sigma,
	sl.measured{*}.height
	*/
	from QSoCatalogAll qc 	left outer join PhotoObjAll as b             on qc.bestObjID   = b.objID 
	             		left outer join TargDr3.dbo.PhotoObjAll as t on qc.targetObjID = t.objID 
		     		left outer join SpecObj  as s                on qc.specObjID   = s.specObjID
	 
-- 119,264 row(s) affected in 5.5 minutes
-----------------------------------------
-- cleanup
drop table QSO_specObj
drop table QSO_PhotoObj
drop table QSO_TargetObj
drop table QSO_pairs
drop table QSO_triples

   


