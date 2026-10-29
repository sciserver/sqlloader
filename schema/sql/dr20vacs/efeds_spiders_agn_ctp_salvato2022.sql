create table efeds_spiders_agn_ctp_salvato2022 (
    ------- 
    --/H eFEDS SPIDERS AGN photometric counterpart catalogue and multi-wavelength photometry from Salvato et al. (2022) 
    --/T This table is part of the SPIDERS (SDSS and eROSITA) AGN fitting results data set, which involves 
    --/T measurements of the optical spectral fits of X-ray-selected Active Galactic Nuclei within 
    --/T the SPIDERS program (Spectroscopic Identification of ERosita Sources) in the eFEDS field. 
    --/T These objects were detected with eROSITA and followed up with SDSS (DR18). 
    --/T Also provided are the X-ray and public photometric data.
    ------- 
    objid varchar(23) NOT NULL, --/U  --/D SDSS Object ID, either PLATE-MJD-FIBERID or PLATE-MJD-CATALOGID 
    ero_name varchar(22) NOT NULL, --/U  --/D eROSITA official source Name (Brunner+2022) 
    sample varchar(4) NOT NULL, --/U  --/D Main or Hard sample from eROSITA (Brunner+2022) 
    ero_id_main int NOT NULL, --/U  --/D ID of Main sample eROSITA source (Brunner+2022) 
    ero_id_hard int NOT NULL, --/U  --/D ID of eROSITA source in the Hard Sample 
    specz_redshift real NOT NULL, --/U  --/D Spectroscopic redshift from the original catalogue 
    ra_sdss float NOT NULL, --/U deg --/D SDSS right ascension sky coordinate of spectroscopic fibre 
    dec_sdss float NOT NULL, --/U deg --/D SDSS declination sky coordinate of spectroscopic fibre 
    mjd int NOT NULL, --/U  --/D SDSS modified Julian date of observation 
    ctp_ls8_unique_objid varchar(11) NOT NULL, --/U  --/D LS8 unique identifier for the counterpart to the eROSITA source (Exp 
    ctp_ls8_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the LS8 counterpart 
    ctp_ls8_dec float NOT NULL, --/U deg --/D J2000 Declination of the LS8 counterpart 
    specz_n_specz int NOT NULL, --/U  --/D Total number of spec_z associated with this Legacy Survey DR9 object 
    specz_normq_specz int NOT NULL, --/U  --/D Normalised quality of spectroscopic redshift: 3=secure, 2=not secure 
    specz_normc_specz varchar(8) NOT NULL, --/U  --/D Final normalised classification determined for this object 
    specz_hasvi_specz bit NOT NULL, --/U  --/D True if best spec-z for this object has a visual inspection 
    specz_catcode_specz varchar(12) NOT NULL, --/U  --/D Catalogue code of best spec-z for this object 
    specz_bitmask_specz bigint NOT NULL, --/U  --/D Bitmask encoding catalogues containing spec-z for this object. Bit e 
    plate int NOT NULL, --/U  --/D SDSS plate 
    fiberid int NOT NULL, --/U  --/D SDSS FIBER ID 
    field int NOT NULL, --/U  --/D SDSS field sequence number 
    catalogid bigint NOT NULL, --/U  --/D SDSS CATALOGID (used before the unification with SDSS_ID) 
    run2d varchar(7) NOT NULL, --/U  --/D Tagged version of idlspec2d used to reduce the SDSS BOSS spectra 
    dr varchar(4) NOT NULL, --/U  --/D SDSS Data Release version 
    url varchar(131) NOT NULL, --/U  --/D SDSS url to (internal) access observed spectrum 
    sep_ls8_sdss float NOT NULL, --/U arcsec --/D Distance between matched objects along a great circle 
    sn_median_all float NOT NULL, --/U  --/D SDSS Median S/N per pix in spectrum (idlspec2d v6_0_2 reductions) 
    z float NOT NULL, --/U  --/D SDSS Pipeline redshift in idlspec2d eFEDS v6_0_2 reductions 
    z_err float NOT NULL, --/U  --/D SDSS Pipeline redshift uncertainty in idlspec2d eFEDS v6_0_2 reducti 
    zwarning float NOT NULL, --/U  --/D SDSS Pipeline redshift warning flags in idlspec2d eFEDS v6_0_2 reduc 
    ero_ra_corr float NOT NULL, --/U deg --/D J2000 Right Ascension of the eROSITA source (corrected) 
    ero_dec_corr float NOT NULL, --/U deg --/D J2000 Declination of the eROSITA source (corrected) 
    ero_radec_error_corr float NOT NULL, --/U deg --/D eROSITA positional uncertainty (corrected) 
    ero_ml_flux real NOT NULL, --/U erg / (cm2 s) --/D 0.2-2.3 keV source flux converted from count rate assuming ECF=1.074 
    ero_ml_flux_err real NOT NULL, --/U erg / (cm2 s) --/D 2.3-5 keV source flux error (1 sigma) 
    ero_det_like real NOT NULL, --/U  --/D X-ray detection likelihood measured by PSF-fitting 
    ero_inarea90 bit NOT NULL, --/U  --/D True if in the 0.2-2.3keV exp>500s region, which comprises 90% 
    dist_ctp_ls8_ero float NOT NULL, --/U arcsec --/D Separation between selected counterpart and eROSITA (corrected) posi 
    ctp_nway_ls8_unique_objid varchar(11) NOT NULL, --/U  --/D Unique OBJECTID of the best LS8 counterpart from NWAY (Expression: t 
    ctp_nway_ls8_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the best LS8 counterpart from NWAY 
    ctp_nway_ls8_dec float NOT NULL, --/U deg --/D J2000 Declination of the best LS8 counterpart from NWAY 
    ctp_nway_dist_bayesfactor real NOT NULL, --/U  --/D Logarithm of ratio between prior and posterior, from separation, pos 
    ctp_nway_dist_post real NOT NULL, --/U  --/D Distance probability comparing this association vs. no association ( 
    ctp_nway_p_single real NOT NULL, --/U  --/D Same as dist_post, but weighted by the prior (see Appx. in Salvato e 
    ctp_nway_p_any real NOT NULL, --/U  --/D For each entry in the X-ray catalogue, the probability that there is 
    ctp_nway_p_i real NOT NULL, --/U  --/D Relative probability of the eROSITA/LS8 match (see Appx. in Salvato 
    dist_nway_ls8_ero real NOT NULL, --/U arcsec --/D Separation between the X-ray position and the best LS8 counterparts 
    ctp_mlr_ls8_unique_objid varchar(11) NOT NULL, --/U  --/D LS8 unique identifier of the LS8 counterpart from Maximum Likelihood 
    ctp_mlr_ls8_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the LS8 counterpart 
    ctp_mlr_ls8_dec float NOT NULL, --/U deg --/D J2000 Declination of the best LS8 counterpart 
    ctp_mlr_lr_best float NOT NULL, --/U  --/D Likelihood Ratio value from Maximum Likelihood Ratio technique 
    ctp_mlr_rel_best float NOT NULL, --/U  --/D Reliability of the identification from Maximum Likelihood Ratio tech 
    dist_mlr_ls8_ero float NOT NULL, --/U arcsec --/D Separation between the X-ray position and the best LS8 counterparts 
    ctp_same smallint NOT NULL, --/U  --/D Comparison NWAY/MLR: true if the counterpart selected by the two met 
    ctp_mlr smallint NOT NULL, --/U  --/D Comparison NWAY/MLR: true if the counterpart from NWAY/MLR has p_any 
    ctp_hamstar int NOT NULL, --/U  --/D Match to Hamstar: 1=same counterpart, 0=different counterpart, -99=n 
    ctp_hamstar_p_stellar float NOT NULL, --/U arcsec --/D probability of association from Hamstar 
    dist_ctp_hamstar float NOT NULL, --/U arcsec --/D Separation between Hamstar ctp and NWAY/MLR ctp 
    ctp_quality smallint NOT NULL, --/U  --/D colour: 1=best, 4=best, 3=good, 2=with secondary, 1/0=unreliable. (s 
    gaiaedr3_id bigint NOT NULL, --/U  --/D ID in Gaia EDR3 source catalog 
    gaiaedr3_parallax float NOT NULL, --/U mas --/D Parallax from Gaia EDR3 
    gaiaedr3_parallax_error float NOT NULL, --/U mas --/D Parallax error from Gaia EDR3 
    gaiaedr3_parallax_over_error float NOT NULL, --/U  --/D Parallax/Parallax error, ratio >5 SECURE GALACTIC 
    gaiaedr3_pmra float NOT NULL, --/U mas / yr --/D Proper motion in RA from Gaia EDR3 
    gaiaedr3_pmra_error float NOT NULL, --/U mas / yr --/D Proper motion error in RA from Gaia EDR3 
    gaiaedr3_pmdec float NOT NULL, --/U mas / yr --/D Proper motion in Dec from Gaia EDR3 
    gaiaedr3_pmdec_error float NOT NULL, --/U mas / yr --/D Proper motion error in Dec from Gaia EDR3 
    gaiaedr3_phot_g_mean_mag float NOT NULL, --/U mag --/D g band magnitude (VEGA) from Gaia EDR3 
    gaiaedr3_phot_g_mean_mag_error float NOT NULL, --/U mag --/D Error g band magnitude from Gaia EDR3 
    gaiaedr3_phot_bp_mean_mag float NOT NULL, --/U mag --/D bp band magnitude from Gaia EDR3 
    gaiaedr3_phot_bp_mean_mag_error float NOT NULL, --/U mag --/D Error bp band magnitude from Gaia EDR3 
    gaiaedr3_phot_rp_mean_mag float NOT NULL, --/U mag --/D rp band magnitude (VEGA) from Gaia EDR3 
    gaiaedr3_phot_rp_mean_mag_error float NOT NULL, --/U mag --/D Error rp band magnitude from Gaia EDR3 
    fuv float NOT NULL, --/U mag --/D Galex Far UV magnitude (AB) 
    fuv_err float NOT NULL, --/U mag --/D Galex Far UV magnitude error (AB) 
    nuv float NOT NULL, --/U mag --/D Galex Near UV magnitude (AB) 
    nuv_err float NOT NULL, --/U mag --/D Galex Near UV magnitude error (AB) 
    kids_u float NOT NULL, --/U mag --/D KIDS u-band magnitude 
    kids_u_err float NOT NULL, --/U mag --/D KIDS u-band magnitude error 
    kids_g float NOT NULL, --/U mag --/D KIDS g-band magnitude 
    kids_g_err float NOT NULL, --/U mag --/D KIDS g-band magnitude error 
    kids_r float NOT NULL, --/U mag --/D KIDS r-band magnitude 
    kids_r_err float NOT NULL, --/U mag --/D KIDS r-band magnitude error 
    kids_i float NOT NULL, --/U mag --/D KIDS i-band magnitude 
    kids_i_err float NOT NULL, --/U mag --/D KIDS i-band magnitude error 
    omegac_z smallint NOT NULL, --/U mag --/D OmegaCAM z-band magnitude (AB) 
    omegac_z_err real NOT NULL, --/U mag --/D OmegaCAM z-band magnitude error 
    hsc_g float NOT NULL, --/U mag --/D HSC g-band magnitude (AB) 
    hsc_g_err float NOT NULL, --/U mag --/D HSC g-band magnitude error 
    hsc_r float NOT NULL, --/U mag --/D HSC r-band magnitude (AB) when images are mostly from r-filter (see 
    hsc_r_err float NOT NULL, --/U mag --/D HSC r-band magnitude error 
    hsc_r2 float NOT NULL, --/U mag --/D HSC r2-band magnitude (AB) when images are mostly from r2-filter (se 
    hsc_r2_err float NOT NULL, --/U mag --/D HSC r2-band magnitude error 
    hsc_i float NOT NULL, --/U mag --/D HSC i-band magnitude (AB) when images are mostly from i-filter (see 
    hsc_i_err float NOT NULL, --/U mag --/D HSC i-band magnitude error 
    hsc_i2 float NOT NULL, --/U mag --/D HSC i2-band magnitude (AB) when images are mostly from i2-filter (se 
    hsc_i2_err float NOT NULL, --/U mag --/D HSC i2-band magnitude error 
    hsc_z float NOT NULL, --/U mag --/D HSC z-band magnitude (AB) 
    hsc_z_err float NOT NULL, --/U mag --/D HSC z-band magnitude error 
    hsc_y float NOT NULL, --/U mag --/D HSC Y-band magnitude (AB) 
    hsc_y_err float NOT NULL, --/U mag --/D HSC Y-band magnitude error 
    vista_z float NOT NULL, --/U mag --/D VISTA/VIKING z-band magnitude (AB) 
    vista_z_err float NOT NULL, --/U mag --/D VISTA/VIKING z-band magnitude error 
    vista_y float NOT NULL, --/U mag --/D VISTA/VIKING Y-band magnitude (AB) 
    vista_y_err float NOT NULL, --/U mag --/D VISTA/VIKING Y-band magnitude error 
    vista_j float NOT NULL, --/U mag --/D VISTA/VIKING J-band magnitude (AB) 
    vista_j_err float NOT NULL, --/U mag --/D VISTA/VIKING J-band magnitude error 
    vista_h float NOT NULL, --/U mag --/D VISTA/VIKING H-band magnitude (AB) 
    vista_h_err float NOT NULL, --/U mag --/D VISTA/VIKING H-band magnitude error 
    vista_ks float NOT NULL, --/U mag --/D VISTA/VIKING Ks-band magnitude (AB) 
    vista_ks_err float NOT NULL, --/U mag --/D VISTA/VIKING Ks-band magnitude error 
    w1 float NOT NULL, --/U mag --/D LS8/Wise W1 magnitude (AB) 
    w1_err float NOT NULL, --/U mag --/D LS8/Wise W1 magnitude error 
    w2 float NOT NULL, --/U mag --/D LS8/Wise W2 magnitude (AB) 
    w2_err float NOT NULL, --/U mag --/D LS8/Wise W2 magnitude error 
    w3 float NOT NULL, --/U mag --/D LS8/Wise W3 magnitude (AB) 
    w3_err float NOT NULL, --/U mag --/D LS8/Wise W3 magnitude error 
    w4 float NOT NULL, --/U mag --/D LS8/Wise W4 magnitude (AB) 
    w4_err float NOT NULL, --/U mag --/D LS8/Wise W4 magnitude error 
    ls8_g float NOT NULL, --/U mag --/D LS8 g-band magnitude (AB) 
    ls8_g_err float NOT NULL, --/U mag --/D LS8 g-band magnitude error 
    ls8_r float NOT NULL, --/U mag --/D LS8 r-band magnitude (AB) 
    ls8_r_err float NOT NULL, --/U mag --/D LS8 r-band magnitude error 
    ls8_z float NOT NULL, --/U mag --/D LS8 z-band magnitude (AB) 
    ls8_z_err float NOT NULL, --/U mag --/D LS8 z-band magnitude error 
    vhs_y float NOT NULL, --/U mag --/D VISTA/VHS Y-band magnitude (AB) 
    vhs_y_err real NOT NULL, --/U mag --/D VISTA/VHS Y-band magnitude error 
    vhs_h float NOT NULL, --/U mag --/D VISTA/VHS H-band magnitude (AB) 
    vhs_h_err real NOT NULL, --/U mag --/D VISTA/VHS H-band magnitude error 
    vhs_ks float NOT NULL, --/U mag --/D VISTA/VHS Ks-band magnitude (AB) 
    vhs_ks_err real NOT NULL, --/U mag --/D VISTA/VHS Ks-band magnitude error 
    hsc_g_diff float NOT NULL, --/U mag --/D Difference between psf and Kron magnitude in HSC g-band 
    hsc_r_diff float NOT NULL, --/U mag --/D Distance between pfron and Kron magnitude in HSC r-band 
    hsc_i_diff float NOT NULL, --/U mag --/D Distance between pfron and Kron magnitude in HSC i-band 
    hsc_z_diff float NOT NULL, --/U mag --/D Distance between pfron and Kron magnitude in HSC z-band 
    hsc_opt_extended int NOT NULL, --/U  --/D Extension in HSC griz bands. 1=extended; -99=data missing; 0=other f 
    ctp_ls8_phot_flag bit NOT NULL, --/U  --/D Flag for LS8 photometry: true when the source has simultaneously g,r 
    ctp_ls8_type varchar(4) NOT NULL, --/U  --/D Morphological model from LS8 
    in_kids_flag smallint NOT NULL, --/U  --/D Source is in KIDS area 
    in_hsc_flag smallint NOT NULL, --/U  --/D Source is in HSC area 
    specz_ra float NOT NULL, --/U deg --/D J2000 Right Ascension of the spectroscopic redshift entry in the ori 
    specz_dec float NOT NULL, --/U deg --/D J2000 Declination of the spectroscopic redshift entry in the origina 
    specz_normq int NOT NULL, --/U  --/D Normalised quality of spectroscopic redshift: 3=secure, 2=not secure 
    specz_origin varchar(8) NOT NULL, --/U  --/D Catalogue which provided this spectroscopic redshift 
    specz_orig_id varchar(12) NOT NULL, --/U  --/D Original ID of this spec-z in ORIGIN catalogue 
    specz_galaxy_flag bit NOT NULL, --/U  --/D True when the CTP has a reliable redshift above 0.002 
    specz_star_flag bit NOT NULL, --/U  --/D True when the CTP has a reliable redshift below 0.002 
    ctp_classification varchar(20) NOT NULL, --/U  --/D SECURE/LIKELY GALACTIC/EXTRAGALACTIC, as from flowchart (Salvato+202 
    phz_lephare_zphot real NOT NULL, --/U  --/D Photoz from Le PHARE, but set to 0 for GALACTIC sources 
    phz_lephare_zl68 real NOT NULL, --/U  --/D Le PHARE zphot min at 1 sigma 
    phz_lephare_zu68 real NOT NULL, --/U  --/D Le PHARE zphot max at 1 sigma 
    phz_lephare_zl90 real NOT NULL, --/U  --/D Le PHARE zphot min at 2 sigma 
    phz_lephare_zu90 real NOT NULL, --/U  --/D Le PHARE zphot max at 2 sigma 
    phz_lephare_zl99 real NOT NULL, --/U  --/D Le PHARE zphot min at 3 sigma 
    phz_lephare_zu99 real NOT NULL, --/U  --/D Le PHARE zphot max at 3 sigma 
    phz_lephare_chi2 float NOT NULL, --/U  --/D Le PHARE chi2 value for best fitting galaxy/AGN template 
    phz_lephare_modelagn smallint NOT NULL, --/U  --/D Le PHARE model number for best template fitting the data (for PLIKE 
    phz_lephare_extlaw smallint NOT NULL, --/U  --/D Le PHARE Extinction Law applied to the template: Prevot (1) or none 
    phz_lephare_ebv real NOT NULL, --/U  --/D Le PHARE E(B-V) applied to the template 
    phz_lephare_pdz real NOT NULL, --/U  --/D Le Phare probability distribution: Photoz more reliable when value i 
    phz_lephare_nband smallint NOT NULL, --/U  --/D Le Phare number of bands used for the computation of photoz 
    phz_lephare_zphot_2 real NOT NULL, --/U  --/D Le Phare best photoz from LePhare, if existing 
    phz_lephare_chi2_2 float NOT NULL, --/U  --/D Le Phare chi2 value for second best fitting template, if existing 
    phz_lephare_modelagn_2 smallint NOT NULL, --/U  --/D Le Phare second best template fitting the data, if existing 
    phz_lephare_pdz_2 real NOT NULL, --/U  --/D Le Phare distribution of photoz for secondary solution, if existing 
    phz_dnnz_zphot float NOT NULL, --/U  --/D Photoz from DNNZ (from Nishizawa et al.), but set to 0 for GALACTIC 
    phz_dnnz_zl68 float NOT NULL, --/U  --/D DNNZ zphot min at 1 sigma 
    phz_dnnz_zu68 float NOT NULL, --/U  --/D DNNZ zphot max at 1 sigma 
    phz_dnnz_zl95 float NOT NULL, --/U  --/D DNNZ zphot min at 2 sigma 
    phz_dnnz_zu95 float NOT NULL, --/U  --/D DNNZ zphot max at 2 sigma 
    ctp_redshift float NOT NULL, --/U  --/D Final redshift: zspec when available, else photo-z from Le PHARE; 0 
    ctp_redshift_grade smallint NOT NULL, --/U  --/D In a range from 5 (spectroscopy) to 0 (unreliable photo-z) 
    cluster_class smallint NOT NULL, --/U  --/D Range from 5 (most likely a cluster) to 1 (not a cluster) (see Salva 
    ctp_class smallint NOT NULL, --/U  --/D same as CTP_classification, but with numbers: 3: SECURE EXTRAGALACTI 
    nspec int NOT NULL, --/U  --/D Number of spectra for the same eROSITA source 
    sdss_class varchar(20) NOT NULL, --/U  --/D SDSS class (STAR, GALAXY, QSO) in idlspec2d eFEDS v6_0_2 reductions 
    sdss_subclass varchar(20) NOT NULL, --/U  --/D SDSS subclass in idlspec2d eFEDS v6_0_2 reductions 
    pk_index int NOT NULL --/U  --/D Primary key index to associate the HDUs 
);
