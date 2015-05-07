
select top 0 *, cast(0 as tinyint) isPrimary
into detectionIndex2
from detectionIndex
 
alter table detectionIndex2 add constraint pk_detectionIndex2_thingid_objid
PRIMARY KEY(thingId, objID)

dbcc traceon(610)
 
insert detectionIndex2 with (tablock)
select
      d.thingId, d.objId, d.loadVersion,
      (case when (t.objid is not null) then 1 else 0 end) isPrimary
from detectionIndex d left outer join thingIndex t
      on d.thingid=t.thingid and d.objid=t.objid
order by d.thingId, d.objId
go

exec spIndexDropSelection 0,0,'F','detectionIndex'


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'detectionIndex')
	DROP TABLE detectionIndex
GO
EXEC spSetDefaultFileGroup 'detectionIndex'
GO
CREATE TABLE detectionIndex (
	thingId		bigint NOT NULL,	--/D thing ID number
	objId		bigint NOT NULL,	--/D object ID number (from run, camcol, field, id, rerun)
	isPrimary	tinyint NOT NULL,	--/D 1 if object is primary, 0 if not
	loadVersion	int	NOT NULL	--/D Load Version --/K ID_VERSION --/F NOFITS
)
GO
--

exec spIndexBuildSelection 0,0,'K','detectionIndex'
exec spIndexBuildSelection 0,0,'I','detectionIndex'
exec spIndexBuildSelection 0,0,'F','detectionIndex'

 
INSERT detectionIndex WITH (tablock)
	SELECT * FROM detectionIndex2 
GO 
 

drop table detectionIndex2
go
