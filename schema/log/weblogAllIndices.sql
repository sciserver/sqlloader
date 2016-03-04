USE [weblog]
GO

/****** Object:  Index [PK__weblogAllNew__43C1049E]    Script Date: 03/02/2016 10:18:01 ******/
ALTER TABLE [dbo].[weblogAll] ADD PRIMARY KEY CLUSTERED 
(
	[yy] DESC,
	[mm] DESC,
	[dd] DESC,
	[hh] DESC,
	[mi] DESC,
	[ss] DESC,
	[seq] DESC,
	[theTime] ASC,
	[logID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


/****** Object:  Index [IX_weblogAll_logID]    Script Date: 03/02/2016 10:18:45 ******/
CREATE NONCLUSTERED INDEX [IX_weblogAll_logID] ON [dbo].[weblogAll] 
(
	[logID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


ALTER TABLE [dbo].[weblogAll]  WITH NOCHECK ADD FOREIGN KEY([logID])
REFERENCES [dbo].[LogSource] ([logID])
GO



/*
USE [weblog]
GO

/****** Object:  Index [PK__SQLlogAllNew__6CC31A31]    Script Date: 03/02/2016 10:38:44 ******/
ALTER TABLE [dbo].[SQLlogAll] ADD PRIMARY KEY CLUSTERED 
(
	[yy] DESC,
	[mm] DESC,
	[dd] DESC,
	[hh] DESC,
	[mi] DESC,
	[ss] DESC,
	[seq] DESC,
	[theTime] ASC,
	[logID] ASC,
	[clientIP] ASC,
	[requestor] ASC,
	[server] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
*/

