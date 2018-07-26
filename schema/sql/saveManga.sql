--=========================================================
--  MangaTables.sql
--  2016-03-29	David Law, David Wake, Brian CHerinka et al.	
-----------------------------------------------------------
--  MaNGA table schema for SQL Server
-----------------------------------------------------------
-- History:
--* 2016-03-29  Ani: Adapted from sas-sql/mangadrp.sql.
--* 2016-03-29  Ani: Increased length of mangaTarget.nsa_subdir to 128.
--* 2016-04-22  Ani: Added htmID to mangaDrpAll.
--=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaDrpAll')
	DROP TABLE mangaDrpAll
GO
--
EXEC spSetDefaultFileGroup 'mangaDrpAll'
GO
CREATE TABLE mangaDrpAll (
------------------------------------------------------------------------------
--/H Final summary file of the MaNGA Data Reduction Pipeline (DRP).
------------------------------------------------------------------------------
--/T Contains all of the information required to find a given set of spectra
--/T for a target.
------------------------------------------------------------------------------
    plate  bigint  NOT NULL,   --/U --/D Plate ID
    ifudsgn  varchar(20)  NOT NULL, --/U --/D IFU design id (e.g. 12701)
    plateIFU  varchar(20)  NOT NULL, --/U --/D (Primary Key) Plate+ifudesign name for this object (e.g. 7443-12701)
    mangaid  varchar(20)  NOT NULL,  --/U --/D MaNGA ID for this object (e.g. 1-114145)
    versdrp2  varchar(20)  NOT NULL, --/U --/D Version of DRP used for 2d reductions
    versdrp3  varchar(20)  NOT NULL, --/U --/D Version of DRP used for 3d reductions
    verscore  varchar(20)  NOT NULL, --/U --/D Version of mangacore used for reductions
    versutil  varchar(20)  NOT NULL, --/U --/D Version of idlutils used for reductions
    versprim  varchar(20)  NOT NULL, --/U --/D Version of mangapreim used for reductions
    platetyp  varchar(20)  NOT NULL, --/U --/D Plate type (e.g. MANGA, APOGEE-2&MANGA)
    srvymode  varchar(20)  NOT NULL, --/U --/D Survey mode (e.g. MANGA dither, MANGA stare, APOGEE lead)
    objra  float  NOT NULL,   --/U degrees --/D Right ascension of the science object in J2000
    objdec  float  NOT NULL,   --/U degrees --/D Declination of the science object in J2000
    ifuglon  float  NOT NULL,   --/U degrees --/D Galactic longitude corresponding to IFURA/DEC
    ifuglat  float  NOT NULL,   --/U degrees --/D Galactic latitude corresponding to IFURA/DEC
    ifura  float  NOT NULL,   --/U degrees --/D Right ascension of this IFU in J2000
    ifudec  float  NOT NULL,   --/U degrees --/D Declination of this IFU in J2000
    ebvgal  float  NOT NULL,   --/U --/D E(B-V) value from SDSS dust routine for this IFUGLON, IFUGLAT
    nexp  bigint  NOT NULL,   --/U --/D Number of science exposures combined
    exptime  float  NOT NULL,   --/U seconds --/D Total exposure time
    drp3qual  bigint  NOT NULL,   --/U --/D Quality bitmask
    bluesn2  float  NOT NULL,   --/U --/D Total blue SN2 across all nexp exposures
    redsn2  float  NOT NULL,   --/U --/D Total red SN2 across all nexp exposures
    harname  varchar(20)  NOT NULL, --/U --/D IFU harness name
    frlplug  bigint  NOT NULL,   --/U --/D Frplug hardware code
    cartid  varchar(20)  NOT NULL, --/U --/D Cartridge ID number
    designid  bigint  NOT NULL,   --/U --/D  Design ID number
    cenra  float  NOT NULL,   --/U degrees --/D Plate center right ascension in J2000
    cendec  float  NOT NULL,   --/U degrees --/D Plate center declination in J2000
    airmsmin  float  NOT NULL,   --/U --/D Minimum airmass across all exposures
    airmsmed  float  NOT NULL,   --/U --/D Median airmass across all exposures
    airmsmax  float  NOT NULL,   --/U --/D Maximum airmass across all exposures
    seemin  float  NOT NULL,   --/U arcsec --/D Best guider seeing
    seemed  float  NOT NULL,   --/U arcsec --/D Median guider seeing
    seemax  float  NOT NULL,   --/U arcsec --/D Worst guider seeing
    transmin  float  NOT NULL,   --/U --/D Worst transparency
    transmed  float  NOT NULL,   --/U --/D Median transparency
    transmax  float  NOT NULL,   --/U --/D Best transparency
    mjdmin  bigint  NOT NULL,   --/U --/D Minimum MJD across all exposures
    mjdmed  bigint  NOT NULL,   --/U --/D Median MJD across all exposures
    mjdmax  bigint  NOT NULL,   --/U --/D Maximum MJD across all exposures
    gfwhm  float  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in g-band
    rfwhm  float  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in r-band
    ifwhm  float  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in i-band
    zfwhm  float  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in z-band
    mngtarg1  bigint  NOT NULL,   --/U --/D Manga-target1 maskbit for galaxy target catalog
    mngtarg2  bigint  NOT NULL,   --/U --/D Manga-target2 maskbit for galaxy target catalog
    mngtarg3  bigint  NOT NULL,   --/U --/D Manga-target3 maskbit for galaxy target catalog
    catidnum  bigint  NOT NULL,   --/U --/D Primary target input catalog (leading digits of mangaid)
    plttarg  varchar(20)  NOT NULL, --/U --/D plateTarget reference file appropriate for this target
    manga_tileid  bigint  NOT NULL,   --/U  --/D The ID of the tile to which this object has been allocated
    nsa_iauname  varchar(20)  NOT NULL,   --/U  --/D IAU-style designation based on RA/Dec (NSA)
    ifutargetsize bigint NOT NULL, --/U fibers --/D The ideal IFU size for this object. The intended IFU size is equal to IFUTargetSize except if IFUTargetSize > 127 when it is 127, or < 19 when it is 19
    ifudesignsize bigint NOT NULL, --/U fibers --/D The allocated IFU size (0 = "unallocated")
    ifudesignwrongsize bigint NOT NULL, --/U fibers --/D The allocated IFU size if the intended IFU size was not available
    nsa_field  bigint  NOT NULL,   --/U   --/D SDSS field ID covering the target
    nsa_run  bigint  NOT NULL,   --/U   --/D SDSS run ID covering the target
    nsa_camcol bigint NOT NULL, --/U --/D SDSS camcol ID covering the catalog position.
    nsa_version  varchar(20)  NOT NULL,   --/U   --/D Version of NSA catalogue used to select these targets
    nsa_nsaid  bigint  NOT NULL,   --/U   --/D The NSAID field in the NSA catalogue referenced in nsa_version.
    nsa_nsaid_v1b bigint NOT NULL, --/U --/D The NSAID of the target in the NSA_v1b_0_0_v2 catalogue (if applicable).
    nsa_z real NOT NULL, --/D Heliocentric redshift (NSA)
    nsa_zdist real NOT NULL, --/D Distance estimate using pecular velocity model of Willick et al. (1997), expressed as a redshift equivalent; multiply by c/H0 for Mpc (NSA)
    nsa_elpetro_mass real NOT NULL, --/U solar masses --/D Stellar mass from K-correction fit (use with caution) for elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_f real NOT NULL, --/F nsa_elpetro_absmag 0 --/U mag --/D Absolute magnitude in rest-frame GALEX far-UV, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_n real NOT NULL, --/F nsa_elpetro_absmag 1 --/U mag --/D Absolute magnitude in rest-frame GALEX near-UV, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_u real NOT NULL, --/F nsa_elpetro_absmag 2 --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_g real NOT NULL, --/F nsa_elpetro_absmag 3 --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_r real NOT NULL, --/F nsa_elpetro_absmag 4 --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_i real NOT NULL, --/F nsa_elpetro_absmag 5 --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_z real NOT NULL, --/F nsa_elpetro_absmag 6 --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_amivar_f real NOT NULL, --/F nsa_elpetro_amivar 0 --/U mag^{-2} --/D Inverse variance of elpetro_absmag_f (NSA)
    nsa_elpetro_amivar_n real NOT NULL, --/F nsa_elpetro_amivar 1 --/U mag^{-2} --/D Inverse variance of elpetro_absmag_n (NSA)
    nsa_elpetro_amivar_u real NOT NULL, --/F nsa_elpetro_amivar 2 --/U mag^{-2} --/D Inverse variance of elpetro_absmag_u (NSA)
    nsa_elpetro_amivar_g real NOT NULL, --/F nsa_elpetro_amivar 3 --/U mag^{-2} --/D Inverse variance of elpetro_absmag_g (NSA)
    nsa_elpetro_amivar_r real NOT NULL, --/F nsa_elpetro_amivar 4 --/U mag^{-2} --/D Inverse variance of elpetro_absmag_r (NSA)
    nsa_elpetro_amivar_i real NOT NULL, --/F nsa_elpetro_amivar 5 --/U mag^{-2} --/D Inverse variance of elpetro_absmag_i (NSA)
    nsa_elpetro_amivar_z real NOT NULL, --/F nsa_elpetro_amivar 6 --/U mag^{-2} --/D Inverse variance of elpetro_absmag_z (NSA)
    nsa_elpetro_flux_f real NOT NULL, --/F nsa_elpetro_flux 0 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA)
    nsa_elpetro_flux_n real NOT NULL, --/F nsa_elpetro_flux 1 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in GALEX near-UV (using r-band aperture) (NSA)
    nsa_elpetro_flux_u real NOT NULL, --/F nsa_elpetro_flux 2 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_g real NOT NULL, --/F nsa_elpetro_flux 3 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_r real NOT NULL, --/F nsa_elpetro_flux 4 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_i real NOT NULL, --/F nsa_elpetro_flux 5 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_z real NOT NULL, --/F nsa_elpetro_flux 6 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_ivar_f real NOT NULL, --/F nsa_elpetro_flux_ivar 0 --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_f (NSA)
    nsa_elpetro_flux_ivar_n real NOT NULL, --/F nsa_elpetro_flux_ivar 1 --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_n (NSA)
    nsa_elpetro_flux_ivar_u real NOT NULL, --/F nsa_elpetro_flux_ivar 2 --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_u (NSA)
    nsa_elpetro_flux_ivar_g real NOT NULL, --/F nsa_elpetro_flux_ivar 3 --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_g (NSA)
    nsa_elpetro_flux_ivar_r real NOT NULL, --/F nsa_elpetro_flux_ivar 4 --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_r (NSA)
    nsa_elpetro_flux_ivar_i real NOT NULL, --/F nsa_elpetro_flux_ivar 5 --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_i (NSA)
    nsa_elpetro_flux_ivar_z real NOT NULL, --/F nsa_elpetro_flux_ivar 6 --/U nanomaggies^{-2} --/D Inverse variance of elpetroflux_z (NSA)
    nsa_elpetro_th50_r real NOT NULL, --/U arcsec --/F nsa_elpetro_th50_r --/D Elliptical Petrosian 50% light radius in SDSS r-band (NSA)
    nsa_elpetro_phi real NOT NULL, --/U deg --/D Position angle (east of north) used for elliptical apertures (for this version, same as ba90) (NSA)
    nsa_elpetro_ba real NOT NULL, --/D Axis ratio used for elliptical apertures (for this version, same as ba90) (NSA)
    nsa_sersic_mass real NOT NULL, --/U solar mass --/D Stellar mass from K-correction fit (use with caution) for Sersic fluxes (NSA)
    nsa_sersic_absmag_f real NOT NULL, --/F nsa_sersic_absmag 0 --/U mag --/D Absolute magnitude in rest-frame GALEX near-UV, from Sersic fluxes (NSA)
    nsa_sersic_absmag_n real NOT NULL, --/F nsa_sersic_absmag 1 --/U mag --/D Absolute magnitude in rest-frame GALEX far-UV, from Sersic fluxes (NSA)
    nsa_sersic_absmag_u real NOT NULL, --/F nsa_sersic_absmag 2 --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_g real NOT NULL, --/F nsa_sersic_absmag 3 --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_r real NOT NULL, --/F nsa_sersic_absmag 4 --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_i real NOT NULL, --/F nsa_sersic_absmag 5 --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_z real NOT NULL, --/F nsa_sersic_absmag 6 --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from Sersic fluxes (NSA)
    nsa_sersic_flux_f real NOT NULL, --/F nsa_sersic_flux 0 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in GALEX far-UV (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_n real NOT NULL, --/F nsa_sersic_flux 1 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in GALEX near-UV (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_u real NOT NULL, --/F nsa_sersic_flux 2 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS u-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_g real NOT NULL, --/F nsa_sersic_flux 3 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS g-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_r real NOT NULL, --/F nsa_sersic_flux 4 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS r-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_i real NOT NULL, --/F nsa_sersic_flux 5 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS i-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_z real NOT NULL, --/F nsa_sersic_flux 6 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS z-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_ivar_f real NOT NULL, --/F nsa_sersic_flux_ivar 0 --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_f (NSA)
    nsa_sersic_flux_ivar_n real NOT NULL, --/F nsa_sersic_flux_ivar 1 --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_n (NSA)
    nsa_sersic_flux_ivar_u real NOT NULL, --/F nsa_sersic_flux_ivar 2 --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_u (NSA)
    nsa_sersic_flux_ivar_g real NOT NULL, --/F nsa_sersic_flux_ivar 3 --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_g (NSA)
    nsa_sersic_flux_ivar_r real NOT NULL, --/F nsa_sersic_flux_ivar 4 --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_r (NSA)
    nsa_sersic_flux_ivar_i real NOT NULL, --/F nsa_sersic_flux_ivar 5 --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_i (NSA)
    nsa_sersic_flux_ivar_z real NOT NULL, --/F nsa_sersic_flux_ivar 6 --/U nanomaggies^{-2} --/D Inverse variance of sersic_flux_z (NSA)
    nsa_sersic_th50 real NOT NULL, --/U arcsec --/D 50% light radius of two-dimensional, single-component Sersic fit to r-band (NSA)
    nsa_sersic_phi real NOT NULL, --/U deg --/D Angle (E of N) of major axis in two-dimensional, single-component Sersic fit in r-band (NSA)
    nsa_sersic_ba real NOT NULL, --/D Axis ratio b/a from two-dimensional, single-component Sersic fit in r-band (NSA)
    nsa_sersic_n real NOT NULL, --/D Sersic index from two-dimensional, single-component Sersic fit in r-band (NSA)
    nsa_petro_flux_f real NOT NULL, --/F nsa_petro_flux 0 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA)
    nsa_petro_flux_n real NOT NULL, --/F nsa_petro_flux 1 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA)
    nsa_petro_flux_u real NOT NULL, --/F nsa_petro_flux 2 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA)
    nsa_petro_flux_g real NOT NULL, --/F nsa_petro_flux 3 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA)
    nsa_petro_flux_r real NOT NULL, --/F nsa_petro_flux 4 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA)
    nsa_petro_flux_i real NOT NULL, --/F nsa_petro_flux 5 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA)
    nsa_petro_flux_z real NOT NULL, --/F nsa_petro_flux 6 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA)
    nsa_petro_flux_ivar_f real NOT NULL, --/F nsa_petro_flux_ivar 0 --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_f (NSA)
    nsa_petro_flux_ivar_n real NOT NULL, --/F nsa_petro_flux_ivar 1 --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_n (NSA)
    nsa_petro_flux_ivar_u real NOT NULL, --/F nsa_petro_flux_ivar 2 --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_u (NSA)
    nsa_petro_flux_ivar_g real NOT NULL, --/F nsa_petro_flux_ivar 3 --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_g (NSA)
    nsa_petro_flux_ivar_r real NOT NULL, --/F nsa_petro_flux_ivar 4 --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_r (NSA)
    nsa_petro_flux_ivar_i real NOT NULL, --/F nsa_petro_flux_ivar 5 --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_i (NSA)
    nsa_petro_flux_ivar_z real NOT NULL, --/F nsa_petro_flux_ivar 6 --/U nanomaggies^{-2} --/D Inverse variance of petro_flux_z (NSA)
    nsa_petro_th50 real NOT NULL, --/U arcsec --/D Azimuthally averaged SDSS-style Petrosian 50% light radius (derived from r band) (NSA)
    nsa_extinction_f real NOT NULL, --/F nsa_extinction 0 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX far-UV (NSA)
    nsa_extinction_n real NOT NULL, --/F nsa_extinction 1 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX near-UV (NSA)
    nsa_extinction_u real NOT NULL, --/F nsa_extinction 2 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS u-band (NSA)
    nsa_extinction_g real NOT NULL, --/F nsa_extinction 3 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS g-band (NSA)
    nsa_extinction_r real NOT NULL, --/F nsa_extinction 4 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS r-band (NSA)
    nsa_extinction_i real NOT NULL, --/F nsa_extinction 5 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS i-band (NSA)
    nsa_extinction_z real NOT NULL, --/F nsa_extinction 6 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS z-band (NSA)
    htmID bigint NOT NULL     	    --/F NOFITS --/D HTM ID 
)
GO
--



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaTarget')
	DROP TABLE mangaTarget
GO
--
EXEC spSetDefaultFileGroup 'mangaTarget'
GO
CREATE TABLE mangatarget (
------------------------------------------------------------------------------
--/H MaNGA Target Catalog
------------------------------------------------------------------------------
--/T The MaNGA targeting catalog, v1_2_18. This table contains the details of
--/T the three main MaNGA samples, Primary, Secondary and Color-Enhanced, as
--/T well as the ancillary targets. In addition to the targeting information
--/T there are details of the tile and IFU allocation as of 03/10/2016. This
--/T tiling and allocation details may change slightly as the survey evolves.
--/T Also included are various useful parameters from the NASA-Sloan Atlas
--/T (NSA) catalog, v1_0_1, which was used to select almost all of the targets.
--/T A few ancillary targets may have been selected from elsewhere. Targets
--/T cover the full SDSS spectroscopic DR7 region, although only approximately
--/T 1/3 will be observed in the final survey.
------------------------------------------------------------------------------
    catalog_ra float NOT NULL, --/U deg --/D Right Ascension of measured object center (J2000) as given in the input catalog (NSA for main samples and most ancillaries)
    catalog_dec float NOT NULL, --/U deg --/D Declination of measured object center (J2000) as given in the input catalog (NSA for main samples and most ancillaries)
    nsa_z real NOT NULL, --/D Heliocentric redshift (NSA)
    nsa_zdist real NOT NULL, --/D Distance estimate using pecular velocity model of Willick et al. (1997), expressed as a redshift equivalent; multiply by c/H0 for Mpc (NSA)
    nsa_elpetro_mass real NOT NULL, --/U solar masses --/D Stellar mass from K-correction fit (use with caution) for elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_f real NOT NULL, --/F nsa_elpetro_absmag 0 --/U mag --/D Absolute magnitude in rest-frame GALEX far-UV, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_n real NOT NULL, --/F nsa_elpetro_absmag 1 --/U mag --/D Absolute magnitude in rest-frame GALEX near-UV, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_u real NOT NULL, --/F nsa_elpetro_absmag 2 --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_g real NOT NULL, --/F nsa_elpetro_absmag 3 --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_r real NOT NULL, --/F nsa_elpetro_absmag 4 --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_i real NOT NULL, --/F nsa_elpetro_absmag 5 --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_absmag_z real NOT NULL, --/F nsa_elpetro_absmag 6 --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from elliptical Petrosian fluxes (NSA)
    nsa_elpetro_amivar_f real NOT NULL, --/F nsa_elpetro_amivar 0 --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_f (NSA)
    nsa_elpetro_amivar_n real NOT NULL, --/F nsa_elpetro_amivar 1 --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_n (NSA)
    nsa_elpetro_amivar_u real NOT NULL, --/F nsa_elpetro_amivar 2 --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_u (NSA)
    nsa_elpetro_amivar_g real NOT NULL, --/F nsa_elpetro_amivar 3 --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_g (NSA)
    nsa_elpetro_amivar_r real NOT NULL, --/F nsa_elpetro_amivar 4 --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_r (NSA)
    nsa_elpetro_amivar_i real NOT NULL, --/F nsa_elpetro_amivar 5 --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_i (NSA)
    nsa_elpetro_amivar_z real NOT NULL, --/F nsa_elpetro_amivar 6 --/U mag^{-2} --/D Inverse variance of nsa_elpetro_absmag_z (NSA)
    nsa_elpetro_flux_f real NOT NULL, --/F nsa_elpetro_flux 0 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA)
    nsa_elpetro_flux_n real NOT NULL, --/F nsa_elpetro_flux 1 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in GALEX near-UV (using r-band aperture) (NSA)
    nsa_elpetro_flux_u real NOT NULL, --/F nsa_elpetro_flux 2 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_g real NOT NULL, --/F nsa_elpetro_flux 3 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_r real NOT NULL, --/F nsa_elpetro_flux 4 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_i real NOT NULL, --/F nsa_elpetro_flux 5 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_z real NOT NULL, --/F nsa_elpetro_flux 6 --/U nanomaggies --/D Elliptical SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA)
    nsa_elpetro_flux_ivar_f real NOT NULL, --/F nsa_elpetro_flux_ivar 0 --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_f (NSA)
    nsa_elpetro_flux_ivar_n real NOT NULL, --/F nsa_elpetro_flux_ivar 1 --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_n (NSA)
    nsa_elpetro_flux_ivar_u real NOT NULL, --/F nsa_elpetro_flux_ivar 2 --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_u (NSA)
    nsa_elpetro_flux_ivar_g real NOT NULL, --/F nsa_elpetro_flux_ivar 3 --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_g (NSA)
    nsa_elpetro_flux_ivar_r real NOT NULL, --/F nsa_elpetro_flux_ivar 4 --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_r (NSA)
    nsa_elpetro_flux_ivar_i real NOT NULL, --/F nsa_elpetro_flux_ivar 5 --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_i (NSA)
    nsa_elpetro_flux_ivar_z real NOT NULL, --/F nsa_elpetro_flux_ivar 6 --/U nanomaggies^{-2} --/D Inverse variance of nsa_elpetro_flux_z (NSA)
    nsa_elpetro_th50_r_original real NOT NULL, --/F nsa_elpetro_th50_r --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS r-band (NSA)
    nsa_elpetro_th50_f real NOT NULL, --/F nsa_elpetro_th50 0 --/U arcsec --/D Elliptical Petrosian 50% light radius in GALEX far-UV (NSA)
    nsa_elpetro_th50_n real NOT NULL, --/F nsa_elpetro_th50 1 --/U arcsec --/D Elliptical Petrosian 50% light radius in GALEX near-UV (NSA)
    nsa_elpetro_th50_u real NOT NULL, --/F nsa_elpetro_th50 2 --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS u-band (NSA)
    nsa_elpetro_th50_g real NOT NULL, --/F nsa_elpetro_th50 3 --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS g-band (NSA)
    nsa_elpetro_th50_r real NOT NULL, --/F nsa_elpetro_th50 4 --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS r-band (NSA)
    nsa_elpetro_th50_i real NOT NULL, --/F nsa_elpetro_th50 5 --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS i-band (NSA)
    nsa_elpetro_th50_z real NOT NULL, --/F nsa_elpetro_th50 6 --/U arcsec --/D Elliptical Petrosian 50% light radius in SDSS z-band (NSA)
    nsa_elpetro_phi real NOT NULL, --/U deg --/D Position angle (east of north) used for elliptical apertures (for this version, same as ba90) (NSA)
    nsa_elpetro_ba real NOT NULL, --/D Axis ratio used for elliptical apertures (for this version, same as ba90) (NSA)
    nsa_sersic_mass real NOT NULL, --/U solar mass --/D Stellar mass from K-correction fit (use with caution) for Sersic fluxes (NSA)
    nsa_sersic_absmag_f real NOT NULL, --/F nsa_sersic_absmag 0 --/U mag --/D Absolute magnitude in rest-frame GALEX near-UV, from Sersic fluxes (NSA)
    nsa_sersic_absmag_n real NOT NULL, --/F nsa_sersic_absmag 1 --/U mag --/D Absolute magnitude in rest-frame GALEX far-UV, from Sersic fluxes (NSA)
    nsa_sersic_absmag_u real NOT NULL, --/F nsa_sersic_absmag 2 --/U mag --/D Absolute magnitude in rest-frame SDSS u-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_g real NOT NULL, --/F nsa_sersic_absmag 3 --/U mag --/D Absolute magnitude in rest-frame SDSS g-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_r real NOT NULL, --/F nsa_sersic_absmag 4 --/U mag --/D Absolute magnitude in rest-frame SDSS r-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_i real NOT NULL, --/F nsa_sersic_absmag 5 --/U mag --/D Absolute magnitude in rest-frame SDSS i-band, from Sersic fluxes (NSA)
    nsa_sersic_absmag_z real NOT NULL, --/F nsa_sersic_absmag 6 --/U mag --/D Absolute magnitude in rest-frame SDSS z-band, from Sersic fluxes (NSA)
    nsa_sersic_amivar_f real NOT NULL, --/F nsa_sersic_amivar 0 --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_f (NSA)
    nsa_sersic_amivar_n real NOT NULL, --/F nsa_sersic_amivar 1 --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_n (NSA)
    nsa_sersic_amivar_u real NOT NULL, --/F nsa_sersic_amivar 2 --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_u (NSA)
    nsa_sersic_amivar_g real NOT NULL, --/F nsa_sersic_amivar 3 --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_g (NSA)
    nsa_sersic_amivar_r real NOT NULL, --/F nsa_sersic_amivar 4 --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_r (NSA)
    nsa_sersic_amivar_i real NOT NULL, --/F nsa_sersic_amivar 5 --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_i (NSA)
    nsa_sersic_amivar_z real NOT NULL, --/F nsa_sersic_amivar 6 --/U mag^{-2} --/D Inverse variance in nsa_sersic_absmag_z (NSA)
    nsa_sersic_flux_f real NOT NULL, --/F nsa_sersic_flux 0 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in GALEX far-UV (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_n real NOT NULL, --/F nsa_sersic_flux 1 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in GALEX near-UV (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_u real NOT NULL, --/F nsa_sersic_flux 2 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS u-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_g real NOT NULL, --/F nsa_sersic_flux 3 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS g-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_r real NOT NULL, --/F nsa_sersic_flux 4 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS r-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_i real NOT NULL, --/F nsa_sersic_flux 5 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS i-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_z real NOT NULL, --/F nsa_sersic_flux 6 --/U nanomaggies --/D Two-dimensional, single-component Sersic fit flux in SDSS z-band (fit using r-band structural parameters) (NSA)
    nsa_sersic_flux_ivar_f real NOT NULL, --/F nsa_sersic_flux_ivar 0 --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_f (NSA)
    nsa_sersic_flux_ivar_n real NOT NULL, --/F nsa_sersic_flux_ivar 1 --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_n (NSA)
    nsa_sersic_flux_ivar_u real NOT NULL, --/F nsa_sersic_flux_ivar 2 --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_u (NSA)
    nsa_sersic_flux_ivar_g real NOT NULL, --/F nsa_sersic_flux_ivar 3 --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_g (NSA)
    nsa_sersic_flux_ivar_r real NOT NULL, --/F nsa_sersic_flux_ivar 4 --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_r (NSA)
    nsa_sersic_flux_ivar_i real NOT NULL, --/F nsa_sersic_flux_ivar 5 --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_i (NSA)
    nsa_sersic_flux_ivar_z real NOT NULL, --/F nsa_sersic_flux_ivar 6 --/U nanomaggies^{-2} --/D Inverse variance of nsa_sersic_flux_z (NSA)
    nsa_sersic_th50 real NOT NULL, --/U arcsec --/D 50% light radius of two-dimensional, single-component Sersic fit to r-band (NSA)
    nsa_sersic_phi real NOT NULL, --/U deg --/D Angle (E of N) of major axis in two-dimensional, single-component Sersic fit in r-band (NSA)
    nsa_sersic_ba real NOT NULL, --/D Axis ratio b/a from two-dimensional, single-component Sersic fit in r-band (NSA)
    nsa_sersic_n real NOT NULL, --/D Sersic index from two-dimensional, single-component Sersic fit in r-band (NSA)
    nsa_petro_flux_f real NOT NULL, --/F nsa_petro_flux 0 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA)
    nsa_petro_flux_n real NOT NULL, --/F nsa_petro_flux 1 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture) (NSA)
    nsa_petro_flux_u real NOT NULL, --/F nsa_petro_flux 2 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS u-band (using r-band aperture) (NSA)
    nsa_petro_flux_g real NOT NULL, --/F nsa_petro_flux 3 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS g-band (using r-band aperture) (NSA)
    nsa_petro_flux_r real NOT NULL, --/F nsa_petro_flux 4 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS r-band (using r-band aperture) (NSA)
    nsa_petro_flux_i real NOT NULL, --/F nsa_petro_flux 5 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS i-band (using r-band aperture) (NSA)
    nsa_petro_flux_z real NOT NULL, --/F nsa_petro_flux 6 --/U nanomaggies --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS z-band (using r-band aperture) (NSA)
    nsa_petro_flux_ivar_f real NOT NULL, --/F nsa_petro_flux_ivar 0 --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_f (NSA)
    nsa_petro_flux_ivar_n real NOT NULL, --/F nsa_petro_flux_ivar 1 --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_n (NSA)
    nsa_petro_flux_ivar_u real NOT NULL, --/F nsa_petro_flux_ivar 2 --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_u (NSA)
    nsa_petro_flux_ivar_g real NOT NULL, --/F nsa_petro_flux_ivar 3 --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_g (NSA)
    nsa_petro_flux_ivar_r real NOT NULL, --/F nsa_petro_flux_ivar 4 --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_r (NSA)
    nsa_petro_flux_ivar_i real NOT NULL, --/F nsa_petro_flux_ivar 5 --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_i (NSA)
    nsa_petro_flux_ivar_z real NOT NULL, --/F nsa_petro_flux_ivar 6 --/U nanomaggies^{-2} --/D Inverse variance of nsa_petro_flux_z (NSA)
    nsa_petro_th50 real NOT NULL, --/U arcsec --/D Azimuthally averaged SDSS-style Petrosian 50% light radius (derived from r band) (NSA)
    nsa_extinction_f real NOT NULL, --/F nsa_extinction 0 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX far-UV (NSA)
    nsa_extinction_n real NOT NULL, --/F nsa_extinction 1 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX near-UV (NSA)
    nsa_extinction_u real NOT NULL, --/F nsa_extinction 2 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS u-band (NSA)
    nsa_extinction_g real NOT NULL, --/F nsa_extinction 3 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS g-band (NSA)
    nsa_extinction_r real NOT NULL, --/F nsa_extinction 4 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS r-band (NSA)
    nsa_extinction_i real NOT NULL, --/F nsa_extinction 5 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS i-band (NSA)
    nsa_extinction_z real NOT NULL, --/F nsa_extinction 6 --/U mag --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS z-band (NSA)
    nsa_iauname varchar(20) NOT NULL, --/D IAU-style designation based on RA/Dec (NSA)
    nsa_subdir varchar(128) NOT NULL, --/D Subdirectory for images in the NSA 'detect' directory (NSA)
    nsa_pid int NOT NULL, --/D Parent id within mosaic for this object (NSA)
    nsa_nsaid int NOT NULL, --/D Unique ID within NSA v1 catalog (NSA)
    catind int NOT NULL, --/D Zero-indexed row within the input NSA v1 catalog (NSA)
    manga_target1 int NOT NULL, --/D Targeting bitmask for main sample targets
    mangaID varchar(20) NOT NULL, --/D Unique ID for each manga target
    zmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary sample
    zmax real NOT NULL, --/D The maximum redshift at which the galaxy could still have been included in the Primary sample
    szmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Secondary sample
    szmax real NOT NULL, --/D The maximum redshift at which the galaxy could still have been included in the Secondary sample
    ezmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample
    ezmax real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample
    ranflag bit NOT NULL, --/D Set to 1 if a target is to be included after random sampling to produce the correct proportions of each sample, otherwise 0
    manga_tileids int NOT NULL, --/D IDs of all tiles that overlap a galaxy's position
    manga_tileid int NOT NULL, --/D The ID of the tile to which this object has been allocated
    tilera float NOT NULL, --/U deg --/D The Right Ascension (J2000) of the tile to which this object has been allocated
    tiledec float NOT NULL, --/U deg --/D The Declination (J2000) of the tile to which this object has been allocated
    ifutargetsize smallint NOT NULL, --/U fibers --/D The ideal IFU size for this object. The intended IFU size is equal to IFUTargetSize except if IFUTargetSize > 127 when it is 127, or < 19 when it is 19
    ifudesignsize smallint NOT NULL, --/U fibers --/D The allocated IFU size (0 = "unallocated")
    ifudesignwrongsize smallint NOT NULL, --/U fibers --/D The allocated IFU size if the intended IFU size was not available
    ifu_ra float NOT NULL, --/U deg --/D The Right Ascension (J2000) of the IFU center
    ifu_dec float NOT NULL, --/U deg --/D The Right Declination (J2000) of the IFU center
    badphotflag bit NOT NULL, --/D Set to 1 if target has been visually inspected to have bad photometry and should not be observed
    starflag bit NOT NULL, --/D Set to 1 if target lies close to a bright star should not be observed
    object_ra float NOT NULL, --/U deg --/D The best estimate of the Right Ascension (J2000) of the center of the object. Normally the same as CATALOG_RA but can be modified particularly as a result of visual inspection
    object_dec float NOT NULL, --/U deg --/D The best estimate of the Declination (J2000) of the center of the object. Normally the same as CATALOG_RA but can be modified particularly as a result of visual inspection
    obsflag bit NOT NULL, --/D Set to 1 if the target has already been included on a plate set to be observed at the time the IFU allocation was made, otherwise 0
    catindanc int NOT NULL, --/D Zero-indexed row within the applicable ancillary catalog
    ifudesignsizemain smallint NOT NULL, --/U fibers --/D The allocated IFU size prior to the addition of the ancillary samples (0 = "unallocated")
    ifuminsizeanc smallint NOT NULL, --/U fibers --/D The minimum acceptable IFU size for the ancillary program
    ifutargsizeanc smallint NOT NULL, --/U fibers --/D The ideal IFU size for the ancillary program
    manga_target3 int NOT NULL, --/D Targeting bitmask for the ancillary samples
    priorityanc int NOT NULL, --/D The ancillary program's priority for this object
    unalloc smallint NOT NULL, --/D Set to 1 if an ancillary target has been allocated an IFU the was not allocated to a main sample galaxy, otherwise 0
)
GO
--


EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[MangaTables.sql]: MaNGA tables created'
GO


