sp_spaceused 'AtlasOutline'

exec sp_estimate_data_compression_savings 'dbo', 'AtlasOutline', null, null, 'page'

y
855932184