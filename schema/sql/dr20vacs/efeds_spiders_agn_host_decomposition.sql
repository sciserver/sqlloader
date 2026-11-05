create table efeds_spiders_agn_host_decomposition (
    ------- 
    --/H eFEDS SPIDERS AGN stellar population and host-galaxy properties (host decomposition with pPXF).
    --/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
    --/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
    --/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
    --/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
    --/T Also provided are the X-ray and public photometric data.
    ------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source name (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of Hard sample eROSITA source (Brunner+2022) 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from visual inspection (Aydar+2025) 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension (J2000) 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination (J2000) 
    mjd int NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    hg_subtraction bit NOT NULL, --/U  --/D True: host-galaxy emission subtracted; False: quasar-dominated 
    reduced_chi2 float NOT NULL, --/U  --/D Reduced chi2 from pPXF fit 
    f_agn float NOT NULL, --/U  --/D AGN continuum (PL+Fe II+Balmer) weight to continuum fit 
    f_hg float NOT NULL, --/U  --/D Host galaxy continuum (SSP) weight to continuum fit 
    stellar_mass_flux_msun_r float NOT NULL, --/U Msun --/D Stellar mass within aperture from the spectral flux in DECam r 
    apcorr_factor float NOT NULL, --/U  --/D Aperture correction factor (Aydar+2026a) 
    stellar_mass_msun_r_apcorr float NOT NULL, --/U Msun --/D Aperture corrected stellar mass from the spectral flux in DECam r 
    stellar_mass_flux_msun_g float NOT NULL, --/U Msun --/D Stellar mass within aperture from the spectral flux in DECam g 
    velocity_dispersion_stars float NOT NULL, --/U km/s --/D Stellar velocity dispersion (second term of kinematic fit) 
    velocity_dispersion_stars_error float NOT NULL, --/U km/s --/D Stellar velocity dispersion error 
    velocity_stars float NOT NULL, --/U km/s --/D Stellar velocity (first term of kinematic fit) 
    velocity_stars_error float NOT NULL, --/U km/s --/D Stellar velocity error 
    specz_normc_specz varchar(6) NOT NULL, --/U  --/D Final normalised classification (Aydar+2025) 
    plate int NOT NULL, --/U  --/D SDSS PLATE 
    fiberid int NOT NULL, --/U  --/D SDSS FIBER ID 
    catalogid bigint NOT NULL, --/U  --/D SDSS CATALOGID 
    run2d varchar(7) NOT NULL, --/U  --/D Tagged version of idlspec2d used to reduce the SDSS BOSS spectra 
    sn_median_all float NOT NULL, --/U  --/D SDSS Median S/N per pix in spectrum (idlspec2d v6_0_2 reductions) 
    ctp_ls8_type varchar(4) NOT NULL, --/U  --/D Morphological model from LS8 
    ls8_g float NOT NULL, --/U mag --/D LS8 g-band magnitude (AB) 
    ls8_r float NOT NULL, --/U mag --/D LS8 r-band magnitude (AB) 
    flux_decam_r float NOT NULL, --/U erg/s/cm2 --/D Spectral flux integrated in the DECam r band coverage 
    d4000 float NOT NULL, --/U  --/D D4000 break measurement from observed spectrum 
    d4000_error float NOT NULL, --/U  --/D D4000 break measurement from observed spectrum error 
    log_mean_age_yr_light float NOT NULL, --/U  --/D Mean light-weighted age from SSP fits (log, yr) 
    mean_metallicity_zsun_light float NOT NULL, --/U Zsun --/D Mean light-weighted metallicity from SSP fits 
    log_mean_age_yr_mass float NOT NULL, --/U  --/D Mean mass-weighted age from SSP fits (log, yr) 
    mean_metallicity_zsun_mass float NOT NULL, --/U Zsun --/D Mean mass-weighted metallicity from SSP fits 
    mass_to_light_decamr float NOT NULL, --/U  --/D Mass to light ratio from the spectral flux in DECam r 
    logl_decamr_ssp float NOT NULL, --/U  --/D SSP luminosity from the spectral flux in DECam r (log, erg/s) 
    mass_to_light_decamg float NOT NULL, --/U  --/D Mass to light ratio from the spectral flux in DECam g 
    logl_decamg_ssp float NOT NULL, --/U  --/D SSP luminosity from the spectral flux in DECam g (log, erg/s) 
    logl5100_ssp float NOT NULL, --/U  --/D SSP luminosity at 5100 A (log, erg/s) 
    logl5100_agn float NOT NULL, --/U  --/D AGN luminosity at 5100 A (log, erg/s) 
    logl5100_obs float NOT NULL, --/U  --/D Observed luminosity at 5100 A (log, erg/s) 
    weight_ssp float NOT NULL, --/U  --/D Simple Stellar Population templates weight to total fit 
    weight_narrowlines float NOT NULL, --/U  --/D Narrow emission lines template weight to total fit 
    weight_broadlines float NOT NULL, --/U  --/D Broad emission lines template weight to total fit 
    weight_feii float NOT NULL, --/U  --/D Fe II pseudo-continuum template weight to total fit 
    weight_powerlaw float NOT NULL, --/U  --/D Power-law templates weight to total fit 
    weight_balmer float NOT NULL, --/U  --/D Balmer continuum and high-order templates weight to total fit 
    log_age_yr_1 float NOT NULL, --/U  --/D Age of SSP with highest weight (log, yr) 
    metallicity_zsun_1 float NOT NULL, --/U Zsun --/D Metallicity of SSP with highest weight 
    weight_1 float NOT NULL, --/U  --/D Weight of SSP with highest weight 
    log_age_yr_2 float NOT NULL, --/U  --/D Age of SSP with second highest weight (log, yr) 
    metallicity_zsun_2 float NOT NULL, --/U Zsun --/D Metallicity of SSP with second highest weight 
    weight_2 float NOT NULL, --/U  --/D Weight of SSP with second highest weight 
    log_age_yr_3 float NOT NULL, --/U  --/D Age of SSP with third highest weight (log, yr) 
    metallicity_zsun_3 float NOT NULL, --/U Zsun --/D Metallicity of SSP with third highest weight 
    weight_3 float NOT NULL, --/U  --/D Weight of SSP with third highest weight 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
);
