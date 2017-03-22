


		select distinct P.ObjID 		-- distinct cases  
		--into ##results18			-- the oid compare eliminats dups
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
		--4611 9 sec


			select  P.ObjID 		-- distinct cases  
		--into ##results18			-- the oid compare eliminats dups
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

		create nonclustered index [ix_neighbors_neighorObjID]  on neighbors (neighborObjID)include (objID)


		select @@version


		select * from IndexMap2
		where compression = 'PAGE'
		and code = 'K'


		select 
		tableName = object_name(c.object_id),
		--columnName = c.name,
		datatype = t.name, 
		count(t.name)
		--maxlength = t.max_length
		from
		sys.columns c
		join sys.types as t
		on c.user_type_id=t.user_type_id
		where object_name(c.object_id) IN (
			select tablename from IndexMap2
			where compression = 'PAGE'
			and code = 'K'
		)
		group by c.object_id, t.name

		--frame, specObjAll, Mask, AtlasOutline, FIRST, emissoinLinesPort, WISE_allsky



		
		select 
		tableName = object_name(c.object_id),
		columnName = c.name,
		datatype = t.name, 
		--count(t.name)
		maxlength = c.max_length
		from
		sys.columns c
		join sys.types as t
		on c.user_type_id=t.user_type_id
		where object_name(c.object_id) IN (
			--select tablename from IndexMap2
			--where compression = 'PAGE'
			--and code = 'K'
			--'frame', 'specObjAll', 'Mask', 'AtlasOutline', 'FIRST', 'emissionLinesPort', 'WISE_allsky'
			'sppParams','Frame''AtlasOutline','wiseForcedTarget','sdssImagingHalfSpaces','SpecObjAll','RegionPatch','WISE_allsky'
		)
		and c.max_length < 1
		--group by c.object_id, t.name



		SELECT 

	t.name AS table_name, 
	i.type_desc AS index_type, 
	i.is_unique AS is_unique_index

	--into tempdb.dbo.ccitables

FROM sys.tables AS t
INNER JOIN sys.schemas AS s
	ON t.schema_id = s.schema_id
INNER JOIN sys.indexes AS i
	ON t.object_id = i.object_id
INNER JOIN indexMap2 as m
	ON t.name = m.tablename
WHERE i.type_desc IN ('CLUSTERED COLUMNSTORE')
and m.compression = 'PAGE'
and m.code = 'K'
order by index_type, table_name



