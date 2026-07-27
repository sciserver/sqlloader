-- Nonclustered indexes for allspec in BestDR20
-- Source: sdss5a.BestDR19.dbo.allspec
-- 2026-07-24 SW
-- Note: ix_allspec_htmid already exists (from run_htm_add.py, without cx/cy/cz INCLUDE)
-- TODO: add these to IndexMap (code='I')

CREATE NONCLUSTERED INDEX ix_allspec_apogee_id
    ON allspec (apogee_id)
    WITH (DATA_COMPRESSION = PAGE)
    ON [SPEC];
GO

CREATE NONCLUSTERED INDEX ix_allspec_apstar_id
    ON allspec (apstar_id)
    WITH (DATA_COMPRESSION = PAGE)
    ON [SPEC];
GO

CREATE NONCLUSTERED INDEX ix_allspec_mangaid
    ON allspec (mangaid)
    WITH (DATA_COMPRESSION = PAGE)
    ON [SPEC];
GO

CREATE NONCLUSTERED INDEX ix_allspec_sdssid
    ON allspec (sdss_id)
    WITH (DATA_COMPRESSION = PAGE)
    ON [SPEC];
GO

CREATE NONCLUSTERED INDEX ix_allspec_specobjid
    ON allspec (specobjid)
    WITH (DATA_COMPRESSION = PAGE)
    ON [SPEC];
GO

CREATE NONCLUSTERED INDEX ix_allspec_mjd_fiberid_plate
    ON allspec (mjd, fiberid, plate_or_fps_field)
    WITH (DATA_COMPRESSION = PAGE)
    ON [SPEC];
GO
