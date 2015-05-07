-- Renaming of various columns to patch DR1 version of schema
EXEC sp_rename 'PhotoObjAll.reddening_g', 'extinction_g', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.reddening_u', 'extinction_u', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.reddening_r', 'extinction_r', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.reddening_i', 'extinction_i', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.reddening_z', 'extinction_z', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.catid', 'insideMask', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.fracPSF_g', 'fracDeV_g', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.fracPSF_u', 'fracDeV_u', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.fracPSF_r', 'fracDeV_r', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.fracPSF_i', 'fracDeV_i', 'COLUMN'
EXEC sp_rename 'PhotoObjAll.fracPSF_z', 'fracDeV_z', 'COLUMN'

EXEC sp_rename 'PlateX.reddening_u', 'extinction_u', 'COLUMN'
EXEC sp_rename 'PlateX.reddening_g', 'extinction_g', 'COLUMN'
EXEC sp_rename 'PlateX.reddening_r', 'extinction_r', 'COLUMN'
EXEC sp_rename 'PlateX.reddening_i', 'extinction_i', 'COLUMN'
EXEC sp_rename 'PlateX.reddening_z', 'extinction_z', 'COLUMN'
EXEC sp_rename 'Tile.reddening_u', 'extinction_u', 'COLUMN'
EXEC sp_rename 'Tile.reddening_g', 'extinction_g', 'COLUMN'
EXEC sp_rename 'Tile.reddening_r', 'extinction_r', 'COLUMN'
EXEC sp_rename 'Tile.reddening_i', 'extinction_i', 'COLUMN'

drop view PhotoObj
drop view PhotoTagView
EXEC sp_rename 'PhotoTag.reddening_g', 'extinction_g', 'COLUMN'
EXEC sp_rename 'PhotoTag.reddening_u', 'extinction_u', 'COLUMN'
EXEC sp_rename 'PhotoTag.reddening_r', 'extinction_r', 'COLUMN'
EXEC sp_rename 'PhotoTag.reddening_i', 'extinction_i', 'COLUMN'
EXEC sp_rename 'PhotoTag.reddening_z', 'extinction_z', 'COLUMN'

