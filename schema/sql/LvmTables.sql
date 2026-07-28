--=========================================================
--  LvmTables.sql
--  2026-06-03	Ani Thakar et al.	
-----------------------------------------------------------
--  Local Volume Mapper (LVM) table schema for SQL Server
-----------------------------------------------------------
-- History:
--* 2026-06-03  Ani: Adapted from master/sql/lvm/*.sql.
--* 2016-03-29  Ani: 
---=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'LVM_DRPall')
	DROP TABLE LVM_DRPall
GO
--
EXEC spSetDefaultFileGroup 'LVM_DRPall'
GO
CREATE TABLE LVM_DRPall (
------------------------------------------------------------------------------
--/H Summary table of observational, instrumental, and processing metadata 
--/H for each LVM DR20 science exposure. 
------------------------------------------------------------------------------
--/T Summary table produced by the LVM Data Reduction Pipeline (DRP) that
--/T compiles observational, instrumental, and processing metadata for 
--/T each science exposure included in DR20; each row corresponds to an 
--/T individual exposure (identified by tileid, mjd, and expnum) and 
--/T contains detailed information on telescope pointing, observing 
--/T conditions, and instrument configuration for the science field (SCI) and 
--/T associated sky fields (SKYE and SKYW), including astrometry, airmass, 
--/T altitude, focus metrics, and angular separations from the Moon, as well as 
--/T lunar and solar conditions at the time of observation; in addition, it 
--/T records pipeline-related information such as reduction stage, processing 
--/T status, quality flags, DRP version, calibration references, and file 
--/T locations, thereby providing a comprehensive master catalog to track data 
--/T provenance, assess data quality, and enable the selection and filtering of 
--/T LVM DR20 observations for scientific analysis. 
------------------------------------------------------------------------------
    tilegrp varchar(6) NOT NULL, --/U  --/D Tile group identifier  
    tileid bigint NOT NULL, --/U  --/D Unique tile identifier  
    mjd bigint NOT NULL, --/U  --/D Modified Julian Date of the observation  
    expnum bigint NOT NULL, --/U  --/D Exposure number within the observing sequence  
    exptime float NOT NULL, --/U seconds --/D Exposure time  
    stage bigint NOT NULL, --/U  --/D Reduction stage identifier  
    status bigint NOT NULL, --/U  --/D Processing status flag  
    drpqual bigint NOT NULL, --/U  --/D DRP quality flag  
    drpver varchar(5) NOT NULL, --/U  --/D Version of the DRP used  
    dpos bigint NOT NULL, --/U  --/D Dither position index  
    object varchar(59) NOT NULL, --/U  --/D Object or field name  
    obstime varchar(23) NOT NULL, --/U  --/D Observation timestamp  
    sci_ra float NOT NULL, --/U degree --/D Right Ascension of science pointing  
    sci_dec float NOT NULL, --/U degree --/D Declination of science pointing  
    sci_pa float NOT NULL, --/U degree --/D Position angle of science field  
    sci_amass float NOT NULL, --/U  --/D Airmass of science exposure  
    sci_kmpos float NOT NULL, --/U  --/D KM mirror position  
    sci_focpos float NOT NULL, --/U  --/D Focus position  
    sci_alt float NOT NULL, --/U degree --/D Altitude of science pointing  
    sci_sh_hght float NOT NULL, --/U  --/D Shack-Hartmann height or focus metric  
    sci_moon_sep float NOT NULL, --/U degree --/D Angular separation to the Moon  
    skye_ra float NOT NULL, --/U degree --/D RA of eastern sky field  
    skye_dec float NOT NULL, --/U degree --/D DEC of eastern sky field  
    skye_pa float NOT NULL, --/U degree --/D Position angle of sky field  
    skye_amass float NOT NULL, --/U  --/D Airmass of sky field  
    skye_kmpos float NOT NULL, --/U  --/D KM mirror position for sky  
    skye_focpos float NOT NULL, --/U  --/D Focus position for sky  
    skye_name varchar(13) NOT NULL, --/U  --/D Identifier of sky field  
    skye_alt float NOT NULL, --/U degree --/D Altitude of sky field  
    sci_skye_sep float NOT NULL, --/U degree --/D Separation SCI–SKYE  
    skye_sh_hght float NOT NULL, --/U  --/D Focus metric for sky field  
    skye_moon_sep float NOT NULL, --/U degree --/D Separation sky–Moon  
    skyw_ra float NOT NULL, --/U degree --/D RA of western sky field  
    skyw_dec float NOT NULL, --/U degree --/D DEC of western sky field  
    skyw_pa float NOT NULL, --/U degree --/D Position angle of sky field  
    skyw_amass float NOT NULL, --/U  --/D Airmass of sky field  
    skyw_kmpos float NOT NULL, --/U  --/D KM mirror position for sky  
    skyw_focpos float NOT NULL, --/U  --/D Focus position for sky  
    skyw_name varchar(13) NOT NULL, --/U  --/D Identifier of sky field  
    skyw_alt float NOT NULL, --/U degree --/D Altitude of sky field  
    sci_skyw_sep float NOT NULL, --/U degree --/D Separation SCI–SKYW  
    skyw_sh_hght float NOT NULL, --/U  --/D Focus metric for sky field  
    skyw_moon_sep float NOT NULL, --/U degree --/D Separation sky–Moon  
    moon_ra float NOT NULL, --/U degree --/D RA of the Moon  
    moon_dec float NOT NULL, --/U degree --/D DEC of the Moon  
    moon_phase float NOT NULL, --/U  --/D Moon phase (fraction illuminated)  
    moon_fli float NOT NULL, --/U  --/D Fractional lunar illumination  
    sun_alt float NOT NULL, --/U degree --/D Altitude of the Sun  
    moon_alt float NOT NULL, --/U degree --/D Altitude of the Moon  
    filename varchar(23) NOT NULL, --/U  --/D Name of the reduced file  
    location varchar(77) NOT NULL, --/U  --/D File system location  
    agcam_location varchar(65) NOT NULL, --/U  --/D Acquisition camera data location  
    calib_mjd bigint NOT NULL, --/U  --/D Calibration MJD used  
    ra float NOT NULL, --/U degree --/D Reference RA of the target  
    dec float NOT NULL, --/U degree --/D Reference DEC of the target  
    pa float NOT NULL, --/U degree --/D Reference position angle  
    ngcname varchar(7) NOT NULL, --/U  --/D NGC identifier if available  
    ra_icrs float NOT NULL, --/U degree --/D RA in ICRS frame  
    dec_icrs float NOT NULL, --/U degree --/D DEC in ICRS frame  
    ra_g float NOT NULL, --/U degree --/D Galactic longitude  
    dec_g float NOT NULL, --/U degree --/D Galactic latitude  
)
GO



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'LVM_DAPall')
	DROP TABLE LVM_DAPall
GO
--
EXEC spSetDefaultFileGroup 'LVM_DAPall'
GO
CREATE TABLE LVM_DAPall (
------------------------------------------------------------------------------
--/H Summary table of LVM DR20 DAP products and exposure-averaged 
--/H spectral properties. 
------------------------------------------------------------------------------
--/T Summary of the dataproducts produced by the LVM DAP analysis for the 
--/T delivered exposures included in SDSS-V DR20. 
--/T It comprises a binary table in which each row corresponds to 
--/T an individual exposure identified by `tileid`, `mjd`, and `expnum`, 
--/T together with the corresponding DAP file, and contains observational and 
--/T physical properties derived from stellar-continuum fitting and 
--/T emission-line measurements of the observed spectra. Fluxes listed in this 
--/T file are average values within the field of view of the science IFU and are 
--/T reported in units of 10^-16 erg/s/cm^2 measured in one fiber area, where 
--/T each fiber area corresponds to 0.2718 arcmin^2. The table combines basic 
--/T observational metadata with stellar population parameters and flux 
--/T measurements of key emission lines across the optical and near-infrared 
--/T range, including Balmer lines, [O II], [O III], [N II], [S II], and [S 
--/T III]. 
------------------------------------------------------------------------------
    tilegrp varchar(6) NOT NULL, --/U  --/D Tile group identifier  
    tileid bigint NOT NULL, --/U  --/D Unique tile identifier  
    mjd bigint NOT NULL, --/U  --/D Modified Julian Date of the observation  
    expnum bigint NOT NULL, --/U  --/D Exposure number  
    exptime float NOT NULL, --/U seconds --/D Exposure time  
    dapfile varchar(33) NOT NULL, --/U  --/D Name of the associated DAP output file  
    ra float NOT NULL, --/U degree --/D Right Ascension of the target  
    dec float NOT NULL, --/U degree --/D Declination of the target  
    teff float NOT NULL, --/U  --/D Effective temperature  
    e_teff float NOT NULL, --/U  --/D Uncertainty in effective temperature  
    log_g float NOT NULL, --/U  --/D Surface gravity (log g)  
    e_log_g float NOT NULL, --/U  --/D Uncertainty in surface gravity  
    fe float NOT NULL, --/U  --/D Stellar metallicity ([Fe/H])  
    e_fe float NOT NULL, --/U  --/D Uncertainty in metallicity  
    alpha float NOT NULL, --/U  --/D Alpha-element enhancement ([alpha/Fe])  
    e_alpha float NOT NULL, --/U  --/D Uncertainty in alpha enhancement  
    av_st float NOT NULL, --/U mag --/D Stellar extinction  
    e_av_st float NOT NULL, --/U mag --/D Uncertainty in stellar extinction  
    z_st float NOT NULL, --/U  --/D Stellar redshift  
    e_z_st float NOT NULL, --/U  --/D Uncertainty in stellar redshift  
    disp_st float NOT NULL, --/U km/s --/D Stellar velocity dispersion  
    e_disp_st float NOT NULL, --/U km/s --/D Uncertainty in velocity dispersion  
    flux_st float NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Average stellar flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    redshift_st float NOT NULL, --/U  --/D Adopted stellar redshift  
    med_flux_st float NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Median stellar flux at the V-band within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_med_flux_st float NOT NULL, --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the median stellar flux at the V-band within the field of view of the science IFU, reported in units measured in one fiber area.  
    vel_st float NOT NULL, --/U km/s --/D Stellar velocity  
    x_sq_st float NOT NULL, --/U  --/D Chi-square of stellar fit  
    x_sq_st_np float NOT NULL, --/U  --/D Chi-square (non-parametric fit)  
    x_sq_st_pek float NOT NULL, --/U  --/D Chi-square for emission-line masked fit  
    flux_pek_3726_03 float NOT NULL, --/F flux_pek_3726.03 --/U 10^-16 erg/s/cm^2 --/D Average [OII] 3726 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_3726_03 float NOT NULL, --/F e_flux_pek_3726.03 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [OII] 3726 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_3728_82 float NOT NULL, --/F flux_pek_3728.82 --/U 10^-16 erg/s/cm^2 --/D Average [OII] 3729 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_3728_82 float NOT NULL, --/F e_flux_pek_3728.82 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [OII] 3729 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_4101_77 float NOT NULL, --/F flux_pek_4101.77 --/U 10^-16 erg/s/cm^2 --/D Average Hδ flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_4101_77 float NOT NULL, --/F e_flux_pek_4101.77 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average Hδ flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_4340_49 float NOT NULL, --/F flux_pek_4340.49 --/U 10^-16 erg/s/cm^2 --/D Average Hγ flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_4340_49 float NOT NULL, --/F e_flux_pek_4340.49 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average Hγ flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_4861_36 float NOT NULL, --/F flux_pek_4861.36 --/U 10^-16 erg/s/cm^2 --/D Average Hβ flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_4861_36 float NOT NULL, --/F e_flux_pek_4861.36 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average Hβ flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_4958_91 float NOT NULL, --/F flux_pek_4958.91 --/U 10^-16 erg/s/cm^2 --/D Average [OIII] 4959 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_4958_91 float NOT NULL, --/F e_flux_pek_4958.91 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [OIII] 4959 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_5006_84 float NOT NULL, --/F flux_pek_5006.84 --/U 10^-16 erg/s/cm^2 --/D Average [OIII] 5007 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_5006_84 float NOT NULL, --/F e_flux_pek_5006.84 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [OIII] 5007 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_6300_3 float NOT NULL, --/F flux_pek_6300.3 --/U 10^-16 erg/s/cm^2 --/D Average [OI] 6300 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_6300_3 float NOT NULL, --/F e_flux_pek_6300.3 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [OI] 6300 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_6548_05 float NOT NULL, --/F flux_pek_6548.05 --/U 10^-16 erg/s/cm^2 --/D Average [NII] 6548 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_6548_05 float NOT NULL, --/F e_flux_pek_6548.05 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [NII] 6548 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_6562_85 float NOT NULL, --/F flux_pek_6562.85 --/U 10^-16 erg/s/cm^2 --/D Average Hα flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_6562_85 float NOT NULL, --/F e_flux_pek_6562.85 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average Hα flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_6583_45 float NOT NULL, --/F flux_pek_6583.45 --/U 10^-16 erg/s/cm^2 --/D Average [NII] 6583 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_6583_45 float NOT NULL, --/F e_flux_pek_6583.45 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [NII] 6583 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_6716_44 float NOT NULL, --/F flux_pek_6716.44 --/U 10^-16 erg/s/cm^2 --/D Average [SII] 6716 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_6716_44 float NOT NULL, --/F e_flux_pek_6716.44 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [SII] 6716 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_6730_82 float NOT NULL, --/F flux_pek_6730.82 --/U 10^-16 erg/s/cm^2 --/D Average [SII] 6731 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_6730_82 float NOT NULL, --/F e_flux_pek_6730.82 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [SII] 6731 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_9069_0 float NOT NULL, --/F flux_pek_9069.0 --/U 10^-16 erg/s/cm^2 --/D Average [SIII] 9069 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_9069_0 float NOT NULL, --/F e_flux_pek_9069.0 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [SIII] 9069 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    flux_pek_9531_1 float NOT NULL, --/F flux_pek_9531.1 --/U 10^-16 erg/s/cm^2 --/D Average [SIII] 9531 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
    e_flux_pek_9531_1 float NOT NULL, --/F e_flux_pek_9531.1 --/U 10^-16 erg/s/cm^2 --/D Uncertainty in the average [SIII] 9531 flux within the field of view of the science IFU, reported in units measured in one fiber area.  
)
GO



EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[LvmTables.sql]: LVM tables created'
GO


