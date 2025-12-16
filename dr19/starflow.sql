

/****** Object:  Table [dbo].[StarFlow_summary]    Script Date: 6/26/2025 1:56:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

drop table if exists Starflow_summary
CREATE TABLE [dbo].[StarFlow_summary](
	[sdss_id] [bigint] NOT NULL,
	[sdss4_apogee_id] [varchar](20) NOT NULL,
	[catalogid] [bigint] NOT NULL,
	[age] [float] NOT NULL,
	[e_p_age] [float] NOT NULL,
	[e_n_age] [float] NOT NULL,
	[mass] [float] NOT NULL,
	[e_p_mass] [float] NOT NULL,
	[e_n_mass] [float] NOT NULL,
	[training_density] [float] NOT NULL,
	[bitmask] [bigint] NOT NULL,
	[PK] [int] primary key clustered NOT NULL
) ON [SPEC]
GO


insert StarFlow_summary with (tablock)
select * from BESTTEST..StarFlow_summary

create nonclustered index ix_Starflow_summary_sdss_id
on Starflow_summary(sdss_id)
