--// Created from HDU 1 in $ALLSPEC/1.0.1/multiplex-dr19-1.0.1.fits

create table multiplex (
    ------- 
    --/H Table of all spectroscopic plates or FPS fields
    --/T Table of all spectroscopic plates or FPS fields across each SDSS instrument.
    ------- 
    multiplex_id varchar(40) NOT NULL, --/U  --/D Unique multiplex ID 
    design_id int NOT NULL, --/U  --/D design_id 
    sdss_phase smallint NOT NULL, --/U  --/D SDSS Phase from 1 to 5 
    observatory varchar(3) NOT NULL, --/U  --/D observatory 
    telescope varchar(6) NOT NULL, --/U  --/D telescope 
    instrument varchar(6) NOT NULL, --/U  --/D instrument 
    plate int NOT NULL, --/U  --/D SDSS/BOSS/eBOSS/BHM plate (before FPS era) 
    fps_field int NOT NULL, --/U  --/D Plate or FPS Field (merges pre/post Plate era) 
    plate_or_fps_field int NOT NULL, --/U  --/D Plate or FPS Field (merges pre/post Plate era) 
    mjd int NOT NULL, --/U  --/D MJD 
    run2d varchar(7) NOT NULL, --/U  --/D idlspec2d version 
    coadd varchar(5) NOT NULL, --/U  --/D either epoch, daily 
    apred_vers varchar(4) NOT NULL, --/U  --/D APOGEE DRP Version 
    drpver varchar(6) NOT NULL, --/U  --/D MaNGA (for e.g.) DRP Version 
    version varchar(7) NOT NULL, --/U  --/D All Pipeline Version 
    racen float NOT NULL, --/U deg --/D Multiplex center's right ascension 
    deccen float NOT NULL, --/U deg --/D Multiplex center's declination 
    position_angle float NOT NULL, --/U  --/D Multiplex position angle 
    healpix int NOT NULL, --/U  --/D healpix 
    healpixgrp smallint NOT NULL, --/U  --/D healpixgrp 
    quality varchar(8) NOT NULL, --/U  --/D Quality flag for spectroscopic reduction 
    programname varchar(35) NOT NULL, --/U  --/D Spectroscopic program Name 
    survey varchar(14) NOT NULL, --/U  --/D Spectroscopic survey or sub-survey 
    cas_url varchar(118) NOT NULL, --/U  --/D CAS URL 
    sas_url varchar(103) NOT NULL --/U  --/D SAS URL 
);

--// Created from HDU 1 in $ALLSPEC/1.0.1/allspec-dr19-1.0.1.fits


create table allspec (
    ------- 
    --/H Table of all spectroscopic reductions
    --/T Table of all spectroscopic reductions across each SDSS instrument. 
    ------- 
    allspec_id varchar(79) NOT NULL, --/U  --/D Unique allspec ID 
    multiplex_id varchar(40) NOT NULL, --/U  --/D multiplex ID 
    sdss_phase smallint NOT NULL, --/U  --/D SDSS Phase from 1 to 5 
    observatory varchar(3) NOT NULL, --/U  --/D observatory 
    instrument varchar(6) NOT NULL, --/U  --/D instrument 
    sdss_id bigint NOT NULL, --/U  --/D sdss_id 
    catalogid bigint NOT NULL, --/U  --/D BHM catalogid 
    fiberid int NOT NULL, --/U  --/D SDSS/BOSS/eBOSS fiberid 
    ifudsgn smallint NOT NULL, --/U  --/D MaNGA IFU DESIGN ID 
    plate int NOT NULL, --/U  --/D SDSS/BOSS/eBOSS/BHM plate (before FPS era) 
    fps_field int NOT NULL, --/U  --/D FPS Field (post Plate era) 
    plate_or_fps_field int NOT NULL, --/U  --/D Plate or FPS Field (merges pre/post Plate era) 
    mjd int NOT NULL, --/U  --/D MJD 
    run2d varchar(7) NOT NULL, --/U  --/D idlspec2d version 
    run1d varchar(7) NOT NULL, --/U  --/D idlspec1d version 
    coadd varchar(8) NOT NULL, --/U  --/D either epoch, daily, or custom=allepoch 
    apred_vers varchar(4) NOT NULL, --/U  --/D APOGEE DRP Version 
    drpver varchar(6) NOT NULL, --/U  --/D MaNGA (for e.g.) DRP Version 
    version varchar(7) NOT NULL, --/U  --/D All Pipeline Version 
    programname varchar(35) NOT NULL, --/U  --/D Spectroscopic program Name 
    survey varchar(32) NOT NULL, --/U  --/D Spectroscopic survey or sub-survey 
    sas_file varchar(46) NOT NULL, --/U  --/D SAS File 
    cas_url varchar(95) NOT NULL, --/U  --/D CAS URL 
    sas_url varchar(153) NOT NULL, --/U  --/D SAS URL 
    ra float NOT NULL, --/U deg --/D Right ascension 
    dec float NOT NULL, --/U deg --/D Declination 
    healpix int NOT NULL, --/U  --/D healpix 
    healpixgrp smallint NOT NULL, --/U  --/D healpixgrp 
    apogee_id varchar(19) NOT NULL, --/U  --/D APOGEE ID 
    apogee_field varchar(22) NOT NULL, --/U  --/D APOGEE Field (prior to SDSS-V) 
    telescope varchar(6) NOT NULL, --/U  --/D 2.5m Telescope 
    file_spec varchar(14) NOT NULL, --/U  --/D sdss_access file species name 
    apstar_id varchar(58) NOT NULL, --/U  --/D APOGEE (combined) star ID 
    visit_id varchar(34) NOT NULL, --/U  --/D APOGEE visit ID 
    has_mwmstar bigint NOT NULL, --/U  --/D Has MWM Star 
    astra_versions varchar(11) NOT NULL, --/U  --/D list of v_astra values if sdss_id has MWM Star 
    mangaid varchar(9) NOT NULL, --/U  --/D MaNGA ID 
    specobjid varchar(29) NOT NULL --/U  --/D spectroscopic object id 
);
