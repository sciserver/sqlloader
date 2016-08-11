-- Patch to set the primary flags for various spectro programs correctly (fixes a bug in DR12)
SELECT specobjid, legacyPrimary INTO #legacy FROM SpecObjAll
SELECT specobjid, bossPrimary INTO #boss FROM SpecObjAll
UPDATE SpecObjAll SET legacyPrimary=seguePrimary
UPDATE SpecObjAll SET bossPrimary=sdssPrimary
UPDATE s SET s.sdssPrimary=t.legacyPrimary FROM SpecObjAll s JOIN #legacy t ON s.specObjID=t.specObjID
UPDATE SpecObjAll SET seguePrimary=segue1Primary
UPDATE SpecObjAll SET segue1Primary=segue2Primary
UPDATE SpecObjAll SET segue2Primary=segue2Primary
UPDATE s SET s.segue2Primary=t.bossPrimary FROM SpecObjAll s JOIN #boss t ON s.specObjID=t.specObjID
DROP TABLE #legacy
DROP TABLE #boss

-- Check the numbers to make sure (should be the ones in the comments)
select count(*) from SpecObjAll                           -- 4411200
select count(*) from SpecObjAll where scienceprimary > 0  -- 3934059
select count(*) from SpecObjAll where legacyprimary > 0   -- 1126664
select count(*) from SpecObjAll where sdssprimary > 0     -- 1653111
select count(*) from SpecObjAll where bossprimary > 0     -- 2334171
select count(*) from SpecObjAll where segueprimary > 0    -- 370966
select count(*) from SpecObjAll where segue1primary > 0   -- 247865
select count(*) from SpecObjAll where segue2primary > 0   -- 125459

-- Set the DB version to 13.4
DELETE FROM Versions WHERE verson='13.4'
EXECUTE spSetVersion
  0
  ,0
  ,'13'
  ,'53a57f8cfee9563ae3d361c93aaf2bc428ce6851'
  ,'Update DR'
  ,'.4'
  ,'Spectro primary flags update'
  ,'Updated all the spectro primary flags in SpecObjAll to fix a bug in DR12 forwhich the fix did not get propagated to DR13'
  ,'A.Thakar'
GO
