use BestDR19
go

drop table if exists occam_cluster
go
CREATE TABLE [dbo].[occam_cluster](
	[name] [varchar](20) NOT NULL,
	[glon] [float] NOT NULL,
	[glat] [float] NOT NULL,
	[radeg] [float] NOT NULL,
	[dedeg] [float] NOT NULL,
	[cg_rad] [float] NOT NULL,
	[cg_pmra] [float] NOT NULL,
	[cg_pmra_err] [float] NOT NULL,
	[cg_pmde] [float] NOT NULL,
	[cg_pmde_err] [float] NOT NULL,
	[v_rad] [float] NOT NULL,
	[v_rad_err] [float] NOT NULL,
	[cg_r_gc] [float] NOT NULL,
	[cg_distpc] [float] NOT NULL,
	[cg_logage] [float] NOT NULL,
	[r_guide] [float] NOT NULL,
	[z_height] [float] NOT NULL,
	[z_max] [float] NOT NULL,
	[azimuth_angle] [float] NOT NULL,
	[eccentricity] [float] NOT NULL,
	[z_period_avg] [float] NOT NULL,
	[radial_period_avg] [float] NOT NULL,
	[fe_h_aspcap] [float] NOT NULL,
	[c_h] [float] NOT NULL,
	[c_h_err] [float] NOT NULL,
	[n_h] [float] NOT NULL,
	[n_h_err] [float] NOT NULL,
	[o_h] [float] NOT NULL,
	[o_h_err] [float] NOT NULL,
	[na_h] [float] NOT NULL,
	[na_h_err] [float] NOT NULL,
	[mg_h] [float] NOT NULL,
	[mg_h_err] [float] NOT NULL,
	[al_h] [float] NOT NULL,
	[al_h_err] [float] NOT NULL,
	[si_h] [float] NOT NULL,
	[si_h_err] [float] NOT NULL,
	[p_h] [float] NOT NULL,
	[p_h_err] [float] NOT NULL,
	[s_h] [float] NOT NULL,
	[s_h_err] [float] NOT NULL,
	[k_h] [float] NOT NULL,
	[k_h_err] [float] NOT NULL,
	[ca_h] [float] NOT NULL,
	[ca_h_err] [float] NOT NULL,
	[ti_h] [float] NOT NULL,
	[ti_h_err] [float] NOT NULL,
	[v_h] [float] NOT NULL,
	[v_h_err] [float] NOT NULL,
	[cr_h] [float] NOT NULL,
	[cr_h_err] [float] NOT NULL,
	[mn_h] [float] NOT NULL,
	[mn_h_err] [float] NOT NULL,
	[fe_h] [float] NOT NULL,
	[fe_h_err] [float] NOT NULL,
	[co_h] [float] NOT NULL,
	[co_h_err] [float] NOT NULL,
	[ni_h] [float] NOT NULL,
	[ni_h_err] [float] NOT NULL,
	[cu_h] [float] NOT NULL,
	[cu_h_err] [float] NOT NULL,
	[ce_h] [float] NOT NULL,
	[ce_h_err] [float] NOT NULL,
	[nd_h] [float] NOT NULL,
	[nd_h_err] [float] NOT NULL,
	[num_stars_aspcap] [bigint] NOT NULL,
	[occam_qual] [bigint] NOT NULL,
	[eh_rad] [float] NOT NULL,
	[eh_pmra] [float] NOT NULL,
	[eh_pmra_err] [float] NOT NULL,
	[eh_pmde] [float] NOT NULL,
	[eh_pmde_err] [float] NOT NULL,
	[eh_r_gc] [float] NOT NULL,
	[eh_distpc] [float] NOT NULL,
	[eh_logage] [float] NOT NULL
) ON [PRIMARY]
GO



/****** Object:  Index [pk_occam_cluster_name]    Script Date: 6/26/2025 1:50:52 PM ******/
ALTER TABLE [dbo].[occam_cluster] ADD  CONSTRAINT [pk_occam_cluster_name] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SPEC]
GO

insert occam_cluster with (tablock)
select * from BESTTEST.dbo.occam_cluster


drop table if exists occam_member
go

CREATE TABLE [dbo].[occam_member](
	[cluster] [varchar](20) NOT NULL,
	[sdss_id] [bigint] NOT NULL,
	[gaiadr3_id] [bigint] NOT NULL,
	[gaiadr2_id] [bigint] NOT NULL,
	[obj_id] [varchar](40) NOT NULL,
	[glon] [real] NOT NULL,
	[glat] [real] NOT NULL,
	[radeg] [float] NOT NULL,
	[dedeg] [float] NOT NULL,
	[v_rad] [real] NOT NULL,
	[e_v_rad] [real] NOT NULL,
	[std_v_rad] [real] NOT NULL,
	[pmra] [real] NOT NULL,
	[e_pmra] [real] NOT NULL,
	[pmde] [real] NOT NULL,
	[e_pmde] [real] NOT NULL,
	[feh_aspcap] [float] NOT NULL,
	[e_feh_aspcap] [float] NOT NULL,
	[cg_prob] [float] NOT NULL,
	[rv_prob] [float] NOT NULL,
	[feh_prob_aspcap] [float] NOT NULL,
	[eh_prob] [float] NOT NULL,
	[xmatch] [tinyint] NOT NULL
) ON [PRIMARY]
GO


/****** Object:  Index [pk_occam_member_sdss_id]    Script Date: 6/26/2025 1:54:11 PM ******/
ALTER TABLE [dbo].[occam_member] ADD  CONSTRAINT [pk_occam_member_sdss_id] PRIMARY KEY CLUSTERED 
(
	[sdss_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [SPEC]
GO

insert occam_member with (tablock) 
select * from BESTTEST..occam_member


