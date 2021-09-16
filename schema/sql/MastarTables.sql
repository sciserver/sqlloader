--=========================================================
--  MastarTables.sql
--  2018-07-24	Renbin Yan	
-----------------------------------------------------------
--  Mastar table schema for SQL Server
-----------------------------------------------------------
-- History:
--* 2018-07-24  Ani: Adapted from sas-sql/mastarall.sql.
--* 2018-07-24  Ani: Flipped the float/real types for coords and mags,
--*             and changed psfMag_[ugriz] to psfMag_[12345] as per 
--*             Renbin's request.
--* 2021-07-01  Ani: Updates for DR17.
--* 2021-07-29  Ani: Added crossmatch and param VACs (DR17).
--=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodstars')
	DROP TABLE mastar_goodstars
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodstars'
GO
CREATE TABLE mastar_goodstars (
------------------------------------------------------------------------------
--/H Summary file of MaNGA Stellar Libary.
------------------------------------------------------------------------------
--/T Summary information for stars with at least one high quality 
--/T visit-spectrum.
------------------------------------------------------------------------------
    drpver varchar(8) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(8) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(25) NOT NULL, --/U  --/D   MaNGA-ID for the target.
    minmjd int NOT NULL, --/U  --/D   Minimum Modified Julian Date of Observations.
    maxmjd int NOT NULL, --/U  --/D   Maximum Modified Julian Date of Observations.
    nvisits int NOT NULL, --/U  --/D   Number of visits for this star (including good and bad observations).
    nplates int NOT NULL, --/U  --/D   Number of plates this star is on.
    ra float NOT NULL, --/U deg --/D   Right Ascension for this object at the time given by the EPOCH column (Equinox J2000).
    dec float NOT NULL, --/U deg --/D   Declination for this object at the time given by the EPOCH column (Equinox J2000).
    epoch real NOT NULL, --/U  --/D   Epoch of the astrometry (which is approximate for some catalogs).
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT.
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT.  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT.  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT.  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    input_logg real NOT NULL, --/U log(cm/s^2) --/D   Surface gravity in the input catalog (with some adjustment made).
    input_teff real NOT NULL, --/U K --/D   Effective temperature in the input catalog (with some adjustment made).
    input_fe_h real NOT NULL, --/U  --/D   [Fe/H] in the input catalog (with some adjustment made).
    input_alpha_m real NOT NULL, --/U  --/D   [alpha/M] in the input catalog (with some adjustment made).
    input_source varchar(16) NOT NULL, --/U  --/D   Source catalog for stellar parameters.
    photocat varchar(10) NOT NULL, --/U  --/D   Source of astrometry and photometry.
)
GO
--



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodvisits')
	DROP TABLE mastar_goodvisits
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodvisits'
GO
CREATE TABLE mastar_goodvisits (
------------------------------------------------------------------------------
--/H Summary file of all visits of stars included in MaNGA Stellar Libary.
------------------------------------------------------------------------------
--/T Summary information for all of the good visits of the good stars.
------------------------------------------------------------------------------
    drpver varchar(8) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(8) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(25) NOT NULL, --/U  --/D   MaNGA-ID for the object.
    plate int NOT NULL, --/U  --/D   Plate ID.
    ifudesign varchar(6) NOT NULL, --/U  --/D   IFUDESIGN for the fiber bundle.
    mjd int NOT NULL, --/U  --/D   Modified Julian Date for this visit.
    ifura float NOT NULL, --/U deg --/D   Right Ascension of the center of the IFU.
    ifudec float NOT NULL, --/U deg --/D   Declination of the center of the IFU.
    ra float NOT NULL, --/U deg --/D   Right Ascension for this object at the time given by the EPOCH column (Equinox J2000).
    dec float NOT NULL, --/U deg --/D   Declination for this object at the time given by the EPOCH column (Equinox J2000).
    epoch real NOT NULL, --/U  --/D   Epoch of the astrometry (which is approximate for some catalogs).
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT.
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT.  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT.  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT.  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    exptime real NOT NULL, --/U sec  --/D   Median exposure time for all exposures on this visit.
    nexp_visit smallint NOT NULL, --/U  --/D   Total number of exposures during this visit. This column was named 'NEXP' in DR15/16.
    nvelgood smallint NOT NULL, --/U  --/D   Number of exposures (from all visits of this PLATE-IFUDESIGN) with good velocity measurements.
    heliov real NOT NULL, --/U km/s  --/D   Median heliocentric velocity of all exposures on all visits that yield good velocity measurements. This is used to shift the spectra to the rest frame. 
    verr real NOT NULL, --/U km/s  --/D   1-sigma uncertainty of the heliocentric velocity
    v_errcode smallint NOT NULL, --/U  --/D   Error code for HELIOV. Zero is good, nonzero is bad.
    heliov_visit real NOT NULL, --/U km/s  --/D   Median heliocentric velocity of good exposures from only this visit, rather than from all visits. 
    verr_visit real NOT NULL, --/U km/s  --/D   1-sigma uncertainty of HELIOV_VISIT. 
    v_errcode_visit smallint NOT NULL, --/U  --/D   Error code for HELIOV_VISIT. Zero is good, nonzero is bad. 
    velvarflag smallint NOT NULL, --/U  --/D   Flag indicating the significant variation of the heliocentric velocity from visit to visit. A value of 1 means the variation is beyond 3-sigma between at least two of the visits. A value of 0 means all variations between pairs of visits are less than 3-sigma.
    dv_maxsig real NOT NULL, --/U  --/D   Maximum significance in velocity variation between pairs of visits. 
    mjdqual int NOT NULL, --/U  --/D   Spectral quality bitmask (MASTAR_QUAL).
    bprperr_sp real NOT NULL, --/U  --/D  Uncertainty in the synthetic Bp-Rp color derived from the spectra. 
    nexp_used smallint NOT NULL, --/U  --/D   Number of exposures used in constructing the visit spectrum.
    s2n real NOT NULL, --/U  --/D   Median signal-to-noise ratio per pixel of this visit spectrum.
    s2n10 real NOT NULL, --/U  --/D   Top 10-th percentile signal-to-noise ratio per pixel of this visit spectrum.
    badpixfrac real NOT NULL, --/U  --/D   Fraction of bad pixels (those with inverse variance being zero.)
    coord_source varchar(10) NOT NULL, --/U  --/D   Source of astrometry.
    photocat varchar(10) NOT NULL, --/U  --/D   Source of photometry.
)
GO
--



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodstars_xmatch_gaiadr2')
	DROP TABLE mastar_goodstars_xmatch_gaiadr2
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodstars_xmatch_gaiadr2'
GO
CREATE TABLE mastar_goodstars_xmatch_gaiadr2 (
------------------------------------------------------------------------------
--/H Photometry crossmatch value added catalog of the good stars in the MaNGA
--/H Stellar Libary (MaStar).  It includes crossmatch with Gaia DR2, 2MASS,
--/H PanSTARRS1, and object type/spectral type information from Simbad.
------------------------------------------------------------------------------
--/T Summary information for good stars with at least one high quality
--/T visit-spectrum.
------------------------------------------------------------------------------
    drpver varchar(10) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(10) NOT NULL, --/U  --/D  Version of mastarproc. 
    mangaid varchar(30) NOT NULL, --/U  --/D  MaNGA-ID for the target. 
    minmjd int NOT NULL, --/U  --/D   Minimum Modified Julian Date of Observations.
    maxmjd int NOT NULL, --/U  --/D  Maximum Modified Julian Date of Observations. 
    nvisits int NOT NULL, --/U  --/D  Number of visits for this star (including good and bad observations). 
    nplates int NOT NULL, --/U  --/D  Number of plates this star is on. 
    ra float NOT NULL, --/U deg --/D  Right Ascension for this object at the time given by the EPOCH column (Equinox J2000). 
    dec float  NOT NULL, --/U deg --/D  Declination for this object at the time given by the EPOCH column (Equinox J2000). 
    epoch real NOT NULL, --/U  --/D  Epoch of the astrometry (which is approximate for some catalogs). 
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT.
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT.  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT.  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT.  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    input_logg real NOT NULL, --/U log(cm/s^2) --/D   Surface gravity in the input catalog (with some adjustment made).
    input_teff real NOT NULL, --/U K --/D   Effective temperature in the input catalog (with some adjustment made).
    input_fe_h real NOT NULL, --/U  --/D   [Fe/H] in the input catalog (with some adjustment made).
    input_alpha_m real NOT NULL, --/U  --/D   [alpha/M] in the input catalog (with some adjustment made).
    input_source varchar(16) NOT NULL, --/U  --/D   Source catalog for stellar parameters.
    photocat varchar(10) NOT NULL, --/U  --/D   Source of astrometry and photometry.
    designation varchar(30) NOT NULL, --/U  --/D  Unique source designation by Gaia
    source_id bigint NOT NULL, --/U  --/D  Gaia DR2 source ID  
    ref_epoch real NOT NULL, --/U  --/D  Epoch for Gaia DR2 astrometry 
    gaiara float NOT NULL, --/U deg --/D  RA given by Gaia DR2 
    gaiara_error float NOT NULL, --/U mas --/D  Uncertainty of RA given by Gaia DR2
    gaiadec float NOT NULL, --/U deg --/D  Dec given by Gaia DR2 
    gaiadec_error float NOT NULL, --/U mas  --/D  Uncertainty of Dec given by Gaia DR2 
    parallax real NOT NULL, --/U mas --/D  Parallax measured by Gaia (DR2)
    parallax_error real NOT NULL, --/U mas --/D  Standard error of parallax (DR2)
    pmra real NOT NULL, --/U mas/yr --/D  Proper motion in right ascension direction (DR2)
    pmra_error real NOT NULL, --/U mas/yr --/D  Standard error of proper motion in right ascension direction  (DR2)
    pmdec real NOT NULL, --/U mas/yr --/D  Proper motion in declination direction (DR2)
    pmdec_error real NOT NULL, --/U mas/yr --/D  Standard error of proper motion in declination direction (DR2)
    astrometric_params_solved smallint NOT NULL, --/U  --/D   A binary code indicating which astrometric parameters were estimated for the source. See Gaia documentation for more details.(DR2)
    astrometric_n_good_obs_al int NOT NULL, --/U  --/D  Number of good observations AL (see gaia data documentation) (DR2)
    astrometric_chi2_al real NOT NULL, --/U  --/D  AL chi-square value (see Gaia data documentation) (DR2)
    visibility_periods_used smallint NOT NULL, --/U  --/D  Number of visibility periods used in the astrometric solution. (DR2)
    phot_g_mean_flux real NOT NULL, --/U e-/s --/D  G-band mean flux (DR2)
    phot_g_mean_flux_over_error real NOT NULL, --/U  --/D   Mean flux in the G-band divided by its error(DR2)
    phot_g_mean_mag real NOT NULL, --/U mag --/D  G-band mean magnitude (DR2)
    phot_bp_mean_flux real NOT NULL, --/U e-/s --/D  Integrated BP mean flux(DR2)
    phot_bp_mean_flux_over_error real NOT NULL, --/U  --/D  Integrated BP mean flux divided by its error (DR2)
    phot_bp_mean_mag real NOT NULL, --/U mag --/D  Integrated BP mean magnitude (DR2)
    phot_rp_mean_flux real NOT NULL, --/U e-/s --/D  Integrated RP mean flux (DR2)
    phot_rp_mean_flux_over_error real NOT NULL, --/U  --/D   	Integrated RP mean flux divided by its error(DR2)
    phot_rp_mean_mag real NOT NULL, --/U mag --/D   Integrated RP mean magnitude(DR2)
    phot_bp_rp_excess_factor real NOT NULL, --/U  --/D   BP/RP excess factor(DR2)
    bp_rp real NOT NULL, --/U mag --/D   BP - RP colour(DR2)
    radial_velocity real NOT NULL, --/U km/s --/D   	Radial velocity (DR2)
    radial_velocity_error real NOT NULL, --/U km/s --/D   	Radial velocity error (DR2)
    phot_variable_flag varchar(20) NOT NULL, --/U  --/D   Photometric variability flag (DR2)
    r_est real NOT NULL, --/U parsec --/D   Estimated distance (Bailer-Jones et al. 2018)
    r_lo real NOT NULL, --/U parsec --/D   Lower bound on the confidence interval of the estimated distance
    r_hi real NOT NULL, --/U parsec --/D   Upper bound on the confidence interval of the estimated distance.
    r_len real NOT NULL, --/U parsec --/D   Length scale used in the prior for the distance estimation.
    result_flag smallint NOT NULL, --/U  --/D   Type of distance estimate result (0=failed estimate; 1=r_est is the mode (highest if the posterior is bimodal); r_lo/r_hi define the lower/upper limits of the highest density interval (HDI) containing 68% of the posterior probability ; 2 = r_est is the median; r_lo/r_hi define the lower/upper limits of the equal-tailed interval (ETI), containing 68% of the posterior probability.)
    modality_flag smallint NOT NULL, --/U  --/D   Distance result regime flag: number of modes in the posterior (1 or 2).
    tmass_id varchar(20) NOT NULL, --/U  --/D   2MASS source designation formed from sexigesimal coordinates
    tmass_distance real NOT NULL, --/U arcsec --/D   Angular distance between the Gaia source and its best neighbour in 2MASS point source catalog
    j_m real NOT NULL, --/U mag --/D   2MASS J band selected "default" magnitude
    j_msigcom real NOT NULL, --/U mag --/D   Combined (total) J band photometric uncertainty
    h_m real NOT NULL, --/U mag --/D   2MASS H band selected "default" magnitude
    h_msigcom real NOT NULL, --/U mag --/D   Combined (total) H band photometric uncertainty
    k_m real NOT NULL, --/U mag --/D   2MASS K band selected "default" magnitude
    k_msigcom real NOT NULL, --/U mag --/D   Combined (total) K band photometric uncertainty
    ph_qual varchar(10) NOT NULL, --/U  --/D   Flag indicating 2MASS photometric quality of source (see 2MASS PSC documentation at IRSA).
    gal_contam smallint NOT NULL, --/U  --/D   Flag indicating if src is contaminated by extended source in 2MASS (see 2MASS PSC documentation at IRSA).
    mp_flg smallint NOT NULL, --/U  --/D  If nonzero, the 2MASS source is positionally associated with an asteroid, comet, etc 
    contamination real NOT NULL, --/U  --/D   Metric indicating maximum contamination level by neighboring objects, evaluated using the Gaia G, BP, and RP magnitudes.
    gaia_cleanmatch smallint NOT NULL, --/U  --/D   A value of 1 indicates the contamination level by the neighboring object(s) is below 0.0084. The source spectrum should be unaffected by the neighboring object.
    ebv real NOT NULL, --/U mag --/D   reddening given by the 3D dustmap (Green et al. 2019) at the distance of R_EST. 
    ebv_sigma_up real NOT NULL, --/U mag --/D   Reddening uncertainty on the upper side (estimated using the 84-th percentile in the reddening posterior at the distance given by R_HI) 
    ebv_sigma_dn real NOT NULL, --/U mag --/D   Reddening uncertainty on the lower side (estimated using the 16-th percentile in the reddening posterior at the distance given by R_LO) 
    m_g real NOT NULL, --/U mag --/D   Absolute G-band magnitude
    m_g_err_up real NOT NULL, --/U mag --/D   Uncertainty on the upper (fainter) side for absolute G-band magnitude (estimated using EBV-EBV_SIGMA_DN and R_LO) 
    m_g_err_dn real NOT NULL, --/U mag --/D   Uncertainty on the lower (brighter) side for absolute G-band magnitude (estimated using EBV+EBV_SIGMA_UP and R_HI) 
    bprpc real NOT NULL, --/U mag --/D   Extinction-corrected BP-RP color
    bprpc_err_up real NOT NULL, --/U mag --/D   Uncertainty on the redder side for the extinction-corrected BP-RP color (propagated using EBV, EBV_SIGMA_DN, and uncertainty on BP and RP magnitudes)
    bprpc_err_dn real NOT NULL, --/U mag --/D   Uncertainty on the bluer side for the extinction-corrected BP-RP color (propagated using EBV, EBV_SIGMA_UP, and uncertainty on BP and RP magnitudes)
    dustclean bigint NOT NULL, --/U  --/D   A value of 1 indicates there is a valid reddening estimate.
    goodstars bigint NOT NULL, --/U  --/D   A value of 1 indicates the star belongs to the GOODSTARS set. This is always true in this table.
    simbad_main_id varchar(40) NOT NULL, --/U  --/D   Main ID of the star on Simbad.
    otype_s varchar(20) NOT NULL, --/U  --/D   Object type given by Simbad.
    sp_type varchar(20) NOT NULL, --/U  --/D   Spectral type given by Simbad.
    sp_qual varchar(1) NOT NULL, --/U  --/D   Quality of the spectral type determination (A:best, E:worst).
    sp_bibcode varchar(20) NOT NULL, --/U  --/D   Reference of the spectral type determination
    mk_ds varchar(10) NOT NULL, --/U  --/D   Dispersive system used for the MK/MSS spectral type determination
    mk_spectral_type varchar(20) NOT NULL, --/U  --/D   Simbad Morgan-Keenan (MK) spectral type
    mk_bibcode varchar(20) NOT NULL, --/U  --/D   Reference of the MK spectral type
    ps1_nmag_ok_g smallint NOT NULL, --/F PS1_NMAG_OK 0 --/U mag --/D   Number of detections for the object in PS1 g filter.  
    ps1_nmag_ok_r smallint NOT NULL, --/F PS1_NMAG_OK 1 --/U mag --/D   Number of detections for the object in PS1 r filter.  
    ps1_nmag_ok_i smallint NOT NULL, --/F PS1_NMAG_OK 2 --/U mag --/D   Number of detections for the object in PS1 i filter.  
    ps1_nmag_ok_z smallint NOT NULL, --/F PS1_NMAG_OK 3 --/U mag --/D   Number of detections for the object in PS1 z filter.  
    ps1_nmag_ok_y smallint NOT NULL, --/F PS1_NMAG_OK 4 --/U mag --/D   Number of detections for the object in PS1 y filter.  
    ps1_mean_g real NOT NULL, --/F PS1_MEAN 0 --/U maggies --/D   Mean flux among all okay detections in PS1 g.  
    ps1_mean_r real NOT NULL, --/F PS1_MEAN 1 --/U maggies --/D   Mean flux among all okay detections in PS1 r.  
    ps1_mean_i real NOT NULL, --/F PS1_MEAN 2 --/U maggies --/D   Mean flux among all okay detections in PS1 i.  
    ps1_mean_z real NOT NULL, --/F PS1_MEAN 3 --/U maggies --/D   Mean flux among all okay detections in PS1 z.  
    ps1_mean_y real NOT NULL, --/F PS1_MEAN 4 --/U maggies --/D   Mean flux among all okay detections in PS1 y.  
    ps1_err_g real NOT NULL, --/F PS1_ERR 0 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 g.  
    ps1_err_r real NOT NULL, --/F PS1_ERR 1 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 r.  
    ps1_err_i real NOT NULL, --/F PS1_ERR 2 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 i.  
    ps1_err_z real NOT NULL, --/F PS1_ERR 3 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 z.  
    ps1_err_y real NOT NULL, --/F PS1_ERR 4 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 y.  
    ps1_stdev_g real NOT NULL, --/F PS1_STDEV 0 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 g.  
    ps1_stdev_r real NOT NULL, --/F PS1_STDEV 1 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 r.  
    ps1_stdev_i real NOT NULL, --/F PS1_STDEV 2 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 i.  
    ps1_stdev_z real NOT NULL, --/F PS1_STDEV 3 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 z.  
    ps1_stdev_y real NOT NULL, --/F PS1_STDEV 4 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 y.  
    ps1_median_g real NOT NULL, --/F PS1_MEDIAN 0 --/U maggies --/D   Median flux in PS1 g.  
    ps1_median_r real NOT NULL, --/F PS1_MEDIAN 1 --/U maggies --/D   Median flux in PS1 r.  
    ps1_median_i real NOT NULL, --/F PS1_MEDIAN 2 --/U maggies --/D   Median flux in PS1 i.  
    ps1_median_z real NOT NULL, --/F PS1_MEDIAN 3 --/U maggies --/D   Median flux in PS1 z.  
    ps1_median_y real NOT NULL, --/F PS1_MEDIAN 4 --/U maggies --/D   Median flux in PS1 y.  
    ps1_q25_g real NOT NULL, --/F PS1_Q25 0 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 g.  
    ps1_q25_r real NOT NULL, --/F PS1_Q25 1 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 r.  
    ps1_q25_i real NOT NULL, --/F PS1_Q25 2 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 i.  
    ps1_q25_z real NOT NULL, --/F PS1_Q25 3 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 z.  
    ps1_q25_y real NOT NULL, --/F PS1_Q25 4 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 y.  
    ps1_q75_g real NOT NULL, --/F PS1_Q75 0 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 g.  
    ps1_q75_r real NOT NULL, --/F PS1_Q75 1 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 r.  
    ps1_q75_i real NOT NULL, --/F PS1_Q75 2 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 i.  
    ps1_q75_z real NOT NULL, --/F PS1_Q75 3 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 z.  
    ps1_q75_y real NOT NULL, --/F PS1_Q75 4 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 y.  
    ps1_median_ap_g real NOT NULL, --/F PS1_MEDIAN_AP 0 --/U maggies --/D   Median aperture flux among all okay detections in PS1 g.  
    ps1_median_ap_r real NOT NULL, --/F PS1_MEDIAN_AP 1 --/U maggies --/D   Median aperture flux among all okay detections in PS1 r.  
    ps1_median_ap_i real NOT NULL, --/F PS1_MEDIAN_AP 2 --/U maggies --/D   Median aperture flux among all okay detections in PS1 i.  
    ps1_median_ap_z real NOT NULL, --/F PS1_MEDIAN_AP 3 --/U maggies --/D   Median aperture flux among all okay detections in PS1 z.  
    ps1_median_ap_y real NOT NULL, --/F PS1_MEDIAN_AP 4 --/U maggies --/D   Median aperture flux among all okay detections in PS1 y.  
    ps1_obj_id bigint NOT NULL, --/U  --/D   Unique object identifier in PS1. A value of zero means the object has no match in the PS1 catalog.
)
GO
--




--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodstars_xmatch_gaiaedr3')
	DROP TABLE mastar_goodstars_xmatch_gaiaedr3
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodstars_xmatch_gaiaedr3'
GO
CREATE TABLE mastar_goodstars_xmatch_gaiaedr3 (
------------------------------------------------------------------------------
--/H Photometry crossmatch value added catalog of the good stars in the MaNGA
--/H Stellar Libary (MaStar). It includes crossmatch with Gaia DR2, 2MASS,
--/H PanSTARRS1, and object type/spectral type information from Simbad.
------------------------------------------------------------------------------
--/T Summary information for good stars with at least one high quality
--/T visit-spectrum.
------------------------------------------------------------------------------
    drpver varchar(10) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(10) NOT NULL, --/U  --/D  Version of mastarproc. 
    mangaid varchar(30) NOT NULL, --/U  --/D  MaNGA-ID for the target. 
    minmjd int NOT NULL, --/U  --/D   Minimum Modified Julian Date of Observations.
    maxmjd int NOT NULL, --/U  --/D  Maximum Modified Julian Date of Observations. 
    nvisits int NOT NULL, --/U  --/D  Number of visits for this star (including good and bad observations). 
    nplates int NOT NULL, --/U  --/D  Number of plates this star is on. 
    ra float NOT NULL, --/U deg --/D  Right Ascension for this object at the time given by the EPOCH column (Equinox J2000). 
    dec float  NOT NULL, --/U deg --/D  Declination for this object at the time given by the EPOCH column (Equinox J2000). 
    epoch real NOT NULL, --/U  --/D  Epoch of the astrometry (which is approximate for some catalogs). 
    psfmag_1 real NOT NULL, --/F PSFMAG 0 --/U mag --/D   PSF magnitude in the first band with the filter correspondence depending on PHOTOCAT.
    psfmag_2 real NOT NULL, --/F PSFMAG 1 --/U mag --/D   PSF magnitude in the second band with the filter correspondence depending on PHOTOCAT.  
    psfmag_3 real NOT NULL, --/F PSFMAG 2 --/U mag --/D   PSF magnitude in the third band with the filter correspondence depending on PHOTOCAT. 
    psfmag_4 real NOT NULL, --/F PSFMAG 3 --/U mag --/D   PSF magnitude in the fourth band with the filter correspondence depending on PHOTOCAT.  
    psfmag_5 real NOT NULL, --/F PSFMAG 4 --/U mag --/D   PSF magnitude in the fifth band with the filter correspondence depending on PHOTOCAT.  
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    input_logg real NOT NULL, --/U log(cm/s^2) --/D   Surface gravity in the input catalog (with some adjustment made).
    input_teff real NOT NULL, --/U K --/D   Effective temperature in the input catalog (with some adjustment made).
    input_fe_h real NOT NULL, --/U  --/D   [Fe/H] in the input catalog (with some adjustment made).
    input_alpha_m real NOT NULL, --/U  --/D   [alpha/M] in the input catalog (with some adjustment made).
    input_source varchar(16) NOT NULL, --/U  --/D   Source catalog for stellar parameters.
    photocat varchar(10) NOT NULL, --/U  --/D   Source of astrometry and photometry.
    designation varchar(30) NOT NULL, --/U  --/D  Unique source designation by Gaia
    source_id bigint NOT NULL, --/U  --/D  Gaia EDR3 source ID  
    ref_epoch real NOT NULL, --/U  --/D  Epoch for Gaia EDR3 astrometry 
    gaiara float NOT NULL, --/U deg --/D  RA given by Gaia EDR3 
    gaiara_error float NOT NULL, --/U mas --/D  Uncertainty of RA given by Gaia EDR3
    gaiadec float NOT NULL, --/U deg --/D  Dec given by Gaia EDR3 
    gaiadec_error float NOT NULL, --/U mas  --/D  Uncertainty of Dec given by Gaia EDR3 
    parallax real NOT NULL, --/U mas --/D  Parallax measured by Gaia (EDR3)
    parallax_error real NOT NULL, --/U mas --/D  Standard error of parallax(EDR3)
    pmra real NOT NULL, --/U mas/yr --/D  Proper motion in right ascension direction (EDR3)
    pmra_error real NOT NULL, --/U mas/yr --/D  Standard error of proper motion in right ascension direction  (EDR3)
    pmdec real NOT NULL, --/U mas/yr --/D  Proper motion in declination direction (EDR3)
    pmdec_error real NOT NULL, --/U mas/yr --/D  Standard error of proper motion in declination direction (EDR3)
    astrometric_params_solved smallint NOT NULL, --/U  --/D   A binary code indicating which astrometric parameters were estimated for the source. See Gaia documentation for more details.(EDR3)
    astrometric_n_good_obs_al int NOT NULL, --/U  --/D  Number of good observations AL (see gaia data documentation) (EDR3)
    astrometric_chi2_al real NOT NULL, --/U  --/D  AL chi-square value (see Gaia data documentation) (EDR3)
    visibility_periods_used smallint NOT NULL, --/U  --/D  Number of visibility periods used in the astrometric solution. (EDR3)
    phot_g_mean_flux real NOT NULL, --/U e-/s --/D  G-band mean flux (EDR3)
    phot_g_mean_flux_over_error real NOT NULL, --/U  --/D   Mean flux in the G-band divided by its error(EDR3)
    phot_g_mean_mag real NOT NULL, --/U mag --/D  G-band mean magnitude (EDR3)
    phot_bp_mean_flux real NOT NULL, --/U e-/s --/D  Integrated BP mean flux(EDR3)
    phot_bp_mean_flux_over_error real NOT NULL, --/U  --/D  Integrated BP mean flux divided by its error (EDR3)
    phot_bp_mean_mag real NOT NULL, --/U mag --/D  Integrated BP mean magnitude (EDR3)
    phot_rp_mean_flux real NOT NULL, --/U e-/s --/D  Integrated RP mean flux (EDR3)
    phot_rp_mean_flux_over_error real NOT NULL, --/U  --/D   	Integrated RP mean flux divided by its error(EDR3)
    phot_rp_mean_mag real NOT NULL, --/U mag --/D   Integrated RP mean magnitude(EDR3)
    phot_bp_rp_excess_factor real NOT NULL, --/U  --/D   BP/RP excess factor(EDR3)
    bp_rp real NOT NULL, --/U mag --/D   BP - RP colour(EDR3)
    r_med_geo real NOT NULL, --/U parsec --/D  The median of the geometric distance posterior. The geometric distance estimate. 
    r_lo_geo real NOT NULL, --/U parsec --/D  The 16th percentile of the geometric distance posterior. The lower 1-sigma-like bound on the confidence interval.
    r_hi_geo real NOT NULL, --/U parsec --/D  The 84th percentile of the geometric distance posterior. The upper 1-sigma-like bound on the confidence interval.
    r_med_photogeo real NOT NULL, --/U parsec --/D   The median of the photogeometric distance posterior. The photogeometric distance estimate.
    r_lo_photogeo real NOT NULL, --/U parsec --/D   The 16th percentile of the photogeometric distance posterior. The lower 1-sigma-like bound on the confidence interval.
    r_hi_photogeo real NOT NULL, --/U parsec --/D   The 84th percentile of the photogeometric distance posterior. The upper 1-sigma-like bound on the confidence interval.
    r_flag varchar(10) NOT NULL, --/U  --/D   Additional information on the solution. Do not use for filtering (see Bailer-Jones et al. 2021).
    tmass_id varchar(20) NOT NULL, --/U  --/D   2MASS source designation formed from sexigesimal coordinates
    tmass_distance real NOT NULL, --/U arcsec --/D   Angular distance between the Gaia source and its best neighbour in 2MASS point source catalog
    j_m real NOT NULL, --/U mag --/D   2MASS J band selected "default" magnitude
    j_msigcom real NOT NULL, --/U mag --/D   Combined (total) J band photometric uncertainty
    h_m real NOT NULL, --/U mag --/D   2MASS H band selected "default" magnitude
    h_msigcom real NOT NULL, --/U mag --/D   Combined (total) H band photometric uncertainty
    k_m real NOT NULL, --/U mag --/D   2MASS K band selected "default" magnitude
    k_msigcom real NOT NULL, --/U mag --/D   Combined (total) K band photometric uncertainty
    ph_qual varchar(10) NOT NULL, --/U  --/D   Flag indicating 2MASS photometric quality of source (see 2MASS PSC documentation at IRSA).
    gal_contam smallint NOT NULL, --/U  --/D   Flag indicating if src is contaminated by extended source in 2MASS (see 2MASS PSC documentation at IRSA).
    mp_flg smallint NOT NULL, --/U  --/D  If nonzero, the 2MASS source is positionally associated with an asteroid, comet, etc 
    contamination real NOT NULL, --/U  --/D   Metric indicating maximum contamination level by neighboring objects, evaluated using the Gaia G, BP, and RP magnitudes.
    gaia_cleanmatch smallint NOT NULL, --/U  --/D   A value of 1 indicates the contamination level by the neighboring object(s) is below 0.0084. The source spectrum should be unaffected by the neighboring object.
    ebv real NOT NULL, --/U mag --/D   reddening given by the 3D dustmap (Green et al. 2019) at the distance of R_MED_PHOTOGEO. 
    ebv_sigma_up real NOT NULL, --/U mag --/D   Reddening uncertainty on the upper side (estimated using the 84-th percentile in the reddening posterior at the distance given by R_HI_PHOTOGEO) 
    ebv_sigma_dn real NOT NULL, --/U mag --/D   Reddening uncertainty on the lower side (estimated using the 16-th percentile in the reddening posterior at the distance given by R_LO_PHOTOGEO) 
    m_g real NOT NULL, --/U mag --/D   Absolute G-band magnitude
    m_g_err_up real NOT NULL, --/U mag --/D   Uncertainty on the upper (fainter) side for absolute G-band magnitude (estimated using EBV-EBV_SIGMA_DN and R_LO_PHOTOGEO) 
    m_g_err_dn real NOT NULL, --/U mag --/D   Uncertainty on the lower (brighter) side for absolute G-band magnitude (estimated using EBV+EBV_SIGMA_UP and R_HI_PHOTOGEO) 
    bprpc real NOT NULL, --/U mag --/D   Extinction-corrected BP-RP color
    bprpc_err_up real NOT NULL, --/U mag --/D   Uncertainty on the redder side for the extinction-corrected BP-RP color (propagated using EBV, EBV_SIGMA_DN, and uncertainty on BP and RP magnitudes)
    bprpc_err_dn real NOT NULL, --/U mag --/D   Uncertainty on the bluer side for the extinction-corrected BP-RP color (propagated using EBV, EBV_SIGMA_UP, and uncertainty on BP and RP magnitudes)
    dustclean bigint NOT NULL, --/U  --/D   A value of 1 indicates there is a valid reddening estimate.
    goodstars bigint NOT NULL, --/U  --/D   A value of 1 indicates the star belongs to the GOODSTARS set. This is always true in this table.
    simbad_main_id varchar(40) NOT NULL, --/U  --/D   Main ID of the star on Simbad.
    otype_s varchar(20) NOT NULL, --/U  --/D   Object type given by Simbad.
    sp_type varchar(20) NOT NULL, --/U  --/D   Spectral type given by Simbad.
    sp_qual varchar(1) NOT NULL, --/U  --/D   Quality of the spectral type determination (A:best, E:worst).
    sp_bibcode varchar(20) NOT NULL, --/U  --/D   Reference of the spectral type determination
    mk_ds varchar(10) NOT NULL, --/U  --/D   Dispersive system used for the MK/MSS spectral type determination
    mk_spectral_type varchar(20) NOT NULL, --/U  --/D   Simbad Morgan-Keenan (MK) spectral type
    mk_bibcode varchar(20) NOT NULL, --/U  --/D   Reference of the MK spectral type
    ps1_nmag_ok_g smallint NOT NULL, --/F PS1_NMAG_OK 0 --/U mag --/D   Number of detections for the object in PS1 g filter.  
    ps1_nmag_ok_r smallint NOT NULL, --/F PS1_NMAG_OK 1 --/U mag --/D   Number of detections for the object in PS1 r filter.  
    ps1_nmag_ok_i smallint NOT NULL, --/F PS1_NMAG_OK 2 --/U mag --/D   Number of detections for the object in PS1 i filter.  
    ps1_nmag_ok_z smallint NOT NULL, --/F PS1_NMAG_OK 3 --/U mag --/D   Number of detections for the object in PS1 z filter.  
    ps1_nmag_ok_y smallint NOT NULL, --/F PS1_NMAG_OK 4 --/U mag --/D   Number of detections for the object in PS1 y filter.  
    ps1_mean_g real NOT NULL, --/F PS1_MEAN 0 --/U maggies --/D   Mean flux among all okay detections in PS1 g.  
    ps1_mean_r real NOT NULL, --/F PS1_MEAN 1 --/U maggies --/D   Mean flux among all okay detections in PS1 r.  
    ps1_mean_i real NOT NULL, --/F PS1_MEAN 2 --/U maggies --/D   Mean flux among all okay detections in PS1 i.  
    ps1_mean_z real NOT NULL, --/F PS1_MEAN 3 --/U maggies --/D   Mean flux among all okay detections in PS1 z.  
    ps1_mean_y real NOT NULL, --/F PS1_MEAN 4 --/U maggies --/D   Mean flux among all okay detections in PS1 y.  
    ps1_err_g real NOT NULL, --/F PS1_ERR 0 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 g.  
    ps1_err_r real NOT NULL, --/F PS1_ERR 1 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 r.  
    ps1_err_i real NOT NULL, --/F PS1_ERR 2 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 i.  
    ps1_err_z real NOT NULL, --/F PS1_ERR 3 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 z.  
    ps1_err_y real NOT NULL, --/F PS1_ERR 4 --/U maggies --/D   Formal uncertainty of the mean flux estimate in PS1 y.  
    ps1_stdev_g real NOT NULL, --/F PS1_STDEV 0 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 g.  
    ps1_stdev_r real NOT NULL, --/F PS1_STDEV 1 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 r.  
    ps1_stdev_i real NOT NULL, --/F PS1_STDEV 2 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 i.  
    ps1_stdev_z real NOT NULL, --/F PS1_STDEV 3 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 z.  
    ps1_stdev_y real NOT NULL, --/F PS1_STDEV 4 --/U maggies --/D   Standard deviation of the flux among all okay detections in PS1 y.  
    ps1_median_g real NOT NULL, --/F PS1_MEDIAN 0 --/U maggies --/D   Median flux in PS1 g.  
    ps1_median_r real NOT NULL, --/F PS1_MEDIAN 1 --/U maggies --/D   Median flux in PS1 r.  
    ps1_median_i real NOT NULL, --/F PS1_MEDIAN 2 --/U maggies --/D   Median flux in PS1 i.  
    ps1_median_z real NOT NULL, --/F PS1_MEDIAN 3 --/U maggies --/D   Median flux in PS1 z.  
    ps1_median_y real NOT NULL, --/F PS1_MEDIAN 4 --/U maggies --/D   Median flux in PS1 y.  
    ps1_q25_g real NOT NULL, --/F PS1_Q25 0 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 g.  
    ps1_q25_r real NOT NULL, --/F PS1_Q25 1 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 r.  
    ps1_q25_i real NOT NULL, --/F PS1_Q25 2 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 i.  
    ps1_q25_z real NOT NULL, --/F PS1_Q25 3 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 z.  
    ps1_q25_y real NOT NULL, --/F PS1_Q25 4 --/U maggies --/D   25-th percentile flux among all okay detections in PS1 y.  
    ps1_q75_g real NOT NULL, --/F PS1_Q75 0 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 g.  
    ps1_q75_r real NOT NULL, --/F PS1_Q75 1 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 r.  
    ps1_q75_i real NOT NULL, --/F PS1_Q75 2 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 i.  
    ps1_q75_z real NOT NULL, --/F PS1_Q75 3 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 z.  
    ps1_q75_y real NOT NULL, --/F PS1_Q75 4 --/U maggies --/D   75-th percentile flux among all okay detections in PS1 y.  
    ps1_median_ap_g real NOT NULL, --/F PS1_MEDIAN_AP 0 --/U maggies --/D   Median aperture flux among all okay detections in PS1 g.  
    ps1_median_ap_r real NOT NULL, --/F PS1_MEDIAN_AP 1 --/U maggies --/D   Median aperture flux among all okay detections in PS1 r.  
    ps1_median_ap_i real NOT NULL, --/F PS1_MEDIAN_AP 2 --/U maggies --/D   Median aperture flux among all okay detections in PS1 i.  
    ps1_median_ap_z real NOT NULL, --/F PS1_MEDIAN_AP 3 --/U maggies --/D   Median aperture flux among all okay detections in PS1 z.  
    ps1_median_ap_y real NOT NULL, --/F PS1_MEDIAN_AP 4 --/U maggies --/D   Median aperture flux among all okay detections in PS1 y.  
    ps1_obj_id bigint NOT NULL, --/U  --/D   Unique object identifier in PS1. A value of zero means the object has no match in the PS1 catalog.
)
GO
--



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodstars_params')
	DROP TABLE mastar_goodstars_params
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodstars_params'
GO
CREATE TABLE mastar_goodstars_params (
------------------------------------------------------------------------------
--/H Summary file of all of the good stars in the stellar parameter VAC for 
--/H the MaNGA Stellar Libary (MaStar).
------------------------------------------------------------------------------
--/T Summary information for stars with at least one high quality 
--/T visit-spectrum.
------------------------------------------------------------------------------
    drpver varchar(8) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(8) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(25) NOT NULL, --/U  --/D   MaNGA-ID for the target.
    minmjd int NOT NULL, --/U  --/D   Minimum Modified Julian Date of Observations.
    maxmjd int NOT NULL, --/U  --/D   Maximum Modified Julian Date of Observations.
    nvisits smallint NOT NULL, --/U  --/D   Number of visits for this star (including good and bad observations).
    nplates smallint NOT NULL, --/U  --/D   Number of plates this star is on.
    ngoodvisits smallint NOT NULL, --/U  --/D
    ra float NOT NULL, --/U deg --/D   Right Ascension for this object at the time given by the EPOCH column (Equinox J2000).
    dec float NOT NULL, --/U deg --/D   Declination for this object at the time given by the EPOCH column (Equinox J2000).
    epoch real NOT NULL, --/U  --/D   Epoch of the astrometry (which is approximate for some catalogs).
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    teff_med real NOT NULL, --/U K --/D   Median effective temperature among groups with valid measurements
    logg_med real NOT NULL, --/U log(cm/s^2) --/D   Median surface gravity among groups with valid measurements
    feh_med real NOT NULL, --/U  --/D   Median [Fe/H] among groups with valid measurements 
    feh_cal_med real NOT NULL, --/U  --/D   Median calibrated [Fe/H] among groups with valid measurements (calibrated using crossmatch with APOGEE to stellar parameters derived by ASPCAP). 
    alpha_med real NOT NULL, --/U  --/D   Median [alpha/Fe] among groups with valid measurements
    zh_med real NOT NULL, --/U  --/D   Median [Z/H] computed based on FEH_MED and ALPHA_MED.
    zh_cal_med real NOT NULL, --/U  --/D   Median calibrated [Z/H] computed based on FEH_CAL_MED and ALPHA_MED.
    teff_med_err real NOT NULL, --/U K --/D   Uncertainty of the median effective temperature (median absolute deviation among groups or the median uncertainty among groups, whichever is larger)
    logg_med_err real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the median surface gravity (median absolute deviation among groups or the median uncertainty among groups, whichever is larger)
    feh_med_err real NOT NULL, --/U  --/D   Uncertainty of the median [Fe/H] (median absolute deviation among groups or the median uncertainty among groups, whichever is larger)
    feh_cal_med_err real NOT NULL, --/U  --/D   Uncertainty of the median calibrated [Fe/H] (median absolute deviation among groups or the median uncertainty among groups, whichever is larger)
    alpha_med_err real NOT NULL, --/U  --/D   Uncertainty of the median [alpha/Fe] (median absolute deviation among groups or the median uncertainty among groups, whichever is larger)
    zh_med_err real NOT NULL, --/U  --/D   Propagated uncertainty of the computed [Z/H] 
    zh_cal_med_err real NOT NULL, --/U  --/D   Propagated uncertainty of the computed, calibrated [Z/H] 
    ngroups smallint NOT NULL, --/U  --/D   Number of groups whose median measurements are used to derive the median parameters for Teff, logg, and [Fe/H].
    input_groups_0 smallint NOT NULL, --/F INPUT_GROUPS 0 --/U  --/D   Flag indicating whether the measurement of JI contributed to the median. 1 means yes and 0 means no.
    input_groups_1 smallint NOT NULL, --/F INPUT_GROUPS 1 --/U  --/D   Flag indicating whether the measurement of DL contributed to the median. 1 means yes and 0 means no.
    input_groups_2 smallint NOT NULL, --/F INPUT_GROUPS 2 --/U  --/D   Flag indicating whether the measurement of LH contributed to the median. 1 means yes and 0 means no.
    input_groups_3 smallint NOT NULL, --/F INPUT_GROUPS 3 --/U  --/D   Flag indicating whether the measurement of YC contributed to the median. 1 means yes and 0 means no.
    input_groups_name varchar(20) NOT NULL, --/U  --/D   Letter abbreviations of the groups from which the median measurements for Teff, logg, and [Fe/H] are based on.
    nalphagroups smallint NOT NULL, --/U  --/D   Number of groups whose measurements are used to derive the median [alpha/Fe].
    input_alpha_groups_0 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 0 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of JI contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_1 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 1 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of DL contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_2 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 2 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of LH contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_3 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 3 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of YC contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_name varchar(32) NOT NULL, --/U  --/D   Letter abbreviations of the groups from which the median [alpha/Fe] measurement is based on.
    teff_ji real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Julie Imig (JI hereafter). 
    logg_ji real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) urface gravity derived by JI
    feh_ji real NOT NULL, --/U  --/D   Median (among visits) [Fe/H] derived by JI
    alpha_ji real NOT NULL, --/U  --/D   Median (among visits) [alpha/Fe] derived by JI
    vmicro_ji real NOT NULL, --/U log(km/s) --/D   Median (among visits) micro-turbulence velocity derived by JI
    teff_err_ji real NOT NULL, --/U K --/D   Uncertainty of the effective temperature derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    logg_err_ji real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the surface gravity derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    feh_err_ji real NOT NULL, --/U  --/D   Uncertainty of the [Fe/H] derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    alpha_err_ji real NOT NULL, --/U  --/D   Uncertainty of the [alpha/Fe] derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    vmicro_err_ji real NOT NULL, --/U log(km/s) --/D   Uncertainty of the micro-turbulence velocity derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    valid_ji smallint NOT NULL, --/U  --/D   Flag indicating quality of the fit performed by JI. A value of 1 means good, and 0 means bad.
    teff_dl real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Daniel Lazarz (DL hereafter)
    logg_dl real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) surface gravity derived by DL
    feh_dl real NOT NULL, --/U  --/D   Median (among visits) [Fe/H] derived by DL
    alpha_dl real NOT NULL, --/U  --/D  Median (among visits) [alpha/Fe] derived by DL 
    teff_err_dl real NOT NULL, --/U K --/D  Uncertainty of the median effective temperature derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    logg_err_dl real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the median surface gravity derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    feh_err_dl real NOT NULL, --/U  --/D   Uncertainty of the median [Fe/H] derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    alpha_err_dl real NOT NULL, --/U  --/D   Uncertainty of the median [alpha/Fe] derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    av_dl real NOT NULL, --/U mag --/D   Median extinction (among visits) in V-band derived by DL
    av_err_dl real NOT NULL, --/U mag --/D   Uncertainty of the extinction derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    av_valid_dl smallint NOT NULL, --/U  --/D   Flag indicating validity of the extinction estimate. A value of 1 means good, and 0 means bad
    valid_dl smallint NOT NULL, --/U  --/D   Flag indicating quality of the fit performed by DL. A value of 1 means good, and 0 means bad
    teff_lh real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Lewis Hill (hereafter LH) 
    logg_lh real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) surface gravity derived by LH
    feh_lh real NOT NULL, --/U  --/D  Median (among visits) [Fe/H] derived by LH 
    alpha_lh real NOT NULL, --/U  --/D   Median (among visits) [alpha/Fe] derived by LH 
    teff_err_lh real NOT NULL, --/U K --/D   Uncertainty of the median effective temperature derived by LH (median absolute deviation or the median uncertainty among visits, whichever is larger)
    logg_err_lh real NOT NULL, --/U log(cm/s^2) --/D  Uncertainty of the median surface gravity derived by LH (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    feh_err_lh real NOT NULL, --/U  --/D   Uncertainty of the median [Fe/H] derived by LH (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    alpha_err_lh real NOT NULL, --/U  --/D   Uncertainty of the median [alpha/Fe] derived by LH (median absolute deviation or the median uncertainty among visits, whichever is larger)
    valid_lh smallint NOT NULL, --/U  --/D  Flag indicating quality of the fit performed by LH. A value of 1 means good, and 0 means bad. 
    teff_yc real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Yanping Chen (hereafter YC)
    logg_yc real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) surface gravity derived by YC 
    feh_yc real NOT NULL, --/U  --/D   Median (among visits) [Fe/H] derived by YC
    alpha_yc real NOT NULL, --/U  --/D   Median (among visits) [alpha/Fe] derived by YC
    teff_err_yc real NOT NULL, --/U K --/D   Uncertainty of the median effective temperature derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    logg_err_yc real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the median surface gravity derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    feh_err_yc real NOT NULL, --/U  --/D   Uncertainty of the median [Fe/H] derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    alpha_err_yc real NOT NULL, --/U  --/D   Uncertainty of the median [alpha/Fe] derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    valid_yc smallint NOT NULL, --/U  --/D   Flag indicating quality of the fit performed by YC. A value of 1 means good, and zero means bad.
)
GO
--




--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mastar_goodvisits_params')
	DROP TABLE mastar_goodvisits_params
GO
--
EXEC spSetDefaultFileGroup 'mastar_goodvisits_params'
GO
CREATE TABLE mastar_goodvisits_params (
------------------------------------------------------------------------------
--/H Summary file of the good visits of good stars in the stellar parameter 
--/H VAC for the MaNGA Stellar Libary (MaStar).
------------------------------------------------------------------------------
--/T Summary information for all of the good visits of the good stars.
------------------------------------------------------------------------------
    drpver varchar(8) NOT NULL, --/U  --/D   Version of mangadrp.
    mprocver varchar(8) NOT NULL, --/U  --/D   Version of mastarproc.
    mangaid varchar(25) NOT NULL, --/U  --/D   MaNGA-ID for the object.
    plate int NOT NULL, --/U  --/D   Plate ID.
    ifudesign varchar(6) NOT NULL, --/U  --/D   IFUDESIGN for the fiber bundle.
    mjd int NOT NULL, --/U  --/D   Modified Julian Date for this visit.
    ra float NOT NULL, --/U deg --/D   Right Ascension for this object at the time given by the EPOCH column (Equinox J2000).
    dec float NOT NULL, --/U deg --/D   Declination for this object at the time given by the EPOCH column (Equinox J2000).
    epoch real NOT NULL, --/U  --/D   Epoch of the astrometry (which is approximate for some catalogs).
    ifura float NOT NULL, --/U deg --/D   Right Ascension of the center of the IFU.
    ifudec float NOT NULL, --/U deg --/D   Declination of the center of the IFU.
    mngtarg2 int NOT NULL, --/U  --/D   MANGA_TARGET2 targeting bitmask.
    mjdqual int NOT NULL, --/U  --/D   Spectral quality bitmask (MASTAR_QUAL).
    teff_med real NOT NULL, --/U K --/D   Median effective temperature among all valid measurements
    logg_med real NOT NULL, --/U log(cm/s^2) --/D   Median surface gravity among all valid measurements
    feh_med real NOT NULL, --/U  --/D   Median [Fe/H] among all valid measurements 
    feh_cal_med real NOT NULL, --/U  --/D   Median calibrated [Fe/H] among all valid measurements (calibrated using crossmatch with APOGEE to stellar parameters derived by ASPCAP). 
    alpha_med real NOT NULL, --/U  --/D   Median [alpha/Fe] among all valid measurements
    zh_med real NOT NULL, --/U  --/D   Median [Z/H] among all valid measurements (computed based on FEH_MED and ALPHA_MED).
    zh_cal_med real NOT NULL, --/U  --/D  Median calibrated [Z/H] among all valid measurements (computed based on FEH_CAL_MED and ALPHA_MED). 
    teff_med_err real NOT NULL, --/U K --/D   Uncertainty of the median effective temperature (derived using median absolute deviation among groups or the median uncertainty among groups, whichever is larger)
    logg_med_err real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the median surface gravity (derived using median absolute deviation among groups or the median uncertainty among groups, whichever is larger)
    feh_med_err real NOT NULL, --/U  --/D   Uncertainty of the median [Fe/H] (derived using median absolute deviation among groups or the median uncertainty among groups,whichever is larger)
    feh_cal_med_err real NOT NULL, --/U  --/D   Uncertainty of the median calibrated [Fe/H] (derived using median absolute deviation among groups or the median uncertainty among groups,whichever is larger)
    alpha_med_err real NOT NULL, --/U  --/D   Uncertainty of the median [alpha/Fe] (derived using median absolute deviation among groups or the median uncertainty among groups,whichever is larger)
    zh_med_err real NOT NULL, --/U  --/D   Propagated uncertainty of the computed [Z/H] 
    zh_cal_med_err real NOT NULL, --/U  --/D   Propagated uncertainty of the computed, calibrated [Z/H] 
    ngroups smallint NOT NULL, --/U  --/D   Number of groups whose measurements are used to derive the median parameters for Teff, logg, and [Fe/H].
    input_groups_0 smallint NOT NULL, --/F INPUT_GROUPS 0 --/U  --/D   Flag indicating whether the measurement of JI contributed to the median. 1 means yes and 0 means no.
    input_groups_1 smallint NOT NULL, --/F INPUT_GROUPS 1 --/U  --/D   Flag indicating whether the measurement of DL contributed to the median. 1 means yes and 0 means no.
    input_groups_2 smallint NOT NULL, --/F INPUT_GROUPS 2 --/U  --/D   Flag indicating whether the measurement of LH contributed to the median. 1 means yes and 0 means no.
    input_groups_3 smallint NOT NULL, --/F INPUT_GROUPS 3 --/U  --/D   Flag indicating whether the measurement of YC contributed to the median. 1 means yes and 0 means no.
    input_groups_name varchar(20) NOT NULL, --/U  --/D   Letter abbreviations of the groups from which the median measurements for Teff, logg, and [Fe/H] are based on.
    nalphagroups smallint NOT NULL, --/U  --/D   Number of groups whose measurements are used to derive the median [alpha/Fe].
    input_alpha_groups_0 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 0 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of JI contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_1 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 1 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of DL contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_2 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 2 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of LH contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_3 smallint NOT NULL, --/F INPUT_ALPHA_GROUPS 3 --/U  --/D   Flag indicating whether the [alpha/Fe] measurement of YC contributed to the median.  1 means yes and 0 means no.
    input_alpha_groups_name varchar(32) NOT NULL, --/U  --/D   Letter abbreviations of the groups from which the median [alpha/Fe] measurement is based on.
    teff_ji real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Julie Imig (JI hereafter). 
    logg_ji real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) surface gravity derived by JI
    feh_ji real NOT NULL, --/U  --/D   Median (among visits) [Fe/H] derived by JI
    alpha_ji real NOT NULL, --/U  --/D   Median (among visits) [alpha/Fe] derived by JI
    vmicro_ji real NOT NULL, --/U log(km/s) --/D   Median (among visits) micro-turbulence velocity derived by JI
    teff_err_ji real NOT NULL, --/U K --/D   Uncertainty of the effective temperature derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    logg_err_ji real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the surface gravity derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    feh_err_ji real NOT NULL, --/U  --/D   Uncertainty of the [Fe/H] derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    alpha_err_ji real NOT NULL, --/U  --/D   Uncertainty of the [alpha/Fe] derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    vmicro_err_ji real NOT NULL, --/U log(km/s) --/D   Uncertainty of the micro-turbulence velocity derived by JI (median absolute deviation or the median uncertainty among visits, whichever is larger)
    chisq_ji real NOT NULL, --/U  --/D   reduced chi-square of the fit performed by JI
    valid_ji smallint NOT NULL, --/U  --/D   Flag indicating quality of the fit performed by JI. A value of 1 means good, and 0 means bad.
    teff_dl real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Daniel Lazarz (DL hereafter)
    logg_dl real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) surface gravity derived by DL
    feh_dl real NOT NULL, --/U  --/D   Median (among visits) [Fe/H] derived by DL
    alpha_dl real NOT NULL, --/U  --/D  Median (among visits) [alpha/Fe] derived by DL 
    teff_err_dl real NOT NULL, --/U K --/D  Uncertainty of the median effective temperature derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    logg_err_dl real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the median surface gravity derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    feh_err_dl real NOT NULL, --/U  --/D   Uncertainty of the median [Fe/H] derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    alpha_err_dl real NOT NULL, --/U  --/D   Uncertainty of the median [alpha/Fe] derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    chisq_dl real NOT NULL, --/U  --/D   Reduced chi-square of the fit performed by DL
    av_dl real NOT NULL, --/U mag --/D   Median extinction (among visits) in V-band derived by DL
    av_err_dl real NOT NULL, --/U mag --/D   Uncertainty of the extinction derived by DL (median absolute deviation or the median uncertainty among visits, whichever is larger)
    av_chisq_dl real NOT NULL, --/U  --/D   Reduced chi-square of the extinction fit performed by DL
    av_valid_dl smallint NOT NULL, --/U  --/D   Flag indicating validity of the extinction estimate. A value of 1 means good, and 0 means bad
    valid_dl smallint NOT NULL, --/U  --/D   Flag indicating quality of the fit performed by DL. A value of 1 means good, and 0 means bad
    teff_lh real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Lewis Hill (hereafter LH) 
    logg_lh real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) surface gravity derived by LH
    feh_lh real NOT NULL, --/U  --/D  Median (among visits) [Fe/H] derived by LH 
    alpha_lh real NOT NULL, --/U  --/D   Median (among visits) [alpha/Fe] derived by LH 
    teff_err_up_lh real NOT NULL, --/U K --/D   Upward uncertainty of effective temperature derived by LH
    teff_err_dn_lh real NOT NULL, --/U K --/D   Downward uncertainty of effective temperature derived by LH
    logg_err_up_lh real NOT NULL, --/U log(cm/s^2) --/D   Upward uncertainty of surface gravity derived by LH
    logg_err_dn_lh real NOT NULL, --/U log(cm/s^2) --/D   Downward uncertainty of surface gravity derived by LH
    feh_err_up_lh real NOT NULL, --/U  --/D   Upward uncertainty of [Fe/H] derived by LH
    feh_err_dn_lh real NOT NULL, --/U  --/D   Downward uncertainty of [Fe/H] derived by LH
    alpha_err_up_lh real NOT NULL, --/U  --/D   Upward uncertainty of [alpha/Fe] derived by LH
    alpha_err_dn_lh real NOT NULL, --/U  --/D   Downward uncertainty of [alpha/Fe] derived by LH
    chisq_lh real NOT NULL, --/U  --/D   Reduced chi-square of the fit performed by LH
    model_lh varchar(10) NOT NULL, --/U  --/D   Template set used by LH for this visit-spectrum. It is either 'BOSZ' or 'MARCS'.
    valid_lh smallint NOT NULL, --/U  --/D  Flag indicating quality of the fit performed by LH. A value of 1 means good, and 0 means bad. 
    teff_yc real NOT NULL, --/U K --/D   Median (among visits) effective temperature derived by Yanping Chen (hereafter YC)
    logg_yc real NOT NULL, --/U log(cm/s^2) --/D   Median (among visits) surface gravity derived by YC 
    feh_yc real NOT NULL, --/U  --/D   Median (among visits) [Fe/H] derived by YC
    alpha_yc real NOT NULL, --/U  --/D   Median (among visits) [alpha/Fe] derived by YC
    teff_err_yc real NOT NULL, --/U K --/D   Uncertainty of the median effective temperature derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    logg_err_yc real NOT NULL, --/U log(cm/s^2) --/D   Uncertainty of the median surface gravity derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    feh_err_yc real NOT NULL, --/U  --/D   Uncertainty of the median [Fe/H] derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    alpha_err_yc real NOT NULL, --/U  --/D   Uncertainty of the median [alpha/Fe] derived by YC (median absolute deviation or the median uncertainty among visits, whichever is larger) 
    chisq_yc real NOT NULL, --/U  --/D   Reduced chi-square of the fit performed by YC
    model_yc varchar(10) NOT NULL, --/U  --/D   Template set used by YC for this visit-spectrum. It is either 'BOSZ' or 'MARCS'.
    valid_yc smallint NOT NULL, --/U  --/D   Flag indicating quality of the fit performed by YC. A value of 1 means good, and zero means bad.
)
GO
--



EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[MastarTables.sql]: Mastar tables created'
GO