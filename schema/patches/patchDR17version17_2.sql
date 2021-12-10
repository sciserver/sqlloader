-- Patch to fix 32-bit flag functions that currently don't work because they assume
-- that the constant values in the DataConstants table are 64-bit.  So this patch
-- replaces the values in DataCOnstants with 64-bit values.

USE BestDR17
GO


-- delete the current 32-bit values first
delete from DataConstants where field='ImageStatus'
delete from DataConstants where field='PhotoStatus'
go

-- insert the new 64-bit values
Insert DataConstants values  ('PhotoStatus', '',  	   	0, 		'SDSS-II (DR1-7): Status of the object in the survey.')
Insert DataConstants values  ('PhotoStatus', 'SET',  	   	0x0000000000000001, 	'Object''s status has been set in reference to its own run')
Insert DataConstants values  ('PhotoStatus', 'GOOD', 	   	0x0000000000000002, 	'Object is good as determined by its object flags. Absence implies bad.')
Insert DataConstants values  ('PhotoStatus', 'DUPLICATE',  	0x0000000000000004, 	'Object has one or more duplicate detections in an adjacent field of the same Frames Pipeline Run.')
Insert DataConstants values  ('PhotoStatus', 'OK_RUN',	   	0x0000000000000010, 	'Object is usable, it is located within the primary range of rows for this field. ')
Insert DataConstants values  ('PhotoStatus', 'RESOLVED',   	0x0000000000000020, 	'Object has been resolved against other runs.')
Insert DataConstants values  ('PhotoStatus', 'PSEGMENT',   	0x0000000000000040, 	'Object Belongs to a PRIMARY segment. This does not imply that this is a primary object. ')
Insert DataConstants values  ('PhotoStatus', 'FIRST_FIELD', 	0x0000000000000100, 	'Object belongs to the first field in its segment. Used to distinguish objects in fields shared by two segments.')
Insert DataConstants values  ('PhotoStatus', 'OK_SCANLINE', 	0x0000000000000200, 	'Object lies within valid nu range for its scanline.')
Insert DataConstants values  ('PhotoStatus', 'OK_STRIPE',   	0x0000000000000400, 	'Object lies within valid eta range for its stripe.')
Insert DataConstants values  ('PhotoStatus', 'SECONDARY',   	0x0000000000001000, 	'This is a secondary survey object.')
Insert DataConstants values  ('PhotoStatus', 'PRIMARY',	   	0x0000000000002000, 	'This is a primary survey object.')
Insert DataConstants values  ('PhotoStatus', 'TARGET',	   	0x0000000000004000, 	'This is a spectroscopic target.')
GO



Insert DataConstants values  ('ImageStatus',	'',		0,	'Sky and instrument conditions of SDSS image. Please see the IMAGE_STATUS entry in Algorithms under Bitmasks for further information.')
Insert DataConstants values  ('ImageStatus',	'CLEAR',	0x0000000000000001,	'Clear skies')
Insert DataConstants values  ('ImageStatus',	'CLOUDY',	0x0000000000000002,	'Cloudy skies (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'UNKNOWN',	0x0000000000000004,	'Sky conditions unknown (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'BAD_ROTATOR',	0x0000000000000008,	'Rotator problems (set score=0)')
Insert DataConstants values  ('ImageStatus',	'BAD_ASTROM',	0x0000000000000010,	'Astrometry problems (set score=0)')
Insert DataConstants values  ('ImageStatus',	'BAD_FOCUS',	0x0000000000000020,	'Focus bad (set score=0)')
Insert DataConstants values  ('ImageStatus',	'SHUTTERS',	0x0000000000000040,	'Shutter out of place (set score=0)')
Insert DataConstants values  ('ImageStatus',	'FF_PETALS',	0x0000000000000080,	'Flat-field petals out of place (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'DEAD_CCD',	0x0000000000000100,	'CCD bad (unphotometric)')
Insert DataConstants values  ('ImageStatus',	'NOISY_CCD',	0x0000000000000200,	'CCD noisy (unphotometric)')
GO

USE [BestDR17]
GO

-- next, reload the SpecPhotoAll table
EXEC spBuildSpecPhotoAll 0,0

USE [BestDR17]
GO
SET ANSI_PADDING ON
GO

/* Uncomment the following if the indices for SpecPhotoAll need to be moved to correct filegroups
/****** Object:  Index [i_SpecPhotoAll_objID_sciencePrim]    Script Date: 12/4/2021 7:22:10 PM ******/
CREATE NONCLUSTERED INDEX [i_SpecPhotoAll_objID_sciencePrim] ON [dbo].[SpecPhotoAll]
(
	[objID] ASC,
	[sciencePrimary] ASC,
	[class] ASC,
	[z] ASC,
	[targetObjID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SPEC]
GO

USE [BestDR17]
GO

SET ANSI_PADDING ON
GO

/****** Object:  Index [i_SpecPhotoAll_targetObjID_scien]    Script Date: 12/4/2021 7:22:30 PM ******/
CREATE NONCLUSTERED INDEX [i_SpecPhotoAll_targetObjID_scien] ON [dbo].[SpecPhotoAll]
(
	[targetObjID] ASC,
	[sciencePrimary] ASC,
	[class] ASC,
	[z] ASC,
	[objID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = ON, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SPEC]
GO
*/


-- update db version to 17.2
USE [BestDR17]
GO

EXECUTE spSetVersion
  0
  ,0
  ,'17'
  ,'639d0bb'
  ,'Update DR'
  ,'.2'
  ,'DataConstants and SpecPhotoAll update for DR17'
  ,'Replaced some 32-bit constant values with 64-bit ones, rebuilt SpecPhotoAll'
  ,'A.Thakar'
  ,0


