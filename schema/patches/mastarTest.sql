

--select * from [dbo].[fGetNearbyMaStarObjEq](38.7, 47.4, 1)

declare @qra float;declare @qdec float;declare @searchRadius float;
set @searchRadius=16.0/60.0
set @qra=193.06119	
set @qdec=41.02368

--set @qra=38.7048931
--set @qdec=47.4085836
set @qra=131.009990414743
set @qdec=10.7660346114096

set statistics time on
set statistics io on

select * 
from dbo.fGetNearbyMangaObjEq(@qra , @qdec , @searchRadius) f 
join mangaDrpAll m on m.plateifu = f.plateIFU



select * 
from [dbo].[fGetNearbyMaStarObjEq](@qra , @qdec , @searchRadius) f 
join mastar_goodstars m on m.mangaid = f.mangaid