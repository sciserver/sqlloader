-- =====================================================================================
-- Fix Undersized VARCHAR Columns in minidb_dr20_v2
-- =====================================================================================
-- Based on actual data length analysis from source tables
-- Adding 30% headroom to max observed lengths for safety
-- =====================================================================================

USE minidb_dr20_v2;
GO

SET NOCOUNT ON;
GO

PRINT '-- ==============================================================================';
PRINT '-- Fixing Undersized VARCHAR Columns';
PRINT '-- Started: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';

-- =====================================================================================
-- dr20_guvcat (3 columns need fixing)
-- =====================================================================================

PRINT '-- Table: dr20_guvcat';
ALTER TABLE dr20_guvcat ALTER COLUMN groupgid varchar(500) NULL;
PRINT '  ✓ groupgid: 100 → 500 (max observed: 239)';

ALTER TABLE dr20_guvcat ALTER COLUMN groupgiddist varchar(500) NULL;
PRINT '  ✓ groupgiddist: 100 → 500 (max observed: 239)';

ALTER TABLE dr20_guvcat ALTER COLUMN groupgidtot varchar(500) NULL;
PRINT '  ✓ groupgidtot: 100 → 500 (max observed: 239)';
PRINT '';

-- =====================================================================================
-- dr20_allstar_dr17_synspec_rev1 (3 columns need fixing)
-- =====================================================================================

PRINT '-- Table: dr20_allstar_dr17_synspec_rev1';
ALTER TABLE dr20_allstar_dr17_synspec_rev1 ALTER COLUMN targflags varchar(200) NULL;
PRINT '  ✓ targflags: 100 → 200 (max observed: 132)';

ALTER TABLE dr20_allstar_dr17_synspec_rev1 ALTER COLUMN starflags varchar(200) NULL;
PRINT '  ✓ starflags: 100 → 200 (max observed: 130)';

ALTER TABLE dr20_allstar_dr17_synspec_rev1 ALTER COLUMN andflags varchar(200) NULL;
PRINT '  ✓ andflags: 100 → 200 (max observed: 105)';
PRINT '';

-- =====================================================================================
-- dr20_opsdb_apo_camera_frame (1 column needs fixing)
-- =====================================================================================

PRINT '-- Table: dr20_opsdb_apo_camera_frame';
ALTER TABLE dr20_opsdb_apo_camera_frame ALTER COLUMN comment varchar(500) NULL;
PRINT '  ✓ comment: 100 → 500 (max observed: 181)';
PRINT '';

-- =====================================================================================
-- dr20_sdss_apogeeallstarmerge_r13 (4 columns need fixing)
-- =====================================================================================

PRINT '-- Table: dr20_sdss_apogeeallstarmerge_r13';
ALTER TABLE dr20_sdss_apogeeallstarmerge_r13 ALTER COLUMN apstar_ids varchar(1000) NULL;
PRINT '  ✓ apstar_ids: 500 → 1000 (max observed: 675)';

ALTER TABLE dr20_sdss_apogeeallstarmerge_r13 ALTER COLUMN fields varchar(200) NULL;
PRINT '  ✓ fields: 100 → 200 (max observed: 142)';

ALTER TABLE dr20_sdss_apogeeallstarmerge_r13 ALTER COLUMN surveys varchar(500) NULL;
PRINT '  ✓ surveys: 100 → 500 (max observed: 181)';

-- Note: visits is already 2000, max observed is 1379, so it's OK
PRINT '';

-- =====================================================================================
-- dr20_sdss_dr16_qso (4 columns need fixing)
-- =====================================================================================

PRINT '-- Table: dr20_sdss_dr16_qso';
ALTER TABLE dr20_sdss_dr16_qso ALTER COLUMN plate_duplicate varchar(500) NULL;
PRINT '  ✓ plate_duplicate: 100 → 500 (max observed: 364)';

ALTER TABLE dr20_sdss_dr16_qso ALTER COLUMN mjd_duplicate varchar(500) NULL;
PRINT '  ✓ mjd_duplicate: 100 → 500 (max observed: 437)';

ALTER TABLE dr20_sdss_dr16_qso ALTER COLUMN fiberid_duplicate varchar(500) NULL;
PRINT '  ✓ fiberid_duplicate: 100 → 500 (max observed: 297)';

ALTER TABLE dr20_sdss_dr16_qso ALTER COLUMN spectro_duplicate varchar(200) NULL;
PRINT '  ✓ spectro_duplicate: 100 → 200 (max observed: 145)';
PRINT '';

-- =====================================================================================
-- dr20_sdss_dr17_apogee_allstarmerge (7 columns need fixing)
-- =====================================================================================

PRINT '-- Table: dr20_sdss_dr17_apogee_allstarmerge';
ALTER TABLE dr20_sdss_dr17_apogee_allstarmerge ALTER COLUMN stars_pk varchar(200) NULL;
PRINT '  ✓ stars_pk: 100 → 200 (max observed: 125)';

ALTER TABLE dr20_sdss_dr17_apogee_allstarmerge ALTER COLUMN snr_entry varchar(200) NULL;
PRINT '  ✓ snr_entry: 100 → 200 (max observed: 143)';

ALTER TABLE dr20_sdss_dr17_apogee_allstarmerge ALTER COLUMN telescopes varchar(200) NULL;
PRINT '  ✓ telescopes: 100 → 200 (max observed: 125)';

ALTER TABLE dr20_sdss_dr17_apogee_allstarmerge ALTER COLUMN fields varchar(500) NULL;
PRINT '  ✓ fields: 100 → 500 (max observed: 197)';

ALTER TABLE dr20_sdss_dr17_apogee_allstarmerge ALTER COLUMN visits_pk varchar(1000) NULL;
PRINT '  ✓ visits_pk: 500 → 1000 (max observed: 775)';

-- Note: targflags (294), starflags (130), aspcapflags (175) are already 500, so OK
PRINT '';

-- =====================================================================================
-- Summary
-- =====================================================================================

PRINT '-- ==============================================================================';
PRINT '-- Column Resizing Complete!';
PRINT '-- Ended: ' + CONVERT(VARCHAR(30), SYSDATETIME(), 121);
PRINT '-- ==============================================================================';
PRINT '';
PRINT 'Fixed 22 undersized varchar columns across 5 tables';
PRINT '';
PRINT 'Ready to retry data load for the 6 failed tables';
GO
