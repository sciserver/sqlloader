-- gen_vac_pk.sql
-- Query IndexMap in BestDR20 for PK definitions of VAC tables,
-- then generate ALTER TABLE ... ADD CONSTRAINT pk_xxx PRIMARY KEY CLUSTERED statements.
-- Not all tables will be in IndexMap yet; this generates statements for those that are.
-- Run in BestDR20 context.

USE BestDR20;
GO

SELECT
    'ALTER TABLE [dbo].[' + tableName + ']'
    + ' ADD CONSTRAINT [pk_' + tableName + ']'
    + ' PRIMARY KEY CLUSTERED (' + fieldList + ')'
    + ' WITH (DATA_COMPRESSION = PAGE);'
    + CHAR(13) + 'GO'
    AS pk_statement
FROM dbo.IndexMap
WHERE code = 'K'
  AND tableName IN (
    -- spAll / spAll epoch
    'spall', 'spall_epoch', 'spall_allepoch',
    -- LVM
    'lvm_drpall', 'lvm_dapall',
    -- VAC 05 MWM Stellar Age
    'gyro_age_dwarf',
    -- VAC 18 MWM YSO
    'yso_ob_kin',
    -- VAC 20 MWM MDwarf
    'mdwarf_contin_summary',
    -- VAC 21 BOSS OCCAM
    'boss_occam_cluster', 'boss_occam_member',
    -- VAC 22 Minesweeper
    'minesweeper',
    -- VAC 24 Spiders AGN
    'efeds_spiders_agn_line_properties',
    'efeds_spiders_agn_host_decomposition',
    'efeds_spiders_agn_classification_props',
    'efeds_spiders_agn_fit_params',
    'efeds_spiders_agn_main_xray_catalogue',
    'efeds_spiders_agn_hard_xray_catalogue',
    'efeds_spiders_agn_xray_spectral_props',
    'efeds_spiders_agn_ctp_salvato2022',
    -- VAC 26 BHM QSO Properties
    'DR20Q_prop',
    -- VAC 27 MWM RGB
    'payne4GAIN_summary',
    -- VAC 28 MWM ISM
    'boss_ISM_NaI_absorption',
    -- VAC 29 MWM White Dwarf
    'da_dwd_candidates', 'da_dwd_rvs',
    -- VAC 30 BHM QSO Host
    'qms_hg_index_diagram', 'qms_hg_h_hb_indices',
    -- VAC 31 MWM White Dwarf (eROSITA CVs)
    'eROSITA_CVs',
    -- VAC 32 MWM Orbits
    'grav_pot_16',
    -- VAC 33 DL1 SDSS eROSITA
    'DL1_spec_SDSSV_eROSITA_eRASS3_allepoch',
    'DL1_spec_SDSSV_eROSITA_eRASS3_daily',
    -- VAC 34 BHM Blazar
    'fermi_blazar',
    -- VAC 35 MWM MDwarf active
    'mdwarf_active_params',
    -- VAC 36 BOSS CLAM
    'boss_clam_lite', 'boss_clam_params',
    -- VAC 37 BHM Visual Inspection
    'boss_vi_results',
    -- Astra tables (already in BestDR20 as heaps)
    'boss_net_boss_star', 'boss_net_boss_visit',
    'corv_boss_visit',
    'line_forest_boss_star', 'line_forest_boss_visit',
    'm_dwarf_type_boss_star', 'm_dwarf_type_boss_visit',
    'slam_boss_star', 'snow_white_boss_star',
    'mwm_boss_allstar', 'mwm_boss_allvisit'
  )
ORDER BY tableName;
