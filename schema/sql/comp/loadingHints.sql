

alter table mangaFirefly add constraint pk_mangaFirefly_plateIFU
primary key clustered (plateifu)
with (data_compression=page, sort_in_tempdb=on)
on [DATAFG]

alter table sppTargets add constraint pk_sppTargets_objid
primary key clustered (objid)
with (data_compression=page, sort_in_tempdb=on)
on [DATAFG]

/*

in order to get minimal logging when you're loading into a table with a clustered index
you need the following:
1. table has to be empty (so if you have to stop the loading for some reason, you should
drop and re-create the table and index before you try again.)  truncating the table may 
not be sufficient.  to be safe, i always drop and re-create.

2. before your insert you need to have DBCC TRACEON(610)

3. your insert needs the tablock hint

so for example:
*/
DBCC TRACEON(610)
INSERT mytable with (tablock)
select * from source_table with (nolock) -- i guess nolock should be faster, right?
DBCC TRACEOFF(610)


/*
also, if you say DBCC TRACEON(610, -1) i think that turns on the trace flag for all SPIDS until you turn it off

let me know how it works!
--sue

