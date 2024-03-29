/****** Object:  Table [dbo].[IndexMap]    Script Date: 7/31/2018 1:33:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndexMap](
	[indexmapid] [int] NOT NULL,
	[code] [varchar](2) NOT NULL,
	[type] [varchar](32) NOT NULL,
	[tableName] [varchar](128) NOT NULL,
	[fieldList] [varchar](1000) NOT NULL,
	[foreignKey] [varchar](1000) NOT NULL,
	[indexgroup] [varchar](128) NOT NULL,
	[compression] [varchar](32) NULL,
	[filegroup] [varchar](32) NULL,
	[common] bit null)
alter table IndexMap add constraint [pk_IndexMap_indexmapid]
PRIMARY KEY CLUSTERED 
(
	[indexmapid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
ON [PRIMARY]




GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (1, N'K', N'primary key', N'PartitionMap', N'fileGroupName', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (2, N'K', N'primary key', N'FileGroupMap', N'tableName', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (3, N'K', N'primary key', N'IndexMap', N'indexmapid', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (4, N'K', N'primary key', N'PubHistory', N'name,loadversion', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (5, N'K', N'primary key', N'QueryResults', N'query, time', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (6, N'K', N'primary key', N'RecentQueries', N'ipAddr,lastQueryTime', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (7, N'K', N'primary key', N'RunShift', N'run', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (8, N'K', N'primary key', N'Versions', N'version', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (9, N'K', N'primary key', N'DBObjects', N'name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (10, N'K', N'primary key', N'DBColumns', N'tableName,name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (11, N'K', N'primary key', N'DBViewCols', N'viewName,name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (12, N'K', N'primary key', N'History', N'id', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (13, N'K', N'primary key', N'Inventory', N'filename,name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (14, N'K', N'primary key', N'Dependency', N'parent,child', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (15, N'K', N'primary key', N'DataConstants', N'field,name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (16, N'K', N'primary key', N'Diagnostics', N'name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (17, N'K', N'primary key', N'SDSSConstants', N'name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (18, N'K', N'primary key', N'SiteConstants', N'name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (19, N'K', N'primary key', N'SiteDiagnostics', N'name', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (20, N'K', N'primary key', N'ProfileDefs', N'bin', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (21, N'K', N'primary key', N'LoadHistory', N'loadVersion,tStart', N'', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (22, N'K', N'primary key', N'PhotoObjAll', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (23, N'K', N'primary key', N'PhotoProfile', N'objID,bin,band', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (24, N'K', N'primary key', N'AtlasOutline', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (25, N'K', N'primary key', N'Frame', N'fieldID,zoom', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (26, N'K', N'primary key', N'PhotoPrimaryDR7', N'dr8objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (27, N'K', N'primary key', N'PhotoObjDR7', N'dr8objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (28, N'K', N'primary key', N'Photoz', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (29, N'K', N'primary key', N'PhotozErrorMap', N'cellID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (30, N'K', N'primary key', N'Field', N'fieldID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (31, N'K', N'primary key', N'FieldProfile', N'fieldID,bin,band', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (32, N'K', N'primary key', N'Mask', N'maskID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (33, N'K', N'primary key', N'First', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (34, N'K', N'primary key', N'RC3', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (35, N'K', N'primary key', N'Rosat', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (36, N'K', N'primary key', N'USNO', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (37, N'K', N'primary key', N'TwoMass', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (38, N'K', N'primary key', N'TwoMassXSC', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (39, N'K', N'primary key', N'WISE_xmatch', N'sdss_objID,wise_cntr', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (40, N'K', N'primary key', N'WISE_allsky', N'cntr', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (41, N'K', N'primary key', N'wiseForcedTarget', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (42, N'K', N'primary key', N'thingIndex', N'thingId', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (43, N'K', N'primary key', N'detectionIndex', N'thingId,objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (44, N'K', N'primary key', N'ProperMotions', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (45, N'K', N'primary key', N'StripeDefs', N'stripe', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (46, N'K', N'primary key', N'MaskedObject', N'objid,maskid', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (47, N'K', N'primary key', N'zooMirrorBias', N'dr7objid', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (48, N'K', N'primary key', N'zooMonochromeBias', N'dr7objid', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (49, N'K', N'primary key', N'zooNoSpec', N'dr7objid', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (50, N'K', N'primary key', N'zooVotes', N'dr7objid', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (51, N'K', N'primary key', N'zoo2MainPhotoz', N'dr7objid', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (52, N'K', N'primary key', N'PlateX', N'plateID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (53, N'K', N'primary key', N'SpecObjAll', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (54, N'K', N'primary key', N'SpecDR7', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (55, N'K', N'primary key', N'sppParams', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (56, N'K', N'primary key', N'sppLines', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (57, N'K', N'primary key', N'segueTargetAll', N'objID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (58, N'K', N'primary key', N'galSpecExtra', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (59, N'K', N'primary key', N'galSpecIndx', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (60, N'K', N'primary key', N'galSpecInfo', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (61, N'K', N'primary key', N'galSpecLine', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (62, N'K', N'primary key', N'emissionLinesPort', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (63, N'K', N'primary key', N'stellarMassFSPSGranEarlyDust', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (64, N'K', N'primary key', N'stellarMassFSPSGranEarlyNoDust', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (65, N'K', N'primary key', N'stellarMassFSPSGranWideDust', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (66, N'K', N'primary key', N'stellarMassFSPSGranWideNoDust', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (67, N'K', N'primary key', N'stellarMassPCAWiscBC03', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (68, N'K', N'primary key', N'stellarMassPCAWiscM11', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (69, N'K', N'primary key', N'stellarMassStarformingPort', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (70, N'K', N'primary key', N'stellarMassPassivePort', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (71, N'K', N'primary key', N'apogeeDesign', N'designid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (72, N'K', N'primary key', N'apogeeField', N'location_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (73, N'K', N'primary key', N'apogeeVisit', N'visit_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (74, N'K', N'primary key', N'apogeeStar', N'apstar_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (75, N'K', N'primary key', N'aspcapStar', N'aspcap_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (76, N'K', N'primary key', N'apogeePlate', N'plate_visit_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (77, N'K', N'primary key', N'aspcapStarCovar', N'aspcap_covar_id,aspcap_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (78, N'K', N'primary key', N'apogeeObject', N'target_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (79, N'K', N'primary key', N'apogeeStarVisit', N'visit_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (80, N'K', N'primary key', N'apogeeStarAllVisit', N'visit_id,apstar_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (81, N'K', N'primary key', N'cannonStar', N'cannon_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (82, N'K', N'primary key', N'mangaDAPall', N'plateIFU,daptype', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (83, N'K', N'primary key', N'mangaDRPall', N'plateIFU', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (84, N'K', N'primary key', N'mangaTarget', N'mangaID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (85, N'K', N'primary key', N'nsatlas', N'nsaID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (86, N'K', N'primary key', N'mangaFirefly', N'plateIFU', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (87, N'K', N'primary key', N'mangaPipe3D', N'plateIFU', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (88, N'K', N'primary key', N'mangaHIall', N'plateIFU', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (89, N'K', N'primary key', N'mangaHIbonus', N'plateIFU,bonusid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (90, N'K', N'primary key', N'qsoVarPTF', N'VAR_OBJID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (91, N'K', N'primary key', N'qsoVarStripe', N'VAR_OBJID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (92, N'K', N'primary key', N'zooSpec', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (93, N'K', N'primary key', N'zooConfidence', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (94, N'K', N'primary key', N'zoo2MainSpecz', N'dr7objid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (95, N'K', N'primary key', N'zoo2Stripe82Coadd1', N'stripe82objid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (96, N'K', N'primary key', N'zoo2Stripe82Coadd2', N'stripe82objid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (97, N'K', N'primary key', N'zoo2Stripe82Normal', N'dr7objid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (98, N'K', N'primary key', N'marvelsStar', N'STARNAME,PLATE', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (99, N'K', N'primary key', N'marvelsVelocityCurveUF1D', N'STARNAME,BEAM,RADECID,FCJD,[LST-OBS]', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (100, N'K', N'primary key', N'sppTargets', N'TARGETID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (101, N'K', N'primary key', N'sdssEbossFirefly', N'specObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (102, N'K', N'primary key', N'spiders_quasar', N'name', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (103, N'K', N'primary key', N'mastar_goodstars', N'mangaid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (104, N'K', N'primary key', N'mastar_goodvisits', N'mangaid,mjd', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (105, N'K', N'primary key', N'Target', N'targetID', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (106, N'K', N'primary key', N'TargetInfo', N'skyVersion,targetID', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (107, N'K', N'primary key', N'sdssTargetParam', N'targetVersion,paramFile,name', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (108, N'K', N'primary key', N'sdssTileAll', N'tile', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (109, N'K', N'primary key', N'sdssTilingGeometry', N'tilingGeometryID', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (110, N'K', N'primary key', N'sdssTilingRun', N'tileRun', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (111, N'K', N'primary key', N'sdssTiledTargetAll', N'targetID', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (112, N'K', N'primary key', N'sdssTilingInfo', N'tileRun,targetID', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (113, N'K', N'primary key', N'plate2Target', N'plate2TargetID,plate,objid', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (114, N'K', N'primary key', N'RMatrix', N'mode,row', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (115, N'K', N'primary key', N'Region', N'regionId', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (116, N'K', N'primary key', N'HalfSpace', N'constraintid', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (117, N'K', N'primary key', N'RegionArcs', N'regionId,convexid,arcid', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (118, N'K', N'primary key', N'RegionPatch', N'regionid,convexid,patchid', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (119, N'K', N'primary key', N'sdssImagingHalfspaces', N'sdssPolygonID,x,y,z', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (120, N'K', N'primary key', N'sdssPolygon2Field', N'sdssPolygonID,fieldID', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (121, N'K', N'primary key', N'sdssPolygons', N'sdssPolygonID', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (122, N'K', N'primary key', N'Zone', N'zoneID,ra,objID', N'', N'ZONE', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (123, N'K', N'primary key', N'Neighbors', N'objID,NeighborObjID', N'', N'NEIGHBORS', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (124, N'K', N'primary key', N'SpecPhotoAll', N'specObjID', N'', N'FINISH', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (125, N'F', N'foreign key', N'PhotoObjAll', N'fieldID', N'Field(fieldID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (126, N'F', N'foreign key', N'PhotoProfile', N'objID', N'PhotoObjAll(objID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (127, N'F', N'foreign key', N'AtlasOutline', N'objID', N'PhotoObjAll(objID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (128, N'F', N'foreign key', N'Frame', N'fieldID', N'Field(fieldID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (129, N'F', N'foreign key', N'Photoz', N'objID', N'PhotoObjAll(objID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (130, N'F', N'foreign key', N'detectionIndex', N'thingID', N'thingIndex(thingID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (131, N'F', N'foreign key', N'thingIndex', N'sdssPolygonID', N'sdssPolygons(sdssPolygonID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (132, N'F', N'foreign key', N'FieldProfile', N'fieldID', N'Field(fieldID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (133, N'F', N'foreign key', N'ProperMotions', N'objID', N'PhotoObjAll(objID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (134, N'F', N'foreign key', N'MaskedObject', N'objID', N'PhotoObjAll(objID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (135, N'F', N'foreign key', N'MaskedObject', N'maskID', N'Mask(maskID)', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (136, N'F', N'foreign key', N'SpecObjAll', N'plateID', N'PlateX(plateID)', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (137, N'F', N'foreign key', N'mangaDAPall', N'mangaID', N'mangaTarget(mangaID)', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (138, N'F', N'foreign key', N'mangaDRPall', N'mangaID', N'mangaTarget(mangaID)', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (139, N'F', N'foreign key', N'zoo2MainSpecz', N'dr8objid', N'PhotoObjAll(objid)', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (140, N'F', N'foreign key', N'zoo2Stripe82Coadd1', N'dr8objid', N'PhotoObjAll(objid)', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (141, N'F', N'foreign key', N'zoo2Stripe82Coadd2', N'dr8objid', N'PhotoObjAll(objid)', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (142, N'F', N'foreign key', N'zoo2Stripe82Normal', N'dr8objid', N'PhotoObjAll(objid)', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (143, N'F', N'foreign key', N'TargetInfo', N'targetID', N'Target(targetID)', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (144, N'F', N'foreign key', N'sdssTileAll', N'tileRun', N'sdssTilingRun(tileRun)', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (145, N'F', N'foreign key', N'sdssTilingGeometry', N'tileRun', N'sdssTilingRun(tileRun)', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (146, N'F', N'foreign key', N'sdssTilingInfo', N'tileRun', N'sdssTilingRun(tileRun)', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (147, N'F', N'foreign key', N'HalfSpace', N'regionID', N'Region(regionID)', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (148, N'F', N'foreign key', N'RegionArcs', N'regionID', N'Region(regionID)', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (149, N'F', N'foreign key', N'RegionPatch', N'regionID', N'Region(regionID)', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (150, N'F', N'foreign key', N'Zone', N'objID', N'PhotoObjAll(objID)', N'ZONE', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (151, N'F', N'foreign key', N'Neighbors', N'objID', N'PhotoObjAll(objID)', N'NEIGHBORS', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (152, N'F', N'foreign key', N'SpecPhotoAll', N'specObjID', N'SpecObjAll(specObjID)', N'FINISH', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (153, N'F', N'foreign key', N'DBColumns', N'tablename', N'DBObjects(name)', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (154, N'F', N'foreign key', N'DBViewCols', N'viewname', N'DBObjects(name)', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (155, N'F', N'foreign key', N'IndexMap', N'tableName', N'DBObjects(name)', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (156, N'F', N'foreign key', N'FileGroupMap', N'tableFileGroup', N'PartitionMap(fileGroupName)', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (157, N'F', N'foreign key', N'Inventory', N'name', N'DBObjects(name)', N'META', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (158, N'I', N'index', N'Field', N'field,camcol,run,rerun', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (159, N'I', N'index', N'Field', N'run,camcol,field,rerun', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (160, N'I', N'index', N'Frame', N'field,camcol,run,zoom,rerun', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (161, N'I', N'index', N'Frame', N'htmID,zoom,cx,cy,cz,a,b,c,d,e,f,node,incl', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (162, N'I', N'index', N'Mask', N'htmID,ra,dec,cx,cy,cz', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (163, N'I', N'index', N'PhotoObjAll', N'mode,cy,cx,cz,htmID,type,flags,ra,dec,u,g,r,i,z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (164, N'I', N'index', N'PhotoObjAll', N'htmID,cx,cy,cz,type,mode,flags,ra,dec,u,g,r,i,z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (165, N'I', N'index', N'PhotoObjAll', N'htmID,run,camcol,field,rerun,type,mode,flags,cx,cy,cz,g,r', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (166, N'I', N'index', N'PhotoObjAll', N'field,run,rerun,camcol,type,mode,flags,rowc,colc,ra,dec,u,g,r,i,z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (167, N'I', N'index', N'PhotoObjAll', N'fieldID,objID,ra,dec,r,type,flags', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (168, N'I', N'index', N'PhotoObjAll', N'SpecObjID,cx,cy,cz,mode,type,flags,ra,dec,u,g,r,i,z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (169, N'I', N'index', N'PhotoObjAll', N'cx,cy,cz,htmID,mode,type,flags,ra,dec,u,g,r,i,z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (170, N'I', N'index', N'PhotoObjAll', N'run,mode,type,flags,u,g,r,i,z,Err_u,Err_g,Err_r,Err_i,Err_z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (171, N'I', N'index', N'PhotoObjAll', N'run,camcol,rerun,type,mode,flags,ra,dec,fieldID,field,u,g,r,i,z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (172, N'I', N'index', N'PhotoObjAll', N'run,camcol,field,mode,parentID,q_r,q_g,u_r,u_g,fiberMag_u,fiberMag_g,fiberMag_r,fiberMag_i,fiberMag_z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (173, N'I', N'index', N'PhotoObjAll', N'run,camcol,type,mode,cx,cy,cz', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (174, N'I', N'index', N'PhotoObjAll', N'ra,[dec],type,mode,flags,u,g,r,i,z,psfMag_u,psfMag_g,psfMag_r,psfMag_i,psfMag_z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (175, N'I', N'index', N'PhotoObjAll', N'b,l,type,mode,flags,u,g,r,i,z,psfMag_u,psfMag_g,psfMag_r,psfMag_i,psfMag_z', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (176, N'I', N'index', N'PhotoObjAll', N'phototag', N'', N'SCHEMA', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (177, N'I', N'index', N'PhotoObjAll', N'parentid,mode,type', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (178, N'I', N'index', N'PhotoObjDR7', N'dr7objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (179, N'I', N'index', N'thingIndex', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (180, N'I', N'index', N'detectionIndex', N'thingID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (181, N'I', N'index', N'TwoMass', N'ra', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (182, N'I', N'index', N'TwoMass', N'dec', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (183, N'I', N'index', N'TwoMass', N'j', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (184, N'I', N'index', N'TwoMass', N'h', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (185, N'I', N'index', N'TwoMass', N'k', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (186, N'I', N'index', N'TwoMass', N'ccflag', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (187, N'I', N'index', N'TwoMass', N'phqual', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (188, N'I', N'index', N'WISE_allsky', N'w1mpro', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (189, N'I', N'index', N'WISE_allsky', N'w2mpro', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (190, N'I', N'index', N'WISE_allsky', N'w3mpro', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (191, N'I', N'index', N'WISE_allsky', N'w4mpro', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (192, N'I', N'index', N'WISE_allsky', N'n_2mass', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (193, N'I', N'index', N'WISE_allsky', N'tmass_key', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (194, N'I', N'index', N'WISE_allsky', N'ra,dec', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (195, N'I', N'index', N'WISE_allsky', N'glat,glon', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (196, N'I', N'index', N'WISE_allsky', N'j_m_2mass', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (197, N'I', N'index', N'WISE_allsky', N'h_m_2mass', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (198, N'I', N'index', N'WISE_allsky', N'k_m_2mass', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (199, N'I', N'index', N'WISE_allsky', N'w1rsemi', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (200, N'I', N'index', N'WISE_allsky', N'blend_ext_flags', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (201, N'I', N'index', N'WISE_allsky', N'w1cc_map', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (202, N'I', N'index', N'WISE_allsky', N'w2cc_map', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (203, N'I', N'index', N'WISE_allsky', N'w3cc_map', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (204, N'I', N'index', N'WISE_allsky', N'w4cc_map', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (205, N'I', N'index', N'WISE_xmatch', N'wise_cntr', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (206, N'I', N'index', N'wiseForcedTarget', N'ra,dec,has_wise_phot,treated_as_pointsource', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (207, N'I', N'index', N'zooNoSpec', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (208, N'I', N'index', N'zooVotes', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (209, N'I', N'index', N'zooMirrorBias', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (210, N'I', N'index', N'zooMonochromeBias', N'objID', N'', N'PHOTO', N'PAGE', N'PHOTO')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (211, N'I', N'index', N'PlateX', N'htmID,ra,dec,cx,cy,cz', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (212, N'I', N'index', N'SpecObjAll', N'htmID,ra,dec,cx,cy,cz,sciencePrimary', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (213, N'I', N'index', N'SpecObjAll', N'BestObjID,sourceType,sciencePrimary,class,htmID,ra,dec,plate,mjd,fiberid,z,zErr', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (214, N'I', N'index', N'SpecObjAll', N'class,zWarning,z,sciencePrimary,plateId,bestObjID,targetObjId,htmID,ra,dec', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (215, N'I', N'index', N'SpecObjAll', N'targetObjID,sourceType,sciencePrimary,class,htmID,ra,dec', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (216, N'I', N'index', N'SpecObjAll', N'ra,[dec],class, plate, tile, z, zErr, sciencePrimary,plateID, bestObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (217, N'I', N'index', N'SpecObjAll', N'fluxObjID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (218, N'I', N'index', N'segueTargetAll', N'segue1_target1, segue2_target1', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (219, N'I', N'index', N'apogeeObject', N'apogee_id,j,h,k,j_err,h_err,k_err', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (220, N'I', N'index', N'apogeeVisit', N'apogee_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (221, N'I', N'index', N'apogeeVisit', N'plate,mjd,fiberid', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (222, N'I', N'index', N'apogeeStar', N'apogee_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (223, N'I', N'index', N'apogeeStar', N'htmID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (224, N'I', N'index', N'aspcapStar', N'apstar_id', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (225, N'I', N'index', N'zooSpec', N'objID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (226, N'I', N'index', N'zooConfidence', N'objID', N'', N'SPECTRO', N'page', N'SPEC')
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (227, N'I', N'unique index', N'sdssTileAll', N'tileRun,tile', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (228, N'I', N'index', N'sdssTileAll', N'htmID,racen,deccen,cx,cy,cz', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (229, N'I', N'index', N'sdssTiledTargetAll', N'htmID,ra,dec,cx,cy,cz', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (230, N'I', N'unique index', N'sdssTilingInfo', N'targetID,tileRun,collisionGroup', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (231, N'I', N'unique index', N'sdssTilingInfo', N'tileRun,tid,collisionGroup', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (232, N'I', N'index', N'sdssTilingInfo', N'tile,collisionGroup', N'', N'TILES', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (233, N'I', N'index', N'HalfSpace', N'regionID,convexID,x,y,z,c', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (234, N'I', N'index', N'RegionPatch', N'htmID,ra,dec,x,y,z,type', N'', N'REGION', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (235, N'I', N'index', N'WISE_allsky', N'rjce', N'', N'FINISH', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (236, N'I', N'index', N'SpecPhotoAll', N'objID,sciencePrimary,class,z,targetObjid', N'', N'FINISH', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (237, N'I', N'index', N'SpecPhotoAll', N'targetObjID,sciencePrimary,class,z,objid', N'', N'FINISH', NULL, NULL)
GO
INSERT [dbo].[IndexMap] ([indexmapid], [code], [type], [tableName], [fieldList], [foreignKey], [indexgroup], [compression], [filegroup]) VALUES (238, N'I', N'index', N'DataConstants', N'value', N'', N'META', NULL, NULL)
GO
