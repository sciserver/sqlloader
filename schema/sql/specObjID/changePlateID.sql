
alter table plate2target alter column plateid numeric(20,0) not null
alter table SpecObjAll alter column plateid numeric(20,0) not null
alter table SpecPhotoAll alter column plateid numeric(20,0) not null
alter table sppParams alter column plateid numeric(20,0) not null
alter table sppTargets alter column plateid numeric(20,0) not null


--dont forget to add index to specObjAll