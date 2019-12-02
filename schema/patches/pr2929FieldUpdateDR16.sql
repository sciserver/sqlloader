-- 2019-11-24 Ani: created patch to apply the update from Mike Blanton in PR # 2929 re psf2G* values in Field table.
-- Download sqlFieldUpdateDR16-2-301.csv from SDSS-IV trac ticket #2929 and import CSV into table sqlFieldUpdateDR15-2-301.
-- 
-- select count(*) from [sqlFieldUpdateDR16-2-301]
-- select count(*) from Field

-- Create PK on fieldID in the imported table to do the join and speed up the update to Field table.

USE [BestDR16]
GO

/****** Object:  Index [pk_Field_fieldID]    Script Date: 11/23/2019 10:27:37 PM ******/
ALTER TABLE [dbo].[sqlFieldUpdateDR16-2-301] ADD  CONSTRAINT [pk_FieldUpdate_fieldID] PRIMARY KEY CLUSTERED 
(
	[fieldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATAFG]
GO


-- Now apply the update to the Field table
USE [BestDR16]
GO

UPDATE f
        set f.[psf2GSigma1_u]=u.[psf2GSigma1_u],
         f.[psf2GSigma1_g]=u.[psf2GSigma1_g],
         f.[psf2GSigma1_r]=u.[psf2GSigma1_r],
         f.[psf2GSigma1_i]=u.[psf2GSigma1_i],
         f.[psf2GSigma1_z]=u.[psf2GSigma1_z],
         f.[psf2GSigma2_u]=u.[psf2GSigma2_u],
         f.[psf2GSigma2_g]=u.[psf2GSigma2_g],
         f.[psf2GSigma2_r]=u.[psf2GSigma2_r],
         f.[psf2GSigma2_i]=u.[psf2GSigma2_i],
         f.[psf2GSigma2_z]=u.[psf2GSigma2_z],
         f.[psf2GB_u]=u.[psf2GB_u],
         f.[psf2GB_g]=u.[psf2GB_g],
         f.[psf2GB_r]=u.[psf2GB_r],
         f.[psf2GB_i]=u.[psf2GB_i],
         f.[psf2GB_z]=u.[psf2GB_z]
  FROM Field f JOIN [sqlFieldUpdateDR16-2-301] u ON f.fieldID=u.fieldID



