--=================================
-- debugging the Sectors
-- Alex Szalay
-- 2005-04-01, Munich
--=================================

-----------------------------------------------
-- are positive TIPRIMARIES distinct within each tileRun?
-----------------------------------------------
select t1.stripe, r1.regionid, r2.regionid
from Region r1, Region r2, 
     TilingGeometry t1, 
     TilingGeometry t2
where r1.type='TIPRIMARY'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and r1.isMask=0
  and r2.isMask=0
  and r1.id=t1.tilinggeometryid
  and r2.id=t2.tilinggeometryid
  and t1.stripe=t2.stripe
  and t1.tilerun=t2.tilerun
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
order by t1.stripe
--......................
-- CORRECT, we get NULL
--......................


-----------------------------------
-- add up the area of all WEDGEs
-- corresponding to the same TILE
-----------------------------------
select tile, count(*), sum(w.area) 
from Sector2Tile s, Region w
where w.type='WEDGE'
  and s.type=w.type
  and s.regionid=w.regionid
  and s.ismask=0
group by s.tile
order by sum(w.area)
--................................
-- CORRECT, each row is 6.974256*
--................................

-----------------------------------
-- add up the area of all SECTORLETs
-- corresponding to the same TILE
-----------------------------------
select tile, count(*), sum(w.area) 
from Sector2Tile s, Region w
where w.type='SECTORLET'
  and s.type=w.type
  and s.regionid=w.regionid
  and s.ismask=0
group by s.tile
order by sum(w.area)
--............................
-- CORRECT: max is the plate area
--............................


-----------------------------------
-- add up the area of all SECTORs
-- corresponding to the same TILE
-----------------------------------
select tile, count(*), sum(w.area) 
from Sector2Tile s, Region w
where w.type='SECTOR'
  and s.type=w.type
  and s.regionid=w.regionid
  and s.ismask=0
group by s.tile
order by sum(w.area)
--............................
-- CORRECT: max is the plate area
--............................



-----------------------------------------------
-- are TIPRIMARY regions distinct between different stripes?
-----------------------------------------------
select t1.stripe,r1.regionid, r2.regionid, r1.area, r2.area
from Region r1, Region r2, TilingGeometry t1, TilingGeometry t2
where r1.type='TIPRIMARY'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and r1.id=t1.tilinggeometryid
  and r2.id=t2.tilinggeometryid
  and t1.stripe!=t2.stripe
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
order by t1.stripe
--................................
-- CORRECT, we get NULL
--................................


-----------------------------------------------
-- are Tileboxes distinct within each tileRun?
-----------------------------------------------
select t1.stripe, r1.regionid, r2.regionid
from Region r1, Region r2, 
     TilingGeometry t1, 
     TilingGeometry t2
where r1.type='TILEBOX'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and r1.id=t1.tilinggeometryid
  and r2.id=t2.tilinggeometryid
  and t1.stripe=t2.stripe
  and t1.tilerun=t2.tilerun
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
order by t1.stripe
--......................
-- CORRECT, we get NULL
--......................

-----------------------------------------------
-- are SkyBoxes distinct?
-----------------------------------------------
select r1.regionid, r2.regionid, r1.area, r2.area
from Region r1, Region r2
where r1.type='SKYBOX'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
--........................
-- CORRECT, no overlap
--........................

-------------------------------------
-- find degenerate TILEBOXes:
--   they are from the same STRIPE
--   and from different tileruns
-------------------------------------
select t1.stripe,r1.regionid, r2.regionid, 
	r1.area, r2.area, 
	t1.targetVersion, t2.targetVersion
from Region r1, Region r2, 
     TilingGeometry t1, TilingGeometry t2
where r1.type='TILEBOX'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and r1.id=t1.tilinggeometryid
  and r2.id=t2.tilinggeometryid
  and t1.stripe=t2.stripe
  and t1.tilerun!=t2.tilerun
  and abs(r1.area-r2.area)<0.001
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
order by t1.stripe
--.................................
-- 24 rows with equal area, and
-- the targetVersions all match!
-- DR5: returns only 2 rows
--.................................

-------------------------------------
-- How many non-degenerate overlaps?
-------------------------------------
select t1.stripe,r1.regionid, r2.regionid, r1.id, r2.id,
	t1.targetVersion, t2.targetVersion
from Region r1, Region r2, TilingGeometry t1, TilingGeometry t2
where r1.type='TILEBOX'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and r1.id=t1.tilinggeometryid
  and r2.id=t2.tilinggeometryid
  and t1.stripe=t2.stripe
  and t1.tilerun!=t2.tilerun
  and t1.targetVersion!=t2.targetVersion
  and abs(r1.area-r2.area)>0.001
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
order by t1.stripe
--....................................................
-- 231 rows which overlap between different tileruns, 
-- DR5: returns 8 rows only
--...................................


-----------------------------------------------
-- how many overlapping TILEBOXes have
-- different targetVersions?
-----------------------------------------------
select t1.stripe,r1.regionid, r2.regionid, r1.id, r2.id,
	t1.targetVersion, t2.targetVersion
from Region r1, Region r2, TilingGeometry t1, TilingGeometry t2
where r1.type='TILEBOX'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and r1.id=t1.tilinggeometryid
  and r2.id=t2.tilinggeometryid
  and t1.stripe=t2.stripe
  and t1.tilerun!=t2.tilerun
  and t1.targetVersion!=t2.targetVersion
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
order by t1.stripe
--..................................
-- DR5: returns 8 rows
--..................................


--------------------------------------------
-- how many TILEBOXes are collisionless?
--------------------------------------------
declare @pairs table (
	r1 bigint,
	r2 bigint
)
--
insert @pairs
select r1.regionid as r1, r2.regionid as r2
from Region r1, Region r2, TilingGeometry t1, TilingGeometry t2
where r1.type='TILEBOX'
  and r1.type=r2.type
  and r1.regionid>r2.regionid
  and r1.id=t1.tilinggeometryid
  and r2.id=t2.tilinggeometryid
  and t1.stripe=t2.stripe
  and t1.tilerun!=t2.tilerun
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
order by t1.stripe
--
select regionid from Region
where type='TILEBOX'
and regionid not in (select r1 from @pairs union select r2 from @pairs)
-- 339 rows out of 689
-- DR5: 47 rows out of 246
 
---------------------------------------
-- find TILEBOX--SKYBOX pairs
---------------------------------------

select r1.id, r1.regionid, r2.regionid, r1.area, r2.area
from Region r1, Region r2
where r1.type='TILEBOX'
  and r2.type='SKYBOX'
  and r1.id=r2.id
  and abs(r1.area-r2.area)<0.001
  and dbo.fRegionOverlapId(r1.regionid,r2.regionid,0) is not null
--.........................
-- 689, they all match
-- DR5: 52 rows
--.........................

drop table #intersect


--	INSERT @intersect

	SELECT DISTINCT r.regionid as holeid, h2.regionid as sectorid
	INTO #intersect
	    FROM RegionConvex h2, Region r
	    WHERE h2.type='SECTOR'
	      and r.type='TIHOLE'
	      and NOT EXISTS ( select h1.convexid 
		from Halfspace as h1
		where h1.regionid=r.regionid
		and case when (sqrt(power(h1.x-h2.x,2)
			+power(h1.y-h2.y,2)
			+power(h1.z-h2.z,2))/2)<1
		then 2*asin(sqrt(power(h1.x-h2.x,2)
			+power(h1.y-h2.y,2)
			+power(h1.z-h2.z,2))/2) 
		else PI() end > acos(h1.c)+RADIANS(h2.radius/60)
		group by h1.convexid
		)
	    GROUP BY r.regionid, h2.regionid

-- 709 rows, in 26 sec
-- DR5: 940 rows in 50 sec


drop table #intersect

		select 	distinct h2.regionid as holeid, h1.regionid as sectorid
		into #intersect
		from RegionConvex h1, RegionConvex h2
		where h1.type='TIHOLE' 
		  and h2.type='SECTOR'
		group by h2.regionid, h2.convexid, h2.patch, h1.regionid, h1.convexid, h1.patch
		having
		    max(case when (sqrt(power(h1.x-h2.x,2)
			+power(h1.y-h2.y,2)
			+power(h1.z-h2.z,2))/2)<1
		    then 2*asin(0.5*sqrt(power(h1.x-h2.x,2)
			+power(h1.y-h2.y,2)
			+power(h1.z-h2.z,2))) 
		    else PI() end - radians((h1.radius+h2.radius)/60) 
		) <0
--809 rows in 12 sec
-- DR5: 1962 rows in 24 sec

delete #intersect
where dbo.fRegionOverlapId(holeid, sectorid,0) is null
--561 rows in 25 sec
-- DR5: deletes all 1962 rows!

select * from #intersect
where dbo.fRegionOverlapId(holeid, sectorid,0) is not null
-- 248 rows in 13 sec
-- DR5: 0 rows, see above

select * from #intersect
where dbo.fRegionOverlapId(sectorid,holeid,0) is not null
-- 248 rows in 14 sec
-- DR5: 0 rows, see above

select * from #intersect
-- 133 rows
-- DR5: 0 rows, see above

select holeid, count(*)
from #intersect
group by holeid
-- 105

select sectorid, count(*)
from #intersect
group by sectorid
-- 112



select * from Region
where type='TIHOLE'
and regionid not in (select holeid from #intersect)


select * from RegionArcs where regionid=10570
-- DR5: nothing returned

select dbo.fRegionOverlapId(279569, 10570,0)  -- does work
select dbo.fRegionOverlapId(10570,279569,0)   -- does not work
-- DR5: both return NULL

--REGION CONVEX  0.000000000000000  0.000000000000000  1.000000000000000 -0.014644492369264 -0.089125151859616  0.996020435184942  0.000000000000000  0.000000000000000  0.083920506627905 -0.996472452487933  0.000000000000000  0.000000000000000  0.00000000000
--NULL



select * from dbo.fRegionsContainingPointEq(
184.81395265891425,-0.83909759999999678,'SECTOR',0)
-- DR5: returns 116505,SECTOR

select * from #intersect
order by holeid


select sum(dbo.fRegionAreaPatch(regionid,convexid,patch))
from regionconvex
where regionid=279569
-- DR5: returns NULL


select * from Region where regionid=279569
-- DR5: returns NULL
