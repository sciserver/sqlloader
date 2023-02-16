--=============================================================================
--   ApogeeTables.sql
--   2013-02-05 Mike Blanton & Ani Thakar
-------------------------------------------------------------------------------
--  APOGEE schema for SkyServer  Feb-05-2013
-------------------------------------------------------------------------------
-- History:
--* 2013-04-25 Ani: Added htmID to apogeeStar.
--* 2013-05-22 Ani: Updated schema with v302 changes, added 
--*            aspcapStarCovar table.  Copied additional tables from
--*            sas-sql but left them commented out for now.
--* 2013-05-22 Ani: Fixed errors and typos in schema - starflag included
--*            twice in apogeeVisit and missing comma at end of line.
--* 2013-05-22 Ani: Increased length of string columns in aspcapStar.
--* 2013-05-22 Ani: Bumped up all flags from smallint to int in aspcapStar.
--* 2013-05-22 Ani: Added htmID column to apogeeStar.
--* 2013-05-22 Ani: Added table descriptions to aspcapStarCovar and
--*            apogeePlate.
--* 2013-05-22 Ani: Updated PK for aspcapStarCovar (first 2 columns).
--* 2013-06-12 Ani: Added info links for APOGEE flags.
--* 2013-07-02 Ani: Swapped in v303 schema, left v302 commented for now.
--* 2013-07-02 Ani: Fixed typos in APOGEE schema.
--* 2013-07-03 Ani: Added apogeeDesign, apogeeField and apogeeObject tables.
--* 2013-07-09 Ani: Added apogeeStarVisit and apogeeStarAllVisit.
--* 2013-12-10 Ani: Removed deletion of apogeeDesign, apogeeField and 
--*            apogeeObject tables if they already exist.  The tables 
--*            are now created only if they don't already exist.
--* 2014-08-12 Ani: Updated schema for DR12.
--* 2014-08-12 Ani: Fixed typo in aspcapStar.
--* 2014-08-12 Ani: Changed plate column to varchar for apogeeVisit and
--*            apogeePlate..
--* 2014-08-13 Ani: Changed all varchar(50) columns to varchar(64), in
--*            particular this was needed for aspcap_covar_id.
--* 2014-09-03 Ani: Updated schema for v601.
--* 2014-09-05 Ani: Fixed typo in ApogeePlate short description.
--* 2014-11-06 Ani: Applied DR12 updates - removed apogeeObject.observed
--*            and updated descriptions for a few other columns.
--* 2014-11-06 Ani: Increased length of id strings in apogeeObject to 64.
--* 2014-11-13 Ani: Increased length of target_id everywhere to 64.
--* 2014-11-25 Ani: Incorporated schema changes for DR12 (new columns
--*            param_m_h_err and param_alpha_m_err in aspcapStar) and
--*            changed http bitmask help links to internal info links.
--* 2016-03-16 DR13 updates.
--* 2016-03-30 More DR13 updates - ce_* and felem_ce* columns removed..
--* 2016-05-13 Updated felem* column descriptions in aspcapStar as per Jen
--*            Sobeck.
--* 2017-04-11 Added the DR14 schema updates, including new table
--*            cannonStar.
--* 2017-04-19 Updated cannonStar schema from SVN, added default values for
--*            cannonStar.filename and field columns because the CSVs have
--*            NULL values.
--* 2017-05-06 Added columns to apogeeVisit and apogeeStar for DR14.
--* 2018-07-18 Removed conditional DROP TABLE from tables that do not
--*            get recreated with each release (apogeeDesign/Field/Object).
--* 2019-11-14 DR16 schema changes.
--* 2021-06-23 DR17 schema changes.
--* 2021-06-23 Fixed bug in ApogeeStar, put "file" column name in []. Also
--*            commented out cannonStar which is not reloaded in DR17.
--* 2021-07-28 Updated ApogeeVisit - added new "field" column (DR17).
--* 2023-02-16 Added cx, cy, cz to ApogeeStar
-------------------------------------------------------------------------------

SET NOCOUNT ON;
GO


--=============================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'apogeeVisit')
	DROP TABLE apogeeVisit
GO
--
EXEC spSetDefaultFileGroup 'apogeeVisit'
GO

CREATE TABLE apogeeVisit (
-------------------------------------------------------------------------------
--/H Contains data for a particular APOGEE spectrum visit.
--
--/T This table corresponds to the data in a single spectrum visit in APOGEE 
-------------------------------------------------------------------------------
    visit_id varchar(64) NOT NULL, --/D Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid (Primary key)
    apred_version varchar(32) NOT NULL, --/F NOFITS --/D Visit reduction pipeline version (e.g. "r3")
    apogee_id varchar(64) NOT NULL, --/D 2MASS-style star identification  
    target_id varchar(64) NOT NULL, --/D target ID (Foreign key, of form [location_id].[apogee_id])  
    alt_id varchar(64) NOT NULL, --/D alternate ID star identification, for apo1m, used within reductions
    [file] varchar(128) NOT NULL, --/D File base name with visit spectrum and catalog information
    fiberid bigint NOT NULL, --/D Fiber ID for this visit
    plate varchar(32) NOT NULL, --/D Plate of this visit
    mjd bigint NOT NULL, --/D MJD of this visit
    telescope varchar(32) NOT NULL, --/D Telescope where data was taken
    location_id bigint NOT NULL, --/D Location ID for the field this visit is in (Foreign key)
    field varchar(128) NOT NULL, --/D Name of field
    ra float NOT NULL, --/U deg --/D Right ascension, J2000
    dec float NOT NULL, --/U deg --/D Declination, J2000
    glon float NOT NULL, --/U deg --/D Galactic longitude
    glat float NOT NULL, --/U deg --/D Galactic latitude
    apogee_target1 bigint NOT NULL, --/D APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
    apogee_target2 bigint NOT NULL, --/D APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    apogee2_target1 bigint NOT NULL, --/D APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
    apogee2_target2 bigint NOT NULL, --/D APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    apogee2_target3 bigint NOT NULL, --/D APOGEE target flag (third 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    apogee2_target4 bigint NOT NULL, --/D APOGEE target flag (fourth 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    min_h real NOT NULL, --/D minimum H mag for cohort for main survey target
    max_h real NOT NULL, --/D maximum H mag for cohort for main survey target
    min_jk real NOT NULL, --/D minimum J-K mag for cohort for main survey target
    max_jk real NOT NULL, --/D maximum J-K mag for cohort for main survey target
    survey varchar(100) NOT NULL, --/D Name of survey (apogee/apogee2/apo1m)
    snr real NOT NULL, --/D Median signal-to-noise ratio per pixel
    starflag bigint NOT NULL, --/D Bit mask with APOGEE star flags (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
    dateobs varchar(100) NOT NULL, --/D Date of observation (YYYY-MM-DDTHH:MM:SS.SSS) 
    jd float NOT NULL, --/D Julian date of observation	
    bc real NOT NULL, --/U km/s --/D Barycentric correction (VHELIO - VREL)
    vrel real NOT NULL, --/U km/s --/D Derived radial velocity 
    vrelerr real NOT NULL, --/U km/s --/D Derived radial velocity error
    vhelio real NOT NULL, --/U km/s --/D Derived heliocentric radial velocity 
    chisq real NOT NULL, --/D Chi-squared of match to TV template
    rv_feh real NOT NULL, --/D [Fe/H] of radial velocity template
    rv_teff real NOT NULL, --/U K --/D Effective temperature of radial velocity template
    rv_logg real NOT NULL, --/U dex --/D Log gravity of radial velocity template
    rv_alpha real NOT NULL, --/D [alpha/M] alpha-element abundance
    rv_carb real NOT NULL, --/D [C/H] carbon abundance
    xcorr_vrel real NOT NULL, --/U km/s --/D Initial radial velocity for individual visit RV estimate
    xcorr_vrelerr real NOT NULL, --/U km/s --/D Error in initial radial velocity for individual visit RV estimate
    xcorr_vhelio real NOT NULL, --/U km/s --/D Initial heliocentric radial velocity for individual visit RV estimate
    rv_chi2 real NOT NULL, --/D Chi2 of RV fit
    ccfwhm real NOT NULL, --/D FWHM of RV cross correlation function
    autofwhm real NOT NULL, --/D FWHM of RV autocorrelation function
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'apogeeStar')
	DROP TABLE apogeeStar
GO
--
EXEC spSetDefaultFileGroup 'apogeeStar'
GO
CREATE TABLE apogeeStar (
-------------------------------------------------------------------------------
--/H Contains data for an APOGEE star combined spectrum.
--
--/T This table contains the data in the combined spectrum for an APOGEE star. 
-------------------------------------------------------------------------------
    apstar_id varchar(64) NOT NULL, --/D Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id (Primary key)
    target_id varchar(64) NOT NULL, --/D target ID (Foreign key, of form [location_id].[apogee_id]) 
    alt_id varchar(32) NOT NULL, --/D ID alternate star identification, for apo1m used within reductions
    [file] varchar(128) NOT NULL, --/D File base name with combined star spectrum 
    apogee_id varchar(32) NOT NULL, --/D 2MASS-style star identification  
    telescope varchar(32) NOT NULL, --/D Telescope where data was taken
    location_id bigint NOT NULL, --/D Location ID for the field this visit is in (Foreign key)
    field varchar(100) NOT NULL, --/D Name of field
    ra float NOT NULL, --/U deg --/D Right ascension, J2000
    dec float NOT NULL, --/U deg --/D Declination, J2000
    glon float NOT NULL, --/U deg --/D Galactic longitude
    glat float NOT NULL, --/U deg --/D Galactic latitude
    apogee_target1 bigint NOT NULL, --/D APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
    apogee_target2 bigint NOT NULL, --/D APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    apogee2_target1 bigint NOT NULL, --/D APOGEE target flag (first 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET1)
    apogee2_target2 bigint NOT NULL, --/D APOGEE target flag (second 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    apogee2_target3 bigint NOT NULL, --/D APOGEE target flag (third 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    apogee2_target4 bigint NOT NULL, --/D APOGEE target flag (fourth 64 bits) (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_TARGET2)
    min_h real NOT NULL, --/D minimum H mag for cohort for main survey target 
    max_h real NOT NULL, --/D maximum H mag for cohort for main survey target 
    min_jk real NOT NULL, --/D minimum J-K mag for cohort for main survey target 
    max_jk real NOT NULL, --/D maximum J-K mag for cohort for main survey target 
    survey varchar(100) NOT NULL, --/D Name of survey (apogee/apogee2/apo1m)
    extratarg bigint NOT NULL, --/D Shorthand flag to denote not a main survey object (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_EXTRATARG)
    nvisits bigint NOT NULL, --/D Number of visits contributing to the combined spectrum
    snr real NOT NULL, --/D Median signal-to-noise ratio per pixel
    starflag bigint NOT NULL, --/D Bit mask with APOGEE star flags; each bit is set here if it is set in any visit (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
    andflag bigint NOT NULL, --/D AND of visit bit mask with APOGEE star flags; each bit is set if set in all visits (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_STARFLAG)
    vhelio_avg real NOT NULL, --/U km/s --/D Signal-to-noise weighted average of heliocentric radial velocity, as determined relative to combined spectrum, with zeropoint from xcorr of combined spectrum with best-fitting template
    vscatter real NOT NULL, --/U km/s --/D Standard deviation of scatter of individual visit RVs around average
    verr real NOT NULL, --/U km/s --/D  Weighted error of heliocentric RV
    rv_teff real NOT NULL, --/U deg K --/D effective temperature from RV template match
    rv_logg real NOT NULL, --/U dex --/D log g from RV template match
    rv_feh real NOT NULL, --/U dex --/D [Fe/H] from RV template match
    rv_alpha real NOT NULL, --/D [alpha/M] alpha-element abundance
    rv_carb real NOT NULL, --/D [C/H] carbon abundance
    rv_ccfwhm real NOT NULL, --/U km/s --/D FWHM of cross-correlation peak from combined vs best-match synthetic spectrum
    rv_autofwhm real NOT NULL, --/U km/s --/D FWHM of auto-correlation of best-match synthetic spectrum
    rv_flag bigint NOT NULL, --/D Bitmask for RV determination
    n_components int NOT NULL, --/D Number of components from RV cross correlation
    gaiaedr3_source_id bigint NOT NULL, --/D GAIA EDR3 source id
    gaiaedr3_parallax real NOT NULL, --/U mas --/D GAIA EDR3 parallax
    gaiaedr3_parallax_error real NOT NULL, --/U mas --/D GAIA EDR3 parallax uncertainty
    gaiaedr3_pmra real NOT NULL, --/U mas/yr --/D GAIA EDR3 proper motion in RA
    gaiaedr3_pmra_error real NOT NULL, --/U mas/yr --/D GAIA EDR3 proper motion in RA uncertainty
    gaiaedr3_pmdec real NOT NULL, --/U mas/yr --/D GAIA EDR3 proper motion in DEC
    gaiaedr3_pmdec_error real NOT NULL, --/U mas/yr --/D GAIA EDR3 proper motion in DEC uncertainty
    gaiaedr3_phot_g_mean_mag real NOT NULL, --/D GAIA EDR3 g mean magnitude
    gaiaedr3_phot_bp_mean_mag real NOT NULL, --/D GAIA EDR3 Bp mean magnitude
    gaiaedr3_phot_rp_mean_mag real NOT NULL, --/D GAIA EDR3 Rp mean magnitude
    gaiaedr3_dr2_radial_velocity real NOT NULL, --/U km/s --/D GAIA EDR3 radial velocity
    gaiaedr3_dr2_radial_velocity_error real NOT NULL, --/U km/s --/D GAIA EDR3 radial velocity
    gaiaedr3_r_med_geo real NOT NULL, --/U pc --/D GAIA EDR3 Bailer Jones r_med_geo
    gaiaedr3_r_lo_geo real NOT NULL, --/U pc --/D GAIA EDR3 Bailer Jones r_lo_geo
    gaiaedr3_r_hi_geo real NOT NULL, --/U pc --/D GAIA EDR3 Bailer Jones r_hi_geo
    gaiaedr3_r_med_photogeo real NOT NULL, --/U pc --/D GAIA EDR3 Bailer Jones r_med_photogeo
    gaiaedr3_r_lo_photogeo real NOT NULL, --/U pc --/D GAIA EDR3 Bailer Jones r_lo_photogeo
    gaiaedr3_r_hi_photogeo real NOT NULL, --/U pc --/D GAIA EDR3 Bailer Jones r_hi_photogeo
    htmID bigint NOT NULL, --/F NOFITS --/D HTM ID 
	cx float, --/D unit vector for ra+dec 
	cy float, --/D unit vector for ra+dec 
	cz float  --/D unit vector for ra+dec 
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'apogeeStarVisit')
	DROP TABLE apogeeStarVisit
GO
--
EXEC spSetDefaultFileGroup 'apogeeStarVisit'
GO
CREATE TABLE apogeeStarVisit (
-------------------------------------------------------------------------------
--/H Links an APOGEE combined star spectrum with the visits used to create it. 
--
--/T This is a linking table that links an APOGEE combined star spectrum
--/T with the visits that were used to create the combined spectrum.
-------------------------------------------------------------------------------
    visit_id varchar(64) NOT NULL, --/D Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid 
    apstar_id varchar(64) NOT NULL --/D Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id 
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'apogeeStarAllVisit')
	DROP TABLE apogeeStarAllVisit
GO
--
EXEC spSetDefaultFileGroup 'apogeeStarAllVisit'
GO
CREATE TABLE apogeeStarAllVisit (
-------------------------------------------------------------------------------
--/H Links an APOGEE combined star spectrum with all visits for that star.
--
--/T This is a linking table that links an APOGEE combined star spectrum
--/T with all the visits for that star, including good, bad, commsssioning,
--/T not, etc.
-------------------------------------------------------------------------------
    visit_id varchar(64) NOT NULL, --/D Unique ID for visit spectrum, of form apogee.[telescope].[cs].[apred_version].plate.mjd.fiberid 
    apstar_id varchar(64) NOT NULL --/D Unique ID for combined star spectrum of form apogee.[telescope].[cs].apstar_version.location_id.apogee_id 
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'aspcapStar')
	DROP TABLE aspcapStar
GO
--
EXEC spSetDefaultFileGroup 'aspcapStar'
GO

CREATE TABLE aspcapStar (
-------------------------------------------------------------------------------
--/H Contains data for an APOGEE star ASPCAP entry.
--
--/T This table contains the data in the ASPCAP entry for an APOGEE star. 
-------------------------------------------------------------------------------
    apogee_id varchar(32) NOT NULL, --/D 2MASS-style star identification  
    target_id varchar(64) NOT NULL, --/D target ID (Foreign key, of form [location_id].[apogee_id]) 
    apstar_id varchar(72) NOT NULL, --/D Unique ID of combined star spectrum on which these results are based (Foreign key)
    aspcap_id varchar(72) NOT NULL, --/D Unique ID for ASPCAP results of form apogee.[telescope].[cs].results_version.location_id.star (Primary key)
    teff real NOT NULL,  --/U deg K --/D Empirically calibrated temperature from ASPCAP 
    teff_err real NOT NULL, --/U deg K  --/D external uncertainty estimate for calibrated temperature from ASPCAP
    teff_flag int NOT NULL, --/F paramflag 0 --/D PARAMFLAG for effective temperature(see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
    teff_spec real NOT NULL,  --/U deg K --/D Spectroscopic (uncalibrated) temperature from ASPCAP 
    logg real NOT NULL, --/U dex --/D empirically calibrated log gravity from ASPCAP
    logg_err real NOT NULL, --/U dex --/D external uncertainty estimate for log gravity from ASPCAP
    logg_flag int NOT NULL, --/F paramflag 1 --/D PARAMFLAG for log g(see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
    logg_spec real NOT NULL, --/U dex --/D spectroscopic (uncalibrated) log gravity from ASPCAP
    vmicro real NOT NULL, --/U km/s --/D microturbulent velocity (fit for dwarfs, f(log g) for giants)
    vmacro real NOT NULL, --/U km/s --/D macroturbulent velocity (f(log Teff,[M/H]) for giants)
    vsini real NOT NULL, --/U km/s --/D rotation+macroturbulent velocity (fit for dwarfs)
    m_h real NOT NULL, --/U dex --/D calibrated [M/H]
    m_h_err real NOT NULL, --/U dex --/D calibrated [M/H] uncertainty
    m_h_flag int NOT NULL, --/F paramflag 3 --/D PARAMFLAG for [M/H] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
    alpha_m real NOT NULL, --/U dex --/D calibrated [M/H]
    alpha_m_err real NOT NULL, --/U dex --/D calibrated [M/H] uncertainty
    alpha_m_flag int NOT NULL, --/F paramflag 6 --/D PARAMFLAG for [alpha/M] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
    aspcap_chi2 real NOT NULL, --/D chi^2 of ASPCAP fit
    aspcap_grid varchar(12) NOT NULL, --/D Temperature class of best-fitting spectrum
    aspcapflag bigint NOT NULL, --/D Bitmask flag relating results of ASPCAP (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ASPCAPFLAG)
    frac_badpix real NOT NULL, --/D fraction of bad pixels in spectrum
    frac_lowsnr real NOT NULL, --/D fraction of low S/N pixels in spectrum
    frac_sigsky real NOT NULL, --/D fraction of pixels with significant sky emission in spectrum
    fparam_teff real NOT NULL, --/U deg K --/F fparam 0 --/D original fit temperature
    fparam_logg real NOT NULL, --/U dex --/F fparam 1 --/D original fit log g from 6-parameter FERRE fit
    fparam_logvmicro real NOT NULL, --/F fparam 2 --/D log10 of the fit microturbulent velocity in km/s from 6-parameter FERRE fit 
    fparam_m_h real NOT NULL, --/U dex --/F fparam 3 --/D original fit [M/H] from 6-parameter FERRE fit
    fparam_c_m real NOT NULL, --/U dex --/F fparam 4 --/D original fit [C/H] from 6-parameter FERRE fit
    fparam_n_m real NOT NULL, --/U dex --/F fparam 5 --/D original fit [N/H] from 6-parameter FERRE fit
    fparam_alpha_m real NOT NULL, --/U dex --/F fparam 6 --/D original fit [alpha/M] from 6-parameter FERRE fit
    param_c_m real NOT NULL, --/F param 4 --/U dex --/D empirically calibrated [C/M] from ASPCAP
    param_c_m_flag int NOT NULL, --/F paramflag 4 --/D PARAMFLAG for [C/M] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
    param_n_m real NOT NULL, --/F param 5 --/U dex --/D empirically calibrated [N/M] from ASPCAP
    param_n_m_flag int NOT NULL, --/F paramflag 5 --/D PARAMFLAG for [N/M] (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
    c_fe real NOT NULL, --/U dex --/D empirically calibrated [C/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals 
    c_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [C/Fe] from ASPCAP 
    c_fe_flag int NOT NULL, --/F elemflag 0 --/D ELEMFLAG for C (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    ci_fe real NOT NULL, --/U dex --/D empirically calibrated [CI/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals 
    ci_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [CI/Fe] from ASPCAP 
    ci_fe_flag int NOT NULL, --/F elemflag 1 --/D ELEMFLAG for CI (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    n_fe real NOT NULL, --/U dex --/D empirically calibrated [N/Fe] from ASPCAP; [N/Fe] is calculated as (ASPCAP [N/M])+param_metals 
    n_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [N/Fe] from ASPCAP 
    n_fe_flag int NOT NULL, --/F elemflag 2 --/D ELEMFLAG for N (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    o_fe real NOT NULL, --/U dex --/D empirically calibrated [O/Fe] from ASPCAP; [O/Fe] is calculated as (ASPCAP [O/M])+param_metals 
    o_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [O/Fe] from ASPCAP 
    o_fe_flag int NOT NULL, --/F elemflag 3 --/D ELEMFLAG for O (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    na_fe real NOT NULL, --/U dex --/D empirically calibrated [Na/Fe] from ASPCAP 
    na_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Na/Fe] from ASPCAP 
    na_fe_flag int NOT NULL, --/F elemflag 4 --/D ELEMFLAG for Na (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    mg_fe real NOT NULL, --/U dex --/D empirically calibrated [Mg/Fe] from ASPCAP; [Mg/Fe] is calculated as (ASPCAP [Mg/M])+param_metals  
    mg_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Mg/Fe] from ASPCAP 
    mg_fe_flag int NOT NULL, --/F elemflag 5 --/D ELEMFLAG for Mg (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    al_fe real NOT NULL, --/U dex --/D empirically calibrated [Al/Fe] from ASPCAP 
    al_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Al/Fe] from ASPCAP 
    al_fe_flag int NOT NULL, --/F elemflag 6 --/D ELEMFLAG for Al (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    si_fe real NOT NULL, --/U dex --/D empirically calibrated [Si/Fe] from ASPCAP; [Si/Fe] is calculated as (ASPCAP [Si/M])+param_metals  
    si_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Si/Fe] from ASPCAP 
    si_fe_flag int NOT NULL, --/F elemflag 7 --/D ELEMFLAG for Si (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    p_fe real NOT NULL, --/U dex --/D empirically calibrated [P/Fe] from ASPCAP; [P/Fe] is calculated as (ASPCAP [P/M])+param_metals  
    p_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [P/Fe] from ASPCAP 
    p_fe_flag int NOT NULL, --/F elemflag 8 --/D ELEMFLAG for Si (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    s_fe real NOT NULL, --/U dex --/D empirically calibrated [S/Fe] from ASPCAP; [S/Fe] is calculated as (ASPCAP [S/M])+param_metals 
    s_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [S/Fe] from ASPCAP 
    s_fe_flag int NOT NULL, --/F elemflag 9 --/D ELEMFLAG for S (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    k_fe real NOT NULL, --/U dex --/D empirically calibrated [K/Fe] from ASPCAP 
    k_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [K/Fe] from ASPCAP 
    k_fe_flag int NOT NULL, --/F elemflag 10 --/D ELEMFLAG for K (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    ca_fe real NOT NULL, --/U dex --/D empirically calibrated [Ca/Fe] from ASPCAP ; [Ca/Fe] is calculated as (ASPCAP [Ca/M])+param_metals 
    ca_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Ca/Fe] from ASPCAP 
    ca_fe_flag int NOT NULL, --/F elemflag 11 --/D ELEMFLAG for Ca (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    ti_fe real NOT NULL, --/U dex --/D empirically calibrated [Ti/Fe] from ASPCAP; [Ti/Fe] is calculated as (ASPCAP [Ti/M])+param_metals  
    ti_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Ti/Fe] from ASPCAP 
    ti_fe_flag int NOT NULL, --/F elemflag 12 --/D ELEMFLAG for Ti (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    tiii_fe real NOT NULL, --/U dex --/D empirically calibrated [TiII/Fe] from ASPCAP; [TiII/Fe] is calculated as (ASPCAP [TiII/M])+param_metals  
    tiii_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [TiII/Fe] from ASPCAP 
    tiii_fe_flag int NOT NULL, --/F elemflag 13 --/D ELEMFLAG for TiII (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    v_fe real NOT NULL, --/U dex --/D empirically calibrated [V/Fe] from ASPCAP 
    v_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [V/Fe] from ASPCAP 
    v_fe_flag int NOT NULL, --/F elemflag 14 --/D ELEMFLAG for V (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    cr_fe real NOT NULL, --/U dex --/D empirically calibrated [Cr/Fe] from ASPCAP 
    cr_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Cr/Fe] from ASPCAP 
    cr_fe_flag int NOT NULL, --/F elemflag 15 --/D ELEMFLAG for Cr (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    mn_fe real NOT NULL, --/U dex --/D empirically calibrated [Mn/Fe] from ASPCAP 
    mn_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Mn/Fe] from ASPCAP 
    mn_fe_flag int NOT NULL, --/F elemflag 16 --/D ELEMFLAG for Mn (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    fe_h real NOT NULL, --/U dex --/D empirically calibrated [Fe/H] from ASPCAP 
    fe_h_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Fe/H] from ASPCAP 
    fe_h_flag int NOT NULL, --/F elemflag 17 --/D ELEMFLAG for Fe (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    co_fe real NOT NULL, --/U dex --/D empirically calibrated [Co/Fe] from ASPCAP 
    co_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Co/Fe] from ASPCAP 
    co_fe_flag int NOT NULL, --/F elemflag 18 --/D ELEMFLAG for Co (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    ni_fe real NOT NULL, --/U dex --/D empirically calibrated [Ni/Fe] from ASPCAP 
    ni_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Ni/Fe] from ASPCAP 
    ni_fe_flag int NOT NULL, --/F elemflag 19 --/D ELEMFLAG for Ni (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    cu_fe real NOT NULL, --/U dex --/D empirically calibrated [Cu/Fe] from ASPCAP 
    cu_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Cu/Fe] from ASPCAP 
    cu_fe_flag int NOT NULL, --/F elemflag 20 --/D ELEMFLAG for Cu (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    ce_fe real NOT NULL, --/U dex --/D empirically calibrated [Ce/Fe] from ASPCAP 
    ce_fe_err real NOT NULL, --/U dex --/D external uncertainty for empirically calibrated [Ce/Fe] from ASPCAP 
    ce_fe_flag int NOT NULL, --/F elemflag 24 --/D ELEMFLAG for Ce (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
    felem_c_m real NOT NULL, --/U dex --/F felem 0 --/D original fit [C/M]
    felem_c_m_err real NOT NULL, --/U dex --/F felem_err 0 --/D original fit uncertainty [C/M]
    felem_ci_m real NOT NULL, --/U dex --/F felem 1 --/D original fit [CI/M]
    felem_ci_m_err real NOT NULL, --/U dex --/F felem_err 1 --/D original fit uncertainty [CI/M]
    felem_n_m real NOT NULL, --/U dex --/F felem 2 --/D original fit [N/M]
    felem_n_m_err real NOT NULL, --/U dex --/F felem_err 2 --/D original fit uncertainty [N/M]
    felem_o_m real NOT NULL, --/U dex --/F felem 3 --/D original fit [O/M]
    felem_o_m_err real NOT NULL, --/U dex --/F felem_err 3 --/D original fit uncertainty [O/M]
    felem_na_h real NOT NULL, --/U dex --/F felem 4 --/D original fit [Na/H]
    felem_na_h_err real NOT NULL, --/U dex --/F felem_err 4 --/D original fit uncertainty [Na/H]
    felem_mg_m real NOT NULL, --/U dex --/F felem 5 --/D original fit [Mg/M]
    felem_mg_m_err real NOT NULL, --/U dex --/F felem_err 5 --/D original fit uncertainty [Mg/M]
    felem_al_h real NOT NULL, --/U deg K --/F felem 6 --/D original fit [Al/H]
    felem_al_h_err real NOT NULL, --/U deg K --/F felem_err 6 --/D original fit uncertainty [Al/H]
    felem_si_m real NOT NULL, --/U dex --/F felem 7 --/D original fit [Si/M]
    felem_si_m_err real NOT NULL, --/U dex --/F felem_err 7 --/D original fit uncertainty [Si/M]
    felem_p_m real NOT NULL, --/U dex --/F felem 8 --/D original fit [P/M]
    felem_p_m_err real NOT NULL, --/U dex --/F felem_err 8 --/D original fit uncertainty [P/M]
    felem_s_m real NOT NULL, --/U dex --/F felem 9 --/D original fit [S/M]
    felem_s_m_err real NOT NULL, --/U dex --/F felem_err 9 --/D original fit uncertainty [S/M]
    felem_k_h real NOT NULL, --/U dex --/F felem 10 --/D original fit [K/H]
    felem_k_h_err real NOT NULL, --/U dex --/F felem_err 10 --/D original fit uncertainty [K/H]
    felem_ca_m real NOT NULL, --/U dex --/F felem 11 --/D original fit [Ca/M]
    felem_ca_m_err real NOT NULL, --/U dex --/F felem_err 11 --/D original fit uncertainty [Ca/M]
    felem_ti_m real NOT NULL, --/U dex --/F felem 12 --/D original fit [Ti/M]
    felem_ti_m_err real NOT NULL, --/U dex --/F felem_err 12 --/D original fit uncertainty [Ti/M]
    felem_tiii_m real NOT NULL, --/U dex --/F felem 13 --/D original fit [TiII/M]
    felem_tiii_m_err real NOT NULL, --/U dex --/F felem_err 13 --/D original fit uncertainty [TiII/M]
    felem_v_h real NOT NULL, --/U dex --/F felem 14 --/D original fit [V/H]
    felem_v_h_err real NOT NULL, --/U dex --/F felem_err 14 --/D original fit uncertainty [V/H]
    felem_cr_h real NOT NULL, --/U dex --/F felem 15 --/D original fit [Cr/H]
    felem_cr_h_err real NOT NULL, --/U dex --/F felem_err 15 --/D original fit uncertainty [Cr/H]
    felem_mn_h real NOT NULL, --/U dex --/F felem 16 --/D original fit [Mn/H]
    felem_mn_h_err real NOT NULL, --/U dex --/F felem_err 16 --/D original fit uncertainty [Mn/H]
    felem_fe_h real NOT NULL, --/U dex --/F felem 17 --/D original fit [Fe/H]
    felem_fe_h_err real NOT NULL, --/U dex --/F felem_err 17 --/D original fit uncertainty [Fe/H]
    felem_co_h real NOT NULL, --/U dex --/F felem 18 --/D original fit [Co/H]
    felem_co_h_err real NOT NULL, --/U dex --/F felem_err 18 --/D original fit uncertainty [Co/H]
    felem_ni_h real NOT NULL, --/U dex --/F felem 19 --/D original fit [Ni/H]
    felem_ni_h_err real NOT NULL, --/U dex --/F felem_err 19 --/D original fit uncertainty [Ni/H]
    felem_cu_h real NOT NULL, --/U dex --/F felem 20 --/D original fit [Cu/H]
    felem_cu_h_err real NOT NULL, --/U dex --/F felem_err 20 --/D original fit uncertainty [Cu/H]
    felem_ge_h real NOT NULL, --/U dex --/F felem 21 --/D original fit [Ge/H]
    felem_ge_h_err real NOT NULL, --/U dex --/F felem_err 21 --/D original fit uncertainty [Ge/H]
    felem_rb_h real NOT NULL, --/U dex --/F felem 23 --/D original fit [Rb/H]
    felem_rb_h_err real NOT NULL, --/U dex --/F felem_err 23 --/D original fit uncertainty [Rb/H]
    felem_ce_h real NOT NULL, --/U dex --/F felem 24 --/D original fit [Ce/H]
    felem_ce_h_err real NOT NULL, --/U dex --/F felem_err 24 --/D original fit uncertainty [Ce/H]
    felem_nd_h real NOT NULL, --/U dex --/F felem 25 --/D original fit [Nd/H]
    felem_nd_h_err real NOT NULL, --/U dex --/F felem_err 25 --/D original fit uncertainty [Nd/H]
    felem_yb_h real NOT NULL, --/U dex --/F felem 24 --/D original fit [Yb/H]
    felem_yb_h_err real NOT NULL, --/U dex --/F felem_err 24 --/D original fit uncertainty [Yb/H]
)
GO



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'aspcapStarCovar')
	DROP TABLE aspcapStarCovar
GO
--
EXEC spSetDefaultFileGroup 'aspcapStarCovar'
GO
CREATE TABLE aspcapStarCovar (
-------------------------------------------------------------------------------
--/H Contains the covariance information for an APOGEE star ASPCAP entry.
--
--/T This table contains selected covariance matrix fields for the ASPCAP 
--/T entry for an APOGEE star. 
-------------------------------------------------------------------------------
	aspcap_covar_id varchar(64) NOT NULL, --/D Unique ID for this covariance matrix element of form apogee.[telescope].[cs].results_version.location_id.star.param_1.param_2 (Primary key)
	aspcap_id varchar(64) NOT NULL, --/D Unique ID for ASPCAP results of form apogee.[telescope].[cs].results_version.location_id.star 
   	param_1 tinyint NOT NULL, --/D Parameter #1 in covariance (0..6, corresponding to Teff, log(g), log(vmicro), [M/H], [C/M], [N/M], [alpha/M])
   	param_2 tinyint NOT NULL, --/D Parameter #2 in covariance (0..6, corresponding to Teff, log(g), log(vmicro), [M/H], [C/M], [N/M], [alpha/M])
	covar real NOT NULL, --/D Covariance between two parameters for this star (external estimate) --/F param_cov
	fit_covar real NOT NULL --/D Covariance between two parameters for this star (internal estimate for original fit values) --/F fparam_cov
)
GO



-- DR17 no cannonStar reload

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'cannonStar')
	DROP TABLE cannonStar
GO
--
EXEC spSetDefaultFileGroup 'cannonStar'
GO
CREATE TABLE cannonStar (
-------------------------------------------------------------------------------
--/H Contains the stellar parameters obtained from the Cannon.
--
--/T The Cannon (named by David Hogg, after Annie Jump Cannon) is a 
--/T data-driven approach to determining stellar parameters. This table 
--/T contains the parameters resulting froom applying that method. More
--/T information can be found at https://arxiv.org/abs/1501.07604.
-------------------------------------------------------------------------------
    apogee_id varchar(32) NOT NULL, --/D 2MASS-style star identification
    cannon_id varchar(64) NOT NULL, --/D Unique ID for Cannon results of form apogee.[telescope].[cs].results_version.location_id.star (Primary key)
    filename varchar(128) NOT NULL DEFAULT(''), --/D Cannon file used 
    location_id bigint NOT NULL, --/D Location ID for the field this visit is in (Foreign key)
    field varchar(128) NOT NULL DEFAULT(''), --/D Name of field
    teff real NOT NULL,  --/U deg K --/D effective temperature from Cannon analysis
    logg real NOT NULL,  --/U dex --/D surface gravity from Cannon analysis
    m_h real NOT NULL,  --/U dex --/D [M/H] from Cannon analysis
    alpha_m real NOT NULL,  --/U dex --/D [alpha/H] from Cannon analysis
    fe_h real NOT NULL,  --/U dex --/D [Fe/H] from Cannon analysis
    c_h real NOT NULL,  --/U dex --/D [C/H] from Cannon analysis
    ci_h real NOT NULL,  --/U dex --/D [CI/H] from Cannon analysis
    n_h real NOT NULL,  --/U dex --/D [N/H] from Cannon analysis
    o_h real NOT NULL,  --/U dex --/D [O/H] from Cannon analysis
    na_h real NOT NULL,  --/U dex --/D [Na/H] from Cannon analysis
    mg_h real NOT NULL,  --/U dex --/D [Mg/H] from Cannon analysis
    al_h real NOT NULL,  --/U dex --/D [Al/H] from Cannon analysis
    si_h real NOT NULL,  --/U dex --/D [Si/H] from Cannon analysis
    p_h real NOT NULL,  --/U dex --/D [P/H] from Cannon analysis
    s_h real NOT NULL,  --/U dex --/D [S/H] from Cannon analysis
    k_h real NOT NULL,  --/U dex --/D [K/H] from Cannon analysis
    ca_h real NOT NULL,  --/U dex --/D [Ca/H] from Cannon analysis
    ti_h real NOT NULL,  --/U dex --/D [Ti/H] from Cannon analysis
    tiii_h real NOT NULL,  --/U dex --/D [TiII/H] from Cannon analysis
    v_h real NOT NULL,  --/U dex --/D [V/H] from Cannon analysis
    cr_h real NOT NULL,  --/U dex --/D [Cr/H] from Cannon analysis
    mn_h real NOT NULL,  --/U dex --/D [Mn/H] from Cannon analysis
    co_h real NOT NULL,  --/U dex --/D [Co/H] from Cannon analysis
    ni_h real NOT NULL,  --/U dex --/D [Ni/H] from Cannon analysis
    teff_rawerr real NOT NULL,  --/U deg K --/D raw uncertainty in effective temperature from Cannon analysis
    logg_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in surface gravity from Cannon analysis
    m_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [M/H] from Cannon analysis
    alpha_m_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [alpha/H] from Cannon analysis
    fe_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Fe/H] from Cannon analysis
    c_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [C/H] from Cannon analysis
    ci_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [CI/H] from Cannon analysis
    n_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [N/H] from Cannon analysis
    o_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [O/H] from Cannon analysis
    na_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Na/H] from Cannon analysis
    mg_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Mg/H] from Cannon analysis
    al_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Al/H] from Cannon analysis
    si_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Si/H] from Cannon analysis
    p_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [P/H] from Cannon analysis
    s_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [S/H] from Cannon analysis
    k_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [K/H] from Cannon analysis
    ca_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Ca/H] from Cannon analysis
    ti_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Ti/H] from Cannon analysis
    tiii_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [TiII/H] from Cannon analysis
    v_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [V/H] from Cannon analysis
    cr_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Cr/H] from Cannon analysis
    mn_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Mn/H] from Cannon analysis
    co_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Co/H] from Cannon analysis
    ni_h_rawerr real NOT NULL,  --/U dex --/D raw uncertainty in [Ni/H] from Cannon analysis
    teff_err real NOT NULL,  --/U deg K --/D uncertainty in effective temperature from Cannon analysis
    logg_err real NOT NULL,  --/U dex --/D uncertainty in surface gravity from Cannon analysis
    m_h_err real NOT NULL,  --/U dex --/D uncertainty in [M/H] from Cannon analysis
    alpha_m_err real NOT NULL,  --/U dex --/D uncertainty in [alpha/H] from Cannon analysis
    fe_h_err real NOT NULL,  --/U dex --/D uncertainty in [Fe/H] from Cannon analysis
    c_h_err real NOT NULL,  --/U dex --/D uncertainty in [C/H] from Cannon analysis
    ci_h_err real NOT NULL,  --/U dex --/D uncertainty in [CI/H] from Cannon analysis
    n_h_err real NOT NULL,  --/U dex --/D uncertainty in [N/H] from Cannon analysis
    o_h_err real NOT NULL,  --/U dex --/D uncertainty in [O/H] from Cannon analysis
    na_h_err real NOT NULL,  --/U dex --/D uncertainty in [Na/H] from Cannon analysis
    mg_h_err real NOT NULL,  --/U dex --/D uncertainty in [Mg/H] from Cannon analysis
    al_h_err real NOT NULL,  --/U dex --/D uncertainty in [Al/H] from Cannon analysis
    si_h_err real NOT NULL,  --/U dex --/D uncertainty in [Si/H] from Cannon analysis
    p_h_err real NOT NULL,  --/U dex --/D uncertainty in [P/H] from Cannon analysis
    s_h_err real NOT NULL,  --/U dex --/D uncertainty in [S/H] from Cannon analysis
    k_h_err real NOT NULL,  --/U dex --/D uncertainty in [K/H] from Cannon analysis
    ca_h_err real NOT NULL,  --/U dex --/D uncertainty in [Ca/H] from Cannon analysis
    ti_h_err real NOT NULL,  --/U dex --/D uncertainty in [Ti/H] from Cannon analysis
    tiii_h_err real NOT NULL,  --/U dex --/D uncertainty in [TiII/H] from Cannon analysis
    v_h_err real NOT NULL,  --/U dex --/D uncertainty in [V/H] from Cannon analysis
    cr_h_err real NOT NULL,  --/U dex --/D uncertainty in [Cr/H] from Cannon analysis
    mn_h_err real NOT NULL,  --/U dex --/D uncertainty in [Mn/H] from Cannon analysis
    co_h_err real NOT NULL,  --/U dex --/D uncertainty in [Co/H] from Cannon analysis
    ni_h_err real NOT NULL,  --/U dex --/D uncertainty in [Ni/H] from Cannon analysis
    chi_sq real NOT NULL, --/D chi^2 from Cannon analysis
    r_chi_sq real NOT NULL, --/D reduced chi^2 from Cannon analysis
)
GO

-- DR17 no cannonStar reload



--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'apogeePlate')
	DROP TABLE apogeePlate
GO
--
EXEC spSetDefaultFileGroup 'apogeePlate'
GO
CREATE TABLE apogeePlate (
-------------------------------------------------------------------------------
--/H Contains all the information associated with an APOGEE plate.
--
--/T This table contains the parameters for an APOGEE spectral plate
-------------------------------------------------------------------------------
    plate_visit_id varchar(64) NOT NULL, --/D Unique ID for plate visit, of form apogee.[telescope].[cs].plate.mjd (Primary key)
    location_id bigint NOT NULL, --/D Location ID (Foreign key) 
    plate varchar(32) NOT NULL, --/D Plate of this visit
    mjd bigint NOT NULL, --/D MJD of this visit
    apred_version varchar(32) NOT NULL, --/D Visit reduction pipeline version --/F NOFITS
    name varchar(50) NOT NULL, --/D Name of location that this plate belongs to
    racen float NOT NULL, --/U deg --/D Right ascension, J2000, of plate center
    deccen float NOT NULL, --/U deg --/D Declination, J2000, of plate center
    radius real NOT NULL,  --/U deg --/D Utilized radius of plate
    shared tinyint NOT NULL, --/D If set to 1, a plate shared with another survey (0 if not)
    field_type tinyint NOT NULL,  --/D Type of field
    survey varchar(50) NOT NULL, --/D Survey name 
    programname varchar(50) NOT NULL, --/D Program name within survey
    platerun varchar(50) NOT NULL,  --/D Plate run in which plate was drilled 
    designid bigint NOT NULL, --/D Design ID associated with plate  (Foreign key)
    nStandard bigint NOT NULL, --/D Number of standard stars on plate
    nScience bigint NOT NULL, --/D Number of science stars on plate
    nSky bigint NOT NULL, --/D Number of sky fibers on plate
    platedesign_version varchar(10) NOT NULL,  --/D Version of platedesign used to create plate design
)
GO

-- The remaining tables do not get recreated each time, so comment out the
-- following block of 3 statements when they are not to be recreated.

-- /* start of commented block 

--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'apogeeDesign')
	DROP TABLE apogeeDesign
GO
--
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'apogeeObject')
	DROP TABLE apogeeObject
GO
--
--=============================================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'apogeeField')
	DROP TABLE apogeeField
GO
--

-- end of commented block */



EXEC spSetDefaultFileGroup 'apogeeDesign'
GO
CREATE TABLE apogeeDesign (
-------------------------------------------------------------------------------
--/H Contains the plate design information for APOGEE plates.
--
--/T This table contains all the design parameters used in designing plates
--/T for APOGEE spectra.
-------------------------------------------------------------------------------
    designid varchar(64) NOT NULL, --/F design_id --/D Design ID from plate design (Primary key)
    location_id bigint NOT NULL, --/D Location ID (Foreign key) 
    ra float NOT NULL, --/U deg --/D Right ascension, J2000, of plate center
    dec float NOT NULL, --/U deg --/D Declination, J2000, of plate center
    field_name varchar(128) NOT NULL, --/D Name of field
    design_type varchar(128) NOT NULL, --/D Type of design
    design_driver varchar(128) NOT NULL, --/D Driver for design
    radius real NOT NULL,  --/U deg --/D Utilized radius of plate
    shared tinyint NOT NULL, --/D If set to 1, a plate shared with another survey (0 if not)
    comments varchar(200) NOT NULL, --/D Additional comments on design
    number_of_visits  [int] NOT NULL, --/D Total number of visits intended for this design
    number_of_tellurics  [int] NOT NULL, --/D Number of hot star tellurics on this design (tellurics/science targets may overlap)
    number_of_sky  [int] NOT NULL, --/D Number of sky targets on this design 
    number_of_science  [int] NOT NULL, --/D Number of science targets on this design (tellurics/science targets may overlap)
    cohort_short_version [int] NOT NULL, --/D Which of this field's short cohorts is in this design
    cohort_medium_version [int] NOT NULL, --/D Which of this field's medium cohorts is in this design
    cohort_long_version [int] NOT NULL, --/D Which of this field's long cohorts is in this design
    cohort_fraction_1 float NOT NULL, --/D Which of this field's long cohorts is in this design
    cohort_fraction_2 float NOT NULL, --/D Which of this field's long cohorts is in this design
    cohort_fraction_3 float NOT NULL, --/D Which of this field's long cohorts is in this design
    cohort_min_h_1 float NOT NULL, --/D Minimum H mag for each cohort
    cohort_min_h_2 float NOT NULL, --/D Minimum H mag for each cohort
    cohort_min_h_3 float NOT NULL, --/D Minimum H mag for each cohort
    cohort_max_h_1 float NOT NULL, --/D Minimum H mag for each cohort
    cohort_max_h_2 float NOT NULL, --/D Minimum H mag for each cohort
    cohort_max_h_3 float NOT NULL, --/D Minimum H mag for each cohort
    cohort_number_of_visits_1 int NOT NULL, --/D Number of visits for each cohort
    cohort_number_of_visits_2 int NOT NULL, --/D Number of visits for each cohort
    cohort_number_of_visits_3 int NOT NULL, --/D Number of visits for each cohort
    number_of_selection_bins int NOT NULL, --/D Number of selection bins
    bin_fraction_1 float NOT NULL, --/D Number of selection bins (5 max)
    bin_fraction_2 float NOT NULL, --/D Number of selection bins (5 max)
    bin_fraction_3 float NOT NULL, --/D Number of selection bins (5 max)
    bin_priority_1 float NOT NULL, --/D Bin priority
    bin_priority_2 float NOT NULL, --/D Bin priority
    bin_priority_3 float NOT NULL, --/D Bin priority
    bin_use_wd_flag_1 float NOT NULL, --/D Use WD flag
    bin_use_wd_flag_2 float NOT NULL, --/D Use WD flag
    bin_use_wd_flag_3 float NOT NULL, --/D Use WD flag
    bin_dereddened_min_jk_color_1 float NOT NULL, --/D Minimum J-K for this bin
    bin_dereddened_min_jk_color_2 float NOT NULL, --/D Minimum J-K for this bin
    bin_dereddened_min_jk_color_3 float NOT NULL, --/D Minimum J-K for this bin
    bin_dereddened_max_jk_color_1 float NOT NULL, --/D Maximum J-K for this bin
    bin_dereddened_max_jk_color_2 float NOT NULL, --/D Maximum J-K for this bin
    bin_dereddened_max_jk_color_3 float NOT NULL, --/D Maximum J-K for this bin
    platerun varchar(100) NOT NULL, --/D Platerun for original design
)
GO




EXEC spSetDefaultFileGroup 'apogeeField'
GO
CREATE TABLE apogeeField (
-------------------------------------------------------------------------------
--/H Contains the basic information for an APOGEE field.
--
--/T This table contains the name, location and number of visits expected
--/T for an APOGEE field.
-------------------------------------------------------------------------------
    field_name varchar(100) NOT NULL, --/D Name of field
    location_id bigint NOT NULL, --/D Location ID (Primary key)
    ra float NOT NULL, --/U deg --/D Right ascension of field center (J2000)
    dec float NOT NULL, --/U deg --/D Declination of field center (J2000)
    glon float NOT NULL, --/U deg --/D Galactic longitude of field center (J2000)
    glat float NOT NULL, --/U deg --/D Galactic latitude of field center (J2000)
    expected_no_of_visits [int] NOT NULL, --/D Expected number of visits for this field (not necessarily the number of visits actually achieved)
    expected_no_of_designs [int] NOT NULL, --/D Expected number of designs for this field 
    no_of_designs_completed [int] NOT NULL, --/D number of designs completed for this field 
)
GO



EXEC spSetDefaultFileGroup 'apogeeObject'
GO
CREATE TABLE apogeeObject (
-------------------------------------------------------------------------------
--/H Contains the targeting information for an APOGEE object.
--
--/T This table contains all the parameters that went into targeting objects
--/T for APOGEE spectra.
-------------------------------------------------------------------------------
    apogee_id varchar(64) NOT NULL, --/D ID identifying this target object 
    target_id varchar(64) NOT NULL, --/D Unique targeting ID identifying this target object (of form [location_id].[apogee_id])
    alt_id varchar(64) NOT NULL, --/D Alternate name for non-2MASS objects
    location_id bigint NOT NULL, --/D Location ID 
    ra float NOT NULL, --/U deg --/D Right ascension (J2000)
    dec float NOT NULL, --/U deg --/D Declination (J2000)
    j real NOT NULL, --/U mag --/D 2MASS J-band magnitude
    j_err real NOT NULL, --/U mag --/D 2MASS J-band magnitude error
    h real NOT NULL, --/U mag --/D H-band magnitude
    src_h varchar(100) NOT NULL, --/D Source of H magnitude
    h_err real NOT NULL, --/U mag --/D H-band magnitude error
    k real NOT NULL, --/U mag --/D 2MASS Ks-band magnitude
    k_err real NOT NULL, --/U mag --/D 2MASS Ks-band magnitude error
    irac_3_6 real NOT NULL, --/U mag  --/D IRAC 3.6 micron magnitude
    irac_3_6_err real NOT NULL, --/U mag --/D IRAC 3.6 micron magnitude error
    irac_4_5 real NOT NULL, --/U mag  --/D IRAC 4.5 micron magnitude
    irac_4_5_err real NOT NULL, --/U mag --/D IRAC 4.5 micron magnitude error
    src_4_5 varchar(100) NOT NULL,  --/D source of 4.5 micron magnitude used for targeting
    irac_5_8 real NOT NULL, --/U mag  --/D IRAC 5.4 micron magnitude
    irac_5_8_err real NOT NULL, --/U mag --/D IRAC 5.4 micron magnitude error
    irac_8_0 real NOT NULL, --/U mag  --/D IRAC 8.0 micron magnitude
    irac_8_0_err real NOT NULL, --/U mag --/D IRAC 8.0 micron magnitude error
    wise_4_5 real NOT NULL, --/U mag --/D WISE allWISE release 4.5 micron magnitude
    wise_4_5_err real NOT NULL, --/U mag --/D WISE allWISE release 4.5 micron magnitude error
    ak_wise real NOT NULL, --/U mag --/D Ks-band extinction based on WISE allWISE release photometry
    sfd_ebv real NOT NULL, --/U mag --/D E(B-V) at object's position in Schlegel, Finkbeiner, & David (1998) maps
    wash_m real NOT NULL, --/U mag --/D Washington M magnitude
    wash_m_err real NOT NULL, --/U mag --/D Washington M magnitude error
    wash_t2 real NOT NULL, --/U mag --/D Washington T2 magnitude
    wash_t2_err real NOT NULL, --/U mag --/D Washington T2 magnitude error
    DDO51 real NOT NULL, --/U mag --/D DDO51 magnitude
    DDO51_err real NOT NULL, --/U mag --/D DDO51 magnitude error
    wash_ddo51_giant_flag [int] NOT NULL, --/D Luminosity class classification derived from Wash+DDO51 data (1 = giant, 0 = dwarf, -1 = no data)
    wash_ddo51_star_flag [int] NOT NULL, --/D Stellar classification based on Washington+DDO51 data (0=extended, 1=star-like or no data)
    targ_4_5 real NOT NULL, --/U mag --/D 4.5 micron magnitude used for targeting
    targ_4_5_err real NOT NULL, --/U mag --/D Error in 4.5 micron magnitude used for targeting
    ak_targ real NOT NULL, --/U mag --/D Ks-band extinction used for target selection
    ak_targ_method varchar(32) NOT NULL, --/U mag --/D Method to calculate Ks-band extinction used for target selection (RJCE_IRAC, RJCE_WISE_ALLSKY, RJCE_WISE_PARTSKY, RJCE_WISE_OPS2, RJCE_WISE_OPS, SFD_EBV, NONE)
    pmra real NOT NULL, --/U mas/yr --/D Proper motion in RA
    pmra_err real NOT NULL, --/U mas/yr --/D Uncertainty in proper motion in RA
    pmdec real NOT NULL, --/U mas/yr --/D Proper motion in Dec
    pmdec_err real NOT NULL, --/U mas/yr --/D Uncertainty in proper motion in Dec
    pm_src varchar(100) NOT NULL, --/D Source of proper motion data
    tmass_a varchar(32) NOT NULL, --/D Source of 2MASS optical counterpart			 
    tmass_pxpa real NOT NULL, --/U deg --/D Position angle of 2MASS optical counterpart (East of North)
    tmass_prox real NOT NULL, --/U arcsec --/D Proximity of 2MASS nearest neighbor
    tmass_phqual varchar(32) NOT NULL, --/D 2MASS ph_qual flag
    tmass_rdflg varchar(32) NOT NULL, --/D 2MASS read_flag
    tmass_ccflg varchar(32) NOT NULL, --/D 2MASS contamination flag
    tmass_extkey bigint NOT NULL, --/D 2MASS Extended Source Catalog ID of associated source
    tmass_gal_contam varchar(32) NOT NULL, --/D 2MASS galaxy contamination flag
)
GO

--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[ApogeeTables.sql]: APOGEE tables created'
GO

