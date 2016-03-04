USE BestDR12
GO

	declare @rows BIGINT

	BEGIN TRANSACTION
	    UPDATE p
		SET p.specobjid=0
		FROM PhotoObjAll p WITH (tablock)
		WHERE 
		    p.specobjid != 0
	    SET  @rows = ROWCOUNT_BIG();
	COMMIT TRANSACTION
	PRINT 'Set specobjid to 0 for ' + str(@rows) + ' PhotoObjAll rows.'
	
	BEGIN TRANSACTION
--		drop table #specuniq
--		drop table #specdup
--		drop table #specinfo
--		drop table #specresolve
		SELECT p.objID, MAX(s.specObjID) as specobjID
		INTO #specuniq
		FROM PhotoObjAll p JOIN SpecObjAll s ON p.objID=s.bestObjID
		GROUP BY p.objID
		HAVING COUNT(p.objID) = 1

		SELECT p.objID
		INTO #specdup
		FROM PhotoObjAll p JOIN SpecObjAll s ON p.objID=s.bestObjID
		GROUP BY p.objID
		HAVING COUNT(p.objID) > 1

		SELECT p.objid, q.ra as pra, q.dec as pdec, s.specobjid, s.sciencePrimary, s.ra as sra, s.dec as sdec, 
			dbo.fDistanceArcMinEq(q.ra, q.dec, s.ra, s.dec) as dist
		INTO #specinfo
		FROM #specdup p join PhotoObjAll q ON p.objID=q.objID join SpecObjAll s ON p.objID=s.bestObjID
		ORDER BY q.objID, s.sciencePrimary DESC, dist ASC

		SELECT distinct p.objid, 
			(SELECT TOP 1 q.specobjid FROM #specinfo q WHERE q.objID=p.objID ORDER BY q.sciencePrimary DESC, q.dist ASC) as specobjid
		INTO #specresolve
		FROM #specdup p 

		INSERT #specuniq
		SELECT objID, specObjID
		FROM #specresolve

	    UPDATE p
		SET p.specobjid=s.specobjid
		FROM PhotoObjAll p WITH (tablock)
		     JOIN #specuniq s ON p.objid=s.objid
	    SET  @rows = ROWCOUNT_BIG();
	COMMIT TRANSACTION
	PRINT 'Set specobjid for ' + str(@rows) + ' PhotoObjAll rows.'

/*
drop table #specuniq
drop table #specdup
drop table #specinfo
drop table #specresolve
*/

-- select COUNT(*) from SpecObj s join Galaxy g on g.specObjID=s.specObjID		-- 2324547
-- select COUNT(*) from SpecObj s join Galaxy g on g.objID=s.bestObjID			-- 2324582
