


/****** Object:  Index [i_PlateX_htmID_ra_dec_cx_cy_cz]    Script Date: 4/5/2017 2:32:34 PM ******/
DROP INDEX [i_PlateX_htmID_ra_dec_cx_cy_cz] ON [dbo].[PlateX]
GO



/****** Object:  Index [pk_PlateX_plateID]    Script Date: 4/5/2017 2:32:45 PM ******/
ALTER TABLE [dbo].[PlateX] DROP CONSTRAINT [pk_PlateX_plateID]
GO


alter table dbo.PlateX alter column plateID numeric(20,0) not null



/****** Object:  Index [pk_PlateX_plateID]    Script Date: 4/5/2017 2:31:54 PM ******/
ALTER TABLE [dbo].[PlateX] ADD  CONSTRAINT [pk_PlateX_plateID] PRIMARY KEY CLUSTERED 
(
	[plateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATAFG]
GO



/****** Object:  Index [i_PlateX_htmID_ra_dec_cx_cy_cz]    Script Date: 4/5/2017 2:32:00 PM ******/
CREATE NONCLUSTERED INDEX [i_PlateX_htmID_ra_dec_cx_cy_cz] ON [dbo].[PlateX]
(
	[htmID] ASC,
	[ra] ASC,
	[dec] ASC,
	[cx] ASC,
	[cy] ASC,
	[cz] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [DATAFG]
GO

