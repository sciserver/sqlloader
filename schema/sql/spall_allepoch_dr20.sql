CREATE TABLE spAll_allepoch (
--------------------------------------------------------------------------------
--/H Summary spectroscopic information for the BOSS spectrograph data custom Coadds
--
--/T This is a base table containing the summary spectroscopic information
--/T for the BOSS spectrograph data coadded on custom target level
--/T requirements
--------------------------------------------------------------------------------
    field bigint NOT NULL,   --/D SDSS FieldID (plateID for plate era data)  
    mjd bigint NOT NULL,   --/D Modified Julian date of combined Spectra  
    obs varchar(3) NOT NULL,   --/D Observatory of Observation  
    mjd_final float NOT NULL,   --/D Mean MJD of the Coadded Spectra  
    mjd_list varchar(5915) NOT NULL,   --/D List of MJD of each included exposures  
    run2d varchar(6) NOT NULL,   --/D Spectro-2D reduction name  
    run1d varchar(6) NOT NULL,   --/D Spectro-1D reduction name  
    designs varchar(4970) NOT NULL,   --/D List of Included Designs  
    configs varchar(5585) NOT NULL,   --/D List of Included Configurations  
    nexp smallint NOT NULL,   --/D Number of Included Exposures  
    exptime real NOT NULL,    --/U s --/D Total Exposure time of Coadded Spectra  
    target_index bigint NOT NULL,   --/D Index of target on combined spField  
    fiberid_list varchar(3879) NOT NULL,   --/D List of FiberIDs contributing to Stack  
    spec_file varchar(46) NOT NULL,   --/D Name of spec file (in SAS)  
    programname varchar(14) NOT NULL,   --/D Program name within a given survey  
    survey varchar(13) NOT NULL,   --/D Survey that field is part of  
    cadence varchar(19) NOT NULL,   --/D Requested Target Cadence  
    firstcarton varchar(54) NOT NULL,   --/D Primary SDSS Carton for target  
    carton_to_target_pk varchar(78) NOT NULL,   --/D SDSS-V CartonToTarget DB Table Primary Key  
    objtype varchar(16) NOT NULL,   --/D Why this object was targeted.  Note that if this field says QSO, it could be the case that this object would have been targetted as a GALAXY or any number of other categories as well. The PRIMTARGET and SECTARGET flags in the plug-map structure (in the spField file) gives this full information.  
    too varchar(1971) NOT NULL,   --/D the fiber is allocated to a TOO  
    too_id bigint NOT NULL,   --/D SDSS-V Target of Opportunity ID (only if TOO)  
    catalogid bigint NOT NULL,   --/D SDSS-V CatalogID used in naming  
    catalogid_v0 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0  
    catalogid_v0p5 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v0.5  
    catalogid_v1 bigint NOT NULL,   --/D SDSS-V CatalogID from Catalog v1  
    sdss_id bigint NOT NULL,   --/D Unified SDSS Target Identifier  
    specobjid numeric(30) NOT NULL,   --/D Unique ID based on Field, MJD, SDSSID, RUN2D, COADD type  
    calibflux_u real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-u from PSFmag  --/F CALIBFLUX
    calibflux_g real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-g from PSFmag  --/F CALIBFLUX
    calibflux_r real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-r from PSFmag  --/F CALIBFLUX
    calibflux_i real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-i from PSFmag  --/F CALIBFLUX
    calibflux_z real NOT NULL,    --/U nanomaggy --/D Broad-band flux in SDSS-z from PSFmag  --/F CALIBFLUX
    calibflux_ivar_u real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-u from PSFmag  --/F CALIBFLUX_IVAR
    calibflux_ivar_g real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-g from PSFmag  --/F CALIBFLUX_IVAR
    calibflux_ivar_r real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-r from PSFmag  --/F CALIBFLUX_IVAR
    calibflux_ivar_i real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-i from PSFmag  --/F CALIBFLUX_IVAR
    calibflux_ivar_z real NOT NULL,    --/U nanomaggy --/D Inverse var flux SDSS-z from PSFmag  --/F CALIBFLUX_IVAR
    optical_prov varchar(26) NOT NULL,   --/D The source of the optical CATDB_MAG magnitudes  
    mag_u real NOT NULL,   --/D u optical magnitudes  --/F MAG
    mag_g real NOT NULL,   --/D g optical magnitudes  --/F MAG
    mag_r real NOT NULL,   --/D r optical magnitudes  --/F MAG
    mag_i real NOT NULL,   --/D i optical magnitudes  --/F MAG
    mag_z real NOT NULL,   --/D z optical magnitudes  --/F MAG
    psfmag_u real NOT NULL,   --/D u optical PSF magnitudes  --/F PSFMAG
    psfmag_g real NOT NULL,   --/D g optical PSF magnitudes  --/F PSFMAG
    psfmag_r real NOT NULL,   --/D r optical PSF magnitudes  --/F PSFMAG
    psfmag_i real NOT NULL,   --/D i optical PSF magnitudes  --/F PSFMAG
    psfmag_z real NOT NULL,   --/D z optical PSF magnitudes  --/F PSFMAG
    fiber2mag_u real NOT NULL,   --/D u optical Fiber2 magnitudes  --/F FIBER2MAG
    fiber2mag_g real NOT NULL,   --/D g optical Fiber2 magnitudes  --/F FIBER2MAG
    fiber2mag_r real NOT NULL,   --/D r optical Fiber2 magnitudes  --/F FIBER2MAG
    fiber2mag_i real NOT NULL,   --/D i optical Fiber2 magnitudes  --/F FIBER2MAG
    fiber2mag_z real NOT NULL,   --/D z optical Fiber2 magnitudes  --/F FIBER2MAG
    catdb_mag_u real NOT NULL,   --/D u Raw TargetDB magnitudes  --/F CATDB_MAG
    catdb_mag_g real NOT NULL,   --/D g Raw TargetDB magnitudes  --/F CATDB_MAG
    catdb_mag_r real NOT NULL,   --/D r Raw TargetDB magnitudes  --/F CATDB_MAG
    catdb_mag_i real NOT NULL,   --/D i Raw TargetDB magnitudes  --/F CATDB_MAG
    catdb_mag_z real NOT NULL,   --/D z Raw TargetDB magnitudes  --/F CATDB_MAG
    gaia_g_mag real NOT NULL,   --/D Gaia G magnitude  
    gri_gaia_transform bigint NOT NULL,   --/D provenance of photometry in SDSS-V plate design  
    bp_mag real NOT NULL,   --/D Gaia BP magnitude  
    rp_mag real NOT NULL,   --/D Gaia RP magnitude  
    gaia_id bigint NOT NULL,   --/D Gaia DR2 SourceID  
    wise_mag_1 real NOT NULL,   --/D WISE W1 band magnitudes  --/F WISE_MAG
    wise_mag_2 real NOT NULL,   --/D WISE W2 band magnitudes  --/F WISE_MAG
    wise_mag_3 real NOT NULL,   --/D WISE W3 band magnitudes  --/F WISE_MAG
    wise_mag_4 real NOT NULL,   --/D WISE W4 band magnitudes  --/F WISE_MAG
    twomass_mag_1 real NOT NULL,   --/D 2MASS J band magnitudes  --/F TWOMASS_MAG
    twomass_mag_2 real NOT NULL,   --/D 2MASS H band magnitudes  --/F TWOMASS_MAG
    twomass_mag_3 real NOT NULL,   --/D 2MASS Ks band magnitudes  --/F TWOMASS_MAG
    guvcat_mag_1 real NOT NULL,   --/D GALEX FUV band magnitudes  --/F GUVCAT_MAG
    guvcat_mag_2 real NOT NULL,   --/D GALEX NUV band magnitudes  --/F GUVCAT_MAG
    ebv real NOT NULL,   --/D dust extinction  
    ebv_type varchar(14) NOT NULL,   --/D Source of dust extinction  
    fiber_ra float NOT NULL,    --/U degrees --/D Fiber RA [J2000 for plate; at exp for FPS]  
    fiber_dec float NOT NULL,    --/U degrees --/D Fiber DEC [J2000 for plate; at exp for FPS]  
    plug_ra float NOT NULL,    --/U degrees --/D Object RA (drilled fiber position) [J2000]  
    plug_dec float NOT NULL,    --/U degrees --/D Object DEC (drilled fiber position) [J2000]  
    racat float NOT NULL,    --/U degrees --/D Catalog RA in ICRS coordinates at coord_epoch  
    deccat float NOT NULL,    --/U degrees --/D Catalog DEC in ICRS coordinates at coord_epoch  
    coord_epoch real NOT NULL,   --/D Epoch of the RACAT/DECCAT Catalog coordinates.  
    pmra real NOT NULL,    --/U mas/year --/D Proper motion in RA (pmra is a true angle)  
    pmdec real NOT NULL,    --/U mas/year --/D Proper motion in Dec  
    parallax real NOT NULL,    --/U mas --/D Parallax  
    delta_ra_list varchar(7887) NOT NULL,    --/U arcsec --/D List of designed RA offsets per exposure  
    delta_dec_list varchar(7887) NOT NULL,    --/U arcsec --/D List of designed DEC offsets per exposure  
    fiber_offset bigint NOT NULL,   --/D Flag identifying the fiber was offset by design  
    zoffset real NOT NULL,    --/U microns --/D Backstopping offset distance  
    lambda_eff real NOT NULL,    --/U AA --/D Wavelength to optimize hole location for  
    bluefiber bigint NOT NULL,   --/D 1 if assigned target a blue fiber; 0 otherwise  
    healpix bigint NOT NULL,   --/D healpix pixel number of the RACAT and DECCAT coordinates, computed with healpix nside=128  
    healpixgrp bigint NOT NULL,   --/D Rounded-down integer value of healpix / 1000  
    healpix_path varchar(75) NOT NULL,   --/D Path to spec fits file in SAS healpix structure  
    fieldquality varchar(4) NOT NULL,   --/D Characterization of field quality  
    exp_disp_med float NOT NULL,   --/D Dispersion of Median Exposure Flux  
    fieldsn2 real NOT NULL,   --/D Overall (S/N)^2 for field; min of cameras  
    fieldsnr2g_list varchar(4929) NOT NULL,   --/D Overall Field (S/N)^2 in g per exposure  
    fieldsnr2r_list varchar(5141) NOT NULL,   --/D Overall Field (S/N)^2 in r per exposure  
    fieldsnr2i_list varchar(5064) NOT NULL,   --/D Overall Field (S/N)^2 in i per exposure  
    spec1_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 1 (same value for 500 fibers)  
    spec1_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 1 (same value for 500 fibers)  
    spec1_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 1 (same value for 500 fibers)  
    spec2_g real NOT NULL,   --/D Fit (S/N)^2 at g=20.20 for spectrograph 2 (same value for 500 fibers)  
    spec2_r real NOT NULL,   --/D Fit (S/N)^2 at r=20.25 for spectrograph 2 (same value for 500 fibers)  
    spec2_i real NOT NULL,   --/D Fit (S/N)^2 at i=19.90 for spectrograph 2 (same value for 500 fibers)  
    sn_median_u real NOT NULL,   --/D Median S/N for all good pixels in SDSS-u  --/F SN_MEDIAN
    sn_median_g real NOT NULL,   --/D Median S/N for all good pixels in SDSS-g  --/F SN_MEDIAN
    sn_median_r real NOT NULL,   --/D Median S/N for all good pixels in SDSS-r  --/F SN_MEDIAN
    sn_median_i real NOT NULL,   --/D Median S/N for all good pixels in SDSS-i  --/F SN_MEDIAN
    sn_median_z real NOT NULL,   --/D Median S/N for all good pixels in SDSS-z  --/F SN_MEDIAN
    sn_median_all real NOT NULL,   --/D Median S/N for all good pixels in all filters  
    airmass real NOT NULL,   --/D Airmass at time of observation  
    seeing20 real NOT NULL,    --/U arcsecs --/D Mean 20% seeing during exposures (arcsec)  
    seeing50 real NOT NULL,    --/U arcsecs --/D Mean 50% seeing during exposures (arcsec)  
    seeing80 real NOT NULL,    --/U arcsecs --/D Mean 80% seeing during exposures (arcsec)  
    moon_dist varchar(5581) NOT NULL,    --/U degrees --/D Mean Moon-target separation of Coadded Spectra  
    moon_phase varchar(4929) NOT NULL,   --/D Mean Moon phase of the Coadded Spectra  
    assigned varchar(2925) NOT NULL,   --/D Whether this fibre was assigned to a target  
    on_target varchar(2925) NOT NULL,   --/D Whether this fibre is on target  
    valid varchar(2925) NOT NULL,   --/D alpha and beta angles are valid  
    decollided varchar(2925) NOT NULL,   --/D this positioner had to be moved to decollide it  
    anyandmask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ANDMASK  
    anyormask bigint NOT NULL,   --/D For each bit, records whether any pixel in the spectrum has that bit set in its ORMASK  
    specprimary tinyint NOT NULL,   --/D Objects observed multiple times will have this set to 1 for one observation only. This is usually the 'best' observation, as defined by critera listed in fieldmerge.py.  
    specboss bigint NOT NULL,   --/D Best version of spectrum at this location  
    boss_specobj_id bigint NOT NULL,   --/D ID of spectrum location on sky  
    nspecobs bigint NOT NULL,   --/D Number of spectral observations  
    spectroflux_u real NOT NULL,   --/D Spectrum projected onto SDSS-u filter  --/F SPECTROFLUX
    spectroflux_g real NOT NULL,   --/D Spectrum projected onto SDSS-g filter  --/F SPECTROFLUX
    spectroflux_r real NOT NULL,   --/D Spectrum projected onto SDSS-r filter  --/F SPECTROFLUX
    spectroflux_i real NOT NULL,   --/D Spectrum projected onto SDSS-i filter  --/F SPECTROFLUX
    spectroflux_z real NOT NULL,   --/D Spectrum projected onto SDSS-z filter  --/F SPECTROFLUX
    spectroflux_ivar_u real NOT NULL,   --/D Inverse variance of SPECTROFLUX_u  --/F SPECTROFLUX_IVAR
    spectroflux_ivar_g real NOT NULL,   --/D Inverse variance of SPECTROFLUX_g  --/F SPECTROFLUX_IVAR
    spectroflux_ivar_r real NOT NULL,   --/D Inverse variance of SPECTROFLUX_r  --/F SPECTROFLUX_IVAR
    spectroflux_ivar_i real NOT NULL,   --/D Inverse variance of SPECTROFLUX_i  --/F SPECTROFLUX_IVAR
    spectroflux_ivar_z real NOT NULL,   --/D Inverse variance of SPECTROFLUX_z  --/F SPECTROFLUX_IVAR
    spectrosynflux_u real NOT NULL,   --/D Best-fit template projected onto SDSS-u  --/F SPECTROSYNFLUX
    spectrosynflux_g real NOT NULL,   --/D Best-fit template projected onto SDSS-g  --/F SPECTROSYNFLUX
    spectrosynflux_r real NOT NULL,   --/D Best-fit template projected onto SDSS-r  --/F SPECTROSYNFLUX
    spectrosynflux_i real NOT NULL,   --/D Best-fit template projected onto SDSS-i  --/F SPECTROSYNFLUX
    spectrosynflux_z real NOT NULL,   --/D Best-fit template projected onto SDSS-z  --/F SPECTROSYNFLUX
    spectrosynflux_ivar_u real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_u  --/F SPECTROSYNFLUX_IVAR
    spectrosynflux_ivar_g real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_g  --/F SPECTROSYNFLUX_IVAR
    spectrosynflux_ivar_r real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_r  --/F SPECTROSYNFLUX_IVAR
    spectrosynflux_ivar_i real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_i  --/F SPECTROSYNFLUX_IVAR
    spectrosynflux_ivar_z real NOT NULL,   --/D Inverse variance of SPECTROSYNFLUX_z  --/F SPECTROSYNFLUX_IVAR
    spectroskyflux_u real NOT NULL,   --/D Sky spectrum projected onto SDSS-u filter  --/F SPECTROSKYFLUX
    spectroskyflux_g real NOT NULL,   --/D Sky spectrum projected onto SDSS-g filter  --/F SPECTROSKYFLUX
    spectroskyflux_r real NOT NULL,   --/D Sky spectrum projected onto SDSS-r filter  --/F SPECTROSKYFLUX
    spectroskyflux_i real NOT NULL,   --/D Sky spectrum projected onto SDSS-i filter  --/F SPECTROSKYFLUX
    spectroskyflux_z real NOT NULL,   --/D Sky spectrum projected onto SDSS-z filter  --/F SPECTROSKYFLUX
    wavemin real NOT NULL,    --/U AA --/D Minimum observed (vacuum) wavelength for target  
    wavemax real NOT NULL,    --/U AA --/D Maximum observed (vacuum) wavelength for target  
    wcoverage real NOT NULL,    --/U log10(AA) --/D Amount of wavelength coverage in log-10(Angs)  
    class varchar(6) NOT NULL,   --/D Spectro classification: GALAXY, QSO, STAR  
    subclass varchar(21) NOT NULL,   --/D Spectro sub-classification  
    z real NOT NULL,   --/D Redshift; incorrect for nonzero ZWARNING flag  
    z_err real NOT NULL,   --/D z error from chi^2 min; negative is invalid fit  
    zwarning bigint NOT NULL,   --/D A flag for bad z fits in place of CLASS=UNKNOWN  
    rchi2 real NOT NULL,   --/D Reduced chi^2 for best fit  
    dof bigint NOT NULL,   --/D Degrees of freedom for best fit  
    rchi2diff real NOT NULL,   --/D Diff in reduced chi^2 of 2 best solutions  
    tfile varchar(24) NOT NULL,   --/D Template file in $IDLSPEC2D_DIR/templates  
    tcolumn_1 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_2 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_3 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_4 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_5 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_6 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_7 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_8 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_9 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    tcolumn_10 bigint NOT NULL,   --/D Column to use in template file (0-indexed); unused value set to -1  --/F TCOLUMN
    npoly bigint NOT NULL,   --/D # of polynomial terms with TFILE  
    theta_1 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_2 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_3 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_4 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_5 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_6 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_7 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_8 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_9 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    theta_10 real NOT NULL,   --/D Eigenvalue coeff for template file + polynomial  --/F THETA
    vdisp real NOT NULL,    --/U km/s --/D Velocity dispersion, only computed for galaxies  
    vdisp_err real NOT NULL,    --/U km/s --/D Error in VDISP; negative for invalid fit  
    vdispz real NOT NULL,   --/D Redshift for best-fit velocity dispersion  
    vdispz_err real NOT NULL,   --/D Error in VDISPZ  
    vdispchi2 real NOT NULL,   --/D Chi^2 for best-fit velocity dispersion  
    vdispnpix real NOT NULL,   --/D Num of pixels overlapping VDISP fit templates  
    vdispdof bigint NOT NULL,   --/D Degrees of freedom for best-fit velocity dispersion, equal to VDISPNPIX minus the number of templates minus the number of polynomial terms minus 1 (the last 1 is for the velocity dispersion)  
    chi68p real NOT NULL,   --/D 68% of abs(chi) of synthetic to actual spectrum  
    fracnsigma_1 real NOT NULL,   --/D Fraction of pixels low by >1 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_2 real NOT NULL,   --/D Fraction of pixels low by >2 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_3 real NOT NULL,   --/D Fraction of pixels low by >3 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_4 real NOT NULL,   --/D Fraction of pixels low by >4 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_5 real NOT NULL,   --/D Fraction of pixels low by >5 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_6 real NOT NULL,   --/D Fraction of pixels low by >6 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_7 real NOT NULL,   --/D Fraction of pixels low by >7 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_8 real NOT NULL,   --/D Fraction of pixels low by >8 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_9 real NOT NULL,   --/D Fraction of pixels low by >9 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsigma_10 real NOT NULL,   --/D Fraction of pixels low by >10 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGMA
    fracnsighi_1 real NOT NULL,   --/D Fraction of pixels high by >1 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_2 real NOT NULL,   --/D Fraction of pixels high by >2 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_3 real NOT NULL,   --/D Fraction of pixels high by >3 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_4 real NOT NULL,   --/D Fraction of pixels high by >4 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_5 real NOT NULL,   --/D Fraction of pixels high by >5 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_6 real NOT NULL,   --/D Fraction of pixels high by >6 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_7 real NOT NULL,   --/D Fraction of pixels high by >7 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_8 real NOT NULL,   --/D Fraction of pixels high by >8 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_9 real NOT NULL,   --/D Fraction of pixels high by >9 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsighi_10 real NOT NULL,   --/D Fraction of pixels high by >10 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGHI
    fracnsiglo_1 real NOT NULL,   --/D Fraction of pixels deviant by >1 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_2 real NOT NULL,   --/D Fraction of pixels deviant by >2 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_3 real NOT NULL,   --/D Fraction of pixels deviant by >3 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_4 real NOT NULL,   --/D Fraction of pixels deviant by >4 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_5 real NOT NULL,   --/D Fraction of pixels deviant by >5 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_6 real NOT NULL,   --/D Fraction of pixels deviant by >6 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_7 real NOT NULL,   --/D Fraction of pixels deviant by >7 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_8 real NOT NULL,   --/D Fraction of pixels deviant by >8 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_9 real NOT NULL,   --/D Fraction of pixels deviant by >9 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    fracnsiglo_10 real NOT NULL,   --/D Fraction of pixels deviant by >10 sigma (igorning all points blueward of rest-frame 1216 Ang)  --/F FRACNSIGLO
    z_noqso real NOT NULL,   --/D Redshift of the best-fit non-QSO model (recommended for CMASS and LOZ)  
    z_err_noqso real NOT NULL,   --/D Formal one-sigma error on Z_NOQSO (recommended for CMASS and LOZ)  
    znum_noqso bigint NOT NULL,   --/D Best fit z/class index excluding QSO; 1-indexed (recommended for CMASS and LOZ)  
    zwarning_noqso bigint NOT NULL,   --/D Redshift warning flag for Z_NOQSO (recommended for CMASS and LOZ)  
    class_noqso varchar(6) NOT NULL,   --/D Spectro class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    subclass_noqso varchar(21) NOT NULL,   --/D Spectro sub-class of best-fit non-QSO model (recommended for CMASS and LOZ)  
    rchi2diff_noqso real NOT NULL,   --/D Reduced chi^2 diff to next-best non-QSO model (recommended for CMASS and LOZ)  
    xcsao_rv real NOT NULL,    --/U km/s --/D Radial velocity measured with pyXCSAO  
    xcsao_erv real NOT NULL,    --/U km/s --/D Uncertainty in Radial velocity  
    xcsao_rxc real NOT NULL,   --/D Cross correlation strength from pyXCSAO  
    xcsao_teff real NOT NULL,    --/U K --/D Interpolated temperature from pyXCSAO  
    xcsao_eteff real NOT NULL,    --/U K --/D Uncertainty in Interpolated temperature  
    xcsao_logg real NOT NULL,    --/U cm/s^2 --/D Interpolated surface gravity from pyXCSAO  
    xcsao_elogg real NOT NULL,    --/U cm/s^2 --/D Uncertainty in Interpolated surface gravity  
    xcsao_feh real NOT NULL,    --/U solar --/D Interpolated metallicity from pyXCSAO  
    xcsao_efeh real NOT NULL,    --/U solar --/D Uncertainty in interpolated metallicity  
);
