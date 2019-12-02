--=========================================================
--  MangaTables.sql
--  2016-03-29	David Law, David Wake, Brian CHerinka et al.	
-----------------------------------------------------------
--  MaNGA table schema for SQL Server
-----------------------------------------------------------
-- History:
--* 2016-03-29  Ani: Adapted from sas-sql/mangadrp.sql.
--* 2016-03-29  Ani: Increased length of mangaTarget.nsa_subdir to 128.
--* 2016-04-22  Ani: Added htmID to mangaDRPall.
--* 2016-04-26  Ani: Updated schema for mangaDRPall from D.Law to make
--*                  data types the required precision.
--* 2016-05-03  Ani: Added nsatlas table for NASA-SLoan Atlas.
--* 2016-05-04  Ani: Increased nsatlas.subdir to 128 chars and some other
--*                  strings (e.g. programname) to 32 chars, indented table.
--* 2016-05-10  Ani: Updated schema for NASA-SLoan Atlas.
--* 2017-04-26  Ani: Updates for DR14.
--* 2017-05-26  Ani: Added mangaFirefly and mangaPipe3D VAC tables.
--* 2017-06-13  Ani: Added PLATEIFU to mangaFirefly.
--* 2018-06-08  Ani: Added mangaDAPall (DR15). 
--* 2018-06-12  Ani: Updated mangaDRPall schema (DR15). 
--* 2018-06-12  Ani: Added htmID to mangaDAPall. (DR15)
--* 2018-06-13  Ani: Changed BIGINTs to INTs and FLOATs to REALs wherever
--*                  applicable in mangaDapAll. Added mangaHIall and
--*                  mangaHIbonus. (DR15)
--* 2018-07-20  Ani: Added mastar tables. (DR15)
--* 2018-07-24  Ani: Moved mastar tables to separate file MastarTables.sql. (DR15)
--* 2018-07-25  Ani: Updated objra,objdec for mangaFirefly to FLOAT from REAL
--*                . (DR15)
--* 2018-08-06  Ani: Replaced all VARCHAR(20) with VARCHAR(32), made all
--*                  mangaID columns VARCHAR(32) for FK consistency. (DR15)
--* 2019-07-30  Ani: Added mangaGalaxyZoo table, changed all non-coord floats
--*                  to reals, increased the varchar lengths, and added commas
--*                  after each line and a closing parenthesis.
--* 2019-07-31  Ani: Changed nsa_id in mangaGalaxyZoo to int from bigint,
--*                  IFUDESIGNSIZE to int from real after confirmation from K
--*                  Masters. Also chamged MANGA_TILEID to int from real.
--* 2019-09-27  Ani: Brought mangaGAlaxyZoo table into this file, it was in
--*                  its own file before.
--* 2019-10-24  Ani: Added mangaAlfalfaDR15 VAC table.
---=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaDRPall')
	DROP TABLE mangaDRPall
GO
--
EXEC spSetDefaultFileGroup 'mangaDRPall'
GO
CREATE TABLE mangaDRPall (
------------------------------------------------------------------------------
--/H Final summary file of the MaNGA Data Reduction Pipeline (DRP).
------------------------------------------------------------------------------
--/T Contains all of the information required to find a given set of spectra
--/T for a target.
------------------------------------------------------------------------------
    plate  int  NOT NULL,   --/U --/D Plate ID
    ifudsgn  varchar(32)  NOT NULL, --/U --/D IFU design id (e.g. 12701)
    plateifu  varchar(32)  NOT NULL, --/U --/D Plate+ifudesign name for this object (e.g. 7443-12701)
    mangaid  varchar(32)  NOT NULL,  --/U --/D MaNGA ID for this object (e.g. 1-114145)
    versdrp2  varchar(32)  NOT NULL, --/U --/D Version of DRP used for 2d reductions
    versdrp3  varchar(32)  NOT NULL, --/U --/D Version of DRP used for 3d reductions
    verscore  varchar(32)  NOT NULL, --/U --/D Version of mangacore used for reductions
    versutil  varchar(32)  NOT NULL, --/U --/D Version of idlutils used for reductions
    versprim  varchar(32)  NOT NULL, --/U --/D Version of mangapreim used for reductions
    platetyp  varchar(32)  NOT NULL, --/U --/D Plate type (e.g. MANGA, APOGEE-2&MANGA)
    srvymode  varchar(32)  NOT NULL, --/U --/D Survey mode (e.g. MANGA dither, MANGA stare, APOGEE lead)
    objra  float  NOT NULL,   --/U degrees --/D Right ascension of the science object in J2000
    objdec  float  NOT NULL,   --/U degrees --/D Declination of the science object in J2000
    ifuglon  float  NOT NULL,   --/U degrees --/D Galactic longitude corresponding to IFURA/DEC
    ifuglat  float  NOT NULL,   --/U degrees --/D Galactic latitude corresponding to IFURA/DEC
    ifura  float  NOT NULL,   --/U degrees --/D Right ascension of this IFU in J2000
    ifudec  float  NOT NULL,   --/U degrees --/D Declination of this IFU in J2000
    ebvgal  real  NOT NULL,   --/U --/D E(B-V) value from SDSS dust routine for this IFUGLON, IFUGLAT
    nexp  int  NOT NULL,   --/U --/D Number of science exposures combined
    exptime  real  NOT NULL,   --/U seconds --/D Total exposure time
    drp3qual  int  NOT NULL,   --/U --/D Quality bitmask
    bluesn2  real  NOT NULL,   --/U --/D Total blue SN2 across all nexp exposures
    redsn2  real  NOT NULL,   --/U --/D Total red SN2 across all nexp exposures
    harname  varchar(64)  NOT NULL, --/U --/D IFU harness name
    frlplug  int  NOT NULL,   --/U --/D Frplug hardware code
    cartid  varchar(32)  NOT NULL, --/U --/D Cartridge ID number
    designid  int  NOT NULL,   --/U --/D  Design ID number
    cenra  float  NOT NULL,   --/U degrees --/D Plate center right ascension in J2000
    cendec  float  NOT NULL,   --/U degrees --/D Plate center declination in J2000
    airmsmin  real  NOT NULL,   --/U --/D Minimum airmass across all exposures
    airmsmed  real  NOT NULL,   --/U --/D Median airmass across all exposures
    airmsmax  real  NOT NULL,   --/U --/D Maximum airmass across all exposures
    seemin  real  NOT NULL,   --/U arcsec --/D Best guider seeing
    seemed  real  NOT NULL,   --/U arcsec --/D Median guider seeing
    seemax  real  NOT NULL,   --/U arcsec --/D Worst guider seeing
    transmin  real  NOT NULL,   --/U --/D Worst transparency
    transmed  real  NOT NULL,   --/U --/D Median transparency
    transmax  real  NOT NULL,   --/U --/D Best transparency
    mjdmin  int  NOT NULL,   --/U --/D Minimum MJD across all exposures
    mjdmed  int  NOT NULL,   --/U --/D Median MJD across all exposures
    mjdmax  int  NOT NULL,   --/U --/D Maximum MJD across all exposures
    gfwhm  real  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in g-band
    rfwhm  real  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in r-band
    ifwhm  real  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in i-band
    zfwhm  real  NOT NULL,   --/U arcsec --/D Reconstructed FWHM in z-band
    mngtarg1  bigint  NOT NULL,   --/U --/D Manga-target1 maskbit for galaxy target catalog
    mngtarg2  bigint  NOT NULL,   --/U --/D Manga-target2 maskbit for galaxy target catalog
    mngtarg3  bigint  NOT NULL,   --/U --/D Manga-target3 maskbit for galaxy target catalog
    catidnum  bigint  NOT NULL,   --/U --/D Primary target input catalog (leading digits of mangaid)
    plttarg  varchar(32)  NOT NULL, --/U --/D plateTarget reference file appropriate for this target
    manga_tileid  int  NOT NULL,   --/U  --/D The ID of the tile to which this object has been allocated
    nsa_iauname  varchar(32)  NOT NULL,   --/U  --/D IAU-style designation based on RA/Dec (NSA)
    ifutargetsize int NOT NULL, --/U fibers --/D The ideal IFU size for this object. The intended IFU size is equal to IFUTargetSize except if IFUTargetSize > 127 when it is 127, or < 19 when it is 19
    ifudesignsize int NOT NULL, --/U fibers --/D The allocated IFU size (0 = "unallocated")
    ifudesignwrongsize int NOT NULL, --/U fibers --/D The allocated IFU size if the intended IFU size was not available
    z real NOT NULL, --/D The targeting redshift (identical to nsa_z for those targets in the NSA Catalog. For others, it is the redshift provided by the Ancillary programs)
    zmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary sample
    zmax real NOT NULL, --/D The maximum redshift at which the galaxy could still have been included in the Primary sample
    szmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Secondary sample
    szmax real NOT NULL, --/D The maximum redshift at which the galaxy could still have been included in the Secondary sample
    ezmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample
    ezmax real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample
    probs real NOT NULL, --/D The probability that a Secondary sample galaxy is included after down-sampling. For galaxies not in the Secondary sample PROBS is set to the mean down-sampling probability
    pweight real NOT NULL, --/D The volume weight for the Primary sample. Corrects the MaNGA selection to a volume limited sample.
    psweight real NOT NULL, --/D The volume weight for the combined Primary and full Secondary samples. Corrects the MaNGA selection to a volume limited sample.
    psrweight real NOT NULL, --/D The volume weight for the combined Primary and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample.
    sweight real NOT NULL, --/D The volume weight for the full Secondary sample. Corrects the MaNGA selection to a volume limited sample.
    srweight real NOT NULL, --/D The volume weight for the down-sampled Secondary sample. Corrects the MaNGA selection to a volume limited sample.
    eweight real NOT NULL, --/D The volume weight for the Primary+ sample. Corrects the MaNGA selection to a volume limited sample.
    esweight real NOT NULL, --/D The volume weight for the combined Primary+ and full Secondary samples. Corrects the MaNGA selection to a volume limited sample.
    esrweight real NOT NULL, --/D The volume weight for the combined Primary+ and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample.
    nsa_field  int  NOT NULL,   --/U   --/D SDSS field ID covering the target
    nsa_run  int  NOT NULL,   --/U   --/D SDSS run ID covering the target
    nsa_camcol int NOT NULL, --/U --/D SDSS camcol ID covering the catalog position.
    nsa_version  varchar(32)  NOT NULL,   --/U   --/D Version of NSA catalogue used to select these targets
    nsa_nsaid  int  NOT NULL,   --/U   --/D The NSAID field in the NSA catalogue referenced in nsa_version.
    nsa_nsaid_v1b int NOT NULL, --/U --/D The NSAID of the target in the NSA_v1b_0_0_v2 catalogue (if applicable).
    nsa_z real NOT NULL, --/D Heliocentric redshift (NSA)
    nsa_zdist real NOT NULL, --/D Distance estimate using peculiar velocity model of Willick et al. (1997), expressed as a redshift equivalent; multiply by c/H0 for Mpc (NSA)
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
    htmID bigint NOT NULL  --/F NOFITS --/D 20-level deep Hierarchical Triangular Mesh ID 
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
    nsa_iauname VARCHAR(32) NOT NULL, --/D IAU-style designation based on RA/Dec (NSA)
    nsa_subdir varchar(128) NOT NULL, --/D Subdirectory for images in the NSA 'detect' directory (NSA)
    nsa_pid int NOT NULL, --/D Parent id within mosaic for this object (NSA)
    nsa_nsaid int NOT NULL, --/D Unique ID within NSA v1 catalog (NSA)
    catind int NOT NULL, --/D Zero-indexed row within the input NSA v1 catalog (NSA)
    manga_target1 bigint NOT NULL, --/D Targeting bitmask for main sample targets
    mangaID varchar(32) NOT NULL, --/D Unique ID for each manga target
    zmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary sample
    zmax real NOT NULL, --/D The maximum redshift at which the galaxy could still have been included in the Primary sample
    szmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Secondary sample
    szmax real NOT NULL, --/D The maximum redshift at which the galaxy could still have been included in the Secondary sample
    ezmin real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample
    ezmax real NOT NULL, --/D The minimum redshift at which the galaxy could still have been included in the Primary+ sample
    probs real NOT NULL, --/D The probability that a Secondary sample galaxy is included after down-sampling. For galaxies not in the Secondary sample PROBS is set to the mean down-sampling probability
    pweight real NOT NULL, --/D The volume weight for the Primary sample. Corrects the MaNGA selection to a volume limited sample
    sweight real NOT NULL, --/D The volume weight for the full Secondary sample. Corrects the MaNGA selection to a volume limited sample
    srweight real NOT NULL, --/D The volume weight for the down-sampled Secondary sample. Corrects the MaNGA selection to a volume limited sample
    eweight real NOT NULL, --/D The volume weight for the Primary+ sample. Corrects the MaNGA selection to a volume limited sample
    psrweight real NOT NULL, --/D The volume weight for the combined Primary and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample
    esrweight real NOT NULL, --/D The volume weight for the combined Primary+ and down-sampled Secondary samples. Corrects the MaNGA selection to a volume limited sample
    psweight real NOT NULL, --/D The volume weight for the combined Primary and full Secondary samples. Corrects the MaNGA selection to a volume limited sample
    esweight real NOT NULL, --/D The volume weight for the combined Primary+ and full Secondary samples. Corrects the MaNGA selection to a volume limited sample
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
    manga_target3 bigint NOT NULL, --/D Targeting bitmask for the ancillary samples
    priorityanc int NOT NULL, --/D The ancillary program's priority for this object
    unalloc smallint NOT NULL, --/D Set to 1 if an ancillary target has been allocated an IFU the was not allocated to a main sample galaxy, otherwise 0
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'nsatlas')
	DROP TABLE nsatlas
GO
--
EXEC spSetDefaultFileGroup 'nsatlas'
GO
CREATE TABLE nsatlas (
------------------------------------------------------------------------------
--/H NASA-Sloan Atlas catalog
------------------------------------------------------------------------------
--/T The NASA-Sloan Atlas (NSA) catalog, v1_0_1. This NSA sample was
--/T selected to include virtually all known redshifts out to about
--/T z &lt; 0.15 for galaxies within the coverage of SDSS DR11. For each
--/T such galaxy, we have created image mosaics from SDSS and GALEX and
--/T rephotometered the ugriz bands plus the far and near ultraviolet
--/T bands in a self-consistent manner. After cleaning a number of
--/T suspicious cases the final catalog contains about 640,000
--/T galaxies. See http://nsatlas.org for more information.
--/T <br><br>
--/T We recommend the use of the elliptical Petrosian photometry from 
--/T this catalog. K-corrected absolute magnitudes are provided using
--/T kcorrect v4_2. 
--/T <br><br>
--/T There are cases of elliptical Petrosian quantities in this file
--/T with <code>_r_original</code> suffices (e.g. <code>petro_flux_r_original</code>), 
--/T to indicate that these are the original quantities determined for the
--/T r-band, without corrections. They differ from the r-band values in the
--/T arrays (e.g. <code>petro_flux_r_original</code>) in those cases where the
--/T Petrosian radius was undefined in the r-band. In those cases, the
--/T quantities in the arrays assume a Petrosian radius of 5 arcsec.
--/T <br><br>
--/T All absolute magnitudes are given with <i>H<sub>0</sub> = 100 h km
--/T s<sup>-1</sup> Mpc<sup>-1</sup></i>, so should be interpreted as 
--/T <i>M - 5 log<sub>10</sub> h</i>.
------------------------------------------------------------------------------
	nsaid     int  NOT NULL,  --/D Unique ID within NSA v1 catalog
	iauname   VARCHAR(32)  NOT NULL,  --/D IAU-style designation based on RA/Dec
	subdir    varchar(128)  NOT NULL,  --/D Subdirectory for images in the NSA 'detect' directory
	ra        float  NOT NULL,  --/U deg  --/D Right Ascension of measured object center (J2000)
	dec       float  NOT NULL,  --/U deg  --/D Declination of measured object center (J2000)
	isdss     int  NOT NULL,  --/D Zero-indexed row of SDSS source file for NSA (-1 if no match)
	ined      int  NOT NULL,  --/D Zero-indexed row of NED source file for NSA (-1 if no match)
	isixdf    int  NOT NULL,  --/D Zero-indexed row of 6dFGRS source file for NSA (-1 if no match)
	ialfalfa  int  NOT NULL,  --/D Zero-indexed row of ALFALFA source file for NSA (-1 if no match)
	izcat     int  NOT NULL,  --/D Zero-indexed row of ZCAT source file for NSA (-1 if no match)
	itwodf    int  NOT NULL,  --/D Zero-indexed row of 2dFGRS source file for NSA (-1 if no match)
	mag       real  NOT NULL,  --/U mag  --/D Nominal B magnitude; not reliable, only used to set size of image for analysis
	z         real  NOT NULL,  --/D Heliocentric redshift
	zsrc      VARCHAR(32)  NOT NULL,  --/D Source of redshift determination (alfalfa, ned, sdss, sixdf, twodf, or zcat)
	size      real  NOT NULL,  --/U deg  --/D Size of analyzed mosaics
	run       smallint  NOT NULL,  --/D SDSS drift scan run covering catalog position (racat, deccat)
	camcol    tinyint  NOT NULL,  --/D SDSS camcol covering catalog position (racat, deccat)
	field     smallint  NOT NULL,  --/D SDSS field covering catalog position (racat, deccat)
	rerun     VARCHAR(32)  NOT NULL,  --/D Photometric rerun of SDSS used to determine SDSS coverage
	xpos      real  NOT NULL,  --/U pix  --/D SDSS camera column of catalog position (racat, deccat)
	ypos      real  NOT NULL,  --/U pix  --/D SDSS camera row of catalog position (racat, deccat)
	zdist     real  NOT NULL,  --/D Distance estimate using pecular velocity model of Willick et al. (1997), expressed as a redshift equivalent; multiply by <var>c/H<sub>0</sub></var> for Mpc
	plate  int  NOT NULL,   --/D SDSS plate number (0 if not observed)
	fiberid  smallint  NOT NULL,   --/D SDSS fiber number (0 if not observed)
	mjd  int  NOT NULL,   --/U days  --/D SDSS MJD of spectroscopic observation (0 if not observed)
	racat  float  NOT NULL,   --/U deg  --/D Right Ascension of catalog object (J2000)
	deccat  float  NOT NULL,   --/U deg  --/D Declination of catalog object (J2000)
	survey  varchar(32)  NOT NULL,   --/D Survey within SDSS that observed the plate
	programname  varchar(32)  NOT NULL,   --/D Program name within the survey that observed the plate
	platequality  varchar(32)  NOT NULL,   --/D Quality of plate
	tile  int  NOT NULL,   --/D Tile number for plate containing spectrum
	plug_ra  float  NOT NULL,   --/U deg  --/D Right Ascension of spectroscopic fiber (J2000)
	plug_dec  float  NOT NULL,   --/U deg  --/D Declination of spectroscopic fiber (J2000)
	in_dr7_lss  tinyint  NOT NULL,   --/D Set to 1 if spectrum is in SDSS Legacy survey large-scale structure sample (based on the NYU Value Added Galaxy Catalog for DR7, specifically lss_geometry.dr72.ply)
	elpetro_ba  real  NOT NULL,   --/D Axis ratio used for elliptical apertures (for this version, same as petro_ba90)
	elpetro_phi  real  NOT NULL,   --/U deg  --/D Position angle (east of north) used for elliptical apertures (for this version, same as petro_ba90)
	elpetro_theta  real  NOT NULL,   --/U arcsec  --/D Elliptical SDSS-style Petrosian radius (r-band, with correction)
	elpetro_theta_r_original  real  NOT NULL,   --/F elpetro_theta_r --/U arcsec  --/D Elliptical SDSS-style Petrosian radius in SDSS r-band, no correction
	elpetro_flux_f  real  NOT NULL,   --/F elpetro_flux 0 --/U nanomaggies  --/D Elliptical SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture)
	elpetro_flux_n  real  NOT NULL,   --/F elpetro_flux 1 --/U nanomaggies  --/D Elliptical SDSS-style Petrosian flux in GALEX near-UV (using r-band aperture)
	elpetro_flux_u  real  NOT NULL,   --/F elpetro_flux 2 --/U nanomaggies  --/D Elliptical SDSS-style Petrosian flux in SDSS u-band (using r-band aperture)
	elpetro_flux_g  real  NOT NULL,   --/F elpetro_flux 3 --/U nanomaggies  --/D Elliptical SDSS-style Petrosian flux in SDSS g-band (using r-band aperture)
	elpetro_flux_r  real  NOT NULL,   --/F elpetro_flux 4 --/U nanomaggies  --/D Elliptical SDSS-style Petrosian flux in SDSS r-band (using r-band aperture)
	elpetro_flux_i  real  NOT NULL,   --/F elpetro_flux 5 --/U nanomaggies  --/D Elliptical SDSS-style Petrosian flux in SDSS i-band (using r-band aperture)
	elpetro_flux_z  real  NOT NULL,   --/F elpetro_flux 6 --/U nanomaggies  --/D Elliptical SDSS-style Petrosian flux in SDSS z-band (using r-band aperture)
	elpetro_flux_r_original  real  NOT NULL,   --/F elpetro_flux_r --/U arcsec  --/D Elliptical SDSS-style Petrosian flux in SDSS r-band, no correction
	elpetro_flux_ivar_f  real  NOT NULL,   --/F elpetro_flux_ivar 0 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_f
	elpetro_flux_ivar_n  real  NOT NULL,   --/F elpetro_flux_ivar 1 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_n
	elpetro_flux_ivar_u  real  NOT NULL,   --/F elpetro_flux_ivar 2 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_u
	elpetro_flux_ivar_g  real  NOT NULL,   --/F elpetro_flux_ivar 3 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_g
	elpetro_flux_ivar_r  real  NOT NULL,   --/F elpetro_flux_ivar 4 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_r
	elpetro_flux_ivar_i  real  NOT NULL,   --/F elpetro_flux_ivar 5 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_i
	elpetro_flux_ivar_z  real  NOT NULL,   --/F elpetro_flux_ivar 6 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_z
	elpetro_flux_ivar_r_original  real  NOT NULL,   --/F elpetro_flux_ivar_r --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_flux_r_original
	elpetro_th50_f  real  NOT NULL,   --/F elpetro_th50 0 --/U arcsec  --/D Elliptical Petrosian 50% light radius in GALEX far-UV
	elpetro_th50_n  real  NOT NULL,   --/F elpetro_th50 1 --/U arcsec  --/D Elliptical Petrosian 50% light radius in GALEX near-UV
	elpetro_th50_u  real  NOT NULL,   --/F elpetro_th50 2 --/U arcsec  --/D Elliptical Petrosian 50% light radius in SDSS u-band
	elpetro_th50_g  real  NOT NULL,   --/F elpetro_th50 3 --/U arcsec  --/D Elliptical Petrosian 50% light radius in SDSS g-band
	elpetro_th50_r  real  NOT NULL,   --/F elpetro_th50 4 --/U arcsec  --/D Elliptical Petrosian 50% light radius in SDSS r-band
	elpetro_th50_i  real  NOT NULL,   --/F elpetro_th50 5 --/U arcsec  --/D Elliptical Petrosian 50% light radius in SDSS i-band
	elpetro_th50_z  real  NOT NULL,   --/F elpetro_th50 6 --/U arcsec  --/D Elliptical Petrosian 50% light radius in SDSS z-band
	elpetro_th90_f  real  NOT NULL,   --/F elpetro_th90 0 --/U arcsec  --/D Elliptical Petrosian 90% light radius in GALEX far-UV
	elpetro_th50_r_original  real  NOT NULL,   --/F elpetro_th50_r --/U arcsec  --/D Elliptical Petrosian 50% light radius in SDSS r-band, no correction
	elpetro_th90_n  real  NOT NULL,   --/F elpetro_th90 1 --/U arcsec  --/D Elliptical Petrosian 90% light radius in GALEX near-UV
	elpetro_th90_u  real  NOT NULL,   --/F elpetro_th90 2 --/U arcsec  --/D Elliptical Petrosian 90% light radius in SDSS u-band
	elpetro_th90_g  real  NOT NULL,   --/F elpetro_th90 3 --/U arcsec  --/D Elliptical Petrosian 90% light radius in SDSS g-band
	elpetro_th90_r  real  NOT NULL,   --/F elpetro_th90 4 --/U arcsec  --/D Elliptical Petrosian 90% light radius in SDSS r-band
	elpetro_th90_i  real  NOT NULL,   --/F elpetro_th90 5 --/U arcsec  --/D Elliptical Petrosian 90% light radius in SDSS i-band
	elpetro_th90_z  real  NOT NULL,   --/F elpetro_th90 6 --/U arcsec  --/D Elliptical Petrosian 90% light radius in SDSS z-band
	elpetro_th90_r_original  real  NOT NULL,   --/F elpetro_th90_r --/U arcsec  --/D Elliptical Petrosian 90% light radius in SDSS r-band, no correction
	elpetro_nmgy_f  real  NOT NULL,   --/F elpetro_nmgy 0 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in GALEX far-UV used for K-correction (from elpetro_flux_f)
	elpetro_nmgy_n  real  NOT NULL,   --/F elpetro_nmgy 1 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in GALEX near-UV used for K-correction (from elpetro_flux_n)
	elpetro_nmgy_u  real  NOT NULL,   --/F elpetro_nmgy 2 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS u-band used for K-correction (from elpetro_flux_u)
	elpetro_nmgy_g  real  NOT NULL,   --/F elpetro_nmgy 3 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS g-band used for K-correction (from elpetro_flux_g)
	elpetro_nmgy_r  real  NOT NULL,   --/F elpetro_nmgy 4 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS r-band used for K-correction (from elpetro_flux_r)
	elpetro_nmgy_i  real  NOT NULL,   --/F elpetro_nmgy 5 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS i-band used for K-correction (from elpetro_flux_i)
	elpetro_nmgy_z  real  NOT NULL,   --/F elpetro_nmgy 6 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS z-band used for K-correction (from elpetro_flux_z)
	elpetro_nmgy_ivar_f  real  NOT NULL,   --/F elpetro_nmgy_ivar 0 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_nmgy_f
	elpetro_nmgy_ivar_n  real  NOT NULL,   --/F elpetro_nmgy_ivar 1 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_nmgy_n
	elpetro_nmgy_ivar_u  real  NOT NULL,   --/F elpetro_nmgy_ivar 2 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_nmgy_u
	elpetro_nmgy_ivar_g  real  NOT NULL,   --/F elpetro_nmgy_ivar 3 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_nmgy_g
	elpetro_nmgy_ivar_r  real  NOT NULL,   --/F elpetro_nmgy_ivar 4 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_nmgy_r
	elpetro_nmgy_ivar_i  real  NOT NULL,   --/F elpetro_nmgy_ivar 5 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_nmgy_i
	elpetro_nmgy_ivar_z  real  NOT NULL,   --/F elpetro_nmgy_ivar 6 --/U nanomaggies^{-2}  --/D Inverse variance of elpetro_nmgy_z
	elpetro_ok  smallint  NOT NULL,   --/D For elliptical Petrosian fluxes, 1 if K-correction was performed, 0 if not (should all be 1)
	elpetro_rnmgy_f  real  NOT NULL,   --/F elpetro_rnmgy 0 --/U nanomaggies  --/D Reconstructed AB nanomaggies in GALEX far-UV from K-correction fit, for elliptical Petrosian fluxes
	elpetro_rnmgy_n  real  NOT NULL,   --/F elpetro_rnmgy 1 --/U nanomaggies  --/D Reconstructed AB nanomaggies in GALEX near-UV from K-correction fit, for elliptical Petrosian fluxes
	elpetro_rnmgy_u  real  NOT NULL,   --/F elpetro_rnmgy 2 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS u-band from K-correction fit, for elliptical Petrosian fluxes
	elpetro_rnmgy_g  real  NOT NULL,   --/F elpetro_rnmgy 3 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS g-band from K-correction fit, for elliptical Petrosian fluxes
	elpetro_rnmgy_r  real  NOT NULL,   --/F elpetro_rnmgy 4 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS r-band from K-correction fit, for elliptical Petrosian fluxes
	elpetro_rnmgy_i  real  NOT NULL,   --/F elpetro_rnmgy 5 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS i-band from K-correction fit, for elliptical Petrosian fluxes
	elpetro_rnmgy_z  real  NOT NULL,   --/F elpetro_rnmgy 6 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS z-band from K-correction fit, for elliptical Petrosian fluxes
	elpetro_absmag_f  real  NOT NULL,   --/F elpetro_absmag 0 --/U mag  --/D Absolute magnitude in rest-frame GALEX far-UV, from elliptical Petrosian fluxes
	elpetro_absmag_n  real  NOT NULL,   --/F elpetro_absmag 1 --/U mag  --/D Absolute magnitude in rest-frame GALEX near-UV, from elliptical Petrosian fluxes
	elpetro_absmag_u  real  NOT NULL,   --/F elpetro_absmag 2 --/U mag  --/D Absolute magnitude in rest-frame SDSS u-band, from elliptical Petrosian fluxes
	elpetro_absmag_g  real  NOT NULL,   --/F elpetro_absmag 3 --/U mag  --/D Absolute magnitude in rest-frame SDSS g-band, from elliptical Petrosian fluxes
	elpetro_absmag_r  real  NOT NULL,   --/F elpetro_absmag 4 --/U mag  --/D Absolute magnitude in rest-frame SDSS r-band, from elliptical Petrosian fluxes
	elpetro_absmag_i  real  NOT NULL,   --/F elpetro_absmag 5 --/U mag  --/D Absolute magnitude in rest-frame SDSS i-band, from elliptical Petrosian fluxes
	elpetro_absmag_z  real  NOT NULL,   --/F elpetro_absmag 6 --/U mag  --/D Absolute magnitude in rest-frame SDSS z-band, from elliptical Petrosian fluxes
	elpetro_amivar_f  real  NOT NULL,   --/F elpetro_amivar 0 --/U mag^{-2}  --/D Inverse variance of petro_absmag_f
	elpetro_amivar_n  real  NOT NULL,   --/F elpetro_amivar 1 --/U mag^{-2}  --/D Inverse variance of petro_absmag_n
	elpetro_amivar_u  real  NOT NULL,   --/F elpetro_amivar 2 --/U mag^{-2}  --/D Inverse variance of petro_absmag_u
	elpetro_amivar_g  real  NOT NULL,   --/F elpetro_amivar 3 --/U mag^{-2}  --/D Inverse variance of petro_absmag_g
	elpetro_amivar_r  real  NOT NULL,   --/F elpetro_amivar 4 --/U mag^{-2}  --/D Inverse variance of petro_absmag_r
	elpetro_amivar_i  real  NOT NULL,   --/F elpetro_amivar 5 --/U mag^{-2}  --/D Inverse variance of petro_absmag_i
	elpetro_amivar_z  real  NOT NULL,   --/F elpetro_amivar 6 --/U mag^{-2}  --/D Inverse variance of petro_absmag_z
	elpetro_kcorrect_f  real  NOT NULL,   --/F elpetro_kcorrect 0 --/U mag  --/D K-correction value used for absolute magnitude in the GALEX far-UV for elliptical Petrosian fluxes 
	elpetro_kcorrect_n  real  NOT NULL,   --/F elpetro_kcorrect 1 --/U mag  --/D K-correction value used for absolute magnitude in the GALEX near-UV for elliptical Petrosian fluxes 
	elpetro_kcorrect_u  real  NOT NULL,   --/F elpetro_kcorrect 2 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS u-band for elliptical Petrosian fluxes 
	elpetro_kcorrect_g  real  NOT NULL,   --/F elpetro_kcorrect 3 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS g-band for elliptical Petrosian fluxes 
	elpetro_kcorrect_r  real  NOT NULL,   --/F elpetro_kcorrect 4 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS r-band for elliptical Petrosian fluxes 
	elpetro_kcorrect_i  real  NOT NULL,   --/F elpetro_kcorrect 5 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS i-band for elliptical Petrosian fluxes 
	elpetro_kcorrect_z  real  NOT NULL,   --/F elpetro_kcorrect 6 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS z-band for elliptical Petrosian fluxes 
	elpetro_kcoeff_0  real  NOT NULL,   --/F elpetro_kcoeff 0  --/D Coefficient 0 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for elliptical Petrosian fluxes
	elpetro_kcoeff_1  real  NOT NULL,   --/F elpetro_kcoeff 1  --/D Coefficient 1 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for elliptical Petrosian fluxes
	elpetro_kcoeff_2  real  NOT NULL,   --/F elpetro_kcoeff 2  --/D Coefficient 2 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for elliptical Petrosian fluxes
	elpetro_kcoeff_3  real  NOT NULL,   --/F elpetro_kcoeff 3  --/D Coefficient 3 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for elliptical Petrosian fluxes
	elpetro_kcoeff_4  real  NOT NULL,   --/F elpetro_kcoeff 4  --/D Coefficient 4 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for elliptical Petrosian fluxes
	elpetro_mass  real  NOT NULL,   --/U  solar masses --/D Stellar mass from K-correction fit (use with caution) for elliptical Petrosian fluxes
	elpetro_mtol_f  real  NOT NULL,   --/F elpetro_mtol 0 --/U solar  --/D Mass-to-light ratio derived in K-correction fit for GALEX far-UV for elliptical Petrosian fluxes
	elpetro_mtol_n  real  NOT NULL,   --/F elpetro_mtol 1 --/U solar  --/D Mass-to-light ratio derived in K-correction fit for GALEX near-UV for elliptical Petrosian fluxes
	elpetro_mtol_u  real  NOT NULL,   --/F elpetro_mtol 2 --/U solar  --/D Mass-to-light ratio derived in K-correction fit for SDSS u-band for elliptical Petrosian fluxes
	elpetro_mtol_g  real  NOT NULL,   --/F elpetro_mtol 3 --/U solar  --/D Mass-to-light ratio derived in K-correction fit for SDSS g-band for elliptical Petrosian fluxes
	elpetro_mtol_r  real  NOT NULL,   --/F elpetro_mtol 4 --/U solar  --/D Mass-to-light ratio derived in K-correction fit for SDSS r-band for elliptical Petrosian fluxes
	elpetro_mtol_i  real  NOT NULL,   --/F elpetro_mtol 5 --/U solar  --/D Mass-to-light ratio derived in K-correction fit for SDSS i-band for elliptical Petrosian fluxes
	elpetro_mtol_z  real  NOT NULL,   --/F elpetro_mtol 6 --/U solar  --/D Mass-to-light ratio derived in K-correction fit for SDSS z-band for elliptical Petrosian fluxes
	elpetro_b300  real  NOT NULL,   --/D Star-formation rate b-parameter (current over past average) for last 300 Myrs (from K-correction fit, use with caution) for elliptical Petrosian fluxes
	elpetro_b1000  real  NOT NULL,  --/D Star-formation rate b-parameter (current over past average) for last 1 Gyrs (from K-correction fit, use with caution) for elliptical Petrosian fluxes
	elpetro_mets  real  NOT NULL,   --/D Metallicity from K-correction fit (use with caution) for elliptical Petrosian fluxes
	petro_theta  real  NOT NULL,   --/U arcsec  --/D Azimuthally averaged SDSS-style Petrosian radius (derived from r band)
	petro_th50  real  NOT NULL,   --/U arcsec  --/D Azimuthally averaged SDSS-style Petrosian 50% light radius (derived from r band)
	petro_th90  real  NOT NULL,   --/U arcsec  --/D Azimuthally averaged SDSS-style Petrosian 90% light radius (derived from r band)
	petro_ba50  real  NOT NULL,   --/D Axis ratio b/a from Stokes parameters at 50% light radius (based on r-band)
	petro_phi50  real  NOT NULL,   --/U deg  --/D Angle (E of N) from Stokes parameters at 50% light radius(based on r-band)
	petro_ba90  real  NOT NULL,   --/D Axis ratio b/a from Stokes parameters at 90% light radius (based on r-band)
	petro_phi90  real  NOT NULL,   --/U deg  --/D Angle (E of N) from Stokes parameters at 90% light radius(based on r-band)
	petro_flux_f  real  NOT NULL,   --/F petro_flux 0 --/U nanomaggies  --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture)
	petro_flux_n  real  NOT NULL,   --/F petro_flux 1 --/U nanomaggies  --/D Azimuthally-averaged SDSS-style Petrosian flux in GALEX far-UV (using r-band aperture)
	petro_flux_u  real  NOT NULL,   --/F petro_flux 2 --/U nanomaggies  --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS u-band (using r-band aperture)
	petro_flux_g  real  NOT NULL,   --/F petro_flux 3 --/U nanomaggies  --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS g-band (using r-band aperture)
	petro_flux_r  real  NOT NULL,   --/F petro_flux 4 --/U nanomaggies  --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS r-band (using r-band aperture)
	petro_flux_i  real  NOT NULL,   --/F petro_flux 5 --/U nanomaggies  --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS i-band (using r-band aperture)
	petro_flux_z  real  NOT NULL,   --/F petro_flux 6 --/U nanomaggies  --/D Azimuthally-averaged SDSS-style Petrosian flux in SDSS z-band (using r-band aperture)
	petro_flux_ivar_f  real  NOT NULL,   --/F petro_flux_ivar 0 --/U nanomaggies^{-2}  --/D Inverse variance of petro_flux_f
	petro_flux_ivar_n  real  NOT NULL,   --/F petro_flux_ivar 1 --/U nanomaggies^{-2}  --/D Inverse variance of petro_flux_n
	petro_flux_ivar_u  real  NOT NULL,   --/F petro_flux_ivar 2 --/U nanomaggies^{-2}  --/D Inverse variance of petro_flux_u
	petro_flux_ivar_g  real  NOT NULL,   --/F petro_flux_ivar 3 --/U nanomaggies^{-2}  --/D Inverse variance of petro_flux_g
	petro_flux_ivar_r  real  NOT NULL,   --/F petro_flux_ivar 4 --/U nanomaggies^{-2}  --/D Inverse variance of petro_flux_r
	petro_flux_ivar_i  real  NOT NULL,   --/F petro_flux_ivar 5 --/U nanomaggies^{-2}  --/D Inverse variance of petro_flux_i
	petro_flux_ivar_z  real  NOT NULL,   --/F petro_flux_ivar 6 --/U nanomaggies^{-2}  --/D Inverse variance of petro_flux_z
	fiber_flux_f  real  NOT NULL,   --/F fiber_flux 0 --/U nanomaggies  --/D Flux in 3-arcsec diameter aperture (not apodized) in GALEX far-UV
	fiber_flux_n  real  NOT NULL,   --/F fiber_flux 1 --/U nanomaggies  --/D Flux in 3-arcsec diameter aperture (not apodized) in GALEX near-UV
	fiber_flux_u  real  NOT NULL,   --/F fiber_flux 2 --/U nanomaggies  --/D Flux in 3-arcsec diameter aperture (not apodized) in SDSS u-band
	fiber_flux_g  real  NOT NULL,   --/F fiber_flux 3 --/U nanomaggies  --/D Flux in 3-arcsec diameter aperture (not apodized) in SDSS g-band
	fiber_flux_r  real  NOT NULL,   --/F fiber_flux 4 --/U nanomaggies  --/D Flux in 3-arcsec diameter aperture (not apodized) in SDSS r-band
	fiber_flux_i  real  NOT NULL,   --/F fiber_flux 5 --/U nanomaggies  --/D Flux in 3-arcsec diameter aperture (not apodized) in SDSS i-band
	fiber_flux_z  real  NOT NULL,   --/F fiber_flux 6 --/U nanomaggies  --/D Flux in 3-arcsec diameter aperture (not apodized) in SDSS z-band
	fiber_flux_ivar_f  real  NOT NULL,   --/F fiber_flux_ivar 0 --/U nanomaggies^{-2}  --/D Inverse variance of fiber_flux_f
	fiber_flux_ivar_n  real  NOT NULL,   --/F fiber_flux_ivar 1 --/U nanomaggies^{-2}  --/D Inverse variance of fiber_flux_n
	fiber_flux_ivar_u  real  NOT NULL,   --/F fiber_flux_ivar 2 --/U nanomaggies^{-2}  --/D Inverse variance of fiber_flux_u
	fiber_flux_ivar_g  real  NOT NULL,   --/F fiber_flux_ivar 3 --/U nanomaggies^{-2}  --/D Inverse variance of fiber_flux_g
	fiber_flux_ivar_r  real  NOT NULL,   --/F fiber_flux_ivar 4 --/U nanomaggies^{-2}  --/D Inverse variance of fiber_flux_r
	fiber_flux_ivar_i  real  NOT NULL,   --/F fiber_flux_ivar 5 --/U nanomaggies^{-2}  --/D Inverse variance of fiber_flux_i
	fiber_flux_ivar_z  real  NOT NULL,   --/F fiber_flux_ivar 6 --/U nanomaggies^{-2}  --/D Inverse variance of fiber_flux_z
	sersic_n  real  NOT NULL,   --/D Sersic index from two-dimensional, single-component Sersic fit in r-band
	sersic_ba  real  NOT NULL,   --/D Axis ratio b/a from two-dimensional, single-component Sersic fit in r-band
	sersic_phi  real  NOT NULL,   --/U deg  --/D Angle (E of N) of major axis in two-dimensional, single-component Sersic fit in r-band
	sersic_th50  real  NOT NULL,   --/U arcsec  --/D 50% light radius of two-dimensional, single-component Sersic fit to r-band
	sersic_flux_f  real  NOT NULL,   --/F sersic_flux 0 --/U nanomaggies  --/D Two-dimensional, single-component Sersic fit flux in GALEX far-UV (fit using r-band structural parameters)
	sersic_flux_n  real  NOT NULL,   --/F sersic_flux 1 --/U nanomaggies  --/D Two-dimensional, single-component Sersic fit flux in GALEX near-UV (fit using r-band structural parameters)
	sersic_flux_u  real  NOT NULL,   --/F sersic_flux 2 --/U nanomaggies  --/D Two-dimensional, single-component Sersic fit flux in SDSS u-band (fit using r-band structural parameters)
	sersic_flux_g  real  NOT NULL,   --/F sersic_flux 3 --/U nanomaggies  --/D Two-dimensional, single-component Sersic fit flux in SDSS g-band (fit using r-band structural parameters)
	sersic_flux_r  real  NOT NULL,   --/F sersic_flux 4 --/U nanomaggies  --/D Two-dimensional, single-component Sersic fit flux in SDSS r-band (fit using r-band structural parameters)
	sersic_flux_i  real  NOT NULL,   --/F sersic_flux 5 --/U nanomaggies  --/D Two-dimensional, single-component Sersic fit flux in SDSS i-band (fit using r-band structural parameters)
	sersic_flux_z  real  NOT NULL,   --/F sersic_flux 6 --/U nanomaggies  --/D Two-dimensional, single-component Sersic fit flux in SDSS z-band (fit using r-band structural parameters)
	sersic_flux_ivar_f  real  NOT NULL,   --/F sersic_flux_ivar 0 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_flux_f
	sersic_flux_ivar_n  real  NOT NULL,   --/F sersic_flux_ivar 1 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_flux_n
	sersic_flux_ivar_u  real  NOT NULL,   --/F sersic_flux_ivar 2 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_flux_u
	sersic_flux_ivar_g  real  NOT NULL,   --/F sersic_flux_ivar 3 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_flux_g
	sersic_flux_ivar_r  real  NOT NULL,   --/F sersic_flux_ivar 4 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_flux_r
	sersic_flux_ivar_i  real  NOT NULL,   --/F sersic_flux_ivar 5 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_flux_i
	sersic_flux_ivar_z  real  NOT NULL,   --/F sersic_flux_ivar 6 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_flux_z
	sersic_nmgy_f  real  NOT NULL,  --/F sersic_nmgy 0 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in GALEX far-UV used for K-correction (from sersic_flux_f)
	sersic_nmgy_n  real  NOT NULL,  --/F sersic_nmgy 1 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in GALEX near-UV used for K-correction (from sersic_flux_n)
	sersic_nmgy_u  real  NOT NULL,  --/F sersic_nmgy 2 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS u-band used for K-correction (from sersic_flux_u)
	sersic_nmgy_g  real  NOT NULL,  --/F sersic_nmgy 3 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS g-band used for K-correction (from sersic_flux_g)
	sersic_nmgy_r  real  NOT NULL,  --/F sersic_nmgy 4 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS r-band used for K-correction (from sersic_flux_r)
	sersic_nmgy_i  real  NOT NULL,  --/F sersic_nmgy 5 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS i-band used for K-correction (from sersic_flux_i)
	sersic_nmgy_z  real  NOT NULL,  --/F sersic_nmgy 6 --/U nanomaggies  --/D Galactic-extinction corrected AB flux in SDSS z-band used for K-correction (from sersic_flux_z)
	sersic_nmgy_ivar_f  real  NOT NULL,  --/F sersic_nmgy_ivar 0 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_nmgy_f
	sersic_nmgy_ivar_n  real  NOT NULL,  --/F sersic_nmgy_ivar 1 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_nmgy_n
	sersic_nmgy_ivar_u  real  NOT NULL,  --/F sersic_nmgy_ivar 2 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_nmgy_u
	sersic_nmgy_ivar_g  real  NOT NULL,  --/F sersic_nmgy_ivar 3 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_nmgy_g
	sersic_nmgy_ivar_r  real  NOT NULL,  --/F sersic_nmgy_ivar 4 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_nmgy_r
	sersic_nmgy_ivar_i  real  NOT NULL,  --/F sersic_nmgy_ivar 5 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_nmgy_i
	sersic_nmgy_ivar_z  real  NOT NULL,  --/F sersic_nmgy_ivar 6 --/U nanomaggies^{-2}  --/D Inverse variance of sersic_nmgy_z
	sersic_ok  smallint  NOT NULL,  --/D For Sersic fluxes, 1 if K-correction was performed, 0 if not (should all be 1)
	sersic_rnmgy_f  real  NOT NULL,  --/F sersic_rnmgy 0 --/U nanomaggies  --/D Reconstructed AB nanomaggies in GALEX far-UV from K-correction fit, for Sersic fluxes
	sersic_rnmgy_n  real  NOT NULL,  --/F sersic_rnmgy 1 --/U nanomaggies  --/D Reconstructed AB nanomaggies in GALEX near-UV from K-correction fit, for Sersic fluxes
	sersic_rnmgy_u  real  NOT NULL,  --/F sersic_rnmgy 2 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS u-band from K-correction fit, for Sersic fluxes
	sersic_rnmgy_g  real  NOT NULL,  --/F sersic_rnmgy 3 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS g-band from K-correction fit, for Sersic fluxes
	sersic_rnmgy_r  real  NOT NULL,  --/F sersic_rnmgy 4 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS r-band from K-correction fit, for Sersic fluxes
	sersic_rnmgy_i  real  NOT NULL,  --/F sersic_rnmgy 5 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS i-band from K-correction fit, for Sersic fluxes
	sersic_rnmgy_z  real  NOT NULL,  --/F sersic_rnmgy 6 --/U nanomaggies  --/D Reconstructed AB nanomaggies in SDSS z-band from K-correction fit, for Sersic fluxes
	sersic_absmag_f  real  NOT NULL,  --/F sersic_absmag 0 --/U mag  --/D Absolute magnitude in rest-frame GALEX near-UV, from Sersic fluxes
	sersic_absmag_n  real  NOT NULL,  --/F sersic_absmag 1 --/U mag  --/D Absolute magnitude in rest-frame GALEX far-UV, from Sersic fluxes
	sersic_absmag_u  real  NOT NULL,  --/F sersic_absmag 2 --/U mag  --/D Absolute magnitude in rest-frame SDSS u-band, from Sersic fluxes
	sersic_absmag_g  real  NOT NULL,  --/F sersic_absmag 3 --/U mag  --/D Absolute magnitude in rest-frame SDSS g-band, from Sersic fluxes
	sersic_absmag_r  real  NOT NULL,  --/F sersic_absmag 4 --/U mag  --/D Absolute magnitude in rest-frame SDSS r-band, from Sersic fluxes
	sersic_absmag_i  real  NOT NULL,  --/F sersic_absmag 5 --/U mag  --/D Absolute magnitude in rest-frame SDSS i-band, from Sersic fluxes
	sersic_absmag_z  real  NOT NULL,  --/F sersic_absmag 6 --/U mag  --/D Absolute magnitude in rest-frame SDSS z-band, from Sersic fluxes
	sersic_amivar_f  real  NOT NULL,  --/F sersic_amivar 0 --/U mag^{-2}  --/D Inverse variance in sersic_absmag_f
	sersic_amivar_n  real  NOT NULL,  --/F sersic_amivar 1 --/U mag^{-2}  --/D Inverse variance in sersic_absmag_n
	sersic_amivar_u  real  NOT NULL,  --/F sersic_amivar 2 --/U mag^{-2}  --/D Inverse variance in sersic_absmag_u
	sersic_amivar_g  real  NOT NULL,  --/F sersic_amivar 3 --/U mag^{-2}  --/D Inverse variance in sersic_absmag_g
	sersic_amivar_r  real  NOT NULL,  --/F sersic_amivar 4 --/U mag^{-2}  --/D Inverse variance in sersic_absmag_r
	sersic_amivar_i  real  NOT NULL,  --/F sersic_amivar 5 --/U mag^{-2}  --/D Inverse variance in sersic_absmag_i
	sersic_amivar_z  real  NOT NULL,  --/F sersic_amivar 6 --/U mag^{-2}  --/D Inverse variance in sersic_absmag_z
	sersic_kcorrect_f  real  NOT NULL,  --/F sersic_kcorrect 0 --/U mag  --/D K-correction value used for absolute magnitude in the GALEX far-UV for Sersic fluxes
	sersic_kcorrect_n  real  NOT NULL,  --/F sersic_kcorrect 1 --/U mag  --/D K-correction value used for absolute magnitude in the GALEX near-UV for Sersic fluxes
	sersic_kcorrect_u  real  NOT NULL,  --/F sersic_kcorrect 2 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS u-band for Sersic fluxes
	sersic_kcorrect_g  real  NOT NULL,  --/F sersic_kcorrect 3 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS g-band for Sersic fluxes
	sersic_kcorrect_r  real  NOT NULL,  --/F sersic_kcorrect 4 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS r-band for Sersic fluxes
	sersic_kcorrect_i  real  NOT NULL,  --/F sersic_kcorrect 5 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS i-band for Sersic fluxes
	sersic_kcorrect_z  real  NOT NULL,  --/F sersic_kcorrect 6 --/U mag  --/D K-correction value used for absolute magnitude in the SDSS z-band for Sersic fluxes
	sersic_kcoeff_0  real  NOT NULL,  --/F sersic_kcoeff 0 --/D Coefficient 0 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for Sersic fluxes
	sersic_kcoeff_1  real  NOT NULL,  --/F sersic_kcoeff 1 --/D Coefficient 1 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for Sersic fluxes
	sersic_kcoeff_2  real  NOT NULL,  --/F sersic_kcoeff 2 --/D Coefficient 2 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for Sersic fluxes
	sersic_kcoeff_3  real  NOT NULL,  --/F sersic_kcoeff 3 --/D Coefficient 3 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for Sersic fluxes
	sersic_kcoeff_4  real  NOT NULL,  --/F sersic_kcoeff 4 --/D Coefficient 4 of templates in K-correction fit (see Blanton &amp; Roweis 2007) for Sersic fluxes
	sersic_mass  real  NOT NULL,   --/U solar masses  --/D Stellar mass from K-correction fit (use with caution) for Sersic fluxes
	sersic_mtol_f  real  NOT NULL,   --/F sersic_mtol 0 --/U solar mass per solar luminosity --/D Mass-to-light ratio derived in K-correction fit for GALEX far-UV for Sersic fluxes
	sersic_mtol_n  real  NOT NULL,   --/F sersic_mtol 1 --/U solar mass per solar luminosity --/D Mass-to-light ratio derived in K-correction fit for GALEX near-UV for Sersic fluxes
	sersic_mtol_u  real  NOT NULL,   --/F sersic_mtol 2 --/U solar mass per solar luminosity --/D Mass-to-light ratio derived in K-correction fit for SDSS u-band for Sersic fluxes
	sersic_mtol_g  real  NOT NULL,   --/F sersic_mtol 3 --/U solar mass per solar luminosity --/D Mass-to-light ratio derived in K-correction fit for SDSS g-band for Sersic fluxes
	sersic_mtol_r  real  NOT NULL,   --/F sersic_mtol 4 --/U solar mass per solar luminosity --/D Mass-to-light ratio derived in K-correction fit for SDSS r-band for Sersic fluxes
	sersic_mtol_i  real  NOT NULL,   --/F sersic_mtol 5 --/U solar mass per solar luminosity --/D Mass-to-light ratio derived in K-correction fit for SDSS i-band for Sersic fluxes
	sersic_mtol_z  real  NOT NULL,   --/F sersic_mtol 6 --/U solar mass per solar luminosity --/D Mass-to-light ratio derived in K-correction fit for SDSS z-band for Sersic fluxes
	sersic_b300  real  NOT NULL,   --/D Star-formation rate b-parameter (current over past average) for last 300 Myrs (from K-correction fit, use with caution) for Sersic fluxes
	sersic_b1000  real  NOT NULL,    --/D Star-formation rate b-parameter (current over past average) for last 1 Gyrs (from K-correction fit, use with caution) for Sersic fluxes
	sersic_mets  real  NOT NULL,   --/D Metallicity from K-correction fit (use with caution) for Sersic fluxes
	asymmetry_f  real  NOT NULL,   --/F asymmetry 0 --/D Asymmetry parameter (use with caution) in GALEX far-UV 
	asymmetry_n  real  NOT NULL,   --/F asymmetry 1 --/D Asymmetry parameter (use with caution) in GALEX near-UV 
	asymmetry_u  real  NOT NULL,   --/F asymmetry 2 --/D Asymmetry parameter (use with caution) in SDSS u-band 
	asymmetry_g  real  NOT NULL,   --/F asymmetry 3 --/D Asymmetry parameter (use with caution) in SDSS g-band 
	asymmetry_r  real  NOT NULL,   --/F asymmetry 4 --/D Asymmetry parameter (use with caution) in SDSS r-band 
	asymmetry_i  real  NOT NULL,   --/F asymmetry 5 --/D Asymmetry parameter (use with caution) in SDSS i-band 
	asymmetry_z  real  NOT NULL,   --/F asymmetry 6 --/D Asymmetry parameter (use with caution) in SDSS z-band 
	clumpy_f  real  NOT NULL,   --/F clumpy 0 --/D Clumpiness parameter (use with caution)in GALEX far-UV
	clumpy_n  real  NOT NULL,   --/F clumpy 1 --/D Clumpiness parameter (use with caution)in GALEX near-UV
	clumpy_u  real  NOT NULL,   --/F clumpy 2 --/D Clumpiness parameter (use with caution)in SDSS u-band
	clumpy_g  real  NOT NULL,   --/F clumpy 3 --/D Clumpiness parameter (use with caution)in SDSS g-band
	clumpy_r  real  NOT NULL,   --/F clumpy 4 --/D Clumpiness parameter (use with caution)in SDSS r-band
	clumpy_i  real  NOT NULL,   --/F clumpy 5 --/D Clumpiness parameter (use with caution)in SDSS i-band
	clumpy_z  real  NOT NULL,   --/F clumpy 6 --/D Clumpiness parameter (use with caution)in SDSS z-band
	extinction_f  real  NOT NULL,  --/F extinction 0 --/U mag  --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX far-UV
	extinction_n  real  NOT NULL,  --/F extinction 1 --/U mag  --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in GALEX near-UV
	extinction_u  real  NOT NULL,  --/F extinction 2 --/U mag  --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS u-band
	extinction_g  real  NOT NULL,  --/F extinction 3 --/U mag  --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS g-band
	extinction_r  real  NOT NULL,  --/F extinction 4 --/U mag  --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS r-band
	extinction_i  real  NOT NULL,  --/F extinction 5 --/U mag  --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS i-band
	extinction_z  real  NOT NULL,  --/F extinction 6 --/U mag  --/D Galactic extinction from Schlegel, Finkbeiner, and Davis (1997), in SDSS z-band
	aid  int  NOT NULL,   --/D Child id within parent
	pid  int  NOT NULL,   --/D Parent id within mosaic for this object
	xcen  float  NOT NULL,   --/U   --/D X centroid in child atlas image
	ycen  float  NOT NULL,   --/U   --/D Y centroid in child atlas image
	dflags_f  int  NOT NULL,   --/F dflags 0 --/D Bitmask flags from photometric measurement for GALEX far-UV
	dflags_n  int  NOT NULL,   --/F dflags 1 --/D Bitmask flags from photometric measurement for GALEX near-UV
	dflags_u  int  NOT NULL,   --/F dflags 2 --/D Bitmask flags from photometric measurement for SDSS u-band
	dflags_g  int  NOT NULL,   --/F dflags 3 --/D Bitmask flags from photometric measurement for SDSS g-band
	dflags_r  int  NOT NULL,   --/F dflags 4 --/D Bitmask flags from photometric measurement for SDSS r-band
	dflags_i  int  NOT NULL,   --/F dflags 5 --/D Bitmask flags from photometric measurement for SDSS i-band
	dflags_z  int  NOT NULL,   --/F dflags 6 --/D Bitmask flags from photometric measurement for SDSS z-band
	dversion  VARCHAR(32)  NOT NULL,   --/D Version of dimage software used for object detection and initial measurement
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaFirefly')
	DROP TABLE mangaFirefly
GO
--
EXEC spSetDefaultFileGroup 'mangaFirefly'
GO
CREATE TABLE mangaFirefly (
-------------------------------------------------------------------------------
--/H Contains the measured stellar population parameters for each MaNGA galaxy.
-------------------------------------------------------------------------------
--/T This is a base table containing spectroscopic
--/T information and the results of the FIREFLY fits on
--/T the MaNGA Voronoi binned spectra with S/N threshold of 10.
--/T This run has been computed using Maraston & Stromback (M11, 2011) models with 
--/T the MILES stellar library and a Kroupa stellar initial mass function.
-------------------------------------------------------------------------------
    MANGAID            varchar(32) NOT NULL,     --/D Unique MaNGA identifier.
    PLATEIFU      varchar(32) NOT NULL,   --/D Unique identifier containing the MaNGA plate and ifu combination.                                                 
    PLATE           int NOT NULL,     --/D Plate used to observe galaxy.
    IFUDSGN            varchar(32) NOT NULL,     --/D IFU used to observe galaxy.
    OBJRA            float NOT NULL,     --/D Right ascension of the galaxy, not the IFU.
    OBJDEC            float NOT NULL,     --/D Declination of the galaxy, not the IFU.
    REDSHIFT            real NOT NULL,     --/D Redshift of the galaxy.
    PHOTOMETRIC_MASS            real NOT NULL,     --/D Photometric Mass of galaxy obtained from SED fitting. In units of log(M/M_odot).
    MANGADRP_VER            varchar(32) NOT NULL,     --/D Version of MaNGA DRP that produced this data.
    MANGADAP_VER            varchar(32) NOT NULL,     --/D Version of MaNGA DAP that analysed this data.
    FIREFLY_VER            varchar(32) NOT NULL,     --/D Version of FIREFLY that analysed this data.
    LW_AGE_1RE           real NOT NULL,       --/D Property at 1Re. Units of log(Age(Gyr)).
    LW_AGE_1RE_ERROR           real NOT NULL,        --/D Error on property at 1Re. Units of log(Age(Gyr)).
    MW_AGE_1RE           real NOT NULL,       --/D Property at 1Re. Units of log(Age(Gyr)).
    MW_AGE_1RE_ERROR           real NOT NULL,       --/D Error on property at 1Re. Units of log(Age(Gyr)).
    LW_Z_1RE           real NOT NULL,        --/D Property at 1Re. Units of [Z/H].
    LW_Z_1RE_ERROR           real NOT NULL,        --/D Error on property at 1Re. Units of [Z/H].
    MW_Z_1RE           real NOT NULL,       --/D Property at 1Re. Units of [Z/H].
    MW_Z_1RE_ERROR           real NOT NULL,       --/D Error on property at 1Re. Units of [Z/H].
    LW_AGE_3ARCSEC          real NOT NULL,      --/D Property within 3arcsec diameter.  Units of log(Age(Gyr)).
    LW_AGE_3ARCSEC_ERROR           real NOT NULL,       --/D Error on property within 3arcsec. Units of log(Age(Gyr)).
    MW_AGE_3ARCSEC           real NOT NULL,        --/D Property within 3arcsec diameter. Units of log(Age(Gyr)).
    MW_AGE_3ARCSEC_ERROR           real NOT NULL,       --/D Error on property within 3arcsec. Units of log(Age(Gyr)).
    LW_Z_3ARCSEC           real NOT NULL,       --/D Property within 3arcsec diameter. Units of [Z/H].
    LW_Z_3ARCSEC_ERROR           real NOT NULL,      --/D Error on property within 3arcsec. Units of [Z/H].
    MW_Z_3ARCSEC           real NOT NULL,       --/D Property within 3arcsec diameter. Units of [Z/H].
    MW_Z_3ARCSEC_ERROR           real NOT NULL,      --/D Error on property within 3arcsec. Units of [Z/H].
    LW_AGE_GRADIENT           real NOT NULL,      --/D Gradient within 1.5Re of galaxy. Units of dex/Re.
    LW_AGE_GRADIENT_ERROR           real NOT NULL,      --/D Error on gradient within 1.5Re of galaxy. Units of dex/Re.
    LW_AGE_ZEROPOINT          real NOT NULL,      --/D Zeropoint of gradient slope.
    LW_AGE_ZEROPOINT_ERROR           real NOT NULL,      --/D Error on zeropoint of gradient slope.
    MW_AGE_GRADIENT           real NOT NULL,      --/D Gradient within 1.5Re of galaxy. Units of dex/Re.
    MW_AGE_GRADIENT_ERROR           real NOT NULL,      --/D Error on gradient within 1.5Re of galaxy. Units of dex/Re.
    MW_AGE_ZEROPOINT          real NOT NULL,      --/D Zeropoint of gradient slope.
    MW_AGE_ZEROPOINT_ERROR           real NOT NULL,      --/D Error on zeropoint of gradient slope.
    LW_Z_GRADIENT           real NOT NULL,      --/D Gradient within 1.5Re of galaxy. Units of dex/Re.
    LW_Z_GRADIENT_ERROR           real NOT NULL,      --/D Error on gradient within 1.5Re of galaxy. Units of dex/Re.
    LW_Z_ZEROPOINT          real NOT NULL,      --/D Zeropoint of gradient slope.
    LW_Z_ZEROPOINT_ERROR           real NOT NULL,      --/D Error on zeropoint of gradient slope.
    MW_Z_GRADIENT           real NOT NULL,      --/D Gradient within 1.5Re of galaxy. Units of dex/Re.
    MW_Z_GRADIENT_ERROR           real NOT NULL,      --/D Error on gradient within 1.5Re of galaxy. Units of dex/Re.
    MW_Z_ZEROPOINT          real NOT NULL,      --/D Zeropoint of gradient slope.
    MW_Z_ZEROPOINT_ERROR           real NOT NULL,      --/D Error on zeropoint of gradient slope.
)
GO
--



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaPipe3D')
	DROP TABLE mangaPipe3D
GO
--
EXEC spSetDefaultFileGroup 'mangaPipe3D'
GO
CREATE TABLE mangaPipe3D (
------------------------------------------------------------
--/H Data products of MaNGA cubes derived using Pipe3D.
------------------------------------------------------------
--/T Contains all the information of each data product.
------------------------------------------------------------
    mangaID varchar(32) NOT NULL, --/U  --/D  MaNGA name of the cube
    objra float NOT NULL, --/U degree --/D  RA of the object 
    objdec float NOT NULL, --/U degree --/D  DEC of the object 
    redshift real NOT NULL, --/U  --/D  redshift derived by Pipe3D form the center of the galaxy
    re_arc real NOT NULL, --/U arcsec --/D  adopted effective radius in arcsec
    PA real NOT NULL, --/U degrees --/D  adopted position angle in degrees
    ellip real NOT NULL, --/U  --/D  adopted elipticity
    DL real NOT NULL, --/U  --/D  adopted luminosity distance in Mpc
    re_kpc real NOT NULL, --/U kpc --/D  derived effective radius in kpc
    log_Mass real NOT NULL, --/U logMsun --/D  Integrated stellar mass in units of the solar mass in logarithm scale
    e_log_Mass real NOT NULL, --/U logMsun --/D  Error of the integrated stellar mass in units of the solar mass in logarithm scale
    log_SFR_Ha real NOT NULL, --/U logMsun/yr --/D  Integrated star-formation rate derived from the integrated Halpha flux in logarithm scale
    e_log_SFR_Ha real NOT NULL, --/U logMsun/yr --/D  Error of the Integrated star-formation rate derived from the integrated Halpha flux in logarithm scale
    log_SFR_ssp real NOT NULL, --/U logMsun/yr --/D  Integrated star-formation rate derived from the amount of stellar mass formed in the last 32Myr in logarithm scale
    e_log_SFR_ssp real NOT NULL, --/U logMsun/yr --/D  Error of the Integrated star-formation rate derived from the amount of stellar mass formed in the last 32Myr in logarithm scale
    log_Mass_gas real NOT NULL, --/U logMsun --/D  Integrated gas mass in units of the solar mass in logarithm scale estimated from the dust attenuation
    e_log_Mass_gas real NOT NULL, --/U logMsun --/D  Error in the integrated gas mass in units of the solar mass in logarithm scale estimated from the dust attenuation
    Age_LW_Re_fit real NOT NULL, --/U logyr --/D  Luminosity weighted age of the stellar population in logarithm of years at the effective radius of the galaxy
    e_Age_LW_Re_fit real NOT NULL, --/U logyr --/D  Error in the luminosity weighted age of the stellar population in logarithm of years at the effective radius of the galaxy
    alpha_Age_LW_Re_fit real NOT NULL, --/U  --/D  slope of the gradient of the LW log-age of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_Age_LW_Re_fit real NOT NULL, --/U  --/D  Error of the slope of the gradient of the LW log-age of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    age_MW_Re_fit real NOT NULL, --/U logyr --/D  Mass weighted age of the stellar population in logarithm of years at the effective radius of the galaxy
    e_age_MW_Re_fit real NOT NULL, --/U logyr --/D  Error in the Mass weighted age of the stellar population in logarithm of years at the effective radius of the galaxy
    alpha_Age_MW_Re_fit real NOT NULL, --/U  --/D  slope of the gradient of the MW log-age of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_Age_MW_Re_fit real NOT NULL, --/U  --/D  Error of the slope of the gradient of the MW log-age of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    ZH_LW_Re_fit real NOT NULL, --/U logyr --/D  Luminosity weighted metallicity of the stellar population in logarithm normalized to the solar one at the effective radius of the galaxy
    e_ZH_LW_Re_fit real NOT NULL, --/U logyr --/D  Error in the luminosity weighted metallicity of the stellar population in logarithm normalized to the solar one at the effective radius of the galaxy
    alpha_ZH_LW_Re_fit real NOT NULL, --/U  --/D  slope of the gradient of the LW log-metallicity of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_ZH_LW_Re_fit real NOT NULL, --/U  --/D  Error of the slope of the gradient of the LW log-metallicity of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    ZH_MW_Re_fit real NOT NULL, --/U logyr --/D  Mass weighted metallicity of the stellar population in logarithm normalized to the solar one at the effective radius of the galaxy
    e_ZH_MW_Re_fit real NOT NULL, --/U logyr --/D  Error in the Mass weighted metallicity of the stellar population in logarithm normalized to the solar one at the effective radius of the galaxy
    alpha_ZH_MW_Re_fit real NOT NULL, --/U  --/D  slope of the gradient of the MW log-metallicity of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_ZH_MW_Re_fit real NOT NULL, --/U  --/D  Error of the slope of the gradient of the MW log-metallicity of the stellar population within a galactocentric distance of 0.5-2.0 r_eff
    Av_ssp_Re real NOT NULL, --/U mag --/D  Dust attenuation in the V-band derived from the analysis of the stellar populations at the effective radius
    e_Av_ssp_Re real NOT NULL, --/U mag --/D  Error of the dust attenuation in the V-band derived from the analysis of the stellar populations at the effective radius
    Av_gas_Re real NOT NULL, --/U mag --/D  Dust attenuation in the V-band derived from the Ha/Hb line ratios at the effective radius
    e_Av_gas_Re real NOT NULL, --/U mag --/D  Error of the dust attenuation in the V-band derived from the Ha/Hb line ratios at the effective radius
    OH_Re_fit_O3N2 real NOT NULL, --/U  --/D  12+logO/H oxygen abundance at the effective radius derived using the Marino et al. 2013 O3N2 calibrator
    e_OH_Re_fit_O3N2 real NOT NULL, --/U  --/D  Error of 12+logO/H oxygen abundance at the effective radius derived using the Marino et al. 2013 O3N2 calibrator
    alpha_OH_Re_fit_O3N2 real NOT NULL, --/U  --/D  Slope of the oxygen abundance derived using the Marino et al. 2013 O3N2 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_OH_Re_fit_O3N2 real NOT NULL, --/U  --/D  Error of the slope of the oxygen abundance derived using the Marino et al. 2013 O3N2 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    OH_Re_fit_N2 real NOT NULL, --/U  --/D  12+logO/H oxygen abundance at the effective radius derived using the Marino et al. 2013 N2 calibrator
    e_OH_Re_fit_N2 real NOT NULL, --/U  --/D  Error of 12+logO/H oxygen abundance at the effective radius derived using the Marino et al. 2013 N2 calibrator
    alpha_OH_Re_fit_N2 real NOT NULL, --/U  --/D  Slope of the oxygen abundance derived using the Marino et al. 2013 N2 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_OH_Re_fit_N2 real NOT NULL, --/U  --/D  Error of the slope of the oxygen abundance derived using the Marino et al. 2013 N2 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    OH_Re_fit_ONS real NOT NULL, --/U  --/D  12+logO/H oxygen abundance at the effective radius derived using the Pilyugin et al. 2010 ONS calibrator
    e_OH_Re_fit_ONS real NOT NULL, --/U  --/D  Error of 12+logO/H oxygen abundance at the effective radius derived using the Pilyugin et al. 2010 ONS calibrator
    alpha_OH_Re_fit_ONS real NOT NULL, --/U  --/D  Slope of the oxygen abundance derived using the Pilyugin et al. 2010 ONS calibrator within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_OH_Re_fit_ONS real NOT NULL, --/U  --/D  Error of the slope of the oxygen abundance derived using the Pilyugin et al. 2010 ONS calibrator within a galactocentric distance of 0.5-2.0 r_eff
    OH_Re_fit_pyqz real NOT NULL, --/U  --/D  12+logO/H oxygen abundance at the effective radius derived using the pyqz calibrator
    e_OH_Re_fit_pyqz real NOT NULL, --/U  --/D  Error of 12+logO/H oxygen abundance at the effective radius derived using the pyqz calibrator
    alpha_OH_Re_fit_pyqz real NOT NULL, --/U  --/D  Slope of the oxygen abundance derived using the pyqz calibrator within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_OH_Re_fit_pyqz real NOT NULL, --/U  --/D  Error of the slope of the oxygen abundance derived using the pyqz calibrator within a galactocentric distance of 0.5-2.0 r_eff
    OH_Re_fit_t2 real NOT NULL, --/U  --/D  12+logO/H oxygen abundance at the effective radius derived using the t2 calibrator
    e_OH_Re_fit_t2 real NOT NULL, --/U  --/D  Error of 12+logO/H oxygen abundance at the effective radius derived using the t2 calibrator
    alpha_OH_Re_fit_t2 real NOT NULL, --/U  --/D  Slope of the oxygen abundance derived using the t2 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_OH_Re_fit_t2 real NOT NULL, --/U  --/D  Error of the slope of the oxygen abundance derived using the t2 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    OH_Re_fit_M08 real NOT NULL, --/U  --/D  12+logO/H oxygen abundance at the effective radius derived using the Maiolino et al. 2008 calibrator
    e_OH_Re_fit_M08 real NOT NULL, --/U  --/D  Error of 12+logO/H oxygen abundance at the effective radius derived using the Maiolino et al. 2008 calibrator
    alpha_OH_Re_fit_M08 real NOT NULL, --/U  --/D  Slope of the oxygen abundance derived using the Maiolino et al. 2008 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_OH_Re_fit_M08 real NOT NULL, --/U  --/D  Error of the slope of the oxygen abundance derived using the Maiolino et al. 2008 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    OH_Re_fit_T04 real NOT NULL, --/U  --/D  12+logO/H oxygen abundance at the effective radius derived using the Tremonti et al. 2004 calibrator
    e_OH_Re_fit_T04 real NOT NULL, --/U  --/D  Error of 12+logO/H oxygen abundance at the effective radius derived using the Tremonti et al. 2004 calibrator
    alpha_OH_Re_fit_T04 real NOT NULL, --/U  --/D  Slope of the oxygen abundance derived using the Tremonti et al. 2004 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    e_alpha_OH_Re_fit_T04 real NOT NULL, --/U  --/D  Error of the slope of the oxygen abundance derived using the Tremonti et al. 2004 calibrator within a galactocentric distance of 0.5-2.0 r_eff
    NO_Re_fit_EPM09 real NOT NULL, --/U  --/D  logN/O nitrogen-to-oxygen abundance at the effective radius derived using the Perez-Montero et al. 2009 calibrator
    e_NO_Re_fit_EPM09 real NOT NULL, --/U  --/D  Error of logN/O nitrogen-to-oxygen abundance at the effective radius derived using the Perez-Montero et al. 2009 calibrator
    alpha_NO_Re_fit_EPM09 real NOT NULL, --/U  --/D  Slope of the nitrogen-to-oxygen abundance derived using the Perez-Montero et al. 2009 calibrator
    e_alpha_NO_Re_fit_EPM09 real NOT NULL, --/U  --/D  Error of the slope of the nitrogen-to-oxygen abundance derived using the Perez-Montero et al. 2009 calibrator
    NO_Re_fit_N2S2 real NOT NULL, --/U  --/D  logN/O nitrogen-to-oxygen abundance at the effective radius derived using the Perez-Montero et al. 2009 calibrator
    e_NO_Re_fit_N2S2 real NOT NULL, --/U  --/D  Error of logN/O nitrogen-to-oxygen abundance at the effective radius derived using the Perez-Montero et al. 2009 calibrator
    alpha_NO_Re_fit_N2S2 real NOT NULL, --/U  --/D  Slope of the nitrogen-to-oxygen abundance derived using the Dopita et al. N2/S2 calibrator
    e_alpha_NO_Re_fit_N2S2 real NOT NULL, --/U  --/D  Error of the slope of the nitrogen-to-oxygen abundance derived using the Dopita et al. N2/S2 calibrator
    log_NII_Ha_cen real NOT NULL, --/U  --/D  logarithm of the [NII]6583/Halpha line ratio in the central 2.5arcsec/aperture
    e_log_NII_Ha_cen real NOT NULL, --/U  --/D  error in the logarithm of the [NII]6583/Halpha line ratio in the central 2.5arcsec/aperture
    log_OIII_Hb_cen real NOT NULL, --/U  --/D  logarithm of the [OIII]5007/Hbeta line ratio in the central 2.5arcsec/aperture
    e_log_OIII_Hb_cen real NOT NULL, --/U  --/D  error in the logarithm of the [OIII]5007/Hbeta line ratio in the central 2.5arcsec/aperture
    log_SII_Ha_cen real NOT NULL, --/U  --/D  logarithm of the [SII]6717+6731/Halpha line ratio in the central 2.5arcsec/aperture
    e_log_SII_Ha_cen real NOT NULL, --/U  --/D  error in the logarithm of the [SII]6717/Halpha line ratio in the central 2.5arcsec/aperture
    log_OII_Hb_cen real NOT NULL, --/U  --/D  logarithm of the [OII]3727/Hbeta line ratio in the central 2.5arcsec/aperture
    e_log_OII_Hb_cen real NOT NULL, --/U  --/D  error in the logarithm of the [OII]3727/Hbeta line ratio in the central 2.5arcsec/aperture
    EW_Ha_cen real NOT NULL, --/U  --/D  EW of Halpha in the central 2.5arcsec/aperture
    e_EW_Ha_cen real NOT NULL, --/U  --/D  error of the EW of Halpha in the central 2.5arcsec/aperture
    ion_class_cen real NOT NULL, --/U  --/D  Classification of the central ionization
    sigma_cen real NOT NULL, --/U km/s --/D  Velocity dispersion i.e. sigma in the central 2.5 arcsec/aperture derived for the stellar populations
    e_sigma_cen real NOT NULL, --/U km/s --/D  error in the velocity dispersion in the central 2.5 arcsec/aperture derived for the stellar populations
    sigma_cen_Ha real NOT NULL, --/U km/s --/D  Velocity dispersion i.e. sigma in the central 2.5 arcsec/aperture derived for the Halpha emission line
    e_sigma_cen_Ha real NOT NULL, --/U km/s --/D  error in the velocity dispersion in the central 2.5 arcsec/aperture derived for the  Halpha emission line
    vel_sigma_Re real NOT NULL, --/U  --/D  Velocity/dispersion ratio for the stellar populations within 1.5 effective radius
    e_vel_sigma_Re real NOT NULL, --/U  --/D  error in the velocity/dispersion ratio for the stellar populations within 1.5 effective radius
    Lambda_Re real NOT NULL, --/U  --/D  Specific angular momentum lambda parameter for the stellar populations within 1.5 effective radius
    e_Lambda_Re real NOT NULL, --/U  --/D  error in the specific angular momentum lambda parameter for the stellar populations within 1.5 effective radius
    plateifu VARCHAR(32) NOT NULL, --/U  --/D  
    plate int NOT NULL, --/U  --/D  plate ID of the MaNGA original cube
    ifudsgn int NOT NULL, --/U  --/D  IFU bundle ID of the MaNGA original cube
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaDAPall')
	DROP TABLE mangaDAPall
GO
--
EXEC spSetDefaultFileGroup 'mangaDAPall'
GO
CREATE TABLE mangaDAPall (
------------------------------------------------------------------------------
--/H Final summary file of the MaNGA Data Analysis Pipeline (DAP).
------------------------------------------------------------------------------
--/T Collated summary information about the DAP methods, and global metrics 
--/T derived from the DAP analysis products useful for sample selection.
------------------------------------------------------------------------------
    plate int NOT NULL, --/U  --/D Plate number  
    ifudesign int NOT NULL, --/U  --/D IFU design number  
    plateifu varchar(32) NOT NULL, --/U  --/D String combination of PLATE-IFU to ease searching  
    mangaid varchar(32) NOT NULL, --/U  --/D MaNGA ID string  
    drpallindx int NOT NULL, --/U  --/D Row index of the observation in the DRPall file  
    mode varchar(16) NOT NULL, --/U  --/D 3D mode of the DRP file (CUBE or RSS)  
    daptype varchar(32) NOT NULL, --/U  --/D Keyword of the analysis approach used (e.g., HYB10-GAU-MILESHC)  
    dapdone bit NOT NULL, --/U  --/D Flag that MAPS file successfully produced  
    objra float NOT NULL, --/U deg --/D RA of the galaxy center  
    objdec float NOT NULL, --/U deg --/D Declination of the galaxy center  
    ifura float NOT NULL, --/U deg --/D RA of the IFU pointing center (generally the same as OBJRA)  
    ifudec float NOT NULL, --/U deg --/D Declination of the IFU pointing center (generally the same as OBJDEC)  
    mngtarg1 int NOT NULL, --/U  --/D Main survey targeting bit  
    mngtarg2 int NOT NULL, --/U  --/D Non-galaxy targeting bit  
    mngtarg3 int NOT NULL, --/U  --/D Ancillary targeting bit  
    z real NOT NULL, --/U  --/D Redshift used to set initial guess velocity (typically identical to NSA_Z)  
    ldist_z real NOT NULL, --/U h^{-1} Mpc --/D Luminosity distance based on Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7) 
    adist_z real NOT NULL, --/U h^{-1} Mpc --/D Angular-diameter distance based on Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7)  
    nsa_z real NOT NULL, --/U  --/D Redshift from the NASA-Sloan Atlas  
    nsa_zdist real NOT NULL, --/U  --/D NSA distance estimate using pecular velocity model of Willick et al. (1997); multiply by c/H0 for Mpc.  
    ldist_nsa_z real NOT NULL, --/U h^{-1} Mpc --/D Luminosity distance based on NSA_Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7)  
    adist_nsa_z real NOT NULL, --/U h^{-1} Mpc --/D Angular-diameter distance based on NSA_Z and a standard cosmology (h=1; Ω_{M}=0.3; Ω_{Λ}=0.7)  
    nsa_elpetro_ba real NOT NULL, --/U  --/D NSA isophotal axial ratio from elliptical Petrosian analysis  
    nsa_elpetro_phi real NOT NULL, --/U deg --/D NSA isophotal position angle from elliptical Petrosian analysis  
    nsa_elpetro_th50_r real NOT NULL, --/U arcsec --/D NSA elliptical Petrosian effective radius in the r-band; the is the same as R_{e} below.  
    nsa_sersic_ba real NOT NULL, --/U  --/D NSA isophotal axial ratio from Sersic fit  
    nsa_sersic_phi real NOT NULL, --/U deg --/D NSA isophotal position angle from Sersic fit  
    nsa_sersic_th50 real NOT NULL, --/U arcsec --/D NSA effective radius from the Sersic fit  
    nsa_sersic_n real NOT NULL, --/U  --/D NSA Sersic index  
    versdrp2 varchar(16) NOT NULL, --/U  --/D Version of DRP used for 2d reductions  
    versdrp3 varchar(16) NOT NULL, --/U  --/D Version of DRP used for 3d reductions  
    verscore varchar(16) NOT NULL, --/U  --/D Version of mangacore used by the DAP  
    versutil varchar(16) NOT NULL, --/U  --/D Version of idlutils used by the DAP  
    versdap varchar(16) NOT NULL, --/U  --/D Version of mangadap  
    drp3qual int NOT NULL, --/U  --/D DRP 3D quality bit  
    dapqual int NOT NULL, --/U  --/D DAP quality bit  
    rdxqakey varchar(32) NOT NULL, --/U  --/D Configuration keyword for the method used to assess the reduced data  
    binkey varchar(32) NOT NULL, --/U  --/D Configuration keyword for the spatial binning method  
    sckey varchar(32) NOT NULL, --/U  --/D Configuration keyword for the method used to model the stellar-continuum  
    elmkey varchar(32) NOT NULL, --/U  --/D Configuration keyword that defines the emission-line moment measurement method  
    elfkey varchar(32) NOT NULL, --/U  --/D Configuration keyword that defines the emission-line modeling method  
    sikey varchar(32) NOT NULL, --/U  --/D Configuration keyword that defines the spectral-index measurement method  
    bintype varchar(16) NOT NULL, --/U  --/D Type of binning used  
    binsnr real NOT NULL, --/U  --/D Target for bin S/N, if Voronoi binning  
    tplkey varchar(32) NOT NULL, --/U  --/D The identifier of the template library, e.g., MILES.  
    datedap varchar(12) NOT NULL, --/U  --/D Date the DAP file was created and/or last modified.  
    dapbins int NOT NULL, --/U  --/D The number of "binned" spectra analyzed by the DAP.  
    rcov90 real NOT NULL, --/U arcsec --/D Semi-major axis radius (R) below which spaxels cover at least 90% of elliptical annuli with width R +/- 2.5 arcsec.  This should be independent of the DAPTYPE.  
    snr_med_g real NOT NULL, --/F SNR_MED 0 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for g.  
    snr_med_r real NOT NULL, --/F SNR_MED 1 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for r.  
    snr_med_i real NOT NULL, --/F SNR_MED 2 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for i.  
    snr_med_z real NOT NULL, --/F SNR_MED 3 --/U  --/D Median S/N per pixel in the ''griz'' bands within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for z.  
    snr_ring_g real NOT NULL, --/F SNR_RING 0 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for g.  
    snr_ring_r real NOT NULL, --/F SNR_RING 1 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for r.  
    snr_ring_i real NOT NULL, --/F SNR_RING 2 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for i.  
    snr_ring_z real NOT NULL, --/F SNR_RING 3 --/U  --/D S/N in the ''griz'' bands when binning all spaxels within 1.0-1.5 R_{e}.  This should be independent of the DAPTYPE.  Measurements specifically for z.  
    sb_1re real NOT NULL, --/U 10^{-17} erg/s/cm^{2}/angstrom/spaxel --/D Mean g-band surface brightness of valid spaxels within 1 R_e}.  This should be independent of the DAPTYPE.  
    bin_rmax real NOT NULL, --/U R_{e} --/D Maximum g-band luminosity-weighted semi-major radius of any "valid" binned spectrum.  
    bin_r_n_05 real NOT NULL, --/F BIN_R_N 0 --/U  --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 05.  
    bin_r_n_10 real NOT NULL, --/F BIN_R_N 1 --/U  --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 10.  
    bin_r_n_20 real NOT NULL, --/F BIN_R_N 2 --/U  --/D Number of binned spectra with g-band luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 20.  
    bin_r_snr_05 real NOT NULL, --/F BIN_R_SNR 0 --/U  --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 05.  
    bin_r_snr_10 real NOT NULL, --/F BIN_R_SNR 1 --/U  --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 10.  
    bin_r_snr_20 real NOT NULL, --/F BIN_R_SNR 2 --/U  --/D Median g-band S/N of all binned spectra with luminosity-weighted centers within 0-1, 0.5-1.5, and 1.5-2.5 R_{e}.  Measurements specifically for 20.  
    stellar_z real NOT NULL, --/U  --/D Flux-weighted mean redshift of the stellar component within a 2.5 arcsec aperture at the galaxy center.  
    stellar_vel_lo real NOT NULL, --/U km/s --/D Stellar velocity at 2.5% growth of all valid spaxels.  
    stellar_vel_hi real NOT NULL, --/U km/s --/D Stellar velocity at 97.5% growth of all valid spaxels.  
    stellar_vel_lo_clip real NOT NULL, --/U km/s --/D Stellar velocity at 2.5% growth after iteratively clipping 3-sigma outliers.  
    stellar_vel_hi_clip real NOT NULL, --/U km/s --/D Stellar velocity at 97.5% growth after iteratively clipping 3-sigma outliers.  
    stellar_sigma_1re real NOT NULL, --/U km/s --/D Flux-weighted mean stellar velocity dispersion of all spaxels within 1 R_{e}.  
    stellar_cont_rchi2_1re real NOT NULL, --/U  --/D Median reduced chi^{2} of the stellar-continuum fit within 1 R_{e}.  
    ha_z real NOT NULL, --/U  --/D Flux-weighted mean redshift of the Hα line within a 2.5 arcsec aperture at the galaxy center.  
    ha_gvel_lo real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 2.5% growth of all valid spaxels.  
    ha_gvel_hi real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 97.5% growth of all valid spaxels.  
    ha_gvel_lo_clip real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 2.5% growth after iteratively clipping 3-sigma outliers.  
    ha_gvel_hi_clip real NOT NULL, --/U km/s --/D Gaussian-fitted velocity of the H-alpha line at 97.5% growth after iteratively clipping 3-sigma outliers.  
    ha_gsigma_1re real NOT NULL, --/U km/s --/D Flux-weighted H-alpha velocity dispersion (from Gaussian fit) of all spaxels within 1 R_{e}.  
    ha_gsigma_hi real NOT NULL, --/U km/s --/D H-alpha velocity dispersion (from Gaussian fit) at 97.5% growth of all valid spaxels.  
    ha_gsigma_hi_clip real NOT NULL, --/U km/s --/D H-alpha velocity dispersion (from Gaussian fit) at 97.5% growth after iteratively clipping 3-sigma outliers.  
    emline_sflux_cen_oiid_3728 real NOT NULL, --/F EMLINE_SFLUX_CEN 0 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIId_3728.  
    emline_sflux_cen_oii_3729 real NOT NULL, --/F EMLINE_SFLUX_CEN 1 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OII_3729.  
    emline_sflux_cen_hthe_3798 real NOT NULL, --/F EMLINE_SFLUX_CEN 2 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hthe_3798.  
    emline_sflux_cen_heta_3836 real NOT NULL, --/F EMLINE_SFLUX_CEN 3 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heta_3836.  
    emline_sflux_cen_neiii_3869 real NOT NULL, --/F EMLINE_SFLUX_CEN 4 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3869.  
    emline_sflux_cen_hzet_3890 real NOT NULL, --/F EMLINE_SFLUX_CEN 5 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hzet_3890.  
    emline_sflux_cen_neiii_3968 real NOT NULL, --/F EMLINE_SFLUX_CEN 6 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3968.  
    emline_sflux_cen_heps_3971 real NOT NULL, --/F EMLINE_SFLUX_CEN 7 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heps_3971.  
    emline_sflux_cen_hdel_4102 real NOT NULL, --/F EMLINE_SFLUX_CEN 8 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hdel_4102.  
    emline_sflux_cen_hgam_4341 real NOT NULL, --/F EMLINE_SFLUX_CEN 9 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hgam_4341.  
    emline_sflux_cen_heii_4687 real NOT NULL, --/F EMLINE_SFLUX_CEN 10 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeII_4687.  
    emline_sflux_cen_hb_4862 real NOT NULL, --/F EMLINE_SFLUX_CEN 11 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hb_4862.  
    emline_sflux_cen_oiii_4960 real NOT NULL, --/F EMLINE_SFLUX_CEN 12 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_4960.  
    emline_sflux_cen_oiii_5008 real NOT NULL, --/F EMLINE_SFLUX_CEN 13 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_5008.  
    emline_sflux_cen_hei_5877 real NOT NULL, --/F EMLINE_SFLUX_CEN 14 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_5877.  
    emline_sflux_cen_oi_6302 real NOT NULL, --/F EMLINE_SFLUX_CEN 15 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6302.  
    emline_sflux_cen_oi_6365 real NOT NULL, --/F EMLINE_SFLUX_CEN 16 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6365.  
    emline_sflux_cen_nii_6549 real NOT NULL, --/F EMLINE_SFLUX_CEN 17 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6549.  
    emline_sflux_cen_ha_6564 real NOT NULL, --/F EMLINE_SFLUX_CEN 18 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Ha_6564.  
    emline_sflux_cen_nii_6585 real NOT NULL, --/F EMLINE_SFLUX_CEN 19 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6585.  
    emline_sflux_cen_sii_6718 real NOT NULL, --/F EMLINE_SFLUX_CEN 20 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6718.  
    emline_sflux_cen_sii_6732 real NOT NULL, --/F EMLINE_SFLUX_CEN 21 --/U  --/D Summed emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6732.  
    emline_sflux_1re_oiid_3728 real NOT NULL, --/F EMLINE_SFLUX_1RE 0 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIId_3728.  
    emline_sflux_1re_oii_3729 real NOT NULL, --/F EMLINE_SFLUX_1RE 1 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OII_3729.  
    emline_sflux_1re_hthe_3798 real NOT NULL, --/F EMLINE_SFLUX_1RE 2 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hthe_3798.  
    emline_sflux_1re_heta_3836 real NOT NULL, --/F EMLINE_SFLUX_1RE 3 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heta_3836.  
    emline_sflux_1re_neiii_3869 real NOT NULL, --/F EMLINE_SFLUX_1RE 4 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3869.  
    emline_sflux_1re_hzet_3890 real NOT NULL, --/F EMLINE_SFLUX_1RE 5 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hzet_3890.  
    emline_sflux_1re_neiii_3968 real NOT NULL, --/F EMLINE_SFLUX_1RE 6 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3968.  
    emline_sflux_1re_heps_3971 real NOT NULL, --/F EMLINE_SFLUX_1RE 7 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heps_3971.  
    emline_sflux_1re_hdel_4102 real NOT NULL, --/F EMLINE_SFLUX_1RE 8 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hdel_4102.  
    emline_sflux_1re_hgam_4341 real NOT NULL, --/F EMLINE_SFLUX_1RE 9 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hgam_4341.  
    emline_sflux_1re_heii_4687 real NOT NULL, --/F EMLINE_SFLUX_1RE 10 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeII_4687.  
    emline_sflux_1re_hb_4862 real NOT NULL, --/F EMLINE_SFLUX_1RE 11 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hb_4862.  
    emline_sflux_1re_oiii_4960 real NOT NULL, --/F EMLINE_SFLUX_1RE 12 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_4960.  
    emline_sflux_1re_oiii_5008 real NOT NULL, --/F EMLINE_SFLUX_1RE 13 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_5008.  
    emline_sflux_1re_hei_5877 real NOT NULL, --/F EMLINE_SFLUX_1RE 14 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_5877.  
    emline_sflux_1re_oi_6302 real NOT NULL, --/F EMLINE_SFLUX_1RE 15 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6302.  
    emline_sflux_1re_oi_6365 real NOT NULL, --/F EMLINE_SFLUX_1RE 16 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6365.  
    emline_sflux_1re_nii_6549 real NOT NULL, --/F EMLINE_SFLUX_1RE 17 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6549.  
    emline_sflux_1re_ha_6564 real NOT NULL, --/F EMLINE_SFLUX_1RE 18 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Ha_6564.  
    emline_sflux_1re_nii_6585 real NOT NULL, --/F EMLINE_SFLUX_1RE 19 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6585.  
    emline_sflux_1re_sii_6718 real NOT NULL, --/F EMLINE_SFLUX_1RE 20 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6718.  
    emline_sflux_1re_sii_6732 real NOT NULL, --/F EMLINE_SFLUX_1RE 21 --/U  --/D Summed emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6732.  
    emline_sflux_tot_oiid_3728 real NOT NULL, --/F EMLINE_SFLUX_TOT 0 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OIId_3728.  
    emline_sflux_tot_oii_3729 real NOT NULL, --/F EMLINE_SFLUX_TOT 1 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OII_3729.  
    emline_sflux_tot_hthe_3798 real NOT NULL, --/F EMLINE_SFLUX_TOT 2 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hthe_3798.  
    emline_sflux_tot_heta_3836 real NOT NULL, --/F EMLINE_SFLUX_TOT 3 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Heta_3836.  
    emline_sflux_tot_neiii_3869 real NOT NULL, --/F EMLINE_SFLUX_TOT 4 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NeIII_3869.  
    emline_sflux_tot_hzet_3890 real NOT NULL, --/F EMLINE_SFLUX_TOT 5 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hzet_3890.  
    emline_sflux_tot_neiii_3968 real NOT NULL, --/F EMLINE_SFLUX_TOT 6 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NeIII_3968.  
    emline_sflux_tot_heps_3971 real NOT NULL, --/F EMLINE_SFLUX_TOT 7 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Heps_3971.  
    emline_sflux_tot_hdel_4102 real NOT NULL, --/F EMLINE_SFLUX_TOT 8 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hdel_4102.  
    emline_sflux_tot_hgam_4341 real NOT NULL, --/F EMLINE_SFLUX_TOT 9 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hgam_4341.  
    emline_sflux_tot_heii_4687 real NOT NULL, --/F EMLINE_SFLUX_TOT 10 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for HeII_4687.  
    emline_sflux_tot_hb_4862 real NOT NULL, --/F EMLINE_SFLUX_TOT 11 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Hb_4862.  
    emline_sflux_tot_oiii_4960 real NOT NULL, --/F EMLINE_SFLUX_TOT 12 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OIII_4960.  
    emline_sflux_tot_oiii_5008 real NOT NULL, --/F EMLINE_SFLUX_TOT 13 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OIII_5008.  
    emline_sflux_tot_hei_5877 real NOT NULL, --/F EMLINE_SFLUX_TOT 14 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for HeI_5877.  
    emline_sflux_tot_oi_6302 real NOT NULL, --/F EMLINE_SFLUX_TOT 15 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OI_6302.  
    emline_sflux_tot_oi_6365 real NOT NULL, --/F EMLINE_SFLUX_TOT 16 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for OI_6365.  
    emline_sflux_tot_nii_6549 real NOT NULL, --/F EMLINE_SFLUX_TOT 17 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NII_6549.  
    emline_sflux_tot_ha_6564 real NOT NULL, --/F EMLINE_SFLUX_TOT 18 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for Ha_6564.  
    emline_sflux_tot_nii_6585 real NOT NULL, --/F EMLINE_SFLUX_TOT 19 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for NII_6585.  
    emline_sflux_tot_sii_6718 real NOT NULL, --/F EMLINE_SFLUX_TOT 20 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for SII_6718.  
    emline_sflux_tot_sii_6732 real NOT NULL, --/F EMLINE_SFLUX_TOT 21 --/U  --/D Total integrated flux of each summed emission measurement within the full MaNGA field-of-view.  Measurements specifically for SII_6732.  
    emline_ssb_1re_oiid_3728 real NOT NULL, --/F EMLINE_SSB_1RE 0 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIId_3728.  
    emline_ssb_1re_oii_3729 real NOT NULL, --/F EMLINE_SSB_1RE 1 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_ssb_1re_hthe_3798 real NOT NULL, --/F EMLINE_SSB_1RE 2 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_ssb_1re_heta_3836 real NOT NULL, --/F EMLINE_SSB_1RE 3 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_ssb_1re_neiii_3869 real NOT NULL, --/F EMLINE_SSB_1RE 4 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.  
    emline_ssb_1re_hzet_3890 real NOT NULL, --/F EMLINE_SSB_1RE 5 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_ssb_1re_neiii_3968 real NOT NULL, --/F EMLINE_SSB_1RE 6 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.  
    emline_ssb_1re_heps_3971 real NOT NULL, --/F EMLINE_SSB_1RE 7 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_ssb_1re_hdel_4102 real NOT NULL, --/F EMLINE_SSB_1RE 8 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_ssb_1re_hgam_4341 real NOT NULL, --/F EMLINE_SSB_1RE 9 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_ssb_1re_heii_4687 real NOT NULL, --/F EMLINE_SSB_1RE 10 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_ssb_1re_hb_4862 real NOT NULL, --/F EMLINE_SSB_1RE 11 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_ssb_1re_oiii_4960 real NOT NULL, --/F EMLINE_SSB_1RE 12 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_ssb_1re_oiii_5008 real NOT NULL, --/F EMLINE_SSB_1RE 13 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_ssb_1re_hei_5877 real NOT NULL, --/F EMLINE_SSB_1RE 14 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_ssb_1re_oi_6302 real NOT NULL, --/F EMLINE_SSB_1RE 15 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_ssb_1re_oi_6365 real NOT NULL, --/F EMLINE_SSB_1RE 16 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_ssb_1re_nii_6549 real NOT NULL, --/F EMLINE_SSB_1RE 17 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_ssb_1re_ha_6564 real NOT NULL, --/F EMLINE_SSB_1RE 18 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_ssb_1re_nii_6585 real NOT NULL, --/F EMLINE_SSB_1RE 19 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_ssb_1re_sii_6718 real NOT NULL, --/F EMLINE_SSB_1RE 20 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_ssb_1re_sii_6732 real NOT NULL, --/F EMLINE_SSB_1RE 21 --/U  --/D Mean emission-line surface-brightness from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_ssb_peak_oiid_3728 real NOT NULL, --/F EMLINE_SSB_PEAK 0 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OIId_3728.  
    emline_ssb_peak_oii_3729 real NOT NULL, --/F EMLINE_SSB_PEAK 1 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OII_3729.  
    emline_ssb_peak_hthe_3798 real NOT NULL, --/F EMLINE_SSB_PEAK 2 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hthe_3798.  
    emline_ssb_peak_heta_3836 real NOT NULL, --/F EMLINE_SSB_PEAK 3 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Heta_3836.  
    emline_ssb_peak_neiii_3869 real NOT NULL, --/F EMLINE_SSB_PEAK 4 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NeIII_3869.  
    emline_ssb_peak_hzet_3890 real NOT NULL, --/F EMLINE_SSB_PEAK 5 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hzet_3890.  
    emline_ssb_peak_neiii_3968 real NOT NULL, --/F EMLINE_SSB_PEAK 6 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NeIII_3968.  
    emline_ssb_peak_heps_3971 real NOT NULL, --/F EMLINE_SSB_PEAK 7 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Heps_3971.  
    emline_ssb_peak_hdel_4102 real NOT NULL, --/F EMLINE_SSB_PEAK 8 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hdel_4102.  
    emline_ssb_peak_hgam_4341 real NOT NULL, --/F EMLINE_SSB_PEAK 9 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hgam_4341.  
    emline_ssb_peak_heii_4687 real NOT NULL, --/F EMLINE_SSB_PEAK 10 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for HeII_4687.  
    emline_ssb_peak_hb_4862 real NOT NULL, --/F EMLINE_SSB_PEAK 11 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Hb_4862.  
    emline_ssb_peak_oiii_4960 real NOT NULL, --/F EMLINE_SSB_PEAK 12 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OIII_4960.  
    emline_ssb_peak_oiii_5008 real NOT NULL, --/F EMLINE_SSB_PEAK 13 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OIII_5008.  
    emline_ssb_peak_hei_5877 real NOT NULL, --/F EMLINE_SSB_PEAK 14 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for HeI_5877.  
    emline_ssb_peak_oi_6302 real NOT NULL, --/F EMLINE_SSB_PEAK 15 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OI_6302.  
    emline_ssb_peak_oi_6365 real NOT NULL, --/F EMLINE_SSB_PEAK 16 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for OI_6365.  
    emline_ssb_peak_nii_6549 real NOT NULL, --/F EMLINE_SSB_PEAK 17 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NII_6549.  
    emline_ssb_peak_ha_6564 real NOT NULL, --/F EMLINE_SSB_PEAK 18 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for Ha_6564.  
    emline_ssb_peak_nii_6585 real NOT NULL, --/F EMLINE_SSB_PEAK 19 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for NII_6585.  
    emline_ssb_peak_sii_6718 real NOT NULL, --/F EMLINE_SSB_PEAK 20 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for SII_6718.  
    emline_ssb_peak_sii_6732 real NOT NULL, --/F EMLINE_SSB_PEAK 21 --/U  --/D Peak summed-flux emission-line surface brightness.  Measurements specifically for SII_6732.  
    emline_sew_1re_oiid_3728 real NOT NULL, --/F EMLINE_SEW_1RE 0 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIId_3728.  
    emline_sew_1re_oii_3729 real NOT NULL, --/F EMLINE_SEW_1RE 1 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_sew_1re_hthe_3798 real NOT NULL, --/F EMLINE_SEW_1RE 2 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_sew_1re_heta_3836 real NOT NULL, --/F EMLINE_SEW_1RE 3 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_sew_1re_neiii_3869 real NOT NULL, --/F EMLINE_SEW_1RE 4 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.  
    emline_sew_1re_hzet_3890 real NOT NULL, --/F EMLINE_SEW_1RE 5 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_sew_1re_neiii_3968 real NOT NULL, --/F EMLINE_SEW_1RE 6 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.  
    emline_sew_1re_heps_3971 real NOT NULL, --/F EMLINE_SEW_1RE 7 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_sew_1re_hdel_4102 real NOT NULL, --/F EMLINE_SEW_1RE 8 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_sew_1re_hgam_4341 real NOT NULL, --/F EMLINE_SEW_1RE 9 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_sew_1re_heii_4687 real NOT NULL, --/F EMLINE_SEW_1RE 10 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_sew_1re_hb_4862 real NOT NULL, --/F EMLINE_SEW_1RE 11 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_sew_1re_oiii_4960 real NOT NULL, --/F EMLINE_SEW_1RE 12 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_sew_1re_oiii_5008 real NOT NULL, --/F EMLINE_SEW_1RE 13 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_sew_1re_hei_5877 real NOT NULL, --/F EMLINE_SEW_1RE 14 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_sew_1re_oi_6302 real NOT NULL, --/F EMLINE_SEW_1RE 15 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_sew_1re_oi_6365 real NOT NULL, --/F EMLINE_SEW_1RE 16 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_sew_1re_nii_6549 real NOT NULL, --/F EMLINE_SEW_1RE 17 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_sew_1re_ha_6564 real NOT NULL, --/F EMLINE_SEW_1RE 18 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_sew_1re_nii_6585 real NOT NULL, --/F EMLINE_SEW_1RE 19 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_sew_1re_sii_6718 real NOT NULL, --/F EMLINE_SEW_1RE 20 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_sew_1re_sii_6732 real NOT NULL, --/F EMLINE_SEW_1RE 21 --/U  --/D Mean emission-line equivalent width from the summed flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_sew_peak_oiid_3728 real NOT NULL, --/F EMLINE_SEW_PEAK 0 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for OIId_3728.  
    emline_sew_peak_oii_3729 real NOT NULL, --/F EMLINE_SEW_PEAK 1 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for OII_3729.  
    emline_sew_peak_hthe_3798 real NOT NULL, --/F EMLINE_SEW_PEAK 2 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Hthe_3798.  
    emline_sew_peak_heta_3836 real NOT NULL, --/F EMLINE_SEW_PEAK 3 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Heta_3836.  
    emline_sew_peak_neiii_3869 real NOT NULL, --/F EMLINE_SEW_PEAK 4 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for NeIII_3869.  
    emline_sew_peak_hzet_3890 real NOT NULL, --/F EMLINE_SEW_PEAK 5 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Hzet_3890.  
    emline_sew_peak_neiii_3968 real NOT NULL, --/F EMLINE_SEW_PEAK 6 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for NeIII_3968.  
    emline_sew_peak_heps_3971 real NOT NULL, --/F EMLINE_SEW_PEAK 7 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Heps_3971.  
    emline_sew_peak_hdel_4102 real NOT NULL, --/F EMLINE_SEW_PEAK 8 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Hdel_4102.  
    emline_sew_peak_hgam_4341 real NOT NULL, --/F EMLINE_SEW_PEAK 9 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Hgam_4341.  
    emline_sew_peak_heii_4687 real NOT NULL, --/F EMLINE_SEW_PEAK 10 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for HeII_4687.  
    emline_sew_peak_hb_4862 real NOT NULL, --/F EMLINE_SEW_PEAK 11 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Hb_4862.  
    emline_sew_peak_oiii_4960 real NOT NULL, --/F EMLINE_SEW_PEAK 12 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for OIII_4960.  
    emline_sew_peak_oiii_5008 real NOT NULL, --/F EMLINE_SEW_PEAK 13 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for OIII_5008.  
    emline_sew_peak_hei_5877 real NOT NULL, --/F EMLINE_SEW_PEAK 14 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for HeI_5877.  
    emline_sew_peak_oi_6302 real NOT NULL, --/F EMLINE_SEW_PEAK 15 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for OI_6302.  
    emline_sew_peak_oi_6365 real NOT NULL, --/F EMLINE_SEW_PEAK 16 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for OI_6365.  
    emline_sew_peak_nii_6549 real NOT NULL, --/F EMLINE_SEW_PEAK 17 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for NII_6549.  
    emline_sew_peak_ha_6564 real NOT NULL, --/F EMLINE_SEW_PEAK 18 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for Ha_6564.  
    emline_sew_peak_nii_6585 real NOT NULL, --/F EMLINE_SEW_PEAK 19 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for NII_6585.  
    emline_sew_peak_sii_6718 real NOT NULL, --/F EMLINE_SEW_PEAK 20 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for SII_6718.  
    emline_sew_peak_sii_6732 real NOT NULL, --/F EMLINE_SEW_PEAK 21 --/U  --/D Peak emission-line equivalent width from the summed flux measurements.  Measurements specifically for SII_6732.  
    emline_gflux_cen_oii_3727 real NOT NULL, --/F EMLINE_GFLUX_CEN 0 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OII_3727.  
    emline_gflux_cen_oii_3729 real NOT NULL, --/F EMLINE_GFLUX_CEN 1 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OII_3729.  
    emline_gflux_cen_hthe_3798 real NOT NULL, --/F EMLINE_GFLUX_CEN 2 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hthe_3798.  
    emline_gflux_cen_heta_3836 real NOT NULL, --/F EMLINE_GFLUX_CEN 3 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heta_3836.  
    emline_gflux_cen_neiii_3869 real NOT NULL, --/F EMLINE_GFLUX_CEN 4 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3869.  
    emline_gflux_cen_hzet_3890 real NOT NULL, --/F EMLINE_GFLUX_CEN 5 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hzet_3890.  
    emline_gflux_cen_neiii_3968 real NOT NULL, --/F EMLINE_GFLUX_CEN 6 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NeIII_3968.  
    emline_gflux_cen_heps_3971 real NOT NULL, --/F EMLINE_GFLUX_CEN 7 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Heps_3971.  
    emline_gflux_cen_hdel_4102 real NOT NULL, --/F EMLINE_GFLUX_CEN 8 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hdel_4102.  
    emline_gflux_cen_hgam_4341 real NOT NULL, --/F EMLINE_GFLUX_CEN 9 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hgam_4341.  
    emline_gflux_cen_heii_4687 real NOT NULL, --/F EMLINE_GFLUX_CEN 10 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeII_4687.  
    emline_gflux_cen_hb_4862 real NOT NULL, --/F EMLINE_GFLUX_CEN 11 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Hb_4862.  
    emline_gflux_cen_oiii_4960 real NOT NULL, --/F EMLINE_GFLUX_CEN 12 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_4960.  
    emline_gflux_cen_oiii_5008 real NOT NULL, --/F EMLINE_GFLUX_CEN 13 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OIII_5008.  
    emline_gflux_cen_hei_5877 real NOT NULL, --/F EMLINE_GFLUX_CEN 14 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for HeI_5877.  
    emline_gflux_cen_oi_6302 real NOT NULL, --/F EMLINE_GFLUX_CEN 15 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6302.  
    emline_gflux_cen_oi_6365 real NOT NULL, --/F EMLINE_GFLUX_CEN 16 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for OI_6365.  
    emline_gflux_cen_nii_6549 real NOT NULL, --/F EMLINE_GFLUX_CEN 17 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6549.  
    emline_gflux_cen_ha_6564 real NOT NULL, --/F EMLINE_GFLUX_CEN 18 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for Ha_6564.  
    emline_gflux_cen_nii_6585 real NOT NULL, --/F EMLINE_GFLUX_CEN 19 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for NII_6585.  
    emline_gflux_cen_sii_6718 real NOT NULL, --/F EMLINE_GFLUX_CEN 20 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6718.  
    emline_gflux_cen_sii_6732 real NOT NULL, --/F EMLINE_GFLUX_CEN 21 --/U  --/D Gaussian-fitted emission-line flux integrated within a 2.5 arcsec aperture at the galaxy center.  Measurements specifically for SII_6732.  
    emline_gflux_1re_oii_3727 real NOT NULL, --/F EMLINE_GFLUX_1RE 0 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OII_3727.  
    emline_gflux_1re_oii_3729 real NOT NULL, --/F EMLINE_GFLUX_1RE 1 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OII_3729.  
    emline_gflux_1re_hthe_3798 real NOT NULL, --/F EMLINE_GFLUX_1RE 2 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hthe_3798.  
    emline_gflux_1re_heta_3836 real NOT NULL, --/F EMLINE_GFLUX_1RE 3 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heta_3836.  
    emline_gflux_1re_neiii_3869 real NOT NULL, --/F EMLINE_GFLUX_1RE 4 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3869.  
    emline_gflux_1re_hzet_3890 real NOT NULL, --/F EMLINE_GFLUX_1RE 5 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hzet_3890.  
    emline_gflux_1re_neiii_3968 real NOT NULL, --/F EMLINE_GFLUX_1RE 6 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NeIII_3968.  
    emline_gflux_1re_heps_3971 real NOT NULL, --/F EMLINE_GFLUX_1RE 7 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Heps_3971.  
    emline_gflux_1re_hdel_4102 real NOT NULL, --/F EMLINE_GFLUX_1RE 8 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hdel_4102.  
    emline_gflux_1re_hgam_4341 real NOT NULL, --/F EMLINE_GFLUX_1RE 9 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hgam_4341.  
    emline_gflux_1re_heii_4687 real NOT NULL, --/F EMLINE_GFLUX_1RE 10 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeII_4687.  
    emline_gflux_1re_hb_4862 real NOT NULL, --/F EMLINE_GFLUX_1RE 11 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Hb_4862.  
    emline_gflux_1re_oiii_4960 real NOT NULL, --/F EMLINE_GFLUX_1RE 12 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_4960.  
    emline_gflux_1re_oiii_5008 real NOT NULL, --/F EMLINE_GFLUX_1RE 13 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OIII_5008.  
    emline_gflux_1re_hei_5877 real NOT NULL, --/F EMLINE_GFLUX_1RE 14 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for HeI_5877.  
    emline_gflux_1re_oi_6302 real NOT NULL, --/F EMLINE_GFLUX_1RE 15 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6302.  
    emline_gflux_1re_oi_6365 real NOT NULL, --/F EMLINE_GFLUX_1RE 16 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for OI_6365.  
    emline_gflux_1re_nii_6549 real NOT NULL, --/F EMLINE_GFLUX_1RE 17 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6549.  
    emline_gflux_1re_ha_6564 real NOT NULL, --/F EMLINE_GFLUX_1RE 18 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for Ha_6564.  
    emline_gflux_1re_nii_6585 real NOT NULL, --/F EMLINE_GFLUX_1RE 19 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for NII_6585.  
    emline_gflux_1re_sii_6718 real NOT NULL, --/F EMLINE_GFLUX_1RE 20 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6718.  
    emline_gflux_1re_sii_6732 real NOT NULL, --/F EMLINE_GFLUX_1RE 21 --/U  --/D Gaussian-fitted emission-line flux integrated within 1 effective-radius aperture at the galaxy.  Measurements specifically for SII_6732.  
    emline_gflux_tot_oii_3727 real NOT NULL, --/F EMLINE_GFLUX_TOT 0 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OII_3727.  
    emline_gflux_tot_oii_3729 real NOT NULL, --/F EMLINE_GFLUX_TOT 1 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OII_3729.  
    emline_gflux_tot_hthe_3798 real NOT NULL, --/F EMLINE_GFLUX_TOT 2 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hthe_3798.  
    emline_gflux_tot_heta_3836 real NOT NULL, --/F EMLINE_GFLUX_TOT 3 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Heta_3836.  
    emline_gflux_tot_neiii_3869 real NOT NULL, --/F EMLINE_GFLUX_TOT 4 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NeIII_3869.  
    emline_gflux_tot_hzet_3890 real NOT NULL, --/F EMLINE_GFLUX_TOT 5 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hzet_3890.  
    emline_gflux_tot_neiii_3968 real NOT NULL, --/F EMLINE_GFLUX_TOT 6 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NeIII_3968.  
    emline_gflux_tot_heps_3971 real NOT NULL, --/F EMLINE_GFLUX_TOT 7 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Heps_3971.  
    emline_gflux_tot_hdel_4102 real NOT NULL, --/F EMLINE_GFLUX_TOT 8 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hdel_4102.  
    emline_gflux_tot_hgam_4341 real NOT NULL, --/F EMLINE_GFLUX_TOT 9 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hgam_4341.  
    emline_gflux_tot_heii_4687 real NOT NULL, --/F EMLINE_GFLUX_TOT 10 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for HeII_4687.  
    emline_gflux_tot_hb_4862 real NOT NULL, --/F EMLINE_GFLUX_TOT 11 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Hb_4862.  
    emline_gflux_tot_oiii_4960 real NOT NULL, --/F EMLINE_GFLUX_TOT 12 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OIII_4960.  
    emline_gflux_tot_oiii_5008 real NOT NULL, --/F EMLINE_GFLUX_TOT 13 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OIII_5008.  
    emline_gflux_tot_hei_5877 real NOT NULL, --/F EMLINE_GFLUX_TOT 14 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for HeI_5877.  
    emline_gflux_tot_oi_6302 real NOT NULL, --/F EMLINE_GFLUX_TOT 15 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OI_6302.  
    emline_gflux_tot_oi_6365 real NOT NULL, --/F EMLINE_GFLUX_TOT 16 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for OI_6365.  
    emline_gflux_tot_nii_6549 real NOT NULL, --/F EMLINE_GFLUX_TOT 17 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NII_6549.  
    emline_gflux_tot_ha_6564 real NOT NULL, --/F EMLINE_GFLUX_TOT 18 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for Ha_6564.  
    emline_gflux_tot_nii_6585 real NOT NULL, --/F EMLINE_GFLUX_TOT 19 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for NII_6585.  
    emline_gflux_tot_sii_6718 real NOT NULL, --/F EMLINE_GFLUX_TOT 20 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for SII_6718.  
    emline_gflux_tot_sii_6732 real NOT NULL, --/F EMLINE_GFLUX_TOT 21 --/U  --/D Total integrated flux of the Gaussian fit to each emission line within the full MaNGA field-of-view.  Measurements specifically for SII_6732.  
    emline_gsb_1re_oii_3727 real NOT NULL, --/F EMLINE_GSB_1RE 0 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3727.  
    emline_gsb_1re_oii_3729 real NOT NULL, --/F EMLINE_GSB_1RE 1 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_gsb_1re_hthe_3798 real NOT NULL, --/F EMLINE_GSB_1RE 2 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_gsb_1re_heta_3836 real NOT NULL, --/F EMLINE_GSB_1RE 3 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_gsb_1re_neiii_3869 real NOT NULL, --/F EMLINE_GSB_1RE 4 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.  
    emline_gsb_1re_hzet_3890 real NOT NULL, --/F EMLINE_GSB_1RE 5 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_gsb_1re_neiii_3968 real NOT NULL, --/F EMLINE_GSB_1RE 6 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.  
    emline_gsb_1re_heps_3971 real NOT NULL, --/F EMLINE_GSB_1RE 7 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_gsb_1re_hdel_4102 real NOT NULL, --/F EMLINE_GSB_1RE 8 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_gsb_1re_hgam_4341 real NOT NULL, --/F EMLINE_GSB_1RE 9 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_gsb_1re_heii_4687 real NOT NULL, --/F EMLINE_GSB_1RE 10 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_gsb_1re_hb_4862 real NOT NULL, --/F EMLINE_GSB_1RE 11 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_gsb_1re_oiii_4960 real NOT NULL, --/F EMLINE_GSB_1RE 12 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_gsb_1re_oiii_5008 real NOT NULL, --/F EMLINE_GSB_1RE 13 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_gsb_1re_hei_5877 real NOT NULL, --/F EMLINE_GSB_1RE 14 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_gsb_1re_oi_6302 real NOT NULL, --/F EMLINE_GSB_1RE 15 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_gsb_1re_oi_6365 real NOT NULL, --/F EMLINE_GSB_1RE 16 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_gsb_1re_nii_6549 real NOT NULL, --/F EMLINE_GSB_1RE 17 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_gsb_1re_ha_6564 real NOT NULL, --/F EMLINE_GSB_1RE 18 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_gsb_1re_nii_6585 real NOT NULL, --/F EMLINE_GSB_1RE 19 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_gsb_1re_sii_6718 real NOT NULL, --/F EMLINE_GSB_1RE 20 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_gsb_1re_sii_6732 real NOT NULL, --/F EMLINE_GSB_1RE 21 --/U  --/D Mean emission-line surface-brightness from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_gsb_peak_oii_3727 real NOT NULL, --/F EMLINE_GSB_PEAK 0 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OII_3727.  
    emline_gsb_peak_oii_3729 real NOT NULL, --/F EMLINE_GSB_PEAK 1 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OII_3729.  
    emline_gsb_peak_hthe_3798 real NOT NULL, --/F EMLINE_GSB_PEAK 2 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hthe_3798.  
    emline_gsb_peak_heta_3836 real NOT NULL, --/F EMLINE_GSB_PEAK 3 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Heta_3836.  
    emline_gsb_peak_neiii_3869 real NOT NULL, --/F EMLINE_GSB_PEAK 4 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NeIII_3869.  
    emline_gsb_peak_hzet_3890 real NOT NULL, --/F EMLINE_GSB_PEAK 5 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hzet_3890.  
    emline_gsb_peak_neiii_3968 real NOT NULL, --/F EMLINE_GSB_PEAK 6 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NeIII_3968.  
    emline_gsb_peak_heps_3971 real NOT NULL, --/F EMLINE_GSB_PEAK 7 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Heps_3971.  
    emline_gsb_peak_hdel_4102 real NOT NULL, --/F EMLINE_GSB_PEAK 8 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hdel_4102.  
    emline_gsb_peak_hgam_4341 real NOT NULL, --/F EMLINE_GSB_PEAK 9 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hgam_4341.  
    emline_gsb_peak_heii_4687 real NOT NULL, --/F EMLINE_GSB_PEAK 10 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for HeII_4687.  
    emline_gsb_peak_hb_4862 real NOT NULL, --/F EMLINE_GSB_PEAK 11 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Hb_4862.  
    emline_gsb_peak_oiii_4960 real NOT NULL, --/F EMLINE_GSB_PEAK 12 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OIII_4960.  
    emline_gsb_peak_oiii_5008 real NOT NULL, --/F EMLINE_GSB_PEAK 13 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OIII_5008.  
    emline_gsb_peak_hei_5877 real NOT NULL, --/F EMLINE_GSB_PEAK 14 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for HeI_5877.  
    emline_gsb_peak_oi_6302 real NOT NULL, --/F EMLINE_GSB_PEAK 15 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OI_6302.  
    emline_gsb_peak_oi_6365 real NOT NULL, --/F EMLINE_GSB_PEAK 16 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for OI_6365.  
    emline_gsb_peak_nii_6549 real NOT NULL, --/F EMLINE_GSB_PEAK 17 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NII_6549.  
    emline_gsb_peak_ha_6564 real NOT NULL, --/F EMLINE_GSB_PEAK 18 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for Ha_6564.  
    emline_gsb_peak_nii_6585 real NOT NULL, --/F EMLINE_GSB_PEAK 19 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for NII_6585.  
    emline_gsb_peak_sii_6718 real NOT NULL, --/F EMLINE_GSB_PEAK 20 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for SII_6718.  
    emline_gsb_peak_sii_6732 real NOT NULL, --/F EMLINE_GSB_PEAK 21 --/U  --/D Peak Gaussian-fitted emission-line surface brightness.  Measurements specifically for SII_6732.  
    emline_gew_1re_oii_3727 real NOT NULL, --/F EMLINE_GEW_1RE 0 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3727.  
    emline_gew_1re_oii_3729 real NOT NULL, --/F EMLINE_GEW_1RE 1 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OII_3729.  
    emline_gew_1re_hthe_3798 real NOT NULL, --/F EMLINE_GEW_1RE 2 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hthe_3798.  
    emline_gew_1re_heta_3836 real NOT NULL, --/F EMLINE_GEW_1RE 3 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heta_3836.  
    emline_gew_1re_neiii_3869 real NOT NULL, --/F EMLINE_GEW_1RE 4 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3869.  
    emline_gew_1re_hzet_3890 real NOT NULL, --/F EMLINE_GEW_1RE 5 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hzet_3890.  
    emline_gew_1re_neiii_3968 real NOT NULL, --/F EMLINE_GEW_1RE 6 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NeIII_3968.  
    emline_gew_1re_heps_3971 real NOT NULL, --/F EMLINE_GEW_1RE 7 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Heps_3971.  
    emline_gew_1re_hdel_4102 real NOT NULL, --/F EMLINE_GEW_1RE 8 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hdel_4102.  
    emline_gew_1re_hgam_4341 real NOT NULL, --/F EMLINE_GEW_1RE 9 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hgam_4341.  
    emline_gew_1re_heii_4687 real NOT NULL, --/F EMLINE_GEW_1RE 10 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeII_4687.  
    emline_gew_1re_hb_4862 real NOT NULL, --/F EMLINE_GEW_1RE 11 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Hb_4862.  
    emline_gew_1re_oiii_4960 real NOT NULL, --/F EMLINE_GEW_1RE 12 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_4960.  
    emline_gew_1re_oiii_5008 real NOT NULL, --/F EMLINE_GEW_1RE 13 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OIII_5008.  
    emline_gew_1re_hei_5877 real NOT NULL, --/F EMLINE_GEW_1RE 14 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for HeI_5877.  
    emline_gew_1re_oi_6302 real NOT NULL, --/F EMLINE_GEW_1RE 15 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6302.  
    emline_gew_1re_oi_6365 real NOT NULL, --/F EMLINE_GEW_1RE 16 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for OI_6365.  
    emline_gew_1re_nii_6549 real NOT NULL, --/F EMLINE_GEW_1RE 17 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6549.  
    emline_gew_1re_ha_6564 real NOT NULL, --/F EMLINE_GEW_1RE 18 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for Ha_6564.  
    emline_gew_1re_nii_6585 real NOT NULL, --/F EMLINE_GEW_1RE 19 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for NII_6585.  
    emline_gew_1re_sii_6718 real NOT NULL, --/F EMLINE_GEW_1RE 20 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6718.  
    emline_gew_1re_sii_6732 real NOT NULL, --/F EMLINE_GEW_1RE 21 --/U  --/D Mean emission-line equivalent width from the Gaussian-fitted flux measurements within 1 R_{e}.  Measurements specifically for SII_6732.  
    emline_gew_peak_oii_3727 real NOT NULL, --/F EMLINE_GEW_PEAK 0 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for OII_3727.  
    emline_gew_peak_oii_3729 real NOT NULL, --/F EMLINE_GEW_PEAK 1 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for OII_3729.  
    emline_gew_peak_hthe_3798 real NOT NULL, --/F EMLINE_GEW_PEAK 2 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Hthe_3798.  
    emline_gew_peak_heta_3836 real NOT NULL, --/F EMLINE_GEW_PEAK 3 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Heta_3836.  
    emline_gew_peak_neiii_3869 real NOT NULL, --/F EMLINE_GEW_PEAK 4 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for NeIII_3869.  
    emline_gew_peak_hzet_3890 real NOT NULL, --/F EMLINE_GEW_PEAK 5 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Hzet_3890.  
    emline_gew_peak_neiii_3968 real NOT NULL, --/F EMLINE_GEW_PEAK 6 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for NeIII_3968.  
    emline_gew_peak_heps_3971 real NOT NULL, --/F EMLINE_GEW_PEAK 7 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Heps_3971.  
    emline_gew_peak_hdel_4102 real NOT NULL, --/F EMLINE_GEW_PEAK 8 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Hdel_4102.  
    emline_gew_peak_hgam_4341 real NOT NULL, --/F EMLINE_GEW_PEAK 9 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Hgam_4341.  
    emline_gew_peak_heii_4687 real NOT NULL, --/F EMLINE_GEW_PEAK 10 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for HeII_4687.  
    emline_gew_peak_hb_4862 real NOT NULL, --/F EMLINE_GEW_PEAK 11 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Hb_4862.  
    emline_gew_peak_oiii_4960 real NOT NULL, --/F EMLINE_GEW_PEAK 12 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for OIII_4960.  
    emline_gew_peak_oiii_5008 real NOT NULL, --/F EMLINE_GEW_PEAK 13 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for OIII_5008.  
    emline_gew_peak_hei_5877 real NOT NULL, --/F EMLINE_GEW_PEAK 14 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for HeI_5877.  
    emline_gew_peak_oi_6302 real NOT NULL, --/F EMLINE_GEW_PEAK 15 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for OI_6302.  
    emline_gew_peak_oi_6365 real NOT NULL, --/F EMLINE_GEW_PEAK 16 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for OI_6365.  
    emline_gew_peak_nii_6549 real NOT NULL, --/F EMLINE_GEW_PEAK 17 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for NII_6549.  
    emline_gew_peak_ha_6564 real NOT NULL, --/F EMLINE_GEW_PEAK 18 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for Ha_6564.  
    emline_gew_peak_nii_6585 real NOT NULL, --/F EMLINE_GEW_PEAK 19 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for NII_6585.  
    emline_gew_peak_sii_6718 real NOT NULL, --/F EMLINE_GEW_PEAK 20 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for SII_6718.  
    emline_gew_peak_sii_6732 real NOT NULL, --/F EMLINE_GEW_PEAK 21 --/U  --/D Peak emission-line equivalent width from the Gaussian-fitted flux measurements.  Measurements specifically for SII_6732.  
    specindex_lo_cn1 real NOT NULL, --/F SPECINDEX_LO 0 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CN1.  
    specindex_lo_cn2 real NOT NULL, --/F SPECINDEX_LO 1 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CN2.  
    specindex_lo_ca4227 real NOT NULL, --/F SPECINDEX_LO 2 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Ca4227.  
    specindex_lo_g4300 real NOT NULL, --/F SPECINDEX_LO 3 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for G4300.  
    specindex_lo_fe4383 real NOT NULL, --/F SPECINDEX_LO 4 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe4383.  
    specindex_lo_ca4455 real NOT NULL, --/F SPECINDEX_LO 5 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Ca4455.  
    specindex_lo_fe4531 real NOT NULL, --/F SPECINDEX_LO 6 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe4531.  
    specindex_lo_c24668 real NOT NULL, --/F SPECINDEX_LO 7 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for C24668.  
    specindex_lo_hb real NOT NULL, --/F SPECINDEX_LO 8 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Hb.  
    specindex_lo_fe5015 real NOT NULL, --/F SPECINDEX_LO 9 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5015.  
    specindex_lo_mg1 real NOT NULL, --/F SPECINDEX_LO 10 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Mg1.  
    specindex_lo_mg2 real NOT NULL, --/F SPECINDEX_LO 11 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Mg2.  
    specindex_lo_mgb real NOT NULL, --/F SPECINDEX_LO 12 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Mgb.  
    specindex_lo_fe5270 real NOT NULL, --/F SPECINDEX_LO 13 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5270.  
    specindex_lo_fe5335 real NOT NULL, --/F SPECINDEX_LO 14 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5335.  
    specindex_lo_fe5406 real NOT NULL, --/F SPECINDEX_LO 15 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5406.  
    specindex_lo_fe5709 real NOT NULL, --/F SPECINDEX_LO 16 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5709.  
    specindex_lo_fe5782 real NOT NULL, --/F SPECINDEX_LO 17 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Fe5782.  
    specindex_lo_nad real NOT NULL, --/F SPECINDEX_LO 18 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaD.  
    specindex_lo_tio1 real NOT NULL, --/F SPECINDEX_LO 19 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiO1.  
    specindex_lo_tio2 real NOT NULL, --/F SPECINDEX_LO 20 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiO2.  
    specindex_lo_hdeltaa real NOT NULL, --/F SPECINDEX_LO 21 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HDeltaA.  
    specindex_lo_hgammaa real NOT NULL, --/F SPECINDEX_LO 22 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HGammaA.  
    specindex_lo_hdeltaf real NOT NULL, --/F SPECINDEX_LO 23 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HDeltaF.  
    specindex_lo_hgammaf real NOT NULL, --/F SPECINDEX_LO 24 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for HGammaF.  
    specindex_lo_cahk real NOT NULL, --/F SPECINDEX_LO 25 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaHK.  
    specindex_lo_caii1 real NOT NULL, --/F SPECINDEX_LO 26 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaII1.  
    specindex_lo_caii2 real NOT NULL, --/F SPECINDEX_LO 27 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaII2.  
    specindex_lo_caii3 real NOT NULL, --/F SPECINDEX_LO 28 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaII3.  
    specindex_lo_pa17 real NOT NULL, --/F SPECINDEX_LO 29 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Pa17.  
    specindex_lo_pa14 real NOT NULL, --/F SPECINDEX_LO 30 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Pa14.  
    specindex_lo_pa12 real NOT NULL, --/F SPECINDEX_LO 31 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Pa12.  
    specindex_lo_mgicvd real NOT NULL, --/F SPECINDEX_LO 32 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for MgICvD.  
    specindex_lo_naicvd real NOT NULL, --/F SPECINDEX_LO 33 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaICvD.  
    specindex_lo_mgiir real NOT NULL, --/F SPECINDEX_LO 34 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for MgIIR.  
    specindex_lo_fehcvd real NOT NULL, --/F SPECINDEX_LO 35 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for FeHCvD.  
    specindex_lo_nai real NOT NULL, --/F SPECINDEX_LO 36 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaI.  
    specindex_lo_btio real NOT NULL, --/F SPECINDEX_LO 37 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for bTiO.  
    specindex_lo_atio real NOT NULL, --/F SPECINDEX_LO 38 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for aTiO.  
    specindex_lo_cah1 real NOT NULL, --/F SPECINDEX_LO 39 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaH1.  
    specindex_lo_cah2 real NOT NULL, --/F SPECINDEX_LO 40 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for CaH2.  
    specindex_lo_naisdss real NOT NULL, --/F SPECINDEX_LO 41 --/U ang --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for NaISDSS.  
    specindex_lo_tio2sdss real NOT NULL, --/F SPECINDEX_LO 42 --/U mag --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiO2SDSS.  
    specindex_lo_d4000 real NOT NULL, --/F SPECINDEX_LO 43 --/U  --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for D4000.  
    specindex_lo_dn4000 real NOT NULL, --/F SPECINDEX_LO 44 --/U  --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for Dn4000.  
    specindex_lo_tiocvd real NOT NULL, --/F SPECINDEX_LO 45 --/U  --/D Spectral index at 2.5% growth of all valid spaxels.  Measurements specifically for TiOCvD.  
    specindex_hi_cn1 real NOT NULL, --/F SPECINDEX_HI 0 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CN1.  
    specindex_hi_cn2 real NOT NULL, --/F SPECINDEX_HI 1 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CN2.  
    specindex_hi_ca4227 real NOT NULL, --/F SPECINDEX_HI 2 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Ca4227.  
    specindex_hi_g4300 real NOT NULL, --/F SPECINDEX_HI 3 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for G4300.  
    specindex_hi_fe4383 real NOT NULL, --/F SPECINDEX_HI 4 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe4383.  
    specindex_hi_ca4455 real NOT NULL, --/F SPECINDEX_HI 5 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Ca4455.  
    specindex_hi_fe4531 real NOT NULL, --/F SPECINDEX_HI 6 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe4531.  
    specindex_hi_c24668 real NOT NULL, --/F SPECINDEX_HI 7 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for C24668.  
    specindex_hi_hb real NOT NULL, --/F SPECINDEX_HI 8 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Hb.  
    specindex_hi_fe5015 real NOT NULL, --/F SPECINDEX_HI 9 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5015.  
    specindex_hi_mg1 real NOT NULL, --/F SPECINDEX_HI 10 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Mg1.  
    specindex_hi_mg2 real NOT NULL, --/F SPECINDEX_HI 11 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Mg2.  
    specindex_hi_mgb real NOT NULL, --/F SPECINDEX_HI 12 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Mgb.  
    specindex_hi_fe5270 real NOT NULL, --/F SPECINDEX_HI 13 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5270.  
    specindex_hi_fe5335 real NOT NULL, --/F SPECINDEX_HI 14 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5335.  
    specindex_hi_fe5406 real NOT NULL, --/F SPECINDEX_HI 15 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5406.  
    specindex_hi_fe5709 real NOT NULL, --/F SPECINDEX_HI 16 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5709.  
    specindex_hi_fe5782 real NOT NULL, --/F SPECINDEX_HI 17 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Fe5782.  
    specindex_hi_nad real NOT NULL, --/F SPECINDEX_HI 18 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaD.  
    specindex_hi_tio1 real NOT NULL, --/F SPECINDEX_HI 19 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiO1.  
    specindex_hi_tio2 real NOT NULL, --/F SPECINDEX_HI 20 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiO2.  
    specindex_hi_hdeltaa real NOT NULL, --/F SPECINDEX_HI 21 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HDeltaA.  
    specindex_hi_hgammaa real NOT NULL, --/F SPECINDEX_HI 22 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HGammaA.  
    specindex_hi_hdeltaf real NOT NULL, --/F SPECINDEX_HI 23 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HDeltaF.  
    specindex_hi_hgammaf real NOT NULL, --/F SPECINDEX_HI 24 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for HGammaF.  
    specindex_hi_cahk real NOT NULL, --/F SPECINDEX_HI 25 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaHK.  
    specindex_hi_caii1 real NOT NULL, --/F SPECINDEX_HI 26 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaII1.  
    specindex_hi_caii2 real NOT NULL, --/F SPECINDEX_HI 27 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaII2.  
    specindex_hi_caii3 real NOT NULL, --/F SPECINDEX_HI 28 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaII3.  
    specindex_hi_pa17 real NOT NULL, --/F SPECINDEX_HI 29 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Pa17.  
    specindex_hi_pa14 real NOT NULL, --/F SPECINDEX_HI 30 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Pa14.  
    specindex_hi_pa12 real NOT NULL, --/F SPECINDEX_HI 31 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Pa12.  
    specindex_hi_mgicvd real NOT NULL, --/F SPECINDEX_HI 32 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for MgICvD.  
    specindex_hi_naicvd real NOT NULL, --/F SPECINDEX_HI 33 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaICvD.  
    specindex_hi_mgiir real NOT NULL, --/F SPECINDEX_HI 34 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for MgIIR.  
    specindex_hi_fehcvd real NOT NULL, --/F SPECINDEX_HI 35 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for FeHCvD.  
    specindex_hi_nai real NOT NULL, --/F SPECINDEX_HI 36 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaI.  
    specindex_hi_btio real NOT NULL, --/F SPECINDEX_HI 37 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for bTiO.  
    specindex_hi_atio real NOT NULL, --/F SPECINDEX_HI 38 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for aTiO.  
    specindex_hi_cah1 real NOT NULL, --/F SPECINDEX_HI 39 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaH1.  
    specindex_hi_cah2 real NOT NULL, --/F SPECINDEX_HI 40 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for CaH2.  
    specindex_hi_naisdss real NOT NULL, --/F SPECINDEX_HI 41 --/U ang --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for NaISDSS.  
    specindex_hi_tio2sdss real NOT NULL, --/F SPECINDEX_HI 42 --/U mag --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiO2SDSS.  
    specindex_hi_d4000 real NOT NULL, --/F SPECINDEX_HI 43 --/U  --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for D4000.  
    specindex_hi_dn4000 real NOT NULL, --/F SPECINDEX_HI 44 --/U  --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for Dn4000.  
    specindex_hi_tiocvd real NOT NULL, --/F SPECINDEX_HI 45 --/U  --/D Spectral index at 97.5% growth of all valid spaxels.  Measurements specifically for TiOCvD.  
    specindex_lo_clip_cn1 real NOT NULL, --/F SPECINDEX_LO_CLIP 0 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN1.  
    specindex_lo_clip_cn2 real NOT NULL, --/F SPECINDEX_LO_CLIP 1 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN2.  
    specindex_lo_clip_ca4227 real NOT NULL, --/F SPECINDEX_LO_CLIP 2 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4227.  
    specindex_lo_clip_g4300 real NOT NULL, --/F SPECINDEX_LO_CLIP 3 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for G4300.  
    specindex_lo_clip_fe4383 real NOT NULL, --/F SPECINDEX_LO_CLIP 4 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4383.  
    specindex_lo_clip_ca4455 real NOT NULL, --/F SPECINDEX_LO_CLIP 5 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4455.  
    specindex_lo_clip_fe4531 real NOT NULL, --/F SPECINDEX_LO_CLIP 6 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4531.  
    specindex_lo_clip_c24668 real NOT NULL, --/F SPECINDEX_LO_CLIP 7 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for C24668.  
    specindex_lo_clip_hb real NOT NULL, --/F SPECINDEX_LO_CLIP 8 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Hb.  
    specindex_lo_clip_fe5015 real NOT NULL, --/F SPECINDEX_LO_CLIP 9 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5015.  
    specindex_lo_clip_mg1 real NOT NULL, --/F SPECINDEX_LO_CLIP 10 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg1.  
    specindex_lo_clip_mg2 real NOT NULL, --/F SPECINDEX_LO_CLIP 11 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg2.  
    specindex_lo_clip_mgb real NOT NULL, --/F SPECINDEX_LO_CLIP 12 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mgb.  
    specindex_lo_clip_fe5270 real NOT NULL, --/F SPECINDEX_LO_CLIP 13 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5270.  
    specindex_lo_clip_fe5335 real NOT NULL, --/F SPECINDEX_LO_CLIP 14 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5335.  
    specindex_lo_clip_fe5406 real NOT NULL, --/F SPECINDEX_LO_CLIP 15 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5406.  
    specindex_lo_clip_fe5709 real NOT NULL, --/F SPECINDEX_LO_CLIP 16 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5709.  
    specindex_lo_clip_fe5782 real NOT NULL, --/F SPECINDEX_LO_CLIP 17 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5782.  
    specindex_lo_clip_nad real NOT NULL, --/F SPECINDEX_LO_CLIP 18 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaD.  
    specindex_lo_clip_tio1 real NOT NULL, --/F SPECINDEX_LO_CLIP 19 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO1.  
    specindex_lo_clip_tio2 real NOT NULL, --/F SPECINDEX_LO_CLIP 20 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2.  
    specindex_lo_clip_hdeltaa real NOT NULL, --/F SPECINDEX_LO_CLIP 21 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaA.  
    specindex_lo_clip_hgammaa real NOT NULL, --/F SPECINDEX_LO_CLIP 22 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaA.  
    specindex_lo_clip_hdeltaf real NOT NULL, --/F SPECINDEX_LO_CLIP 23 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaF.  
    specindex_lo_clip_hgammaf real NOT NULL, --/F SPECINDEX_LO_CLIP 24 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaF.  
    specindex_lo_clip_cahk real NOT NULL, --/F SPECINDEX_LO_CLIP 25 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaHK.  
    specindex_lo_clip_caii1 real NOT NULL, --/F SPECINDEX_LO_CLIP 26 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII1.  
    specindex_lo_clip_caii2 real NOT NULL, --/F SPECINDEX_LO_CLIP 27 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII2.  
    specindex_lo_clip_caii3 real NOT NULL, --/F SPECINDEX_LO_CLIP 28 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII3.  
    specindex_lo_clip_pa17 real NOT NULL, --/F SPECINDEX_LO_CLIP 29 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa17.  
    specindex_lo_clip_pa14 real NOT NULL, --/F SPECINDEX_LO_CLIP 30 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa14.  
    specindex_lo_clip_pa12 real NOT NULL, --/F SPECINDEX_LO_CLIP 31 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa12.  
    specindex_lo_clip_mgicvd real NOT NULL, --/F SPECINDEX_LO_CLIP 32 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgICvD.  
    specindex_lo_clip_naicvd real NOT NULL, --/F SPECINDEX_LO_CLIP 33 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaICvD.  
    specindex_lo_clip_mgiir real NOT NULL, --/F SPECINDEX_LO_CLIP 34 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgIIR.  
    specindex_lo_clip_fehcvd real NOT NULL, --/F SPECINDEX_LO_CLIP 35 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for FeHCvD.  
    specindex_lo_clip_nai real NOT NULL, --/F SPECINDEX_LO_CLIP 36 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaI.  
    specindex_lo_clip_btio real NOT NULL, --/F SPECINDEX_LO_CLIP 37 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for bTiO.  
    specindex_lo_clip_atio real NOT NULL, --/F SPECINDEX_LO_CLIP 38 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for aTiO.  
    specindex_lo_clip_cah1 real NOT NULL, --/F SPECINDEX_LO_CLIP 39 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH1.  
    specindex_lo_clip_cah2 real NOT NULL, --/F SPECINDEX_LO_CLIP 40 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH2.  
    specindex_lo_clip_naisdss real NOT NULL, --/F SPECINDEX_LO_CLIP 41 --/U ang --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaISDSS.  
    specindex_lo_clip_tio2sdss real NOT NULL, --/F SPECINDEX_LO_CLIP 42 --/U mag --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2SDSS.  
    specindex_lo_clip_d4000 real NOT NULL, --/F SPECINDEX_LO_CLIP 43 --/U  --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for D4000.  
    specindex_lo_clip_dn4000 real NOT NULL, --/F SPECINDEX_LO_CLIP 44 --/U  --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Dn4000.  
    specindex_lo_clip_tiocvd real NOT NULL, --/F SPECINDEX_LO_CLIP 45 --/U  --/D Spectral index at 2.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiOCvD.  
    specindex_hi_clip_cn1 real NOT NULL, --/F SPECINDEX_HI_CLIP 0 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN1.  
    specindex_hi_clip_cn2 real NOT NULL, --/F SPECINDEX_HI_CLIP 1 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CN2.  
    specindex_hi_clip_ca4227 real NOT NULL, --/F SPECINDEX_HI_CLIP 2 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4227.  
    specindex_hi_clip_g4300 real NOT NULL, --/F SPECINDEX_HI_CLIP 3 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for G4300.  
    specindex_hi_clip_fe4383 real NOT NULL, --/F SPECINDEX_HI_CLIP 4 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4383.  
    specindex_hi_clip_ca4455 real NOT NULL, --/F SPECINDEX_HI_CLIP 5 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Ca4455.  
    specindex_hi_clip_fe4531 real NOT NULL, --/F SPECINDEX_HI_CLIP 6 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe4531.  
    specindex_hi_clip_c24668 real NOT NULL, --/F SPECINDEX_HI_CLIP 7 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for C24668.  
    specindex_hi_clip_hb real NOT NULL, --/F SPECINDEX_HI_CLIP 8 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Hb.  
    specindex_hi_clip_fe5015 real NOT NULL, --/F SPECINDEX_HI_CLIP 9 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5015.  
    specindex_hi_clip_mg1 real NOT NULL, --/F SPECINDEX_HI_CLIP 10 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg1.  
    specindex_hi_clip_mg2 real NOT NULL, --/F SPECINDEX_HI_CLIP 11 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mg2.  
    specindex_hi_clip_mgb real NOT NULL, --/F SPECINDEX_HI_CLIP 12 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Mgb.  
    specindex_hi_clip_fe5270 real NOT NULL, --/F SPECINDEX_HI_CLIP 13 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5270.  
    specindex_hi_clip_fe5335 real NOT NULL, --/F SPECINDEX_HI_CLIP 14 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5335.  
    specindex_hi_clip_fe5406 real NOT NULL, --/F SPECINDEX_HI_CLIP 15 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5406.  
    specindex_hi_clip_fe5709 real NOT NULL, --/F SPECINDEX_HI_CLIP 16 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5709.  
    specindex_hi_clip_fe5782 real NOT NULL, --/F SPECINDEX_HI_CLIP 17 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Fe5782.  
    specindex_hi_clip_nad real NOT NULL, --/F SPECINDEX_HI_CLIP 18 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaD.  
    specindex_hi_clip_tio1 real NOT NULL, --/F SPECINDEX_HI_CLIP 19 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO1.  
    specindex_hi_clip_tio2 real NOT NULL, --/F SPECINDEX_HI_CLIP 20 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2.  
    specindex_hi_clip_hdeltaa real NOT NULL, --/F SPECINDEX_HI_CLIP 21 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaA.  
    specindex_hi_clip_hgammaa real NOT NULL, --/F SPECINDEX_HI_CLIP 22 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaA.  
    specindex_hi_clip_hdeltaf real NOT NULL, --/F SPECINDEX_HI_CLIP 23 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HDeltaF.  
    specindex_hi_clip_hgammaf real NOT NULL, --/F SPECINDEX_HI_CLIP 24 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for HGammaF.  
    specindex_hi_clip_cahk real NOT NULL, --/F SPECINDEX_HI_CLIP 25 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaHK.  
    specindex_hi_clip_caii1 real NOT NULL, --/F SPECINDEX_HI_CLIP 26 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII1.  
    specindex_hi_clip_caii2 real NOT NULL, --/F SPECINDEX_HI_CLIP 27 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII2.  
    specindex_hi_clip_caii3 real NOT NULL, --/F SPECINDEX_HI_CLIP 28 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaII3.  
    specindex_hi_clip_pa17 real NOT NULL, --/F SPECINDEX_HI_CLIP 29 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa17.  
    specindex_hi_clip_pa14 real NOT NULL, --/F SPECINDEX_HI_CLIP 30 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa14.  
    specindex_hi_clip_pa12 real NOT NULL, --/F SPECINDEX_HI_CLIP 31 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Pa12.  
    specindex_hi_clip_mgicvd real NOT NULL, --/F SPECINDEX_HI_CLIP 32 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgICvD.  
    specindex_hi_clip_naicvd real NOT NULL, --/F SPECINDEX_HI_CLIP 33 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaICvD.  
    specindex_hi_clip_mgiir real NOT NULL, --/F SPECINDEX_HI_CLIP 34 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for MgIIR.  
    specindex_hi_clip_fehcvd real NOT NULL, --/F SPECINDEX_HI_CLIP 35 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for FeHCvD.  
    specindex_hi_clip_nai real NOT NULL, --/F SPECINDEX_HI_CLIP 36 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaI.  
    specindex_hi_clip_btio real NOT NULL, --/F SPECINDEX_HI_CLIP 37 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for bTiO.  
    specindex_hi_clip_atio real NOT NULL, --/F SPECINDEX_HI_CLIP 38 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for aTiO.  
    specindex_hi_clip_cah1 real NOT NULL, --/F SPECINDEX_HI_CLIP 39 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH1.  
    specindex_hi_clip_cah2 real NOT NULL, --/F SPECINDEX_HI_CLIP 40 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for CaH2.  
    specindex_hi_clip_naisdss real NOT NULL, --/F SPECINDEX_HI_CLIP 41 --/U ang --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for NaISDSS.  
    specindex_hi_clip_tio2sdss real NOT NULL, --/F SPECINDEX_HI_CLIP 42 --/U mag --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiO2SDSS.  
    specindex_hi_clip_d4000 real NOT NULL, --/F SPECINDEX_HI_CLIP 43 --/U  --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for D4000.  
    specindex_hi_clip_dn4000 real NOT NULL, --/F SPECINDEX_HI_CLIP 44 --/U  --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for Dn4000.  
    specindex_hi_clip_tiocvd real NOT NULL, --/F SPECINDEX_HI_CLIP 45 --/U  --/D Spectral index at 97.5% growth after iteratively clipping 3-sigma outliers.  Measurements specifically for TiOCvD.  
    specindex_1re_cn1 real NOT NULL, --/F SPECINDEX_1RE 0 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CN1.  
    specindex_1re_cn2 real NOT NULL, --/F SPECINDEX_1RE 1 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CN2.  
    specindex_1re_ca4227 real NOT NULL, --/F SPECINDEX_1RE 2 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Ca4227.  
    specindex_1re_g4300 real NOT NULL, --/F SPECINDEX_1RE 3 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for G4300.  
    specindex_1re_fe4383 real NOT NULL, --/F SPECINDEX_1RE 4 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe4383.  
    specindex_1re_ca4455 real NOT NULL, --/F SPECINDEX_1RE 5 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Ca4455.  
    specindex_1re_fe4531 real NOT NULL, --/F SPECINDEX_1RE 6 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe4531.  
    specindex_1re_c24668 real NOT NULL, --/F SPECINDEX_1RE 7 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for C24668.  
    specindex_1re_hb real NOT NULL, --/F SPECINDEX_1RE 8 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Hb.  
    specindex_1re_fe5015 real NOT NULL, --/F SPECINDEX_1RE 9 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5015.  
    specindex_1re_mg1 real NOT NULL, --/F SPECINDEX_1RE 10 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for Mg1.  
    specindex_1re_mg2 real NOT NULL, --/F SPECINDEX_1RE 11 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for Mg2.  
    specindex_1re_mgb real NOT NULL, --/F SPECINDEX_1RE 12 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Mgb.  
    specindex_1re_fe5270 real NOT NULL, --/F SPECINDEX_1RE 13 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5270.  
    specindex_1re_fe5335 real NOT NULL, --/F SPECINDEX_1RE 14 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5335.  
    specindex_1re_fe5406 real NOT NULL, --/F SPECINDEX_1RE 15 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5406.  
    specindex_1re_fe5709 real NOT NULL, --/F SPECINDEX_1RE 16 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5709.  
    specindex_1re_fe5782 real NOT NULL, --/F SPECINDEX_1RE 17 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Fe5782.  
    specindex_1re_nad real NOT NULL, --/F SPECINDEX_1RE 18 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaD.  
    specindex_1re_tio1 real NOT NULL, --/F SPECINDEX_1RE 19 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for TiO1.  
    specindex_1re_tio2 real NOT NULL, --/F SPECINDEX_1RE 20 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for TiO2.  
    specindex_1re_hdeltaa real NOT NULL, --/F SPECINDEX_1RE 21 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HDeltaA.  
    specindex_1re_hgammaa real NOT NULL, --/F SPECINDEX_1RE 22 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HGammaA.  
    specindex_1re_hdeltaf real NOT NULL, --/F SPECINDEX_1RE 23 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HDeltaF.  
    specindex_1re_hgammaf real NOT NULL, --/F SPECINDEX_1RE 24 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for HGammaF.  
    specindex_1re_cahk real NOT NULL, --/F SPECINDEX_1RE 25 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaHK.  
    specindex_1re_caii1 real NOT NULL, --/F SPECINDEX_1RE 26 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaII1.  
    specindex_1re_caii2 real NOT NULL, --/F SPECINDEX_1RE 27 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaII2.  
    specindex_1re_caii3 real NOT NULL, --/F SPECINDEX_1RE 28 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for CaII3.  
    specindex_1re_pa17 real NOT NULL, --/F SPECINDEX_1RE 29 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Pa17.  
    specindex_1re_pa14 real NOT NULL, --/F SPECINDEX_1RE 30 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Pa14.  
    specindex_1re_pa12 real NOT NULL, --/F SPECINDEX_1RE 31 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for Pa12.  
    specindex_1re_mgicvd real NOT NULL, --/F SPECINDEX_1RE 32 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for MgICvD.  
    specindex_1re_naicvd real NOT NULL, --/F SPECINDEX_1RE 33 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaICvD.  
    specindex_1re_mgiir real NOT NULL, --/F SPECINDEX_1RE 34 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for MgIIR.  
    specindex_1re_fehcvd real NOT NULL, --/F SPECINDEX_1RE 35 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for FeHCvD.  
    specindex_1re_nai real NOT NULL, --/F SPECINDEX_1RE 36 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaI.  
    specindex_1re_btio real NOT NULL, --/F SPECINDEX_1RE 37 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for bTiO.  
    specindex_1re_atio real NOT NULL, --/F SPECINDEX_1RE 38 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for aTiO.  
    specindex_1re_cah1 real NOT NULL, --/F SPECINDEX_1RE 39 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CaH1.  
    specindex_1re_cah2 real NOT NULL, --/F SPECINDEX_1RE 40 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for CaH2.  
    specindex_1re_naisdss real NOT NULL, --/F SPECINDEX_1RE 41 --/U ang --/D Median spectral index within 1 effective radius.  Measurements specifically for NaISDSS.  
    specindex_1re_tio2sdss real NOT NULL, --/F SPECINDEX_1RE 42 --/U mag --/D Median spectral index within 1 effective radius.  Measurements specifically for TiO2SDSS.  
    specindex_1re_d4000 real NOT NULL, --/F SPECINDEX_1RE 43 --/U  --/D Median spectral index within 1 effective radius.  Measurements specifically for D4000.  
    specindex_1re_dn4000 real NOT NULL, --/F SPECINDEX_1RE 44 --/U  --/D Median spectral index within 1 effective radius.  Measurements specifically for Dn4000.  
    specindex_1re_tiocvd real NOT NULL, --/F SPECINDEX_1RE 45 --/U  --/D Median spectral index within 1 effective radius.  Measurements specifically for TiOCvD.  
    sfr_1re real NOT NULL, --/U h^{-2} M_{sun}/yr --/D Simple estimate of the star-formation rate within 1 effective radius based on the Gaussian-fitted Hα flux; log(SFR) = log L_{Hα} - 41.27 (Kennicutt & Evans [2012, ARAA, 50, 531], citing Murphy et al. [2011, ApJ, 737, 67] and Hao et al. [2011, ApJ, 741, 124]; Kroupa IMF), where L_{Hα} = 4π EML_FLUX_1RE (LDIST_Z)^{2} and ''no'' attentuation correction has been applied.  
    sfr_tot real NOT NULL, --/U h^{-2} M_{sun}/yr --/D Simple estimate of the star-formation rate within the IFU field-of-view based on the Gaussian-fitted Hα flux; log(SFR) = log L_{Hα} - 41.27 (Kennicutt & Evans [2012, ARAA, 50, 531], citing Murphy et al. [2011, ApJ, 737, 67] and Hao et al. [2011, ApJ, 741, 124]; Kroupa IMF), where L_{Hα} = 4π EML_FLUX_TOT (LDIST_Z)^{2} and ''no'' attentuation correction has been applied.  
    htmID bigint NOT NULL  --/F NOFITS --/D 20-level deep Hierarchical Triangular Mesh ID 
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaHIall')
	DROP TABLE mangaHIall
GO
--
EXEC spSetDefaultFileGroup 'mangaHIall'
GO
CREATE TABLE mangaHIall (
------------------------------------------------------------------------------
--/H Catalogue of Observed MaNGA Targets under program AGBT16A_095
------------------------------------------------------------------------------
--/T Measured parameters for all MaNGA targets observed with the Green Bank
--/T Telescope under project AGBT16A_095.  All measurements were made on
--/T baselined spectra after hanning and boxcar smoothing to a final
--/T resolution of 10 km/s'
------------------------------------------------------------------------------
	mangaid		varchar(32) NOT NULL, --/U    --/D MaNGA ID
	plateifu	varchar(32) NOT NULL, --/U    --/D plate-ifu of MaNGA observation
	ra	      	float NOT NULL, --/U deg  	    --/D Right Ascension, J2000 (objra from DRPAll file)   --/F objra
	dec	      	float NOT NULL, --/U deg  	    --/D Declination, J2000 (objdec from DRPAll file)   --/F objdec
	vopt		real NOT NULL, 	    --/U km/s   --/D Optical velocity - used to set centre frequency of radio observation
	sessions	varchar(32) NOT NULL, --/U    --/D Session(s) of AGBT16A_095 target was observed in. In format AA-BB-CC (e.g. if observed in three sessions). --/F session
	exp	      	real NOT NULL, 	    --/U s   --/D Total integration time with GBT
	rms	      	real NOT NULL, 	    --/U mJy   --/D rms noise in signal free part of HI spectrum
	logHIlim200kms	real NOT NULL, 	    --/U    --/D For non-detections, the log of the HI mass limit (in solar masses) assuming a width of 200 km/s and D = vopt/70 Mpc/km/s
	peak		real NOT NULL, 	    --/U mJy   --/D The peak HI flux
	snr		real NOT NULL, 	    --/U    --/D The peak S/N ratio
	fHI		real NOT NULL, 	    --/U Jy km/s   --/D The integrated flux of the HI line
	logMHI		real NOT NULL, 	    --/U    --/D Log of the HI mass (in solar masses) assuming D = vopt/70 Mpc/km/s
	vHI		real NOT NULL, 	    --/U km/s   --/D Centroid of the HI line detection
	evHI		real NOT NULL, 	    --/U km/s   --/D Error on vHI --/F ev
	WM50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the median of the two peaks
	WP50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the peak of the HI line
	WP20		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 20% of the peak of the HI line
	W2P50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the peak on either side
	WF50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the peak on fits to the sides of the profile
	Pr		real NOT NULL, 	    --/U mJy   --/D The peak HI flux in the high velocity peak
	Pl		real NOT NULL, 	    --/U mJy   --/D The peak HI flux in the low velocity peak
	ar		real NOT NULL, 	    --/U    --/D fit parameter for high velocity side of profile
	br		real NOT NULL, 	    --/U    --/D fit parameter for high velocity side of profile
	al		real NOT NULL, 	    --/U    --/D fit parameter for low velocity side of profile
	bl		real NOT NULL, 	    --/U    --/D fit parameter for low velocity side of profile
)
GO
--



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaHIbonus')
	DROP TABLE mangaHIbonus
GO
--
EXEC spSetDefaultFileGroup 'mangaHIbonus'
GO
CREATE TABLE mangaHIbonus (
------------------------------------------------------------------------------
--/H Catalogue of bonus detections under program AGBT16A_095
------------------------------------------------------------------------------
--/T Measured parameters for all detections in Green Bank Telescope program
--/T AGBT16A_095 that were not the primary target of each observation (i.e.,\
--/T other objects that happened to be within the 9' GBT beam). All
--/T measurements were made on baselined spectra after hanning and boxcar
--/T smoothing to a final resolution of 10 km/s'
------------------------------------------------------------------------------
	mangaid		varchar(32) NOT NULL, --/U    --/D MaNGA ID of target
	bonusid	     	varchar(32) NOT NULL, --/U    --/D ID of bonus detection. Alphabetical ID (ABC...) for extra target in main position. "O" for a detection in the OFF position, which is usually ratarget-00h02m30s
	plateifu   	varchar(32) NOT NULL, --/U    --/D plate-ifu of MaNGA observation
	targetra   	float NOT NULL, --/U deg  	    --/D Right Ascension, J2000 (objra from DRPAll file)  
	targetdec     	float NOT NULL, --/U deg  	    --/D Declination, J2000 (objdec from DRPAll file)  
	vopt	       	real NOT NULL, 	    --/U km/s   --/D Optical velocity - used to set centre frequency of radio observation
	sessions      	varchar(32) NOT NULL, --/U    --/D Session(s) of AGBT16A_095 target was observed in. In format AA-BB-CC (e.g. if observed in three sessions). --/F session
	exp	      	real NOT NULL, 	    --/U s   --/D Total integration time with GBT
	rms	      	real NOT NULL, 	    --/U mJy   --/D rms noise in signal free part of HI spectrum
	peak		real NOT NULL, 	    --/U mJy   --/D The peak HI flux
	snr		real NOT NULL, 	    --/U    --/D The peak S/N ratio
	fHI		real NOT NULL, 	    --/U Jy km/s   --/D The integrated flux of the HI line
	logMHI		real NOT NULL, 	    --/U    --/D Log of the HI mass (in solar masses) assuming D = vopt/70 Mpc/km/s
	vHI		real NOT NULL, 	    --/U km/s   --/D Centoid of the HI line detection
	evHI		real NOT NULL, 	    --/U km/s   --/D Error on vHI --/F ev
	WM50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the median of the two peaks
	WP50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the peak of the HI line
	WP20		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 20% of the peak of the HI line
	W2P50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the peak on either side
	WF50		real NOT NULL, 	    --/U km/s   --/D Width of the HI line measured at 50% of the peak on fits to the sides of the profile
	Pr		real NOT NULL, 	    --/U mJy   --/D The peak HI flux in the high velocity peak
	Pl		real NOT NULL, 	    --/U mJy   --/D The peak HI flux in the low velocity peak
	ar		real NOT NULL, 	    --/U    --/D fit parameter for high velocity side of profile
	br		real NOT NULL, 	    --/U    --/D fit parameter for high velocity side of profile
	al		real NOT NULL, 	    --/U    --/D fit parameter for low velocity side of profile
	bl		real NOT NULL, 	    --/U    --/D fit parameter for low velocity side of profile
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaGalaxyZoo')
	DROP TABLE mangaGalaxyZoo
GO
--
EXEC spSetDefaultFileGroup 'mangaGalaxyZoo'
GO
CREATE TABLE mangaGalaxyZoo (
------------------------------------------------------------------------------
--/H Galaxy Zoo classifications for all MaNGA target galaxies
--/T This tables contains one entry per MaNGA target galaxy.
--/T The Galaxy Zoo (GZ) data for SDSS galaxies has been split 
--/T over several iterations of the website, with the MaNGA target 
--/T galaxies being spread over 5 different GZ data sets. In this 
--/T value added catalog we bring all of these galaxies into one single 
--/T catalog and re-run the debiasing code (Hart 2016) in a consistent 
--/T manner across the all the galaxies. This catalog includes data from
--/T Galaxy Zoo 2 (previously published) and newer data from 
--/T Galaxy Zoo 4 (currently unpublished).
------------------------------------------------------------------------------
nsa_id								int NOT NULL,		--/D NASA Sloan Atlas ID
IAUNAME	        					       	varchar(32) NOT NULL,		--/D IAU name
IFUDESIGNSIZE						        int NOT NULL,		--/D Design size for the IFU
IFU_DEC	        						float NOT NULL,		--/U degrees	--/D DEC of the IFU
IFU_RA	        					        float NOT NULL,		--/U degrees	--/D RA of the IFU
MANGAID	        						varchar(16) NOT NULL,		--D/ MaNGA ID
MANGA_TILEID						 	int NOT NULL,		--/D MaNGA tile ID
OBJECT_DEC						        float NOT NULL,		--/U degrees	--/D DEC of the galaxy
OBJECT_RA						        float NOT NULL,		--/U degrees	--/D RA of the galaxy
survey	        					        varchar(128) NOT NULL,		--/D The Galaxy Zoo data set(s) the galaxy was part of (comma seperated)
t01_smooth_or_features_a01_smooth_count			        real NOT NULL,		--/D Raw GZ vote count
t01_smooth_or_features_a01_smooth_count_fraction	        real NOT NULL,		--/D Raw GZ vote fraction
t01_smooth_or_features_a01_smooth_debiased		        real NOT NULL,		--/D Debiased GZ vote fraction
t01_smooth_or_features_a01_smooth_weight		        real NOT NULL,		--/D User weighted vote count
t01_smooth_or_features_a01_smooth_weight_fraction	        real NOT NULL,		--/D User weighted vote fraction
t01_smooth_or_features_a02_features_or_disk_count	        real NOT NULL,		--/D Raw GZ vote count
t01_smooth_or_features_a02_features_or_disk_count_fraction	real NOT NULL,		--/D Raw GZ vote fraction
t01_smooth_or_features_a02_features_or_disk_debiased		real NOT NULL,		--/D Debiased GZ vote fraction
t01_smooth_or_features_a02_features_or_disk_weight	        real NOT NULL,		--/D User weighted vote count
t01_smooth_or_features_a02_features_or_disk_weight_fraction	real NOT NULL,		--/D User weighted vote fraction
t01_smooth_or_features_a03_star_or_artifact_count		real NOT NULL,		--/D Raw GZ vote count for
t01_smooth_or_features_a03_star_or_artifact_count_fraction	real NOT NULL,		--/D Raw GZ vote fraction
t01_smooth_or_features_a03_star_or_artifact_debiased		real NOT NULL,		--/D Debiased GZ vote fraction
t01_smooth_or_features_a03_star_or_artifact_weight	        real NOT NULL,		--/D User weighted vote count
t01_smooth_or_features_a03_star_or_artifact_weight_fraction	real NOT NULL,		--/D User weighted vote fraction
t01_smooth_or_features_count					real NOT NULL,		--/D The raw number of GZ votes for task 1
t01_smooth_or_features_weight					real NOT NULL,		--/D The user weighted number of GZ votes for task 1
t02_edgeon_a04_yes_count					real NOT NULL,		--/D Raw GZ vote count
t02_edgeon_a04_yes_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t02_edgeon_a04_yes_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t02_edgeon_a04_yes_weight					real NOT NULL,		--/D User weighted vote count
t02_edgeon_a04_yes_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t02_edgeon_a05_no_count						real NOT NULL,		--/D Raw GZ vote count
t02_edgeon_a05_no_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t02_edgeon_a05_no_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t02_edgeon_a05_no_weight					real NOT NULL,		--/D User weighted vote count
t02_edgeon_a05_no_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t02_edgeon_count						real NOT NULL,		--/D The raw number of GZ votes for task 2
t02_edgeon_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 2
t03_bar_a06_bar_count						real NOT NULL,		--/D Raw GZ vote count
t03_bar_a06_bar_count_fraction					real NOT NULL,		--/D Raw GZ vote fraction
t03_bar_a06_bar_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t03_bar_a06_bar_weight						real NOT NULL,		--/D User weighted vote count
t03_bar_a06_bar_weight_fraction					real NOT NULL,		--/D User weighted vote fraction
t03_bar_a07_no_bar_count					real NOT NULL,		--/D Raw GZ vote count
t03_bar_a07_no_bar_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t03_bar_a07_no_bar_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t03_bar_a07_no_bar_weight					real NOT NULL,		--/D User weighted vote count
t03_bar_a07_no_bar_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t03_bar_count							real NOT NULL,		--/D The raw number of GZ votes for task 3
t03_bar_weight							real NOT NULL,		--/D The user weighted number of GZ votes for task 3
t04_spiral_a08_spiral_count					real NOT NULL,		--/D Raw GZ vote count
t04_spiral_a08_spiral_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t04_spiral_a08_spiral_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t04_spiral_a08_spiral_weight					real NOT NULL,		--/D User weighted vote count
t04_spiral_a08_spiral_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t04_spiral_a09_no_spiral_count					real NOT NULL,		--/D Raw GZ vote count
t04_spiral_a09_no_spiral_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t04_spiral_a09_no_spiral_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t04_spiral_a09_no_spiral_weight					real NOT NULL,		--/D User weighted vote count
t04_spiral_a09_no_spiral_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t04_spiral_count						real NOT NULL,		--/D The raw number of GZ votes for task 4
t04_spiral_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 4
t05_bulge_prominence_a10_no_bulge_count				real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a10_no_bulge_count_fraction		real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a10_no_bulge_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a10_no_bulge_weight			real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a10_no_bulge_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_a11_just_noticeable_count			real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a11_just_noticeable_count_fraction		real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a11_just_noticeable_debiased		real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a11_just_noticeable_weight			real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a11_just_noticeable_weight_fraction	real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_a12_obvious_count				real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a12_obvious_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a12_obvious_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a12_obvious_weight				real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a12_obvious_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_a13_dominant_count				real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a13_dominant_count_fraction		real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a13_dominant_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a13_dominant_weight			real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a13_dominant_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_count					real NOT NULL,		--/D The raw number of GZ votes for task 5
t05_bulge_prominence_weight					real NOT NULL,	  	--/D The user weighted number of GZ votes for task 5
t06_odd_a14_yes_count						real NOT NULL,		--/D Raw GZ vote count
t06_odd_a14_yes_count_fraction					real NOT NULL,		--/D Raw GZ vote fraction
t06_odd_a14_yes_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t06_odd_a14_yes_weight						real NOT NULL,		--/D User weighted vote count
t06_odd_a14_yes_weight_fraction					real NOT NULL,		--/D User weighted vote fraction
t06_odd_a15_no_count						real NOT NULL,		--/D Raw GZ vote count
t06_odd_a15_no_count_fraction					real NOT NULL,		--/D Raw GZ vote fraction
t06_odd_a15_no_debiased						real NOT NULL,		--/D Debiased GZ vote fraction
t06_odd_a15_no_weight						real NOT NULL,		--/D User weighted vote count
t06_odd_a15_no_weight_fraction					real NOT NULL,		--/D User weighted vote fraction
t06_odd_count							real NOT NULL,		--/D The raw number of GZ votes for task 6
t06_odd_weight							real NOT NULL,		--/D The user weighted number of GZ votes for task 6
t07_rounded_a16_completely_round_count				real NOT NULL,		--/D Raw GZ vote count
t07_rounded_a16_completely_round_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t07_rounded_a16_completely_round_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t07_rounded_a16_completely_round_weight				real NOT NULL,		--/D User weighted vote count
t07_rounded_a16_completely_round_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t07_rounded_a17_in_between_count				real NOT NULL,		--/D Raw GZ vote count
t07_rounded_a17_in_between_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t07_rounded_a17_in_between_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t07_rounded_a17_in_between_weight				real NOT NULL,		--/D User weighted vote count
t07_rounded_a17_in_between_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t07_rounded_a18_cigar_shaped_count				real NOT NULL,		--/D Raw GZ vote count
t07_rounded_a18_cigar_shaped_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t07_rounded_a18_cigar_shaped_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t07_rounded_a18_cigar_shaped_weight				real NOT NULL,		--/D User weighted vote count
t07_rounded_a18_cigar_shaped_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t07_rounded_count						real NOT NULL,		--/D The raw number of GZ votes for task 7
t07_rounded_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 7
t09_bulge_shape_a25_rounded_count				real NOT NULL,		--/D Raw GZ vote count
t09_bulge_shape_a25_rounded_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t09_bulge_shape_a25_rounded_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t09_bulge_shape_a25_rounded_weight				real NOT NULL,		--/D User weighted vote count
t09_bulge_shape_a25_rounded_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t09_bulge_shape_a26_boxy_count					real NOT NULL,		--/D Raw GZ vote count
t09_bulge_shape_a26_boxy_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t09_bulge_shape_a26_boxy_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t09_bulge_shape_a26_boxy_weight					real NOT NULL,		--/D User weighted vote count
t09_bulge_shape_a26_boxy_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t09_bulge_shape_a27_no_bulge_count				real NOT NULL,		--/D Raw GZ vote count
t09_bulge_shape_a27_no_bulge_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t09_bulge_shape_a27_no_bulge_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t09_bulge_shape_a27_no_bulge_weight				real NOT NULL,		--/D User weighted vote count
t09_bulge_shape_a27_no_bulge_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t09_bulge_shape_count						real NOT NULL,		--/D The raw number of GZ votes for task 9
t09_bulge_shape_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 9
t10_arms_winding_a28_tight_count				real NOT NULL,		--/D Raw GZ vote count
t10_arms_winding_a28_tight_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t10_arms_winding_a28_tight_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t10_arms_winding_a28_tight_weight				real NOT NULL,		--/D User weighted vote count
t10_arms_winding_a28_tight_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t10_arms_winding_a29_medium_count				real NOT NULL,		--/D Raw GZ vote count
t10_arms_winding_a29_medium_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t10_arms_winding_a29_medium_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t10_arms_winding_a29_medium_weight				real NOT NULL,		--/D User weighted vote count
t10_arms_winding_a29_medium_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t10_arms_winding_a30_loose_count				real NOT NULL,		--/D Raw GZ vote count
t10_arms_winding_a30_loose_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t10_arms_winding_a30_loose_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t10_arms_winding_a30_loose_weight				real NOT NULL,		--/D User weighted vote count
t10_arms_winding_a30_loose_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t10_arms_winding_count						real NOT NULL,		--/D The raw number of GZ votes for task 10
t10_arms_winding_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 10
t11_arms_number_a31_1_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a31_1_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a31_1_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a31_1_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a31_1_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a32_2_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a32_2_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a32_2_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a32_2_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a32_2_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a33_3_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a33_3_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a33_3_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a33_3_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a33_3_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a34_4_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a34_4_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a34_4_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a34_4_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a34_4_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a36_more_than_4_count				real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a36_more_than_4_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a36_more_than_4_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a36_more_than_4_weight				real NOT NULL,		--/D User weighted vote count
t11_arms_number_a36_more_than_4_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a37_cant_tell_count				real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a37_cant_tell_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a37_cant_tell_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a37_cant_tell_weight				real NOT NULL,		--/D User weighted vote count
t11_arms_number_a37_cant_tell_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_count						real NOT NULL,		--/D The raw number of GZ votes for task 11
t11_arms_number_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 11
)
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'mangaAlfalfaDR15')
	DROP TABLE mangaAlfalfaDR15
GO
--
EXEC spSetDefaultFileGroup 'mangaAlfalfaDR15'
GO
CREATE TABLE mangaAlfalfaDR15 (
------------------------------------------------------------------------------
--/H LFALFA data for the currently public MaNGA sample
------------------------------------------------------------------------------
--/T Measured paramters for all currently public MaNGA galaxies within the
--/T ALFALFA survey footprint (Haynes et al. 2018).  Any object within 2' and
--/T 200 km/s line-of-sight velocity of an HI centroid is considered a match.  
--/T For this reason, multiple galaxies can have the same ALFALFA match.
-----------------------------------------------------------------------------

	plateifu	varchar(32) NOT NULL, --/U    --/D plate-ifu designation of MaNGA target
	mangaid		varchar(32) NOT NULL, --/U    --/D MaNGA ID of target
   	objra	float NOT NULL,       --/U deg   --/D Right Ascension, J2000 (objra from DRPAll file)
	objdec	float NOT NULL,       --/U deg   --/D Declination, J2000 (objdec from DRPAll file)
	vopt		real NOT NULL,          --U/ km/s --/D Optical velocity
	rms		real NOT NULL, 	        --U/ mJy --/D rms noise in signal-free part of HI spectrum
	loghilim200kms	real NOT NULL, 	        --U/    --/D For non-detections, the log of the HI mass limit (in solar masses) assuming a width of 200 km/s and D = vopt/70 Mpc/km/s
	snr		real NOT NULL, 	        --U/ 	 --/D The signal-to-noise ratio as defined by Equation (4) in Haynes et al. (2018)
	fhi		real NOT NULL, 	        --U/ Jy km/s		  --/D The integrated flux of the HI line
	logmhi		real NOT NULL, 		--U/ 		  --/D Log of the HI mass (in solar masses) assuming D = vopt/70 Mpc/km/s
	vHI		real NOT NULL, 	        --U/ km/s	  --/D velocity centroid of the HI line detection
	eVHI		real NOT NULL, 		--U/ km/s    --/D error on vHI --/F ev
	WP20		real NOT NULL, 		--U/ km/s   --/D Width of the HI line measured at 20% of the peak on fits to the sides of the profile 
	WF50		real NOT NULL, 		--U/ km/s	 --/D Width of the HI liune measured at 50% of the peak on fits to the sides of the profile
	sep		real NOT NULL, 		--U/ arcsec	    --/D Angular separation between the HI source and the optical position of the MaNGA galaxy
	dv		real NOT NULL, 		--U/ km/s --/D Difference between the recession velocity of the HI source and the MaNGA galaxy measured using optical spectra  
	AGC             varchar(32) NOT NULL, --U/ --/D ALFALFA AGC number of HI source 
)
GO
--

EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[MangaTables.sql]: MaNGA tables created'
GO


