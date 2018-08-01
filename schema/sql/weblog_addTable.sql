

/****** Object:  Table [dbo].[QueryResults]    Script Date: 2/7/2018 12:17:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QueryResults](
	[query] [varchar](10) NOT NULL,
	[cpu_sec] [float] NOT NULL,
	[elapsed_time] [float] NOT NULL,
	[physical_IO] [float] NOT NULL,
	[row_count] [bigint] NOT NULL,
	[time] [datetime] NOT NULL,
	[dbname] sysname,
	[comment] [varchar](100) NULL,
 CONSTRAINT [pk_QueryResults_query_time] PRIMARY KEY CLUSTERED 
(
	[query] ASC,
	[time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) )

GO

ALTER TABLE [dbo].[QueryResults] ADD  DEFAULT (getdate()) FOR [time]
GO

ALTER TABLE [dbo].[QueryResults] ADD  DEFAULT ('') FOR [comment]
GO

create nonclustered index ix_queryResults_dbname on QueryResults (dbname)


