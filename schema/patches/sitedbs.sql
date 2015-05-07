alter table sitedbs
add description varchar(128) default ' ' not null
go

alter table sitedbs
add active char(1) default 'Y' not null
go

update sitedbs
set description='<u>Default</u>, the best Photo, Spectro and Tiling data'
where dbname like 'BEST%'

update sitedbs
set description='Photo, frozen at time of target selection'
where dbname like 'TARG%'

update sitedbs
set description='The Early Data Release (EDR) catalog'
where dbname='SkyServerV3'

delete sitedbs
where dbname not like 'BEST%' and dbname not like 'TARG%'
  and dbname not in ('RC3','Stetson','SkyServerV3')

select * from sitedbs

grant select on sitedbs to test
