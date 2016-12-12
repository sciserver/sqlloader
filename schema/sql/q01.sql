declare @saturated bigint;							-- initialized “saturated” flag
		set     @saturated = dbo.fPhotoFlags('saturated');	-- avoids SQL2K optimizer problem
		select	G.objID, GN.distance  				-- return Galaxy Object ID and 
	  	--into 	##results1   					-- angular distance (arc minutes)
		from 	Galaxy                     as G  		-- join Galaxies with
		join	fGetNearbyObjEq(195,2.5, 1) as GN             	-- objects within 1’ of ra=195 & dec=2
						on G.objID = GN.objID	-- connects G and GN
		where (G.flags & @saturated) = 0  			-- not saturated
		order by distance					-- sorted nearest first
		---------------------------------------------------------------------------
		--exec spTestTimeEnd @clock, @elapsed, @cpu, @physical_io, 'Q01', @comment, 1, 1, @@RowCount 
		--drop table ##results1