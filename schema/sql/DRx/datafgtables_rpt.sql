
(1 row(s) affected)
use DR14x;select * into apogeeObject from BestDR14.dbo.apogeeObject where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_apogeeObject_target_id] ON [dbo].[apogeeObject](target_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(87786145 row(s) affected)
use DR14x;insert apogeeObject with (tablock)select * from BestDR14.dbo.apogeeObject with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into apogeePlate from BestDR14.dbo.apogeePlate where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_apogeePlate_plate_visit_id] ON [dbo].[apogeePlate](plate_visit_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(4012 row(s) affected)
use DR14x;insert apogeePlate with (tablock)select * from BestDR14.dbo.apogeePlate with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into apogeeStar from BestDR14.dbo.apogeeStar where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_apogeeStar_apstar_id] ON [dbo].[apogeeStar](apstar_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(277371 row(s) affected)
use DR14x;insert apogeeStar with (tablock)select * from BestDR14.dbo.apogeeStar with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into apogeeStarAllVisit from BestDR14.dbo.apogeeStarAllVisit where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_apogeeStarAllVisit_visit_id_a] ON [dbo].[apogeeStarAllVisit](visit_id ASC, apstar_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(1191008 row(s) affected)
use DR14x;insert apogeeStarAllVisit with (tablock)select * from BestDR14.dbo.apogeeStarAllVisit with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into apogeeStarVisit from BestDR14.dbo.apogeeStarVisit where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_apogeeStarVisit_visit_id] ON [dbo].[apogeeStarVisit](visit_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(1026827 row(s) affected)
use DR14x;insert apogeeStarVisit with (tablock)select * from BestDR14.dbo.apogeeStarVisit with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into apogeeVisit from BestDR14.dbo.apogeeVisit where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_apogeeVisit_visit_id] ON [dbo].[apogeeVisit](visit_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(1054381 row(s) affected)
use DR14x;insert apogeeVisit with (tablock)select * from BestDR14.dbo.apogeeVisit with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into aspcapStar from BestDR14.dbo.aspcapStar where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_aspcapStar_aspcap_id] ON [dbo].[aspcapStar](aspcap_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(277371 row(s) affected)
use DR14x;insert aspcapStar with (tablock)select * from BestDR14.dbo.aspcapStar with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into aspcapStarCovar from BestDR14.dbo.aspcapStarCovar where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_aspcapStarCovar_aspcap_covar_] ON [dbo].[aspcapStarCovar](aspcap_covar_id ASC, aspcap_id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(13591179 row(s) affected)
use DR14x;insert aspcapStarCovar with (tablock)select * from BestDR14.dbo.aspcapStarCovar with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into cannonStar from BestDR14.dbo.cannonStar where 0=1

(0 row(s) affected)
use DR14x;

(277371 row(s) affected)
use DR14x;insert cannonStar with (tablock)select * from BestDR14.dbo.cannonStar with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into DataConstants from BestDR14.dbo.DataConstants where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_DataConstants_field_name] ON [dbo].[DataConstants](field ASC, name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(681 row(s) affected)
use DR14x;insert DataConstants with (tablock)select * from BestDR14.dbo.DataConstants with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into DBColumns from BestDR14.dbo.DBColumns where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_DBColumns_tableName_name] ON [dbo].[DBColumns](tablename ASC, name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(7665 row(s) affected)
use DR14x;insert DBColumns with (tablock)select * from BestDR14.dbo.DBColumns with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into DBObjects from BestDR14.dbo.DBObjects where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_DBObjects_name] ON [dbo].[DBObjects](name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(597 row(s) affected)
use DR14x;insert DBObjects with (tablock)select * from BestDR14.dbo.DBObjects with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into DBViewCols from BestDR14.dbo.DBViewCols where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_DBViewCols_viewName_name] ON [dbo].[DBViewCols](viewname ASC, name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(231 row(s) affected)
use DR14x;insert DBViewCols with (tablock)select * from BestDR14.dbo.DBViewCols with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into Dependency from BestDR14.dbo.Dependency where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_Dependency_parent_child] ON [dbo].[Dependency](parent ASC, child ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(403 row(s) affected)
use DR14x;insert Dependency with (tablock)select * from BestDR14.dbo.Dependency with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into Diagnostics from BestDR14.dbo.Diagnostics where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_Diagnostics_name] ON [dbo].[Diagnostics](name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(497 row(s) affected)
use DR14x;insert Diagnostics with (tablock)select * from BestDR14.dbo.Diagnostics with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into FileGroupMap from BestDR14.dbo.FileGroupMap where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_FileGroupMap_tableName] ON [dbo].[FileGroupMap](tableName ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(0 row(s) affected)
use DR14x;insert FileGroupMap with (tablock)select * from BestDR14.dbo.FileGroupMap with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into History from BestDR14.dbo.History where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_History_id] ON [dbo].[History](id ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];
Msg 8101, Level 16, State 1, Line 1
An explicit value for the identity column in table 'History' can only be specified when a column list is used and IDENTITY_INSERT is ON.
use DR14x;insert History with (tablock)select * from BestDR14.dbo.History with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into Inventory from BestDR14.dbo.Inventory where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_Inventory_filename_name] ON [dbo].[Inventory](filename ASC, name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(597 row(s) affected)
use DR14x;insert Inventory with (tablock)select * from BestDR14.dbo.Inventory with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into LoadHistory from BestDR14.dbo.LoadHistory where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_LoadHistory_loadVersion_tStar] ON [dbo].[LoadHistory](loadversion ASC, tstart ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(141 row(s) affected)
use DR14x;insert LoadHistory with (tablock)select * from BestDR14.dbo.LoadHistory with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into mangaDrpAll from BestDR14.dbo.mangaDrpAll where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_mangaDrpAll_plateIFU] ON [dbo].[mangaDrpAll](plateifu ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(4824 row(s) affected)
use DR14x;insert mangaDrpAll with (tablock)select * from BestDR14.dbo.mangaDrpAll with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into mangaFirefly from BestDR14.dbo.mangaFirefly where 0=1

(0 row(s) affected)
use DR14x;

(2777 row(s) affected)
use DR14x;insert mangaFirefly with (tablock)select * from BestDR14.dbo.mangaFirefly with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into mangaPipe3D from BestDR14.dbo.mangaPipe3D where 0=1

(0 row(s) affected)
use DR14x;

(2755 row(s) affected)
use DR14x;insert mangaPipe3D with (tablock)select * from BestDR14.dbo.mangaPipe3D with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into mangatarget from BestDR14.dbo.mangatarget where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_mangaTarget_mangaID] ON [dbo].[mangatarget](mangaID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(42561 row(s) affected)
use DR14x;insert mangatarget with (tablock)select * from BestDR14.dbo.mangatarget with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into marvelsStar from BestDR14.dbo.marvelsStar where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_marvelsStar_STARNAME_PLATE] ON [dbo].[marvelsStar](STARNAME ASC, Plate ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(11040 row(s) affected)
use DR14x;insert marvelsStar with (tablock)select * from BestDR14.dbo.marvelsStar with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into marvelsVelocityCurveUF1D from BestDR14.dbo.marvelsVelocityCurveUF1D where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_marvelsVelocityCurveUF1D_STAR] ON [dbo].[marvelsVelocityCurveUF1D](STARNAME ASC, BEAM ASC, RADECID ASC, FCJD ASC, LST-OBS ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];
Msg 102, Level 15, State 1, Line 1
Incorrect syntax near '-'.
Msg 319, Level 15, State 1, Line 1
Incorrect syntax near the keyword 'with'. If this statement is a common table expression, an xmlnamespaces clause or a change tracking context clause, the previous statement must be terminated with a semicolon.

(197040 row(s) affected)
use DR14x;insert marvelsVelocityCurveUF1D with (tablock)select * from BestDR14.dbo.marvelsVelocityCurveUF1D with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into nsatlas from BestDR14.dbo.nsatlas where 0=1

(0 row(s) affected)
use DR14x;

(641409 row(s) affected)
use DR14x;insert nsatlas with (tablock)select * from BestDR14.dbo.nsatlas with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into PartitionMap from BestDR14.dbo.PartitionMap where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_PartitionMap_fileGroupName] ON [dbo].[PartitionMap](fileGroupName ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(11 row(s) affected)
use DR14x;insert PartitionMap with (tablock)select * from BestDR14.dbo.PartitionMap with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into PlateX from BestDR14.dbo.PlateX where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_PlateX_plateID] ON [dbo].[PlateX](plateID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(5888 row(s) affected)
use DR14x;insert PlateX with (tablock)select * from BestDR14.dbo.PlateX with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into ProfileDefs from BestDR14.dbo.ProfileDefs where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_ProfileDefs_bin] ON [dbo].[ProfileDefs](bin ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(15 row(s) affected)
use DR14x;insert ProfileDefs with (tablock)select * from BestDR14.dbo.ProfileDefs with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into PubHistory from BestDR14.dbo.PubHistory where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_PubHistory_name_loadversion] ON [dbo].[PubHistory](name ASC, loadversion ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(755 row(s) affected)
use DR14x;insert PubHistory with (tablock)select * from BestDR14.dbo.PubHistory with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into qsoVarPTF from BestDR14.dbo.qsoVarPTF where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_qsoVarPTF_VAR_OBJID] ON [dbo].[qsoVarPTF](VAR_OBJID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(901366 row(s) affected)
use DR14x;insert qsoVarPTF with (tablock)select * from BestDR14.dbo.qsoVarPTF with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into qsoVarStripe from BestDR14.dbo.qsoVarStripe where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_qsoVarStripe_VAR_OBJID] ON [dbo].[qsoVarStripe](VAR_OBJID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(95115 row(s) affected)
use DR14x;insert qsoVarStripe with (tablock)select * from BestDR14.dbo.qsoVarStripe with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into QueryResults from BestDR14.dbo.QueryResults where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_QueryResults_query_time] ON [dbo].[QueryResults](query ASC, time ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(377 row(s) affected)
use DR14x;insert QueryResults with (tablock)select * from BestDR14.dbo.QueryResults with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into RecentQueries from BestDR14.dbo.RecentQueries where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_RecentQueries_ipAddr_lastQuer] ON [dbo].[RecentQueries](ipAddr ASC, lastQueryTime ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(4 row(s) affected)
use DR14x;insert RecentQueries with (tablock)select * from BestDR14.dbo.RecentQueries with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into RunShift from BestDR14.dbo.RunShift where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_RunShift_run] ON [dbo].[RunShift](run ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(9 row(s) affected)
use DR14x;insert RunShift with (tablock)select * from BestDR14.dbo.RunShift with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into SDSSConstants from BestDR14.dbo.SDSSConstants where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_SDSSConstants_name] ON [dbo].[SDSSConstants](name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(48 row(s) affected)
use DR14x;insert SDSSConstants with (tablock)select * from BestDR14.dbo.SDSSConstants with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into SiteConstants from BestDR14.dbo.SiteConstants where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_SiteConstants_name] ON [dbo].[SiteConstants](name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(11 row(s) affected)
use DR14x;insert SiteConstants with (tablock)select * from BestDR14.dbo.SiteConstants with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into SiteDiagnostics from BestDR14.dbo.SiteDiagnostics where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_SiteDiagnostics_name] ON [dbo].[SiteDiagnostics](name ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(497 row(s) affected)
use DR14x;insert SiteDiagnostics with (tablock)select * from BestDR14.dbo.SiteDiagnostics with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into SpecPhotoAll from BestDR14.dbo.SpecPhotoAll where 0=1

(0 row(s) affected)
use DR14x;

(4851200 row(s) affected)
use DR14x;insert SpecPhotoAll with (tablock)select * from BestDR14.dbo.SpecPhotoAll with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into Versions from BestDR14.dbo.Versions where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_Versions_version] ON [dbo].[Versions](version ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(35 row(s) affected)
use DR14x;insert Versions with (tablock)select * from BestDR14.dbo.Versions with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into zoo2MainSpecz from BestDR14.dbo.zoo2MainSpecz where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_zoo2MainSpecz_dr7objid] ON [dbo].[zoo2MainSpecz](dr7objid ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(243500 row(s) affected)
use DR14x;insert zoo2MainSpecz with (tablock)select * from BestDR14.dbo.zoo2MainSpecz with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into zoo2Stripe82Coadd1 from BestDR14.dbo.zoo2Stripe82Coadd1 where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_zoo2Stripe82Coadd1_stripe82ob] ON [dbo].[zoo2Stripe82Coadd1](stripe82objid ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(19765 row(s) affected)
use DR14x;insert zoo2Stripe82Coadd1 with (tablock)select * from BestDR14.dbo.zoo2Stripe82Coadd1 with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into zoo2Stripe82Coadd2 from BestDR14.dbo.zoo2Stripe82Coadd2 where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_zoo2Stripe82Coadd2_stripe82ob] ON [dbo].[zoo2Stripe82Coadd2](stripe82objid ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(19761 row(s) affected)
use DR14x;insert zoo2Stripe82Coadd2 with (tablock)select * from BestDR14.dbo.zoo2Stripe82Coadd2 with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into zoo2Stripe82Normal from BestDR14.dbo.zoo2Stripe82Normal where 0=1

(0 row(s) affected)
use DR14x;CREATE UNIQUE CLUSTERED INDEX [pk_zoo2Stripe82Normal_dr7objid] ON [dbo].[zoo2Stripe82Normal](dr7objid ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [DATAFG];

(17787 row(s) affected)
use DR14x;insert zoo2Stripe82Normal with (tablock)select * from BestDR14.dbo.zoo2Stripe82Normal with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into zooConfidence from BestDR14.dbo.zooConfidence where 0=1

(0 row(s) affected)
use DR14x;

(667944 row(s) affected)
use DR14x;insert zooConfidence with (tablock)select * from BestDR14.dbo.zooConfidence with (nolock)

(1 row(s) affected)

(1 row(s) affected)
use DR14x;select * into zooSpec from BestDR14.dbo.zooSpec where 0=1

(0 row(s) affected)
use DR14x;

(667944 row(s) affected)
use DR14x;insert zooSpec with (tablock)select * from BestDR14.dbo.zooSpec with (nolock)

(1 row(s) affected)
