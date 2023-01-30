--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: minidb; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA minidb;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dr18_allwise; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_allwise (
    designation character(20),
    ra numeric(10,7),
    "dec" numeric(9,7),
    sigra numeric(7,4),
    sigdec numeric(7,4),
    sigradec numeric(8,4),
    glon numeric(10,7),
    glat numeric(9,7),
    elon numeric(10,7),
    elat numeric(9,7),
    wx numeric(7,3),
    wy numeric(7,3),
    cntr bigint NOT NULL,
    source_id character(28),
    coadd_id character(20),
    src integer,
    w1mpro numeric(5,3),
    w1sigmpro numeric(4,3),
    w1snr numeric(7,1),
    w1rchi2 real,
    w2mpro numeric(5,3),
    w2sigmpro numeric(4,3),
    w2snr numeric(7,1),
    w2rchi2 real,
    w3mpro numeric(5,3),
    w3sigmpro numeric(4,3),
    w3snr numeric(7,1),
    w3rchi2 real,
    w4mpro numeric(5,3),
    w4sigmpro numeric(4,3),
    w4snr numeric(7,1),
    w4rchi2 real,
    rchi2 real,
    nb integer,
    na integer,
    w1sat numeric(4,3),
    w2sat numeric(4,3),
    w3sat numeric(4,3),
    w4sat numeric(4,3),
    satnum character(4),
    ra_pm numeric(10,7),
    dec_pm numeric(9,7),
    sigra_pm numeric(7,4),
    sigdec_pm numeric(7,4),
    sigradec_pm numeric(8,4),
    pmra integer,
    sigpmra integer,
    pmdec integer,
    sigpmdec integer,
    w1rchi2_pm real,
    w2rchi2_pm real,
    w3rchi2_pm real,
    w4rchi2_pm real,
    rchi2_pm real,
    pmcode character(5),
    cc_flags character(4),
    rel character(1),
    ext_flg integer,
    var_flg character(4),
    ph_qual character(4),
    det_bit integer,
    moon_lev character(4),
    w1nm integer,
    w1m integer,
    w2nm integer,
    w2m integer,
    w3nm integer,
    w3m integer,
    w4nm integer,
    w4m integer,
    w1cov numeric(6,3),
    w2cov numeric(6,3),
    w3cov numeric(6,3),
    w4cov numeric(6,3),
    w1cc_map integer,
    w1cc_map_str character(9),
    w2cc_map integer,
    w2cc_map_str character(9),
    w3cc_map integer,
    w3cc_map_str character(9),
    w4cc_map integer,
    w4cc_map_str character(9),
    best_use_cntr bigint,
    ngrp smallint,
    w1flux real,
    w1sigflux real,
    w1sky numeric(8,3),
    w1sigsk numeric(6,3),
    w1conf numeric(8,3),
    w2flux real,
    w2sigflux real,
    w2sky numeric(8,3),
    w2sigsk numeric(6,3),
    w2conf numeric(8,3),
    w3flux real,
    w3sigflux real,
    w3sky numeric(8,3),
    w3sigsk numeric(6,3),
    w3conf numeric(8,3),
    w4flux real,
    w4sigflux real,
    w4sky numeric(8,3),
    w4sigsk numeric(6,3),
    w4conf numeric(8,3),
    w1mag numeric(5,3),
    w1sigm numeric(4,3),
    w1flg integer,
    w1mcor numeric(4,3),
    w2mag numeric(5,3),
    w2sigm numeric(4,3),
    w2flg integer,
    w2mcor numeric(4,3),
    w3mag numeric(5,3),
    w3sigm numeric(4,3),
    w3flg integer,
    w3mcor numeric(4,3),
    w4mag numeric(5,3),
    w4sigm numeric(4,3),
    w4flg integer,
    w4mcor numeric(4,3),
    w1mag_1 numeric(5,3),
    w1sigm_1 numeric(4,3),
    w1flg_1 integer,
    w2mag_1 numeric(5,3),
    w2sigm_1 numeric(4,3),
    w2flg_1 integer,
    w3mag_1 numeric(5,3),
    w3sigm_1 numeric(4,3),
    w3flg_1 integer,
    w4mag_1 numeric(5,3),
    w4sigm_1 numeric(4,3),
    w4flg_1 integer,
    w1mag_2 numeric(5,3),
    w1sigm_2 numeric(4,3),
    w1flg_2 integer,
    w2mag_2 numeric(5,3),
    w2sigm_2 numeric(4,3),
    w2flg_2 integer,
    w3mag_2 numeric(5,3),
    w3sigm_2 numeric(4,3),
    w3flg_2 integer,
    w4mag_2 numeric(5,3),
    w4sigm_2 numeric(4,3),
    w4flg_2 integer,
    w1mag_3 numeric(5,3),
    w1sigm_3 numeric(4,3),
    w1flg_3 integer,
    w2mag_3 numeric(5,3),
    w2sigm_3 numeric(4,3),
    w2flg_3 integer,
    w3mag_3 numeric(5,3),
    w3sigm_3 numeric(4,3),
    w3flg_3 integer,
    w4mag_3 numeric(5,3),
    w4sigm_3 numeric(4,3),
    w4flg_3 integer,
    w1mag_4 numeric(5,3),
    w1sigm_4 numeric(4,3),
    w1flg_4 integer,
    w2mag_4 numeric(5,3),
    w2sigm_4 numeric(4,3),
    w2flg_4 integer,
    w3mag_4 numeric(5,3),
    w3sigm_4 numeric(4,3),
    w3flg_4 integer,
    w4mag_4 numeric(5,3),
    w4sigm_4 numeric(4,3),
    w4flg_4 integer,
    w1mag_5 numeric(5,3),
    w1sigm_5 numeric(4,3),
    w1flg_5 integer,
    w2mag_5 numeric(5,3),
    w2sigm_5 numeric(4,3),
    w2flg_5 integer,
    w3mag_5 numeric(5,3),
    w3sigm_5 numeric(4,3),
    w3flg_5 integer,
    w4mag_5 numeric(5,3),
    w4sigm_5 numeric(4,3),
    w4flg_5 integer,
    w1mag_6 numeric(5,3),
    w1sigm_6 numeric(4,3),
    w1flg_6 integer,
    w2mag_6 numeric(5,3),
    w2sigm_6 numeric(4,3),
    w2flg_6 integer,
    w3mag_6 numeric(5,3),
    w3sigm_6 numeric(4,3),
    w3flg_6 integer,
    w4mag_6 numeric(5,3),
    w4sigm_6 numeric(4,3),
    w4flg_6 integer,
    w1mag_7 numeric(5,3),
    w1sigm_7 numeric(4,3),
    w1flg_7 integer,
    w2mag_7 numeric(5,3),
    w2sigm_7 numeric(4,3),
    w2flg_7 integer,
    w3mag_7 numeric(5,3),
    w3sigm_7 numeric(4,3),
    w3flg_7 integer,
    w4mag_7 numeric(5,3),
    w4sigm_7 numeric(4,3),
    w4flg_7 integer,
    w1mag_8 numeric(5,3),
    w1sigm_8 numeric(4,3),
    w1flg_8 integer,
    w2mag_8 numeric(5,3),
    w2sigm_8 numeric(4,3),
    w2flg_8 integer,
    w3mag_8 numeric(5,3),
    w3sigm_8 numeric(4,3),
    w3flg_8 integer,
    w4mag_8 numeric(5,3),
    w4sigm_8 numeric(4,3),
    w4flg_8 integer,
    w1magp numeric(5,3),
    w1sigp1 numeric(5,3),
    w1sigp2 numeric(5,3),
    w1k numeric(4,3),
    w1ndf integer,
    w1mlq numeric(4,2),
    w1mjdmin numeric(13,8),
    w1mjdmax numeric(13,8),
    w1mjdmean numeric(13,8),
    w2magp numeric(5,3),
    w2sigp1 numeric(5,3),
    w2sigp2 numeric(5,3),
    w2k numeric(4,3),
    w2ndf integer,
    w2mlq numeric(4,2),
    w2mjdmin numeric(13,8),
    w2mjdmax numeric(13,8),
    w2mjdmean numeric(13,8),
    w3magp numeric(5,3),
    w3sigp1 numeric(5,3),
    w3sigp2 numeric(5,3),
    w3k numeric(4,3),
    w3ndf integer,
    w3mlq numeric(4,2),
    w3mjdmin numeric(13,8),
    w3mjdmax numeric(13,8),
    w3mjdmean numeric(13,8),
    w4magp numeric(5,3),
    w4sigp1 numeric(5,3),
    w4sigp2 numeric(5,3),
    w4k numeric(4,3),
    w4ndf integer,
    w4mlq numeric(4,2),
    w4mjdmin numeric(13,8),
    w4mjdmax numeric(13,8),
    w4mjdmean numeric(13,8),
    rho12 integer,
    rho23 integer,
    rho34 integer,
    q12 integer,
    q23 integer,
    q34 integer,
    xscprox numeric(7,2),
    w1rsemi numeric(7,2),
    w1ba numeric(3,2),
    w1pa numeric(5,2),
    w1gmag numeric(5,3),
    w1gerr numeric(4,3),
    w1gflg integer,
    w2rsemi numeric(7,2),
    w2ba numeric(3,2),
    w2pa numeric(5,2),
    w2gmag numeric(5,3),
    w2gerr numeric(4,3),
    w2gflg integer,
    w3rsemi numeric(7,2),
    w3ba numeric(3,2),
    w3pa numeric(5,2),
    w3gmag numeric(5,3),
    w3gerr numeric(4,3),
    w3gflg integer,
    w4rsemi numeric(7,2),
    w4ba numeric(3,2),
    w4pa numeric(5,2),
    w4gmag numeric(5,3),
    w4gerr numeric(4,3),
    w4gflg integer,
    tmass_key integer,
    r_2mass numeric(5,3),
    pa_2mass numeric(4,1),
    n_2mass integer,
    j_m_2mass numeric(5,3),
    j_msig_2mass numeric(4,3),
    h_m_2mass numeric(5,3),
    h_msig_2mass numeric(4,3),
    k_m_2mass numeric(5,3),
    k_msig_2mass numeric(4,3),
    x numeric(17,16),
    y numeric(17,16),
    z numeric(17,16),
    spt_ind integer,
    htm20 bigint
);


--
-- Name: dr18_best_brightest; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_best_brightest (
    designation character varying(19),
    ra_1 double precision,
    dec_1 double precision,
    glon double precision,
    glat double precision,
    w1mpro real,
    w2mpro real,
    w3mpro real,
    w4mpro character varying(6),
    pmra integer,
    pmdec integer,
    j_m_2mass real,
    h_m_2mass real,
    k_m_2mass real,
    ra_2 double precision,
    raerr double precision,
    dec_2 double precision,
    decerr double precision,
    nobs integer,
    mobs integer,
    vjmag real,
    bjmag real,
    gmag real,
    rmag real,
    imag real,
    evjmag real,
    ebjmag real,
    egmag real,
    ermag real,
    eimag real,
    name integer,
    separation double precision,
    ebv real,
    version integer,
    original_ext_source_id character varying(16),
    cntr bigint NOT NULL
);


--
-- Name: dr18_bhm_csc_v2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_bhm_csc_v2 (
    cxoid text,
    xra double precision,
    xdec double precision,
    pri smallint,
    ocat text,
    oid bigint,
    ora double precision,
    odec double precision,
    omag real,
    omatchtype smallint,
    irid text,
    ra2m double precision,
    dec2m double precision,
    hmag real,
    irmatchtype smallint,
    lgal double precision,
    bgal double precision,
    logfx real,
    xband text,
    xsn double precision,
    xflags integer,
    designation2m text,
    idg2 bigint,
    idps bigint,
    pk bigint NOT NULL
);


--
-- Name: dr18_bhm_efeds_veto; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_bhm_efeds_veto (
    programname character varying(5),
    chunk character varying(7),
    platesn2 real,
    plate integer,
    tile integer,
    mjd integer,
    fiberid integer,
    run2d character varying(7),
    run1d character varying(7),
    plug_ra double precision,
    plug_dec double precision,
    z_err real,
    rchi2 real,
    dof integer,
    rchi2diff real,
    wavemin real,
    wavemax real,
    wcoverage real,
    zwarning integer,
    sn_median_all real,
    anyandmask integer,
    anyormask integer,
    pk bigint NOT NULL
);


--
-- Name: dr18_bhm_rm_v0_2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_bhm_rm_v0_2 (
    field_name character varying(8),
    ra double precision,
    "dec" double precision,
    distance double precision,
    pos_ref character varying(4),
    ebv double precision,
    des integer,
    coadd_object_id bigint,
    ra_des double precision,
    dec_des double precision,
    extended_coadd integer,
    separation_des double precision,
    ps1 integer,
    objid_ps1 bigint,
    ra_ps1 double precision,
    dec_ps1 double precision,
    class_ps1 double precision,
    separation_ps1 double precision,
    nsc integer,
    id_nsc bigint,
    ra_nsc double precision,
    dec_nsc double precision,
    class_star double precision,
    flags_nsc integer,
    separation_nsc double precision,
    sdss integer,
    objid_sdss bigint,
    ra_sdss double precision,
    dec_sdss double precision,
    type_sdss integer,
    clean_sdss integer,
    separation_sdss double precision,
    gaia integer,
    source_id_gaia bigint,
    mg double precision,
    parallax double precision,
    parallax_error double precision,
    plxsig double precision,
    pmra double precision,
    pmra_error double precision,
    pmdec double precision,
    pmdec_error double precision,
    pmsig double precision,
    unwise integer,
    objid_unwise character varying(16),
    ra_unwise double precision,
    dec_unwise double precision,
    separation_unwise double precision,
    near_ir integer,
    survey_ir character varying(6),
    sourceid_ir bigint,
    ra_ir double precision,
    dec_ir double precision,
    separation_ir double precision,
    optical_survey character varying(4),
    mi double precision,
    cal_skewt_qso integer,
    nband_optical_use integer,
    use_unwise integer,
    use_nir integer,
    photo_combination character varying(17),
    log_qso double precision,
    log_star double precision,
    log_galaxy double precision,
    p_qso double precision,
    p_star real,
    p_galaxy double precision,
    class_skewt_qso character varying(6),
    skewt_qso integer,
    p_qso_prior double precision,
    p_star_prior real,
    p_galaxy_prior double precision,
    class_skewt_qso_prior character varying(6),
    skewt_qso_prior integer,
    photoz_qso double precision,
    photoz_qso_lower double precision,
    photoz_qso_upper double precision,
    prob_photoz_qso double precision,
    photoz_galaxy double precision,
    photoz_galaxy_lower double precision,
    photoz_galaxy_upper double precision,
    pqso_xdqso double precision,
    photoz_xdqso double precision,
    prob_rf_gaia_unwise double precision,
    photoz_gaia_unwise double precision,
    des_var_sn_max double precision,
    ps1_var_sn_max double precision,
    spec_q integer,
    spec_strmask character varying(6),
    spec_bitmask bigint,
    specz double precision,
    specz_ref character varying(16),
    photo_q integer,
    photo_strmask character varying(3),
    photo_bitmask bigint,
    photoz double precision,
    pqso_photo double precision,
    photoz_ref character varying(16),
    pk bigint NOT NULL,
    psfmag_des_g double precision,
    psfmag_des_r double precision,
    psfmag_des_i double precision,
    psfmag_des_z double precision,
    psfmag_des_y double precision,
    psfmagerr_des_g double precision,
    psfmagerr_des_r double precision,
    psfmagerr_des_i double precision,
    psfmagerr_des_z double precision,
    psfmagerr_des_y double precision,
    mag_auto_des_g double precision,
    mag_auto_des_r double precision,
    mag_auto_des_i double precision,
    mag_auto_des_z double precision,
    mag_auto_des_y double precision,
    magerr_auto_des_g double precision,
    magerr_auto_des_r double precision,
    magerr_auto_des_i double precision,
    magerr_auto_des_z double precision,
    magerr_auto_des_y double precision,
    imaflags_iso_g integer,
    imaflags_iso_r integer,
    imaflags_iso_i integer,
    imaflags_iso_z integer,
    imaflags_iso_y integer,
    psfmag_ps1_g double precision,
    psfmag_ps1_r double precision,
    psfmag_ps1_i double precision,
    psfmag_ps1_z double precision,
    psfmag_ps1_y double precision,
    psfmagerr_ps1_g double precision,
    psfmagerr_ps1_r double precision,
    psfmagerr_ps1_i double precision,
    psfmagerr_ps1_z double precision,
    psfmagerr_ps1_y double precision,
    kronmag_ps1_g double precision,
    kronmag_ps1_r double precision,
    kronmag_ps1_i double precision,
    kronmag_ps1_z double precision,
    kronmag_ps1_y double precision,
    kronmagerr_ps1_g double precision,
    kronmagerr_ps1_r double precision,
    kronmagerr_ps1_i double precision,
    kronmagerr_ps1_z double precision,
    kronmagerr_ps1_y double precision,
    infoflag2_g integer,
    infoflag2_r integer,
    infoflag2_i integer,
    infoflag2_z integer,
    infoflag2_y integer,
    mag_nsc_g double precision,
    mag_nsc_r double precision,
    mag_nsc_i double precision,
    mag_nsc_z double precision,
    mag_nsc_y double precision,
    magerr_nsc_g double precision,
    magerr_nsc_r double precision,
    magerr_nsc_i double precision,
    magerr_nsc_z double precision,
    magerr_nsc_y double precision,
    psfmag_sdss_u double precision,
    psfmag_sdss_g double precision,
    psfmag_sdss_r double precision,
    psfmag_sdss_i double precision,
    psfmag_sdss_z double precision,
    psfmagerr_sdss_u double precision,
    psfmagerr_sdss_g double precision,
    psfmagerr_sdss_r double precision,
    psfmagerr_sdss_i double precision,
    psfmagerr_sdss_z double precision,
    modelmag_sdss_u double precision,
    modelmag_sdss_g double precision,
    modelmag_sdss_r double precision,
    modelmag_sdss_i double precision,
    modelmag_sdss_z double precision,
    modelmagerr_sdss_u double precision,
    modelmagerr_sdss_g double precision,
    modelmagerr_sdss_r double precision,
    modelmagerr_sdss_i double precision,
    modelmagerr_sdss_z double precision,
    mag_gaia_g double precision,
    mag_gaia_bp double precision,
    mag_gaia_rp double precision,
    magerr_gaia_g double precision,
    magerr_gaia_bp double precision,
    magerr_gaia_rp double precision,
    mag_unwise_w1 double precision,
    mag_unwise_w2 double precision,
    magerr_unwise_w1 double precision,
    magerr_unwise_w2 double precision,
    flags_unwise_w1 integer,
    flags_unwise_w2 integer,
    mag_ir_y double precision,
    mag_ir_j double precision,
    mag_ir_h double precision,
    mag_ir_k double precision,
    magerr_ir_y double precision,
    magerr_ir_j double precision,
    magerr_ir_h double precision,
    magerr_ir_k double precision,
    des_var_nepoch_g integer,
    des_var_nepoch_r integer,
    des_var_nepoch_i integer,
    des_var_nepoch_z integer,
    des_var_nepoch_y integer,
    des_var_status_g integer,
    des_var_status_r integer,
    des_var_status_i integer,
    des_var_status_z integer,
    des_var_status_y integer,
    des_var_rms_g double precision,
    des_var_rms_r double precision,
    des_var_rms_i double precision,
    des_var_rms_z double precision,
    des_var_rms_y double precision,
    des_var_sigrms_g double precision,
    des_var_sigrms_r double precision,
    des_var_sigrms_i double precision,
    des_var_sigrms_z double precision,
    des_var_sigrms_y double precision,
    des_var_sn_g double precision,
    des_var_sn_r double precision,
    des_var_sn_i double precision,
    des_var_sn_z double precision,
    des_var_sn_y double precision,
    ps1_var_nepoch_g integer,
    ps1_var_nepoch_r integer,
    ps1_var_nepoch_i integer,
    ps1_var_nepoch_z integer,
    ps1_var_nepoch_y integer,
    ps1_var_status_g integer,
    ps1_var_status_r integer,
    ps1_var_status_i integer,
    ps1_var_status_z integer,
    ps1_var_status_y integer,
    ps1_var_rms_g double precision,
    ps1_var_rms_r double precision,
    ps1_var_rms_i double precision,
    ps1_var_rms_z double precision,
    ps1_var_rms_y double precision,
    ps1_var_sigrms_g double precision,
    ps1_var_sigrms_r double precision,
    ps1_var_sigrms_i double precision,
    ps1_var_sigrms_z double precision,
    ps1_var_sigrms_y double precision,
    ps1_var_sn_g double precision,
    ps1_var_sn_r double precision,
    ps1_var_sn_i double precision,
    ps1_var_sn_z double precision,
    ps1_var_sn_y double precision
);


--
-- Name: dr18_cadence; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_cadence (
    label text,
    nepochs integer,
    pk bigint NOT NULL,
    label_root text,
    label_version text,
    max_skybrightness real,
    nexp_total integer
);


--
-- Name: dr18_cadence_epoch; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_cadence_epoch (
    label text NOT NULL,
    nepochs integer,
    cadence_pk bigint,
    epoch integer NOT NULL,
    delta double precision,
    skybrightness real,
    delta_max real,
    delta_min real,
    nexp integer,
    max_length real,
    obsmode_pk text
);


--
-- Name: dr18_carton; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_carton (
    carton text,
    carton_pk integer NOT NULL,
    mapper_pk smallint,
    category_pk smallint,
    target_selection_plan text
);


--
-- Name: dr18_carton_to_target; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_carton_to_target (
    carton_to_target_pk integer NOT NULL,
    lambda_eff real,
    carton_pk smallint,
    target_pk bigint,
    cadence_pk smallint,
    priority integer,
    value real,
    instrument_pk integer,
    delta_ra double precision,
    delta_dec double precision,
    inertial boolean
);


--
-- Name: dr18_carton_txt; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_carton_txt (
    carton text,
    plan text,
    category text,
    stage text,
    active boolean
);


--
-- Name: dr18_cataclysmic_variables; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_cataclysmic_variables (
    ref_id bigint NOT NULL,
    solution_id bigint,
    designation text,
    source_id bigint,
    random_index integer,
    ref_epoch real,
    ra double precision,
    ra_error double precision,
    "dec" double precision,
    dec_error double precision,
    parallax double precision,
    parallax_error double precision,
    parallax_over_error double precision,
    pmra double precision,
    pmra_error double precision,
    pmdec double precision,
    pmdec_error double precision,
    ra_dec_corr double precision,
    ra_parallax_corr double precision,
    ra_pmra_corr double precision,
    ra_pmdec_corr double precision,
    dec_parallax_corr double precision,
    dec_pmra_corr double precision,
    dec_pmdec_corr double precision,
    parallax_pmra_corr double precision,
    parallax_pmdec_corr double precision,
    pmra_pmdec_corr double precision,
    astrometric_n_obs_al smallint,
    astrometric_n_obs_ac smallint,
    astrometric_n_good_obs_al smallint,
    astrometric_n_bad_obs_al smallint,
    astrometric_gof_al double precision,
    astrometric_chi2_al double precision,
    astrometric_excess_noise double precision,
    astrometric_excess_noise_sig double precision,
    astrometric_params_solved smallint,
    astrometric_primary_flag boolean,
    astrometric_weight_al double precision,
    astrometric_pseudo_colour double precision,
    astrometric_pseudo_colour_error double precision,
    mean_varpi_factor_al double precision,
    astrometric_matched_observations smallint,
    visibility_periods_used smallint,
    astrometric_sigma5d_max double precision,
    frame_rotator_object_type smallint,
    matched_observations smallint,
    duplicated_source boolean,
    phot_g_n_obs smallint,
    phot_g_mean_flux double precision,
    phot_g_mean_flux_error double precision,
    phot_g_mean_flux_over_error double precision,
    phot_g_mean_mag double precision,
    phot_bp_n_obs smallint,
    phot_bp_mean_flux double precision,
    phot_bp_mean_flux_error double precision,
    phot_bp_mean_flux_over_error double precision,
    phot_bp_mean_mag double precision,
    phot_rp_n_obs smallint,
    phot_rp_mean_flux double precision,
    phot_rp_mean_flux_error double precision,
    phot_rp_mean_flux_over_error double precision,
    phot_rp_mean_mag double precision,
    phot_bp_rp_excess_factor double precision,
    phot_proc_mode smallint,
    bp_rp double precision,
    bp_g double precision,
    g_rp double precision,
    radial_velocity double precision,
    radial_velocity_error double precision,
    rv_nb_transits smallint,
    rv_template_teff real,
    rv_template_logg real,
    rv_template_fe_h real,
    phot_variable_flag text,
    l double precision,
    b double precision,
    ecl_lon double precision,
    ecl_lat double precision,
    priam_flags integer,
    teff_val double precision,
    teff_percentile_lower double precision,
    teff_percentile_upper double precision,
    a_g_val real,
    a_g_percentile_lower real,
    a_g_percentile_upper real,
    e_bp_min_rp_val real,
    e_bp_min_rp_percentile_lower real,
    e_bp_min_rp_percentile_upper real,
    flame_flags integer,
    radius_val double precision,
    radius_percentile_lower double precision,
    radius_percentile_upper double precision,
    lum_val double precision,
    lum_percentile_lower double precision,
    lum_percentile_upper double precision
);


--
-- Name: dr18_catalog; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog (
    catalogid bigint NOT NULL,
    iauname text,
    ra double precision,
    "dec" double precision,
    pmra real,
    pmdec real,
    parallax real,
    lead text,
    version_id integer
);


--
-- Name: dr18_catalog_to_allwise; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_allwise (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_bhm_efeds_veto; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_bhm_efeds_veto (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_bhm_rm_v0_2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_bhm_rm_v0_2 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_catwise2020; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_catwise2020 (
    catalogid bigint,
    target_id character varying(25),
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_glimpse; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_glimpse (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_guvcat; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_guvcat (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_legacy_survey_dr8; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_legacy_survey_dr8 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_panstarrs1; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_panstarrs1 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_sdss_dr13_photoobj_primary; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_sdss_dr13_photoobj_primary (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_sdss_dr16_specobj; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_sdss_dr16_specobj (
    catalogid bigint,
    target_id numeric(20,0),
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_skies_v2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_skies_v2 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_skymapper_dr2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_skymapper_dr2 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_supercosmos; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_supercosmos (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_tic_v8; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_tic_v8 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_tycho2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_tycho2 (
    catalogid bigint,
    target_id text,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_uvotssc1; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_uvotssc1 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_catalog_to_xmm_om_suss_4_1; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catalog_to_xmm_om_suss_4_1 (
    catalogid bigint,
    target_id bigint,
    version_id smallint,
    distance double precision,
    best boolean
);


--
-- Name: dr18_category; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_category (
    pk integer NOT NULL,
    label text
);


--
-- Name: dr18_catwise2020; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_catwise2020 (
    source_name character(21),
    source_id character(25) NOT NULL,
    ra double precision,
    "dec" double precision,
    sigra real,
    sigdec real,
    sigradec real,
    wx real,
    wy real,
    w1sky real,
    w1sigsk real,
    w1conf real,
    w2sky real,
    w2sigsk real,
    w2conf real,
    w1fitr real,
    w2fitr real,
    w1snr real,
    w2snr real,
    w1flux real,
    w1sigflux real,
    w2flux real,
    w2sigflux real,
    w1mpro real,
    w1sigmpro real,
    w1rchi2 real,
    w2mpro real,
    w2sigmpro real,
    w2rchi2 real,
    rchi2 real,
    nb integer,
    na integer,
    w1sat real,
    w2sat real,
    w1mag real,
    w1sigm real,
    w1flg integer,
    w1cov real,
    w2mag real,
    w2sigm real,
    w2flg integer,
    w2cov real,
    w1mag_1 real,
    w1sigm_1 real,
    w1flg_1 integer,
    w2mag_1 real,
    w2sigm_1 real,
    w2flg_1 integer,
    w1mag_2 real,
    w1sigm_2 real,
    w1flg_2 integer,
    w2mag_2 real,
    w2sigm_2 real,
    w2flg_2 integer,
    w1mag_3 real,
    w1sigm_3 real,
    w1flg_3 integer,
    w2mag_3 real,
    w2sigm_3 real,
    w2flg_3 integer,
    w1mag_4 real,
    w1sigm_4 real,
    w1flg_4 integer,
    w2mag_4 real,
    w2sigm_4 real,
    w2flg_4 integer,
    w1mag_5 real,
    w1sigm_5 real,
    w1flg_5 integer,
    w2mag_5 real,
    w2sigm_5 real,
    w2flg_5 integer,
    w1mag_6 real,
    w1sigm_6 real,
    w1flg_6 integer,
    w2mag_6 real,
    w2sigm_6 real,
    w2flg_6 integer,
    w1mag_7 real,
    w1sigm_7 real,
    w1flg_7 integer,
    w2mag_7 real,
    w2sigm_7 real,
    w2flg_7 integer,
    w1mag_8 real,
    w1sigm_8 real,
    w1flg_8 integer,
    w2mag_8 real,
    w2sigm_8 real,
    w2flg_8 integer,
    w1nm integer,
    w1m integer,
    w1magp real,
    w1sigp1 real,
    w1sigp2 real,
    w1k real,
    w1ndf integer,
    w1mlq real,
    w1mjdmin double precision,
    w1mjdmax double precision,
    w1mjdmean double precision,
    w2nm integer,
    w2m integer,
    w2magp real,
    w2sigp1 real,
    w2sigp2 real,
    w2k real,
    w2ndf integer,
    w2mlq real,
    w2mjdmin double precision,
    w2mjdmax double precision,
    w2mjdmean double precision,
    rho12 integer,
    q12 integer,
    niters integer,
    nsteps integer,
    mdetid integer,
    p1 real,
    p2 real,
    meanobsmjd double precision,
    ra_pm double precision,
    dec_pm double precision,
    sigra_pm real,
    sigdec_pm real,
    sigradec_pm real,
    pmra real,
    pmdec real,
    sigpmra real,
    sigpmdec real,
    w1snr_pm real,
    w2snr_pm real,
    w1flux_pm real,
    w1sigflux_pm real,
    w2flux_pm real,
    w2sigflux_pm real,
    w1mpro_pm real,
    w1sigmpro_pm real,
    w1rchi2_pm real,
    w2mpro_pm real,
    w2sigmpro_pm real,
    w2rchi2_pm real,
    rchi2_pm real,
    pmcode character(7),
    niters_pm integer,
    nsteps_pm integer,
    dist real,
    dw1mag real,
    rch2w1 real,
    dw2mag real,
    rch2w2 real,
    elon_avg double precision,
    elonsig real,
    elat_avg double precision,
    elatsig real,
    delon real,
    delonsig real,
    delat real,
    delatsig real,
    delonsnr real,
    delatsnr real,
    chi2pmra real,
    chi2pmdec real,
    ka integer,
    k1 integer,
    k2 integer,
    km integer,
    par_pm real,
    par_pmsig real,
    par_stat real,
    par_sigma real,
    dist_x real,
    cc_flags character(16),
    w1cc_map integer,
    w1cc_map_str character(20),
    w2cc_map integer,
    w2cc_map_str character(20),
    n_aw integer,
    ab_flags character(9),
    w1ab_map integer,
    w1ab_map_str character(13),
    w2ab_map integer,
    w2ab_map_str character(13),
    glon double precision,
    glat double precision,
    elon double precision,
    elat double precision,
    unwise_objid character(20)
);


--
-- Name: dr18_ebosstarget_v5; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_ebosstarget_v5 (
    run integer,
    camcol integer,
    field integer,
    id integer,
    rerun text,
    fibermag_u real,
    fibermag_g real,
    fibermag_r real,
    fibermag_i real,
    fibermag_z real,
    fiber2mag_u real,
    fiber2mag_g real,
    fiber2mag_r real,
    fiber2mag_i real,
    fiber2mag_z real,
    calib_status_u integer,
    calib_status_g integer,
    calib_status_r integer,
    calib_status_i integer,
    calib_status_z integer,
    ra double precision,
    "dec" double precision,
    epoch real,
    pmra real,
    pmdec real,
    eboss_target1 bigint,
    eboss_target2 bigint,
    eboss_target_id bigint,
    thing_id_targeting integer,
    objc_type integer,
    objc_flags integer,
    objc_flags2 integer,
    flags integer,
    flags2 integer,
    psf_fwhm_u real,
    psf_fwhm_g real,
    psf_fwhm_r real,
    psf_fwhm_i real,
    psf_fwhm_z real,
    psfflux_u real,
    psfflux_g real,
    psfflux_r real,
    psfflux_i real,
    psfflux_z real,
    psfflux_ivar_u real,
    psfflux_ivar_g real,
    psfflux_ivar_r real,
    psfflux_ivar_i real,
    psfflux_ivar_z real,
    extinction_u real,
    extinction_g real,
    extinction_r real,
    extinction_i real,
    extinction_z real,
    fiberflux_u real,
    fiberflux_g real,
    fiberflux_r real,
    fiberflux_i real,
    fiberflux_z real,
    fiberflux_ivar_u real,
    fiberflux_ivar_g real,
    fiberflux_ivar_r real,
    fiberflux_ivar_i real,
    fiberflux_ivar_z real,
    fiber2flux_ivar_u real,
    fiber2flux_ivar_g real,
    fiber2flux_ivar_r real,
    fiber2flux_ivar_i real,
    fiber2flux_ivar_z real,
    modelflux_u real,
    modelflux_g real,
    modelflux_r real,
    modelflux_i real,
    modelflux_z real,
    modelflux_ivar_u real,
    modelflux_ivar_g real,
    modelflux_ivar_r real,
    modelflux_ivar_i real,
    modelflux_ivar_z real,
    modelmag_u real,
    modelmag_g real,
    modelmag_r real,
    modelmag_i real,
    modelmag_z real,
    modelmag_ivar_u real,
    modelmag_ivar_g real,
    modelmag_ivar_r real,
    modelmag_ivar_i real,
    modelmag_ivar_z real,
    resolve_status integer,
    w1_mag real,
    w1_mag_err real,
    w1_nanomaggies real,
    w1_nanomaggies_ivar real,
    w2_nanomaggies real,
    w2_nanomaggies_ivar real,
    has_wise_phot boolean,
    objid_targeting bigint,
    pk bigint NOT NULL
);


--
-- Name: dr18_gaia_dr2_ruwe; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_gaia_dr2_ruwe (
    source_id bigint NOT NULL,
    ruwe real
);


--
-- Name: dr18_gaia_dr2_source; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_gaia_dr2_source (
    solution_id bigint,
    designation text,
    source_id bigint NOT NULL,
    random_index bigint,
    ref_epoch double precision,
    ra double precision,
    ra_error double precision,
    "dec" double precision,
    dec_error double precision,
    parallax double precision,
    parallax_error double precision,
    parallax_over_error real,
    pmra double precision,
    pmra_error double precision,
    pmdec double precision,
    pmdec_error double precision,
    ra_dec_corr real,
    ra_parallax_corr real,
    ra_pmra_corr real,
    ra_pmdec_corr real,
    dec_parallax_corr real,
    dec_pmra_corr real,
    dec_pmdec_corr real,
    parallax_pmra_corr real,
    parallax_pmdec_corr real,
    pmra_pmdec_corr real,
    astrometric_n_obs_al integer,
    astrometric_n_obs_ac integer,
    astrometric_n_good_obs_al integer,
    astrometric_n_bad_obs_al integer,
    astrometric_gof_al real,
    astrometric_chi2_al real,
    astrometric_excess_noise double precision,
    astrometric_excess_noise_sig double precision,
    astrometric_params_solved integer,
    astrometric_primary_flag boolean,
    astrometric_weight_al real,
    astrometric_pseudo_colour double precision,
    astrometric_pseudo_colour_error double precision,
    mean_varpi_factor_al real,
    astrometric_matched_observations smallint,
    visibility_periods_used smallint,
    astrometric_sigma5d_max real,
    frame_rotator_object_type integer,
    matched_observations smallint,
    duplicated_source boolean,
    phot_g_n_obs integer,
    phot_g_mean_flux double precision,
    phot_g_mean_flux_error double precision,
    phot_g_mean_flux_over_error real,
    phot_g_mean_mag real,
    phot_bp_n_obs integer,
    phot_bp_mean_flux double precision,
    phot_bp_mean_flux_error double precision,
    phot_bp_mean_flux_over_error real,
    phot_bp_mean_mag real,
    phot_rp_n_obs integer,
    phot_rp_mean_flux double precision,
    phot_rp_mean_flux_error double precision,
    phot_rp_mean_flux_over_error real,
    phot_rp_mean_mag real,
    phot_bp_rp_excess_factor real,
    phot_proc_mode integer,
    bp_rp real,
    bp_g real,
    g_rp real,
    radial_velocity double precision,
    radial_velocity_error double precision,
    rv_nb_transits integer,
    rv_template_teff real,
    rv_template_logg real,
    rv_template_fe_h real,
    phot_variable_flag text,
    l double precision,
    b double precision,
    ecl_lon double precision,
    ecl_lat double precision,
    priam_flags bigint,
    teff_val real,
    teff_percentile_lower real,
    teff_percentile_upper real,
    a_g_val real,
    a_g_percentile_lower real,
    a_g_percentile_upper real,
    e_bp_min_rp_val real,
    e_bp_min_rp_percentile_lower real,
    e_bp_min_rp_percentile_upper real,
    flame_flags bigint,
    radius_val real,
    radius_percentile_lower real,
    radius_percentile_upper real,
    lum_val real,
    lum_percentile_lower real,
    lum_percentile_upper real
);


--
-- Name: dr18_gaia_dr2_wd; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_gaia_dr2_wd (
    wd text,
    dr2name text,
    source_id bigint NOT NULL,
    source integer,
    ra double precision,
    e_ra double precision,
    "dec" double precision,
    e_dec double precision,
    plx real,
    e_plx real,
    pmra double precision,
    e_pmra double precision,
    pmdec double precision,
    e_pmdec double precision,
    epsi real,
    amax real,
    fg_gaia real,
    e_fg_gaia real,
    g_gaia_mag real,
    fbp real,
    e_fbp real,
    bpmag real,
    frp real,
    e_frp real,
    rpmag real,
    e_br_rp real,
    glon double precision,
    glat double precision,
    density real,
    ag real,
    sdss text,
    umag real,
    e_umag real,
    gmag real,
    e_gmag real,
    rmag real,
    e_rmag real,
    imag real,
    e_imag real,
    zmag real,
    e_zmag real,
    pwd real,
    f_pwd integer,
    teffh real,
    e_teffh real,
    loggh real,
    e_loggh real,
    massh real,
    e_massh real,
    chi2h real,
    teffhe real,
    e_teffhe real,
    logghe real,
    e_logghe real,
    masshe real,
    e_masshe real,
    chisqhe real
);


--
-- Name: dr18_gaia_unwise_agn; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_gaia_unwise_agn (
    ra double precision,
    "dec" double precision,
    gaia_sourceid bigint NOT NULL,
    unwise_objid text,
    plx double precision,
    plx_err double precision,
    pmra double precision,
    pmra_err double precision,
    pmdec double precision,
    pmdec_err double precision,
    plxsig double precision,
    pmsig double precision,
    ebv double precision,
    n_obs integer,
    g double precision,
    bp double precision,
    rp double precision,
    w1 double precision,
    w2 double precision,
    bp_g double precision,
    bp_rp double precision,
    g_rp double precision,
    g_w1 double precision,
    gw_sep double precision,
    w1_w2 double precision,
    g_var double precision,
    bprp_ef double precision,
    aen double precision,
    gof double precision,
    cnt1 integer,
    cnt2 integer,
    cnt4 integer,
    cnt8 integer,
    cnt16 integer,
    cnt32 integer,
    phot_z double precision,
    prob_rf double precision
);


--
-- Name: dr18_gaiadr2_tmass_best_neighbour; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_gaiadr2_tmass_best_neighbour (
    tmass_oid bigint,
    number_of_neighbours integer,
    number_of_mates integer,
    best_neighbour_multiplicity integer,
    source_id bigint NOT NULL,
    original_ext_source_id character(17),
    angular_distance double precision,
    gaia_astrometric_params integer,
    tmass_pts_key integer
);


--
-- Name: dr18_geometric_distances_gaia_dr2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_geometric_distances_gaia_dr2 (
    source_id bigint NOT NULL,
    r_est real,
    r_lo real,
    r_hi real,
    r_len real,
    result_flag character(1),
    modality_flag smallint
);


--
-- Name: dr18_glimpse; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_glimpse (
    designation text,
    tmass_designation character varying(18),
    tmass_cntr integer,
    l double precision,
    b double precision,
    dl double precision,
    db double precision,
    ra double precision,
    "dec" double precision,
    dra double precision,
    ddec double precision,
    csf integer,
    mag_j real,
    dj_m real,
    mag_h real,
    dh_m real,
    mag_ks real,
    dks_m real,
    mag3_6 real,
    d3_6m real,
    mag4_5 real,
    d4_5m real,
    mag5_8 real,
    d5_8m real,
    mag8_0 real,
    d8_0m real,
    f_j real,
    df_j real,
    f_h real,
    df_h real,
    f_ks real,
    df_ks real,
    f3_6 real,
    df3_6 real,
    f4_5 real,
    df4_5 real,
    f5_8 real,
    df5_8 real,
    f8_0 real,
    df8_0 real,
    rms_f3_6 real,
    rms_f4_5 real,
    rms_f5_8 real,
    rms_f8_0 real,
    sky_3_6 real,
    sky_4_5 real,
    sky_5_8 real,
    sky_8_0 real,
    sn_j real,
    sn_h real,
    sn_ks real,
    sn_3_6 real,
    sn_4_5 real,
    sn_5_8 real,
    sn_8_0 real,
    dens_3_6 real,
    dens_4_5 real,
    dens_5_8 real,
    dens_8_0 real,
    m3_6 integer,
    m4_5 integer,
    m5_8 integer,
    m8_0 integer,
    n3_6 integer,
    n4_5 integer,
    n5_8 integer,
    n8_0 integer,
    sqf_j integer,
    sqf_h integer,
    sqf_ks integer,
    sqf_3_6 integer,
    sqf_4_5 integer,
    sqf_5_8 integer,
    sqf_8_0 integer,
    mf3_6 integer,
    mf4_5 integer,
    mf5_8 integer,
    mf8_0 integer,
    pk bigint NOT NULL
);


--
-- Name: dr18_guvcat; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_guvcat (
    objid bigint NOT NULL,
    photoextractid bigint,
    mpstype text,
    avaspra double precision,
    avaspdec double precision,
    fexptime real,
    nexptime real,
    ra double precision,
    "dec" double precision,
    glon double precision,
    glat double precision,
    tilenum integer,
    img integer,
    subvisit integer,
    fov_radius real,
    type integer,
    band integer,
    e_bv real,
    istherespectrum smallint,
    chkobj_type smallint,
    fuv_mag real,
    fuv_magerr real,
    nuv_mag real,
    nuv_magerr real,
    fuv_mag_auto real,
    fuv_magerr_auto real,
    nuv_mag_auto real,
    nuv_magerr_auto real,
    fuv_mag_aper_4 real,
    fuv_magerr_aper_4 real,
    nuv_mag_aper_4 real,
    nuv_magerr_aper_4 real,
    fuv_mag_aper_6 real,
    fuv_magerr_aper_6 real,
    nuv_mag_aper_6 real,
    nuv_magerr_aper_6 real,
    fuv_artifact smallint,
    nuv_artifact smallint,
    fuv_flags smallint,
    nuv_flags smallint,
    fuv_flux real,
    fuv_fluxerr real,
    nuv_flux real,
    nuv_fluxerr real,
    fuv_x_image real,
    fuv_y_image real,
    nuv_x_image real,
    nuv_y_image real,
    fuv_fwhm_image real,
    nuv_fwhm_image real,
    fuv_fwhm_world real,
    nuv_fwhm_world real,
    nuv_class_star real,
    fuv_class_star real,
    nuv_ellipticity real,
    fuv_ellipticity real,
    nuv_theta_j2000 real,
    nuv_errtheta_j2000 real,
    fuv_theta_j2000 real,
    fuv_errtheta_j2000 real,
    fuv_ncat_fwhm_image real,
    fuv_ncat_flux_radius_3 real,
    nuv_kron_radius real,
    nuv_a_world real,
    nuv_b_world real,
    fuv_kron_radius real,
    fuv_a_world real,
    fuv_b_world real,
    nuv_weight real,
    fuv_weight real,
    prob real,
    sep real,
    nuv_poserr real,
    fuv_poserr real,
    ib_poserr real,
    nuv_pperr real,
    fuv_pperr real,
    corv text,
    grank smallint,
    ngrank smallint,
    primgid bigint,
    groupgid text,
    grankdist smallint,
    ngrankdist bigint,
    primgiddist bigint,
    groupgiddist text,
    groupgidtot text,
    difffuv real,
    diffnuv real,
    difffuvdist real,
    diffnuvdist real,
    sepas real,
    sepasdist real,
    inlargeobj text,
    largeobjsize real
);


--
-- Name: dr18_instrument; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_instrument (
    pk integer NOT NULL,
    label text,
    default_lambda_eff real
);


--
-- Name: dr18_legacy_survey_dr8; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_legacy_survey_dr8 (
    release integer,
    brickid bigint,
    brickname text,
    objid bigint,
    type text,
    ra double precision,
    "dec" double precision,
    ra_ivar real,
    dec_ivar real,
    dchisq_psf real,
    dchisq_rex real,
    dchisq_dev real,
    dchisq_exp real,
    dchisq_comp real,
    ebv real,
    flux_g real,
    flux_r real,
    flux_z real,
    flux_w1 real,
    flux_w2 real,
    flux_w3 real,
    flux_w4 real,
    flux_ivar_g real,
    flux_ivar_r real,
    flux_ivar_z real,
    flux_ivar_w1 real,
    flux_ivar_w2 real,
    flux_ivar_w3 real,
    flux_ivar_w4 real,
    mw_transmission_g real,
    mw_transmission_r real,
    mw_transmission_z real,
    mw_transmission_w1 real,
    mw_transmission_w2 real,
    mw_transmission_w3 real,
    mw_transmission_w4 real,
    nobs_g integer,
    nobs_r integer,
    nobs_z integer,
    nobs_w1 integer,
    nobs_w2 integer,
    nobs_w3 integer,
    nobs_w4 integer,
    rchisq_g real,
    rchisq_r real,
    rchisq_z real,
    rchisq_w1 real,
    rchisq_w2 real,
    rchisq_w3 real,
    rchisq_w4 real,
    fracflux_g real,
    fracflux_r real,
    fracflux_z real,
    fracflux_w1 real,
    fracflux_w2 real,
    fracflux_w3 real,
    fracflux_w4 real,
    fracmasked_g real,
    fracmasked_r real,
    fracmasked_z real,
    fracin_g real,
    fracin_r real,
    fracin_z real,
    anymask_g integer,
    anymask_r integer,
    anymask_z integer,
    allmask_g integer,
    allmask_r integer,
    allmask_z integer,
    wisemask_w1 smallint,
    wisemask_w2 smallint,
    psfsize_g real,
    psfsize_r real,
    psfsize_z real,
    psfdepth_g real,
    psfdepth_r real,
    psfdepth_z real,
    galdepth_g real,
    galdepth_r real,
    galdepth_z real,
    psfdepth_w1 real,
    psfdepth_w2 real,
    wise_coadd_id text,
    fracdev real,
    fracdev_ivar real,
    shapedev_r real,
    shapedev_r_ivar real,
    shapedev_e1 real,
    shapedev_e1_ivar real,
    shapedev_e2 real,
    shapedev_e2_ivar real,
    shapeexp_r real,
    shapeexp_r_ivar real,
    shapeexp_e1 real,
    shapeexp_e1_ivar real,
    shapeexp_e2 real,
    shapeexp_e2_ivar real,
    fiberflux_g real,
    fiberflux_r real,
    fiberflux_z real,
    fibertotflux_g real,
    fibertotflux_r real,
    fibertotflux_z real,
    ref_cat text,
    ref_id bigint,
    ref_epoch real,
    gaia_phot_g_mean_mag real,
    gaia_phot_g_mean_flux_over_error real,
    gaia_phot_bp_mean_mag real,
    gaia_phot_bp_mean_flux_over_error real,
    gaia_phot_rp_mean_mag real,
    gaia_phot_rp_mean_flux_over_error real,
    gaia_astrometric_excess_noise real,
    gaia_duplicated_source boolean,
    gaia_phot_bp_rp_excess_factor real,
    gaia_astrometric_sigma5d_max real,
    gaia_astrometric_params_solved smallint,
    parallax real,
    parallax_ivar real,
    pmra real,
    pmra_ivar real,
    pmdec real,
    pmdec_ivar real,
    maskbits integer,
    ls_id bigint NOT NULL,
    tycho_ref bigint,
    gaia_sourceid bigint
);


--
-- Name: dr18_magnitude; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_magnitude (
    carton_to_target_pk integer,
    magnitude_pk bigint NOT NULL,
    g real,
    r real,
    i real,
    h real,
    bp real,
    rp real,
    z real,
    j real,
    k real,
    gaia_g real,
    optical_prov text
);


--
-- Name: dr18_mapper; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_mapper (
    pk integer NOT NULL,
    label text
);


--
-- Name: dr18_panstarrs1; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_panstarrs1 (
    ra double precision,
    "dec" double precision,
    dra real,
    ddec real,
    tmean real,
    trange real,
    chisqpos real,
    stargal real,
    nmeas integer,
    nwarp_ok integer,
    flags integer,
    objid integer,
    catid integer,
    extid_hi integer,
    extid_lo integer,
    g_chp_psf real,
    g_chp_psf_err real,
    g_chp_psf_nphot integer,
    g_chp_aper real,
    g_chp_aper_err real,
    g_chp_aper_nphot integer,
    g_chp_kron real,
    g_chp_kron_err real,
    g_chp_kron_nphot integer,
    g_stk_psf_flux real,
    g_stk_psf_fluxerr real,
    g_stk_psf_nphot integer,
    g_stk_aper_flux real,
    g_stk_aper_fluxerr real,
    g_stk_aper_nphot integer,
    g_stk_kron_flux real,
    g_stk_kron_fluxerr real,
    g_stk_kron_nphot integer,
    g_wrp_psf_flux real,
    g_wrp_psf_fluxerr real,
    g_wrp_psf_nphot integer,
    g_wrp_aper_flux real,
    g_wrp_aper_fluxerr real,
    g_wrp_aper_nphot integer,
    g_wrp_kron_flux real,
    g_wrp_kron_fluxerr real,
    g_wrp_kron_nphot integer,
    g_flags integer,
    g_ncode integer,
    g_nwarp integer,
    g_nwarp_good integer,
    g_nstack integer,
    g_nstack_det integer,
    g_psfqf real,
    g_psfqfperf real,
    r_chp_psf real,
    r_chp_psf_err real,
    r_chp_psf_nphot integer,
    r_chp_aper real,
    r_chp_aper_err real,
    r_chp_aper_nphot integer,
    r_chp_kron real,
    r_chp_kron_err real,
    r_chp_kron_nphot integer,
    r_stk_psf_flux real,
    r_stk_psf_fluxerr real,
    r_stk_psf_nphot integer,
    r_stk_aper_flux real,
    r_stk_aper_fluxerr real,
    r_stk_aper_nphot integer,
    r_stk_kron_flux real,
    r_stk_kron_fluxerr real,
    r_stk_kron_nphot integer,
    r_wrp_psf_flux real,
    r_wrp_psf_fluxerr real,
    r_wrp_psf_nphot integer,
    r_wrp_aper_flux real,
    r_wrp_aper_fluxerr real,
    r_wrp_aper_nphot integer,
    r_wrp_kron_flux real,
    r_wrp_kron_fluxerr real,
    r_wrp_kron_nphot integer,
    r_flags integer,
    r_ncode integer,
    r_nwarp integer,
    r_nwarp_good integer,
    r_nstack integer,
    r_nstack_det integer,
    r_psfqf real,
    r_psfqfperf real,
    i_chp_psf real,
    i_chp_psf_err real,
    i_chp_psf_nphot integer,
    i_chp_aper real,
    i_chp_aper_err real,
    i_chp_aper_nphot integer,
    i_chp_kron real,
    i_chp_kron_err real,
    i_chp_kron_nphot integer,
    i_stk_psf_flux real,
    i_stk_psf_fluxerr real,
    i_stk_psf_nphot integer,
    i_stk_aper_flux real,
    i_stk_aper_fluxerr real,
    i_stk_aper_nphot integer,
    i_stk_kron_flux real,
    i_stk_kron_fluxerr real,
    i_stk_kron_nphot integer,
    i_wrp_psf_flux real,
    i_wrp_psf_fluxerr real,
    i_wrp_psf_nphot integer,
    i_wrp_aper_flux real,
    i_wrp_aper_fluxerr real,
    i_wrp_aper_nphot integer,
    i_wrp_kron_flux real,
    i_wrp_kron_fluxerr real,
    i_wrp_kron_nphot integer,
    i_flags integer,
    i_ncode integer,
    i_nwarp integer,
    i_nwarp_good integer,
    i_nstack integer,
    i_nstack_det integer,
    i_psfqf real,
    i_psfqfperf real,
    z_chp_psf real,
    z_chp_psf_err real,
    z_chp_psf_nphot integer,
    z_chp_aper real,
    z_chp_aper_err real,
    z_chp_aper_nphot integer,
    z_chp_kron real,
    z_chp_kron_err real,
    z_chp_kron_nphot integer,
    z_stk_psf_flux real,
    z_stk_psf_fluxerr real,
    z_stk_psf_nphot integer,
    z_stk_aper_flux real,
    z_stk_aper_fluxerr real,
    z_stk_aper_nphot integer,
    z_stk_kron_flux real,
    z_stk_kron_fluxerr real,
    z_stk_kron_nphot integer,
    z_wrp_psf_flux real,
    z_wrp_psf_fluxerr real,
    z_wrp_psf_nphot integer,
    z_wrp_aper_flux real,
    z_wrp_aper_fluxerr real,
    z_wrp_aper_nphot integer,
    z_wrp_kron_flux real,
    z_wrp_kron_fluxerr real,
    z_wrp_kron_nphot integer,
    z_flags integer,
    z_ncode integer,
    z_nwarp integer,
    z_nwarp_good integer,
    z_nstack integer,
    z_nstack_det integer,
    z_psfqf real,
    z_psfqfperf real,
    y_chp_psf real,
    y_chp_psf_err real,
    y_chp_psf_nphot integer,
    y_chp_aper real,
    y_chp_aper_err real,
    y_chp_aper_nphot integer,
    y_chp_kron real,
    y_chp_kron_err real,
    y_chp_kron_nphot integer,
    y_stk_psf_flux real,
    y_stk_psf_fluxerr real,
    y_stk_psf_nphot integer,
    y_stk_aper_flux real,
    y_stk_aper_fluxerr real,
    y_stk_aper_nphot integer,
    y_stk_kron_flux real,
    y_stk_kron_fluxerr real,
    y_stk_kron_nphot integer,
    y_wrp_psf_flux real,
    y_wrp_psf_fluxerr real,
    y_wrp_psf_nphot integer,
    y_wrp_aper_flux real,
    y_wrp_aper_fluxerr real,
    y_wrp_aper_nphot integer,
    y_wrp_kron_flux real,
    y_wrp_kron_fluxerr real,
    y_wrp_kron_nphot integer,
    y_flags integer,
    y_ncode integer,
    y_nwarp integer,
    y_nwarp_good integer,
    y_nstack integer,
    y_nstack_det integer,
    y_psfqf real,
    y_psfqfperf real,
    catid_objid bigint NOT NULL,
    extid_hi_lo bigint
);


--
-- Name: dr18_sagitta; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_sagitta (
    source_id bigint NOT NULL,
    ra double precision,
    "dec" double precision,
    av real,
    yso real,
    yso_std real,
    age real,
    age_std real
);


--
-- Name: dr18_sdss_apogeeallstarmerge_r13; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_sdss_apogeeallstarmerge_r13 (
    apogee_id text NOT NULL,
    nvisits smallint,
    nentries integer,
    ra double precision,
    "dec" double precision,
    glon double precision,
    glat double precision,
    pmra double precision,
    pmdec double precision,
    pm_src text,
    j real,
    j_err real,
    h real,
    h_err real,
    k real,
    k_err real,
    ak real,
    vhelio_avg real,
    vhelio_err real,
    vscatter real,
    sig_rvvar real,
    baseline real,
    mean_fiber real,
    sig_fiber real,
    apstar_ids text,
    visits text,
    fields text,
    surveys text,
    telescopes text,
    targflags text,
    starflags text,
    aspcapflags text,
    teff real,
    teff_err real,
    logg real,
    logg_err real,
    feh real,
    feh_err real,
    startype text,
    vjitter real,
    dist real,
    dist_err real,
    dist_src text,
    dist_srclist text,
    mstar real,
    mstar_err real,
    rstar real,
    rstar_err real,
    mstar_src text,
    designation text
);


--
-- Name: dr18_sdss_dr13_photoobj_primary; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_sdss_dr13_photoobj_primary (
    objid bigint NOT NULL,
    ra double precision,
    "dec" double precision
);


--
-- Name: dr18_sdss_dr16_qso; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_sdss_dr16_qso (
    sdss_name text,
    ra double precision,
    "dec" double precision,
    plate integer,
    mjd integer,
    fiberid integer,
    autoclass_pqn text,
    autoclass_dr14q text,
    is_qso_qn integer,
    z_qn double precision,
    random_select integer,
    z_10k double precision,
    z_conf_10k integer,
    pipe_corr_10k integer,
    is_qso_10k integer,
    thing_id bigint,
    z_vi double precision,
    z_conf integer,
    class_person integer,
    z_dr12q double precision,
    is_qso_dr12q integer,
    z_dr7q_sch double precision,
    is_qso_dr7q integer,
    z_dr6q_hw double precision,
    z_dr7q_hw double precision,
    is_qso_final integer,
    z double precision,
    source_z text,
    z_pipe double precision,
    zwarning integer,
    objid text,
    z_pca double precision,
    zwarn_pca bigint,
    deltachi2_pca double precision,
    z_halpha double precision,
    zwarn_halpha bigint,
    deltachi2_halpha double precision,
    z_hbeta double precision,
    zwarn_hbeta bigint,
    deltachi2_hbeta double precision,
    z_mgii double precision,
    zwarn_mgii bigint,
    deltachi2_mgii double precision,
    z_ciii double precision,
    zwarn_ciii bigint,
    deltachi2_ciii double precision,
    z_civ double precision,
    zwarn_civ bigint,
    deltachi2_civ double precision,
    z_lya double precision,
    zwarn_lya bigint,
    deltachi2_lya double precision,
    z_lyawg real,
    z_dla text,
    nhi_dla text,
    conf_dla text,
    bal_prob real,
    bi_civ double precision,
    err_bi_civ double precision,
    ai_civ double precision,
    err_ai_civ double precision,
    bi_siiv double precision,
    err_bi_siiv double precision,
    ai_siiv double precision,
    err_ai_siiv double precision,
    boss_target1 bigint,
    eboss_target0 bigint,
    eboss_target1 bigint,
    eboss_target2 bigint,
    ancillary_target1 bigint,
    ancillary_target2 bigint,
    nspec_sdss integer,
    nspec_boss integer,
    nspec integer,
    plate_duplicate text,
    mjd_duplicate text,
    fiberid_duplicate text,
    spectro_duplicate text,
    skyversion integer,
    run_number integer,
    rerun_number text,
    camcol_number integer,
    field_number integer,
    id_number integer,
    lambda_eff double precision,
    zoffset double precision,
    xfocal double precision,
    yfocal double precision,
    chunk text,
    tile integer,
    platesn2 double precision,
    psfflux_u real,
    psfflux_g real,
    psfflux_r real,
    psfflux_i real,
    psfflux_z real,
    psfflux_ivar_u double precision,
    psfflux_ivar_g double precision,
    psfflux_ivar_r double precision,
    psfflux_ivar_i double precision,
    psfflux_ivar_z double precision,
    psfmag_u real,
    psfmag_g real,
    psfmag_r real,
    psfmag_i real,
    psfmag_z real,
    psfmagerr_u double precision,
    psfmagerr_g double precision,
    psfmagerr_r double precision,
    psfmagerr_i double precision,
    psfmagerr_z double precision,
    extinction_u real,
    extinction_g real,
    extinction_r real,
    extinction_i real,
    extinction_z real,
    m_i double precision,
    sn_median_all double precision,
    galex_matched integer,
    fuv double precision,
    fuv_ivar double precision,
    nuv double precision,
    nuv_ivar double precision,
    ukidss_matched integer,
    yflux double precision,
    yflux_err double precision,
    jflux double precision,
    jflux_err double precision,
    hflux double precision,
    hflux_err double precision,
    kflux double precision,
    kflux_err double precision,
    w1_flux real,
    w1_flux_ivar real,
    w1_mag real,
    w1_mag_err real,
    w1_chi2 real,
    w1_flux_snr real,
    w1_src_frac real,
    w1_ext_flux real,
    w1_ext_frac real,
    w1_npix integer,
    w2_flux real,
    w2_flux_ivar real,
    w2_mag real,
    w2_mag_err real,
    w2_chi2 real,
    w2_flux_snr real,
    w2_src_frac real,
    w2_ext_flux real,
    w2_ext_frac real,
    w2_npix integer,
    first_matched integer,
    first_flux double precision,
    first_snr double precision,
    sdss2first_sep double precision,
    jmag double precision,
    jmag_err double precision,
    jsnr double precision,
    jrdflag integer,
    hmag double precision,
    hmag_err double precision,
    hsnr double precision,
    hrdflag integer,
    kmag double precision,
    kmag_err double precision,
    ksnr double precision,
    krdflag integer,
    sdss2mass_sep double precision,
    rass2rxs_id text,
    rass2rxs_ra double precision,
    rass2rxs_dec double precision,
    rass2rxs_src_flux real,
    rass2rxs_src_flux_err real,
    sdss2rosat_sep double precision,
    xmm_src_id bigint,
    xmm_ra double precision,
    xmm_dec double precision,
    xmm_soft_flux real,
    xmm_soft_flux_err real,
    xmm_hard_flux real,
    xmm_hard_flux_err real,
    xmm_total_flux real,
    xmm_total_flux_err real,
    xmm_total_lum real,
    sdss2xmm_sep double precision,
    gaia_matched integer,
    gaia_designation text,
    gaia_ra double precision,
    gaia_dec double precision,
    gaia_parallax double precision,
    gaia_parallax_err double precision,
    gaia_pm_ra double precision,
    gaia_pm_ra_err double precision,
    gaia_pm_dec double precision,
    gaia_pm_dec_err double precision,
    gaia_g_mag double precision,
    gaia_g_flux_snr double precision,
    gaia_bp_mag double precision,
    gaia_bp_flux_snr double precision,
    gaia_rp_mag double precision,
    gaia_rp_flux_snr double precision,
    sdss2gaia_sep double precision,
    pk bigint NOT NULL
);


--
-- Name: dr18_sdss_dr16_qso_original; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_sdss_dr16_qso_original (
    sdss_name text,
    ra double precision,
    "dec" double precision,
    plate integer,
    mjd integer,
    fiberid integer,
    autoclass_pqn text,
    autoclass_dr14q text,
    is_qso_qn integer,
    z_qn double precision,
    random_select integer,
    z_10k double precision,
    z_conf_10k integer,
    pipe_corr_10k integer,
    is_qso_10k integer,
    thing_id bigint,
    z_vi double precision,
    z_conf integer,
    class_person integer,
    z_dr12q double precision,
    is_qso_dr12q integer,
    z_dr7q_sch double precision,
    is_qso_dr7q integer,
    z_dr6q_hw double precision,
    z_dr7q_hw double precision,
    is_qso_final integer,
    z double precision,
    source_z text,
    z_pipe double precision,
    zwarning integer,
    objid text,
    z_pca double precision,
    zwarn_pca bigint,
    deltachi2_pca double precision,
    z_halpha double precision,
    zwarn_halpha bigint,
    deltachi2_halpha double precision,
    z_hbeta double precision,
    zwarn_hbeta bigint,
    deltachi2_hbeta double precision,
    z_mgii double precision,
    zwarn_mgii bigint,
    deltachi2_mgii double precision,
    z_ciii double precision,
    zwarn_ciii bigint,
    deltachi2_ciii double precision,
    z_civ double precision,
    zwarn_civ bigint,
    deltachi2_civ double precision,
    z_lya double precision,
    zwarn_lya bigint,
    deltachi2_lya double precision,
    z_lyawg real,
    z_dla text,
    nhi_dla text,
    conf_dla text,
    bal_prob real,
    bi_civ double precision,
    err_bi_civ double precision,
    ai_civ double precision,
    err_ai_civ double precision,
    bi_siiv double precision,
    err_bi_siiv double precision,
    ai_siiv double precision,
    err_ai_siiv double precision,
    boss_target1 bigint,
    eboss_target0 bigint,
    eboss_target1 bigint,
    eboss_target2 bigint,
    ancillary_target1 bigint,
    ancillary_target2 bigint,
    nspec_sdss integer,
    nspec_boss integer,
    nspec integer,
    plate_duplicate text,
    mjd_duplicate text,
    fiberid_duplicate text,
    spectro_duplicate text,
    skyversion integer,
    run_number integer,
    rerun_number text,
    camcol_number integer,
    field_number integer,
    id_number integer,
    lambda_eff double precision,
    zoffset double precision,
    xfocal double precision,
    yfocal double precision,
    chunk text,
    tile integer,
    platesn2 double precision,
    psfflux_u real,
    psfflux_g real,
    psfflux_r real,
    psfflux_i real,
    psfflux_z real,
    psfflux_ivar_u double precision,
    psfflux_ivar_g double precision,
    psfflux_ivar_r double precision,
    psfflux_ivar_i double precision,
    psfflux_ivar_z double precision,
    psfmag_u real,
    psfmag_g real,
    psfmag_r real,
    psfmag_i real,
    psfmag_z real,
    psfmagerr_u double precision,
    psfmagerr_g double precision,
    psfmagerr_r double precision,
    psfmagerr_i double precision,
    psfmagerr_z double precision,
    extinction_u real,
    extinction_g real,
    extinction_r real,
    extinction_i real,
    extinction_z real,
    m_i double precision,
    sn_median_all double precision,
    galex_matched integer,
    fuv double precision,
    fuv_ivar double precision,
    nuv double precision,
    nuv_ivar double precision,
    ukidss_matched integer,
    yflux double precision,
    yflux_err double precision,
    jflux double precision,
    jflux_err double precision,
    hflux double precision,
    hflux_err double precision,
    kflux double precision,
    kflux_err double precision,
    w1_flux real,
    w1_flux_ivar real,
    w1_mag real,
    w1_mag_err real,
    w1_chi2 real,
    w1_flux_snr real,
    w1_src_frac real,
    w1_ext_flux real,
    w1_ext_frac real,
    w1_npix integer,
    w2_flux real,
    w2_flux_ivar real,
    w2_mag real,
    w2_mag_err real,
    w2_chi2 real,
    w2_flux_snr real,
    w2_src_frac real,
    w2_ext_flux real,
    w2_ext_frac real,
    w2_npix integer,
    first_matched integer,
    first_flux double precision,
    first_snr double precision,
    sdss2first_sep double precision,
    jmag double precision,
    jmag_err double precision,
    jsnr double precision,
    jrdflag integer,
    hmag double precision,
    hmag_err double precision,
    hsnr double precision,
    hrdflag integer,
    kmag double precision,
    kmag_err double precision,
    ksnr double precision,
    krdflag integer,
    sdss2mass_sep double precision,
    rass2rxs_id text,
    rass2rxs_ra double precision,
    rass2rxs_dec double precision,
    rass2rxs_src_flux real,
    rass2rxs_src_flux_err real,
    sdss2rosat_sep double precision,
    xmm_src_id bigint,
    xmm_ra double precision,
    xmm_dec double precision,
    xmm_soft_flux real,
    xmm_soft_flux_err real,
    xmm_hard_flux real,
    xmm_hard_flux_err real,
    xmm_total_flux real,
    xmm_total_flux_err real,
    xmm_total_lum real,
    sdss2xmm_sep double precision,
    gaia_matched integer,
    gaia_designation text,
    gaia_ra double precision,
    gaia_dec double precision,
    gaia_parallax double precision,
    gaia_parallax_err double precision,
    gaia_pm_ra double precision,
    gaia_pm_ra_err double precision,
    gaia_pm_dec double precision,
    gaia_pm_dec_err double precision,
    gaia_g_mag double precision,
    gaia_g_flux_snr double precision,
    gaia_bp_mag double precision,
    gaia_bp_flux_snr double precision,
    gaia_rp_mag double precision,
    gaia_rp_flux_snr double precision,
    sdss2gaia_sep double precision,
    pk bigint
);


--
-- Name: dr18_sdss_dr16_specobj; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_sdss_dr16_specobj (
    specobjid numeric(20,0) NOT NULL,
    bestobjid bigint,
    fluxobjid bigint,
    targetobjid bigint,
    plateid numeric(20,0),
    scienceprimary smallint,
    sdssprimary smallint,
    legacyprimary smallint,
    segueprimary smallint,
    segue1primary smallint,
    segue2primary smallint,
    bossprimary smallint,
    bossspecobjid integer,
    firstrelease character varying(32),
    survey character varying(32),
    instrument character varying(32),
    programname character varying(32),
    chunk character varying(32),
    platerun character varying(32),
    mjd integer,
    plate smallint,
    fiberid smallint,
    run1d character varying(32),
    run2d character varying(32),
    tile integer,
    designid integer,
    legacy_target1 bigint,
    legacy_target2 bigint,
    special_target1 bigint,
    special_target2 bigint,
    segue1_target1 bigint,
    segue1_target2 bigint,
    segue2_target1 bigint,
    segue2_target2 bigint,
    boss_target1 bigint,
    eboss_target0 bigint,
    eboss_target1 bigint,
    eboss_target2 bigint,
    eboss_target_id bigint,
    ancillary_target1 bigint,
    ancillary_target2 bigint,
    thing_id_targeting bigint,
    thing_id integer,
    primtarget bigint,
    sectarget bigint,
    spectrographid smallint,
    sourcetype character varying(128),
    targettype character varying(128),
    ra double precision,
    "dec" double precision,
    cx double precision,
    cy double precision,
    cz double precision,
    xfocal real,
    yfocal real,
    lambdaeff real,
    bluefiber integer,
    zoffset real,
    z real,
    zerr real,
    zwarning integer,
    class character varying(32),
    subclass character varying(32),
    rchi2 real,
    dof real,
    rchi2diff real,
    z_noqso real,
    zerr_noqso real,
    zwarning_noqso integer,
    class_noqso character varying(32),
    subclass_noqso character varying(32),
    rchi2diff_noqso real,
    z_person real,
    class_person character varying(32),
    comments_person character varying(200),
    tfile character varying(32),
    tcolumn_0 smallint,
    tcolumn_1 smallint,
    tcolumn_2 smallint,
    tcolumn_3 smallint,
    tcolumn_4 smallint,
    tcolumn_5 smallint,
    tcolumn_6 smallint,
    tcolumn_7 smallint,
    tcolumn_8 smallint,
    tcolumn_9 smallint,
    npoly real,
    theta_0 real,
    theta_1 real,
    theta_2 real,
    theta_3 real,
    theta_4 real,
    theta_5 real,
    theta_6 real,
    theta_7 real,
    theta_8 real,
    theta_9 real,
    veldisp real,
    veldisperr real,
    veldispz real,
    veldispzerr real,
    veldispchi2 real,
    veldispnpix integer,
    veldispdof integer,
    wavemin real,
    wavemax real,
    wcoverage real,
    snmedian_u real,
    snmedian_g real,
    snmedian_r real,
    snmedian_i real,
    snmedian_z real,
    snmedian real,
    chi68p real,
    fracnsigma_1 real,
    fracnsigma_2 real,
    fracnsigma_3 real,
    fracnsigma_4 real,
    fracnsigma_5 real,
    fracnsigma_6 real,
    fracnsigma_7 real,
    fracnsigma_8 real,
    fracnsigma_9 real,
    fracnsigma_10 real,
    fracnsighi_1 real,
    fracnsighi_2 real,
    fracnsighi_3 real,
    fracnsighi_4 real,
    fracnsighi_5 real,
    fracnsighi_6 real,
    fracnsighi_7 real,
    fracnsighi_8 real,
    fracnsighi_9 real,
    fracnsighi_10 real,
    fracnsiglo_1 real,
    fracnsiglo_2 real,
    fracnsiglo_3 real,
    fracnsiglo_4 real,
    fracnsiglo_5 real,
    fracnsiglo_6 real,
    fracnsiglo_7 real,
    fracnsiglo_8 real,
    fracnsiglo_9 real,
    fracnsiglo_10 real,
    spectroflux_u real,
    spectroflux_g real,
    spectroflux_r real,
    spectroflux_i real,
    spectroflux_z real,
    spectrosynflux_u real,
    spectrosynflux_g real,
    spectrosynflux_r real,
    spectrosynflux_i real,
    spectrosynflux_z real,
    spectrofluxivar_u real,
    spectrofluxivar_g real,
    spectrofluxivar_r real,
    spectrofluxivar_i real,
    spectrofluxivar_z real,
    spectrosynfluxivar_u real,
    spectrosynfluxivar_g real,
    spectrosynfluxivar_r real,
    spectrosynfluxivar_i real,
    spectrosynfluxivar_z real,
    spectroskyflux_u real,
    spectroskyflux_g real,
    spectroskyflux_r real,
    spectroskyflux_i real,
    spectroskyflux_z real,
    anyandmask integer,
    anyormask integer,
    platesn2 real,
    deredsn2 real,
    snturnoff real,
    sn1_g real,
    sn1_r real,
    sn1_i real,
    sn2_g real,
    sn2_r real,
    sn2_i real,
    elodiefilename character varying(32),
    elodieobject character varying(32),
    elodiesptype character varying(32),
    elodiebv real,
    elodieteff real,
    elodielogg real,
    elodiefeh real,
    elodiez real,
    elodiezerr real,
    elodiezmodelerr real,
    elodierchi2 real,
    elodiedof real,
    htmid bigint,
    loadversion integer
);


--
-- Name: dr18_skies_v2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_skies_v2 (
    pix_32768 bigint NOT NULL,
    ra double precision,
    "dec" double precision,
    down_pix bigint,
    tile_32 bigint,
    valid_gaia boolean,
    selected_gaia boolean,
    sep_neighbour_gaia real,
    mag_neighbour_gaia real,
    valid_ls8 boolean,
    selected_ls8 boolean,
    sep_neighbour_ls8 real,
    mag_neighbour_ls8 real,
    valid_ps1dr2 boolean,
    selected_ps1dr2 boolean,
    sep_neighbour_ps1dr2 real,
    mag_neighbour_ps1dr2 real,
    valid_tmass boolean,
    selected_tmass boolean,
    sep_neighbour_tmass real,
    mag_neighbour_tmass real,
    valid_tycho2 boolean,
    selected_tycho2 boolean,
    sep_neighbour_tycho2 real,
    mag_neighbour_tycho2 real,
    valid_tmass_xsc boolean,
    selected_tmass_xsc boolean,
    sep_neighbour_tmass_xsc real
);


--
-- Name: dr18_skymapper_dr2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_skymapper_dr2 (
    object_id bigint NOT NULL,
    raj2000 double precision,
    dej2000 double precision,
    e_raj2000 integer,
    e_dej2000 integer,
    smss_j character(18),
    mean_epoch double precision,
    rms_epoch real,
    glon real,
    glat real,
    flags smallint,
    nimaflags integer,
    ngood smallint,
    ngood_min smallint,
    nch_max smallint,
    density real,
    u_flags smallint,
    u_nimaflags integer,
    u_ngood smallint,
    u_nch smallint,
    u_nclip smallint,
    v_flags smallint,
    v_nimaflags integer,
    v_ngood smallint,
    v_nch smallint,
    v_nclip smallint,
    g_flags smallint,
    g_nimaflags integer,
    g_ngood smallint,
    g_nch smallint,
    g_nclip smallint,
    r_flags smallint,
    r_nimaflags integer,
    r_ngood smallint,
    r_nch smallint,
    r_nclip smallint,
    i_flags smallint,
    i_nimaflags integer,
    i_ngood smallint,
    i_nch smallint,
    i_nclip smallint,
    z_flags smallint,
    z_nimaflags integer,
    z_ngood smallint,
    z_nch smallint,
    z_nclip smallint,
    class_star real,
    flags_psf integer,
    radius_petro real,
    u_psf real,
    e_u_psf real,
    u_rchi2var real,
    u_petro real,
    e_u_petro real,
    v_psf real,
    e_v_psf real,
    v_rchi2var real,
    v_petro real,
    e_v_petro real,
    g_psf real,
    e_g_psf real,
    g_rchi2var real,
    g_petro real,
    e_g_petro real,
    r_psf real,
    e_r_psf real,
    r_rchi2var real,
    r_petro real,
    e_r_petro real,
    i_psf real,
    e_i_psf real,
    i_rchi2var real,
    i_petro real,
    e_i_petro real,
    z_psf real,
    e_z_psf real,
    z_rchi2var real,
    z_petro real,
    e_z_petro real,
    ebmv_sfd real,
    prox real,
    prox_id bigint,
    dr1_id bigint,
    dr1_dist real,
    twomass_key bigint,
    twomass_dist real,
    allwise_cntr bigint,
    allwise_dist real,
    ucac4_mpos bigint,
    ucac4_dist real,
    refcat2_id bigint,
    refcat2_dist real,
    ps1_dr1_id bigint,
    ps1_dr1_dist real,
    galex_guv_id bigint,
    galex_guv_dist real,
    gaia_dr2_id1 bigint,
    gaia_dr2_dist1 real,
    gaia_dr2_id2 bigint,
    gaia_dr2_dist2 real
);


--
-- Name: dr18_supercosmos; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_supercosmos (
    objid bigint NOT NULL,
    objidb bigint,
    objidr1 bigint,
    objidr2 bigint,
    objidi bigint,
    htmid bigint,
    epoch real,
    ra double precision,
    "dec" double precision,
    sigra double precision,
    sigdec double precision,
    cx double precision,
    cy double precision,
    cz double precision,
    muacosd real,
    mud real,
    sigmuacosd real,
    sigmud real,
    chi2 real,
    nplates smallint,
    classmagb real,
    classmagr1 real,
    classmagr2 real,
    classmagi real,
    gcormagb real,
    gcormagr1 real,
    gcormagr2 real,
    gcormagi real,
    scormagb real,
    scormagr1 real,
    scormagr2 real,
    scormagi real,
    meanclass smallint,
    classb smallint,
    classr1 smallint,
    classr2 smallint,
    classi smallint,
    ellipb real,
    ellipr1 real,
    ellipr2 real,
    ellipi real,
    qualb integer,
    qualr1 integer,
    qualr2 integer,
    quali integer,
    blendb integer,
    blendr1 integer,
    blendr2 integer,
    blendi integer,
    prfstatb real,
    prfstatr1 real,
    prfstatr2 real,
    prfstati real,
    l real,
    b real,
    d real,
    ebmv real
);


--
-- Name: dr18_target; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_target (
    target_pk bigint NOT NULL,
    ra double precision,
    "dec" double precision,
    pmra real,
    pmdec real,
    epoch real,
    parallax real,
    catalogid bigint
);


--
-- Name: dr18_tic_v8; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_tic_v8 (
    id bigint NOT NULL,
    version character varying(8),
    hip integer,
    tyc character varying(12),
    ucac character varying(10),
    twomass character varying(20),
    sdss bigint,
    allwise character varying(20),
    gaia character varying(20),
    apass character varying(30),
    kic integer,
    objtype character varying(16),
    typesrc character varying(16),
    ra double precision,
    "dec" double precision,
    posflag character varying(12),
    pmra real,
    e_pmra real,
    pmdec real,
    e_pmdec real,
    pmflag character varying(12),
    plx real,
    e_plx real,
    parflag character varying(12),
    gallong double precision,
    gallat double precision,
    eclong double precision,
    eclat double precision,
    bmag real,
    e_bmag real,
    vmag real,
    e_vmag real,
    umag real,
    e_umag real,
    gmag real,
    e_gmag real,
    rmag real,
    e_rmag real,
    imag real,
    e_imag real,
    zmag real,
    e_zmag real,
    jmag real,
    e_jmag real,
    hmag real,
    e_hmag real,
    kmag real,
    e_kmag real,
    twomflag character varying(20),
    prox real,
    w1mag real,
    e_w1mag real,
    w2mag real,
    e_w2mag real,
    w3mag real,
    e_w3mag real,
    w4mag real,
    e_w4mag real,
    gaiamag real,
    e_gaiamag real,
    tmag real,
    e_tmag real,
    tessflag character varying(20),
    spflag character varying(20),
    teff real,
    e_teff real,
    logg real,
    e_logg real,
    mh real,
    e_mh real,
    rad real,
    e_rad real,
    mass real,
    e_mass real,
    rho real,
    e_rho real,
    lumclass character varying(10),
    lum real,
    e_lum real,
    d real,
    e_d real,
    ebv real,
    e_ebv real,
    numcont integer,
    contratio real,
    disposition character varying(10),
    duplicate_id bigint,
    priority real,
    eneg_ebv real,
    epos_ebv real,
    ebvflag character varying(20),
    eneg_mass real,
    epos_mass real,
    eneg_rad real,
    epos_rad real,
    eneg_rho real,
    epos_rho real,
    eneg_logg real,
    epos_logg real,
    eneg_lum real,
    epos_lum real,
    eneg_dist real,
    epos_dist real,
    distflag character varying(20),
    eneg_teff real,
    epos_teff real,
    tefflag character varying(20),
    gaiabp real,
    e_gaiabp real,
    gaiarp real,
    e_gaiarp real,
    gaiaqflag integer,
    starchareflag character varying(20),
    vmagflag character varying(20),
    bmagflag character varying(20),
    splits character varying(20),
    e_ra double precision,
    e_dec double precision,
    ra_orig double precision,
    dec_orig double precision,
    e_ra_orig double precision,
    e_dec_orig double precision,
    raddflag integer,
    wdflag integer,
    objid bigint,
    gaia_int bigint,
    twomass_psc text,
    twomass_psc_pts_key integer,
    tycho2_tycid integer,
    allwise_cntr bigint
);


--
-- Name: dr18_twomass_psc; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_twomass_psc (
    ra double precision,
    decl double precision,
    err_maj real,
    err_min real,
    err_ang smallint,
    j_m real,
    j_cmsig real,
    j_msigcom real,
    j_snr real,
    h_m real,
    h_cmsig real,
    h_msigcom real,
    h_snr real,
    k_m real,
    k_cmsig real,
    k_msigcom real,
    k_snr real,
    ph_qual character(3),
    rd_flg character(3),
    bl_flg character(3),
    cc_flg character(3),
    ndet character(6),
    prox real,
    pxpa smallint,
    pxcntr integer,
    gal_contam smallint,
    mp_flg smallint,
    pts_key integer NOT NULL,
    hemis character(1),
    date date,
    scan smallint,
    glon real,
    glat real,
    x_scan real,
    jdate double precision,
    j_psfchi real,
    h_psfchi real,
    k_psfchi real,
    j_m_stdap real,
    j_msig_stdap real,
    h_m_stdap real,
    h_msig_stdap real,
    k_m_stdap real,
    k_msig_stdap real,
    dist_edge_ns integer,
    dist_edge_ew integer,
    dist_edge_flg character(2),
    dup_src smallint,
    use_src smallint,
    a character(1),
    dist_opt real,
    phi_opt smallint,
    b_m_opt real,
    vr_m_opt real,
    nopt_mchs smallint,
    ext_key integer,
    scan_key integer,
    coadd_key integer,
    coadd smallint,
    designation text
);


--
-- Name: dr18_tycho2; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_tycho2 (
    tyc1 integer,
    tyc2 integer,
    tyc3 integer,
    pflag character varying(1),
    ramdeg double precision,
    demdeg double precision,
    pmra double precision,
    pmde double precision,
    e_ramdeg integer,
    e_demdeg integer,
    e_pmra double precision,
    e_pmde double precision,
    epram double precision,
    epdem double precision,
    num integer,
    q_ramdeg double precision,
    q_demdeg double precision,
    q_pmra double precision,
    q_pmde double precision,
    btmag real,
    e_btmag real,
    vtmag real,
    e_vtmag real,
    prox integer,
    tyc character varying(1),
    hip bigint,
    ccdm character varying(3),
    radeg double precision,
    dedeg double precision,
    epra_1990 double precision,
    epde_1990 double precision,
    e_radeg double precision,
    e_dedeg double precision,
    posflg character varying(1),
    corr real,
    flag character varying(1),
    mflag character varying(1),
    designation text NOT NULL,
    tycid integer
);


--
-- Name: dr18_uvotssc1; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_uvotssc1 (
    name character varying(17),
    oseq bigint,
    obsid bigint,
    nf bigint,
    srcid bigint,
    radeg double precision,
    dedeg double precision,
    e_radeg double precision,
    e_dedeg double precision,
    ruvw2 real,
    ruvm2 real,
    ruvw1 real,
    ru real,
    rb real,
    rv real,
    nd bigint,
    suvw2 real,
    suvm2 real,
    suvw1 real,
    su real,
    sb real,
    sv real,
    uvw2 double precision,
    uvm2 double precision,
    uvw1 double precision,
    umag double precision,
    bmag double precision,
    vmag double precision,
    uvw2_ab double precision,
    uvm2_ab double precision,
    uvw1_ab double precision,
    u_ab double precision,
    b_ab double precision,
    v_ab double precision,
    e_uvw2 double precision,
    e_uvm2 double precision,
    e_uvw1 double precision,
    e_umag double precision,
    e_bmag double precision,
    e_vmag double precision,
    f_uvw2 double precision,
    f_uvm2 double precision,
    f_uvw1 double precision,
    f_u double precision,
    f_b double precision,
    f_v double precision,
    e_f_uvw2 double precision,
    e_f_uvm2 double precision,
    e_f_uvw1 double precision,
    e_f_u double precision,
    e_f_b double precision,
    e_f_v double precision,
    auvw2 double precision,
    auvm2 double precision,
    auvw1 double precision,
    au double precision,
    ab double precision,
    av double precision,
    buvw2 double precision,
    buvm2 double precision,
    buvw1 double precision,
    bu double precision,
    bb double precision,
    bv double precision,
    pauvw2 real,
    pauvm2 real,
    pauvw1 real,
    pau real,
    pab real,
    pav real,
    xuvw2 integer,
    xuvm2 integer,
    xuvw1 integer,
    xu integer,
    xb integer,
    xv integer,
    fuvw2 integer,
    fuvm2 integer,
    fuvw1 integer,
    fu integer,
    fb integer,
    fv integer,
    id bigint NOT NULL
);


--
-- Name: dr18_xmm_om_suss_4_1; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_xmm_om_suss_4_1 (
    iauname character varying(22),
    n_summary integer,
    obsid character varying(10),
    srcnum integer,
    uvw2_srcdist real,
    uvm2_srcdist real,
    uvw1_srcdist real,
    u_srcdist real,
    b_srcdist real,
    v_srcdist real,
    ra double precision,
    "dec" double precision,
    ra_hms character varying(13),
    dec_dms character varying(14),
    poserr real,
    lii double precision,
    bii double precision,
    n_obsid integer,
    uvw2_signif real,
    uvm2_signif real,
    uvw1_signif real,
    u_signif real,
    b_signif real,
    v_signif real,
    uvw2_rate real,
    uvw2_rate_err real,
    uvm2_rate real,
    uvm2_rate_err real,
    uvw1_rate real,
    uvw1_rate_err real,
    u_rate real,
    u_rate_err real,
    b_rate real,
    b_rate_err real,
    v_rate real,
    v_rate_err real,
    uvw2_ab_flux real,
    uvw2_ab_flux_err real,
    uvm2_ab_flux real,
    uvm2_ab_flux_err real,
    uvw1_ab_flux real,
    uvw1_ab_flux_err real,
    u_ab_flux real,
    u_ab_flux_err real,
    b_ab_flux real,
    b_ab_flux_err real,
    v_ab_flux real,
    v_ab_flux_err real,
    uvw2_ab_mag real,
    uvw2_ab_mag_err real,
    uvm2_ab_mag real,
    uvm2_ab_mag_err real,
    uvw1_ab_mag real,
    uvw1_ab_mag_err real,
    u_ab_mag real,
    u_ab_mag_err real,
    b_ab_mag real,
    b_ab_mag_err real,
    v_ab_mag real,
    v_ab_mag_err real,
    uvw2_vega_mag real,
    uvw2_vega_mag_err real,
    uvm2_vega_mag real,
    uvm2_vega_mag_err real,
    uvw1_vega_mag real,
    uvw1_vega_mag_err real,
    u_vega_mag real,
    u_vega_mag_err real,
    b_vega_mag real,
    b_vega_mag_err real,
    v_vega_mag real,
    v_vega_mag_err real,
    uvw2_major_axis real,
    uvm2_major_axis real,
    uvw1_major_axis real,
    u_major_axis real,
    b_major_axis real,
    v_major_axis real,
    uvw2_minor_axis real,
    uvm2_minor_axis real,
    uvw1_minor_axis real,
    u_minor_axis real,
    b_minor_axis real,
    v_minor_axis real,
    uvw2_posang real,
    uvm2_posang real,
    uvw1_posang real,
    u_posang real,
    b_posang real,
    v_posang real,
    uvw2_quality_flag smallint,
    uvm2_quality_flag smallint,
    uvw1_quality_flag smallint,
    u_quality_flag smallint,
    b_quality_flag smallint,
    v_quality_flag smallint,
    uvw2_quality_flag_st character varying(12),
    uvm2_quality_flag_st character varying(12),
    uvw1_quality_flag_st character varying(12),
    u_quality_flag_st character varying(12),
    b_quality_flag_st character varying(12),
    v_quality_flag_st character varying(12),
    uvw2_extended_flag bigint,
    uvm2_extended_flag bigint,
    uvw1_extended_flag bigint,
    u_extended_flag bigint,
    b_extended_flag bigint,
    v_extended_flag bigint,
    uvw2_sky_image character varying(4),
    uvm2_sky_image character varying(4),
    uvw1_sky_image character varying(4),
    u_sky_image character varying(4),
    b_sky_image character varying(4),
    v_sky_image character varying(4),
    pk bigint NOT NULL
);


--
-- Name: dr18_yso_clustering; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_yso_clustering (
    source_id bigint NOT NULL,
    twomass text,
    ra double precision,
    "dec" double precision,
    parallax real,
    id integer,
    g double precision,
    bp double precision,
    rp double precision,
    j real,
    h real,
    k real,
    age double precision,
    eage double precision,
    av double precision,
    eav double precision,
    dist double precision,
    edist double precision
);


--
-- Name: dr18_zari18pms; Type: TABLE; Schema: minidb; Owner: -
--

CREATE TABLE minidb.dr18_zari18pms (
    source bigint NOT NULL,
    glon double precision,
    glat double precision,
    plx real,
    e_plx real,
    pmglon real,
    e_pmglon real,
    pmglat real,
    e_pmglat real,
    pmlbcorr real,
    rv real,
    e_rv real,
    gmag real,
    bpmag real,
    rpmag real,
    bp_over_rp real,
    chi2al real,
    ngal integer,
    ag real,
    bp_rp real,
    uwe real
);


--
-- Name: dr18_allwise dr18_allwise_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_allwise
    ADD CONSTRAINT dr18_allwise_pkey PRIMARY KEY (cntr);


--
-- Name: dr18_best_brightest dr18_best_brightest_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_best_brightest
    ADD CONSTRAINT dr18_best_brightest_pkey PRIMARY KEY (cntr);


--
-- Name: dr18_bhm_csc_v2 dr18_bhm_csc_v2_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_bhm_csc_v2
    ADD CONSTRAINT dr18_bhm_csc_v2_pkey PRIMARY KEY (pk);


--
-- Name: dr18_bhm_efeds_veto dr18_bhm_efeds_veto_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_bhm_efeds_veto
    ADD CONSTRAINT dr18_bhm_efeds_veto_pkey PRIMARY KEY (pk);


--
-- Name: dr18_bhm_rm_v0_2 dr18_bhm_rm_v0_2_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_bhm_rm_v0_2
    ADD CONSTRAINT dr18_bhm_rm_v0_2_pkey PRIMARY KEY (pk);


--
-- Name: dr18_cadence_epoch dr18_cadence_epoch_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_cadence_epoch
    ADD CONSTRAINT dr18_cadence_epoch_pkey PRIMARY KEY (label, epoch);


--
-- Name: dr18_cadence dr18_cadence_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_cadence
    ADD CONSTRAINT dr18_cadence_pkey PRIMARY KEY (pk);


--
-- Name: dr18_carton dr18_carton_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_carton
    ADD CONSTRAINT dr18_carton_pkey PRIMARY KEY (carton_pk);


--
-- Name: dr18_carton_to_target dr18_carton_to_target_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_carton_to_target
    ADD CONSTRAINT dr18_carton_to_target_pkey PRIMARY KEY (carton_to_target_pk);


--
-- Name: dr18_cataclysmic_variables dr18_cataclysmic_variables_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_cataclysmic_variables
    ADD CONSTRAINT dr18_cataclysmic_variables_pkey PRIMARY KEY (ref_id);


--
-- Name: dr18_catalog dr18_catalog_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog
    ADD CONSTRAINT dr18_catalog_pkey PRIMARY KEY (catalogid);


--
-- Name: dr18_category dr18_category_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_category
    ADD CONSTRAINT dr18_category_pkey PRIMARY KEY (pk);


--
-- Name: dr18_catwise2020 dr18_catwise2020_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catwise2020
    ADD CONSTRAINT dr18_catwise2020_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_ebosstarget_v5 dr18_ebosstarget_v5_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_ebosstarget_v5
    ADD CONSTRAINT dr18_ebosstarget_v5_pkey PRIMARY KEY (pk);


--
-- Name: dr18_gaia_dr2_ruwe dr18_gaia_dr2_ruwe_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaia_dr2_ruwe
    ADD CONSTRAINT dr18_gaia_dr2_ruwe_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_gaia_dr2_source dr18_gaia_dr2_source_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaia_dr2_source
    ADD CONSTRAINT dr18_gaia_dr2_source_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_gaia_dr2_wd dr18_gaia_dr2_wd_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaia_dr2_wd
    ADD CONSTRAINT dr18_gaia_dr2_wd_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_gaia_unwise_agn dr18_gaia_unwise_agn_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaia_unwise_agn
    ADD CONSTRAINT dr18_gaia_unwise_agn_pkey PRIMARY KEY (gaia_sourceid);


--
-- Name: dr18_gaiadr2_tmass_best_neighbour dr18_gaiadr2_tmass_best_neighbour_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr18_gaiadr2_tmass_best_neighbour_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_geometric_distances_gaia_dr2 dr18_geometric_distances_gaia_dr2_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr18_geometric_distances_gaia_dr2_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_glimpse dr18_glimpse_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_glimpse
    ADD CONSTRAINT dr18_glimpse_pkey PRIMARY KEY (pk);


--
-- Name: dr18_guvcat dr18_guvcat_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_guvcat
    ADD CONSTRAINT dr18_guvcat_pkey PRIMARY KEY (objid);


--
-- Name: dr18_instrument dr18_instrument_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_instrument
    ADD CONSTRAINT dr18_instrument_pkey PRIMARY KEY (pk);


--
-- Name: dr18_legacy_survey_dr8 dr18_legacy_survey_dr8_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_legacy_survey_dr8
    ADD CONSTRAINT dr18_legacy_survey_dr8_pkey PRIMARY KEY (ls_id);


--
-- Name: dr18_magnitude dr18_magnitude_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_magnitude
    ADD CONSTRAINT dr18_magnitude_pkey PRIMARY KEY (magnitude_pk);


--
-- Name: dr18_mapper dr18_mapper_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_mapper
    ADD CONSTRAINT dr18_mapper_pkey PRIMARY KEY (pk);


--
-- Name: dr18_panstarrs1 dr18_panstarrs1_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_panstarrs1
    ADD CONSTRAINT dr18_panstarrs1_pkey PRIMARY KEY (catid_objid);


--
-- Name: dr18_sagitta dr18_sagitta_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sagitta
    ADD CONSTRAINT dr18_sagitta_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_sdss_apogeeallstarmerge_r13 dr18_sdss_apogeeallstarmerge_r13_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT dr18_sdss_apogeeallstarmerge_r13_pkey PRIMARY KEY (apogee_id);


--
-- Name: dr18_sdss_dr13_photoobj_primary dr18_sdss_dr13_photoobj_primary_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr18_sdss_dr13_photoobj_primary_pkey PRIMARY KEY (objid);


--
-- Name: dr18_sdss_dr16_qso dr18_sdss_dr16_qso_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sdss_dr16_qso
    ADD CONSTRAINT dr18_sdss_dr16_qso_pkey PRIMARY KEY (pk);


--
-- Name: dr18_sdss_dr16_specobj dr18_sdss_dr16_specobj_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sdss_dr16_specobj
    ADD CONSTRAINT dr18_sdss_dr16_specobj_pkey PRIMARY KEY (specobjid);


--
-- Name: dr18_skies_v2 dr18_skies_v2_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_skies_v2
    ADD CONSTRAINT dr18_skies_v2_pkey PRIMARY KEY (pix_32768);


--
-- Name: dr18_skymapper_dr2 dr18_skymapper_dr2_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_skymapper_dr2
    ADD CONSTRAINT dr18_skymapper_dr2_pkey PRIMARY KEY (object_id);


--
-- Name: dr18_supercosmos dr18_supercosmos_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_supercosmos
    ADD CONSTRAINT dr18_supercosmos_pkey PRIMARY KEY (objid);


--
-- Name: dr18_target dr18_target_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_target
    ADD CONSTRAINT dr18_target_pkey PRIMARY KEY (target_pk);


--
-- Name: dr18_tic_v8 dr18_tic_v8_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_tic_v8
    ADD CONSTRAINT dr18_tic_v8_pkey PRIMARY KEY (id);


--
-- Name: dr18_twomass_psc dr18_twomass_psc_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_twomass_psc
    ADD CONSTRAINT dr18_twomass_psc_pkey PRIMARY KEY (pts_key);


--
-- Name: dr18_tycho2 dr18_tycho2_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_tycho2
    ADD CONSTRAINT dr18_tycho2_pkey PRIMARY KEY (designation);


--
-- Name: dr18_uvotssc1 dr18_uvotssc1_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_uvotssc1
    ADD CONSTRAINT dr18_uvotssc1_pkey PRIMARY KEY (id);


--
-- Name: dr18_xmm_om_suss_4_1 dr18_xmm_om_suss_4_1_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_xmm_om_suss_4_1
    ADD CONSTRAINT dr18_xmm_om_suss_4_1_pkey PRIMARY KEY (pk);


--
-- Name: dr18_yso_clustering dr18_yso_clustering_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_yso_clustering
    ADD CONSTRAINT dr18_yso_clustering_pkey PRIMARY KEY (source_id);


--
-- Name: dr18_zari18pms dr18_zari18pms_pkey; Type: CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_zari18pms
    ADD CONSTRAINT dr18_zari18pms_pkey PRIMARY KEY (source);


--
-- Name: dr18_allwise_designation_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_designation_idx ON minidb.dr18_allwise USING btree (designation);


--
-- Name: dr18_allwise_expr_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_expr_idx ON minidb.dr18_allwise USING btree (((w1mpro - w2mpro)));


--
-- Name: dr18_allwise_ph_qual_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_ph_qual_idx ON minidb.dr18_allwise USING btree (ph_qual);


--
-- Name: dr18_allwise_w1mpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_w1mpro_idx ON minidb.dr18_allwise USING btree (w1mpro);


--
-- Name: dr18_allwise_w1sigmpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_w1sigmpro_idx ON minidb.dr18_allwise USING btree (w1sigmpro);


--
-- Name: dr18_allwise_w2mpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_w2mpro_idx ON minidb.dr18_allwise USING btree (w2mpro);


--
-- Name: dr18_allwise_w2sigmpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_w2sigmpro_idx ON minidb.dr18_allwise USING btree (w2sigmpro);


--
-- Name: dr18_allwise_w3mpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_w3mpro_idx ON minidb.dr18_allwise USING btree (w3mpro);


--
-- Name: dr18_allwise_w3sigmpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_allwise_w3sigmpro_idx ON minidb.dr18_allwise USING btree (w3sigmpro);


--
-- Name: dr18_best_brightest_gmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_best_brightest_gmag_idx ON minidb.dr18_best_brightest USING btree (gmag);


--
-- Name: dr18_best_brightest_version_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_best_brightest_version_idx ON minidb.dr18_best_brightest USING btree (version);


--
-- Name: dr18_bhm_csc_v2_cxoid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_cxoid_idx ON minidb.dr18_bhm_csc_v2 USING btree (cxoid);


--
-- Name: dr18_bhm_csc_v2_designation2m_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_designation2m_idx ON minidb.dr18_bhm_csc_v2 USING btree (designation2m);


--
-- Name: dr18_bhm_csc_v2_hmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_hmag_idx ON minidb.dr18_bhm_csc_v2 USING btree (hmag);


--
-- Name: dr18_bhm_csc_v2_idg2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_idg2_idx ON minidb.dr18_bhm_csc_v2 USING btree (idg2);


--
-- Name: dr18_bhm_csc_v2_idps_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_idps_idx ON minidb.dr18_bhm_csc_v2 USING btree (idps);


--
-- Name: dr18_bhm_csc_v2_ocat_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_ocat_idx ON minidb.dr18_bhm_csc_v2 USING btree (ocat);


--
-- Name: dr18_bhm_csc_v2_oid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_oid_idx ON minidb.dr18_bhm_csc_v2 USING btree (oid);


--
-- Name: dr18_bhm_csc_v2_omag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_csc_v2_omag_idx ON minidb.dr18_bhm_csc_v2 USING btree (omag);


--
-- Name: dr18_bhm_efeds_veto_fiberid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_efeds_veto_fiberid_idx ON minidb.dr18_bhm_efeds_veto USING btree (fiberid);


--
-- Name: dr18_bhm_efeds_veto_mjd_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_efeds_veto_mjd_idx ON minidb.dr18_bhm_efeds_veto USING btree (mjd);


--
-- Name: dr18_bhm_efeds_veto_plate_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_efeds_veto_plate_idx ON minidb.dr18_bhm_efeds_veto USING btree (plate);


--
-- Name: dr18_bhm_efeds_veto_run2d_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_efeds_veto_run2d_idx ON minidb.dr18_bhm_efeds_veto USING btree (run2d);


--
-- Name: dr18_bhm_efeds_veto_tile_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_efeds_veto_tile_idx ON minidb.dr18_bhm_efeds_veto USING btree (tile);


--
-- Name: dr18_bhm_rm_v0_2_coadd_object_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_rm_v0_2_coadd_object_id_idx ON minidb.dr18_bhm_rm_v0_2 USING btree (coadd_object_id);


--
-- Name: dr18_bhm_rm_v0_2_id_nsc_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_rm_v0_2_id_nsc_idx ON minidb.dr18_bhm_rm_v0_2 USING btree (id_nsc);


--
-- Name: dr18_bhm_rm_v0_2_objid_ps1_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_rm_v0_2_objid_ps1_idx ON minidb.dr18_bhm_rm_v0_2 USING btree (objid_ps1);


--
-- Name: dr18_bhm_rm_v0_2_objid_sdss_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_rm_v0_2_objid_sdss_idx ON minidb.dr18_bhm_rm_v0_2 USING btree (objid_sdss);


--
-- Name: dr18_bhm_rm_v0_2_objid_unwise_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_rm_v0_2_objid_unwise_idx ON minidb.dr18_bhm_rm_v0_2 USING btree (objid_unwise);


--
-- Name: dr18_bhm_rm_v0_2_source_id_gaia_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_rm_v0_2_source_id_gaia_idx ON minidb.dr18_bhm_rm_v0_2 USING btree (source_id_gaia);


--
-- Name: dr18_bhm_rm_v0_2_sourceid_ir_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_bhm_rm_v0_2_sourceid_ir_idx ON minidb.dr18_bhm_rm_v0_2 USING btree (sourceid_ir);


--
-- Name: dr18_cadence_epoch_cadence_pk_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_cadence_epoch_cadence_pk_idx ON minidb.dr18_cadence_epoch USING btree (cadence_pk);


--
-- Name: dr18_cadence_epoch_label_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_cadence_epoch_label_idx ON minidb.dr18_cadence_epoch USING btree (label);


--
-- Name: dr18_cadence_label_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE UNIQUE INDEX dr18_cadence_label_idx ON minidb.dr18_cadence USING btree (label);


--
-- Name: dr18_carton_to_target_cadence_pk_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_carton_to_target_cadence_pk_idx ON minidb.dr18_carton_to_target USING btree (cadence_pk);


--
-- Name: dr18_carton_to_target_carton_pk_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_carton_to_target_carton_pk_idx ON minidb.dr18_carton_to_target USING btree (carton_pk);


--
-- Name: dr18_carton_to_target_instrument_pk_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_carton_to_target_instrument_pk_idx ON minidb.dr18_carton_to_target USING btree (instrument_pk);


--
-- Name: dr18_carton_to_target_target_pk_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_carton_to_target_target_pk_idx ON minidb.dr18_carton_to_target USING btree (target_pk);


--
-- Name: dr18_cataclysmic_variables_source_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_cataclysmic_variables_source_id_idx ON minidb.dr18_cataclysmic_variables USING btree (source_id);


--
-- Name: dr18_catalog_to_allwise_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_allwise_best_idx ON minidb.dr18_catalog_to_allwise USING btree (best);


--
-- Name: dr18_catalog_to_allwise_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_allwise_catalogid_idx ON minidb.dr18_catalog_to_allwise USING btree (catalogid);


--
-- Name: dr18_catalog_to_allwise_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_allwise_target_id_idx ON minidb.dr18_catalog_to_allwise USING btree (target_id);


--
-- Name: dr18_catalog_to_allwise_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_allwise_version_id_idx ON minidb.dr18_catalog_to_allwise USING btree (version_id);


--
-- Name: dr18_catalog_to_bhm_efeds_veto_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_efeds_veto_best_idx ON minidb.dr18_catalog_to_bhm_efeds_veto USING btree (best);


--
-- Name: dr18_catalog_to_bhm_efeds_veto_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_efeds_veto_catalogid_idx ON minidb.dr18_catalog_to_bhm_efeds_veto USING btree (catalogid);


--
-- Name: dr18_catalog_to_bhm_efeds_veto_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_efeds_veto_target_id_idx ON minidb.dr18_catalog_to_bhm_efeds_veto USING btree (target_id);


--
-- Name: dr18_catalog_to_bhm_efeds_veto_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_efeds_veto_version_id_idx ON minidb.dr18_catalog_to_bhm_efeds_veto USING btree (version_id);


--
-- Name: dr18_catalog_to_bhm_rm_v0_2_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_rm_v0_2_best_idx ON minidb.dr18_catalog_to_bhm_rm_v0_2 USING btree (best);


--
-- Name: dr18_catalog_to_bhm_rm_v0_2_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_rm_v0_2_catalogid_idx ON minidb.dr18_catalog_to_bhm_rm_v0_2 USING btree (catalogid);


--
-- Name: dr18_catalog_to_bhm_rm_v0_2_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_rm_v0_2_target_id_idx ON minidb.dr18_catalog_to_bhm_rm_v0_2 USING btree (target_id);


--
-- Name: dr18_catalog_to_bhm_rm_v0_2_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_bhm_rm_v0_2_version_id_idx ON minidb.dr18_catalog_to_bhm_rm_v0_2 USING btree (version_id);


--
-- Name: dr18_catalog_to_catwise2020_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_catwise2020_best_idx ON minidb.dr18_catalog_to_catwise2020 USING btree (best);


--
-- Name: dr18_catalog_to_catwise2020_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_catwise2020_catalogid_idx ON minidb.dr18_catalog_to_catwise2020 USING btree (catalogid);


--
-- Name: dr18_catalog_to_catwise2020_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_catwise2020_target_id_idx ON minidb.dr18_catalog_to_catwise2020 USING btree (target_id);


--
-- Name: dr18_catalog_to_catwise2020_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_catwise2020_version_id_idx ON minidb.dr18_catalog_to_catwise2020 USING btree (version_id);


--
-- Name: dr18_catalog_to_glimpse_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_glimpse_best_idx ON minidb.dr18_catalog_to_glimpse USING btree (best);


--
-- Name: dr18_catalog_to_glimpse_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_glimpse_catalogid_idx ON minidb.dr18_catalog_to_glimpse USING btree (catalogid);


--
-- Name: dr18_catalog_to_glimpse_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_glimpse_target_id_idx ON minidb.dr18_catalog_to_glimpse USING btree (target_id);


--
-- Name: dr18_catalog_to_glimpse_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_glimpse_version_id_idx ON minidb.dr18_catalog_to_glimpse USING btree (version_id);


--
-- Name: dr18_catalog_to_guvcat_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_guvcat_best_idx ON minidb.dr18_catalog_to_guvcat USING btree (best);


--
-- Name: dr18_catalog_to_guvcat_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_guvcat_catalogid_idx ON minidb.dr18_catalog_to_guvcat USING btree (catalogid);


--
-- Name: dr18_catalog_to_guvcat_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_guvcat_target_id_idx ON minidb.dr18_catalog_to_guvcat USING btree (target_id);


--
-- Name: dr18_catalog_to_guvcat_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_guvcat_version_id_idx ON minidb.dr18_catalog_to_guvcat USING btree (version_id);


--
-- Name: dr18_catalog_to_legacy_survey_dr8_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_legacy_survey_dr8_best_idx ON minidb.dr18_catalog_to_legacy_survey_dr8 USING btree (best);


--
-- Name: dr18_catalog_to_legacy_survey_dr8_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_legacy_survey_dr8_catalogid_idx ON minidb.dr18_catalog_to_legacy_survey_dr8 USING btree (catalogid);


--
-- Name: dr18_catalog_to_legacy_survey_dr8_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_legacy_survey_dr8_target_id_idx ON minidb.dr18_catalog_to_legacy_survey_dr8 USING btree (target_id);


--
-- Name: dr18_catalog_to_legacy_survey_dr8_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_legacy_survey_dr8_version_id_idx ON minidb.dr18_catalog_to_legacy_survey_dr8 USING btree (version_id);


--
-- Name: dr18_catalog_to_panstarrs1_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_panstarrs1_best_idx ON minidb.dr18_catalog_to_panstarrs1 USING btree (best);


--
-- Name: dr18_catalog_to_panstarrs1_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_panstarrs1_catalogid_idx ON minidb.dr18_catalog_to_panstarrs1 USING btree (catalogid);


--
-- Name: dr18_catalog_to_panstarrs1_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_panstarrs1_target_id_idx ON minidb.dr18_catalog_to_panstarrs1 USING btree (target_id);


--
-- Name: dr18_catalog_to_panstarrs1_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_panstarrs1_version_id_idx ON minidb.dr18_catalog_to_panstarrs1 USING btree (version_id);


--
-- Name: dr18_catalog_to_sdss_dr13_photoobj_primary_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_best_idx ON minidb.dr18_catalog_to_sdss_dr13_photoobj_primary USING btree (best);


--
-- Name: dr18_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_catalogid_idx ON minidb.dr18_catalog_to_sdss_dr13_photoobj_primary USING btree (catalogid);


--
-- Name: dr18_catalog_to_sdss_dr13_photoobj_primary_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_target_id_idx ON minidb.dr18_catalog_to_sdss_dr13_photoobj_primary USING btree (target_id);


--
-- Name: dr18_catalog_to_sdss_dr13_photoobj_primary_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr13_photoobj_primary_version_id_idx ON minidb.dr18_catalog_to_sdss_dr13_photoobj_primary USING btree (version_id);


--
-- Name: dr18_catalog_to_sdss_dr16_specobj_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr16_specobj_best_idx ON minidb.dr18_catalog_to_sdss_dr16_specobj USING btree (best);


--
-- Name: dr18_catalog_to_sdss_dr16_specobj_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr16_specobj_catalogid_idx ON minidb.dr18_catalog_to_sdss_dr16_specobj USING btree (catalogid);


--
-- Name: dr18_catalog_to_sdss_dr16_specobj_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr16_specobj_target_id_idx ON minidb.dr18_catalog_to_sdss_dr16_specobj USING btree (target_id);


--
-- Name: dr18_catalog_to_sdss_dr16_specobj_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_sdss_dr16_specobj_version_id_idx ON minidb.dr18_catalog_to_sdss_dr16_specobj USING btree (version_id);


--
-- Name: dr18_catalog_to_skies_v2_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skies_v2_best_idx ON minidb.dr18_catalog_to_skies_v2 USING btree (best);


--
-- Name: dr18_catalog_to_skies_v2_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skies_v2_catalogid_idx ON minidb.dr18_catalog_to_skies_v2 USING btree (catalogid);


--
-- Name: dr18_catalog_to_skies_v2_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skies_v2_target_id_idx ON minidb.dr18_catalog_to_skies_v2 USING btree (target_id);


--
-- Name: dr18_catalog_to_skies_v2_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skies_v2_version_id_idx ON minidb.dr18_catalog_to_skies_v2 USING btree (version_id);


--
-- Name: dr18_catalog_to_skymapper_dr2_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skymapper_dr2_best_idx ON minidb.dr18_catalog_to_skymapper_dr2 USING btree (best);


--
-- Name: dr18_catalog_to_skymapper_dr2_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skymapper_dr2_catalogid_idx ON minidb.dr18_catalog_to_skymapper_dr2 USING btree (catalogid);


--
-- Name: dr18_catalog_to_skymapper_dr2_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skymapper_dr2_target_id_idx ON minidb.dr18_catalog_to_skymapper_dr2 USING btree (target_id);


--
-- Name: dr18_catalog_to_skymapper_dr2_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_skymapper_dr2_version_id_idx ON minidb.dr18_catalog_to_skymapper_dr2 USING btree (version_id);


--
-- Name: dr18_catalog_to_supercosmos_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_supercosmos_best_idx ON minidb.dr18_catalog_to_supercosmos USING btree (best);


--
-- Name: dr18_catalog_to_supercosmos_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_supercosmos_catalogid_idx ON minidb.dr18_catalog_to_supercosmos USING btree (catalogid);


--
-- Name: dr18_catalog_to_supercosmos_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_supercosmos_target_id_idx ON minidb.dr18_catalog_to_supercosmos USING btree (target_id);


--
-- Name: dr18_catalog_to_supercosmos_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_supercosmos_version_id_idx ON minidb.dr18_catalog_to_supercosmos USING btree (version_id);


--
-- Name: dr18_catalog_to_tic_v8_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tic_v8_best_idx ON minidb.dr18_catalog_to_tic_v8 USING btree (best);


--
-- Name: dr18_catalog_to_tic_v8_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tic_v8_catalogid_idx ON minidb.dr18_catalog_to_tic_v8 USING btree (catalogid);


--
-- Name: dr18_catalog_to_tic_v8_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tic_v8_target_id_idx ON minidb.dr18_catalog_to_tic_v8 USING btree (target_id);


--
-- Name: dr18_catalog_to_tic_v8_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tic_v8_version_id_idx ON minidb.dr18_catalog_to_tic_v8 USING btree (version_id);


--
-- Name: dr18_catalog_to_tycho2_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tycho2_best_idx ON minidb.dr18_catalog_to_tycho2 USING btree (best);


--
-- Name: dr18_catalog_to_tycho2_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tycho2_catalogid_idx ON minidb.dr18_catalog_to_tycho2 USING btree (catalogid);


--
-- Name: dr18_catalog_to_tycho2_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tycho2_target_id_idx ON minidb.dr18_catalog_to_tycho2 USING btree (target_id);


--
-- Name: dr18_catalog_to_tycho2_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_tycho2_version_id_idx ON minidb.dr18_catalog_to_tycho2 USING btree (version_id);


--
-- Name: dr18_catalog_to_uvotssc1_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_uvotssc1_best_idx ON minidb.dr18_catalog_to_uvotssc1 USING btree (best);


--
-- Name: dr18_catalog_to_uvotssc1_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_uvotssc1_catalogid_idx ON minidb.dr18_catalog_to_uvotssc1 USING btree (catalogid);


--
-- Name: dr18_catalog_to_uvotssc1_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_uvotssc1_target_id_idx ON minidb.dr18_catalog_to_uvotssc1 USING btree (target_id);


--
-- Name: dr18_catalog_to_uvotssc1_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_uvotssc1_version_id_idx ON minidb.dr18_catalog_to_uvotssc1 USING btree (version_id);


--
-- Name: dr18_catalog_to_xmm_om_suss_4_1_best_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_xmm_om_suss_4_1_best_idx ON minidb.dr18_catalog_to_xmm_om_suss_4_1 USING btree (best);


--
-- Name: dr18_catalog_to_xmm_om_suss_4_1_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_xmm_om_suss_4_1_catalogid_idx ON minidb.dr18_catalog_to_xmm_om_suss_4_1 USING btree (catalogid);


--
-- Name: dr18_catalog_to_xmm_om_suss_4_1_target_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_xmm_om_suss_4_1_target_id_idx ON minidb.dr18_catalog_to_xmm_om_suss_4_1 USING btree (target_id);


--
-- Name: dr18_catalog_to_xmm_om_suss_4_1_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_to_xmm_om_suss_4_1_version_id_idx ON minidb.dr18_catalog_to_xmm_om_suss_4_1 USING btree (version_id);


--
-- Name: dr18_catalog_version_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catalog_version_id_idx ON minidb.dr18_catalog USING btree (version_id);


--
-- Name: dr18_catwise2020_source_name_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catwise2020_source_name_idx ON minidb.dr18_catwise2020 USING btree (source_name);


--
-- Name: dr18_catwise2020_w1mpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catwise2020_w1mpro_idx ON minidb.dr18_catwise2020 USING btree (w1mpro);


--
-- Name: dr18_catwise2020_w1sigmpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catwise2020_w1sigmpro_idx ON minidb.dr18_catwise2020 USING btree (w1sigmpro);


--
-- Name: dr18_catwise2020_w2mpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catwise2020_w2mpro_idx ON minidb.dr18_catwise2020 USING btree (w2mpro);


--
-- Name: dr18_catwise2020_w2sigmpro_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_catwise2020_w2sigmpro_idx ON minidb.dr18_catwise2020 USING btree (w2sigmpro);


--
-- Name: dr18_ebosstarget_v5_eboss_target1_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_ebosstarget_v5_eboss_target1_idx ON minidb.dr18_ebosstarget_v5 USING btree (eboss_target1);


--
-- Name: dr18_ebosstarget_v5_objc_type_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_ebosstarget_v5_objc_type_idx ON minidb.dr18_ebosstarget_v5 USING btree (objc_type);


--
-- Name: dr18_ebosstarget_v5_objid_targeting_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_ebosstarget_v5_objid_targeting_idx ON minidb.dr18_ebosstarget_v5 USING btree (objid_targeting);


--
-- Name: dr18_ebosstarget_v5_resolve_status_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_ebosstarget_v5_resolve_status_idx ON minidb.dr18_ebosstarget_v5 USING btree (resolve_status);


--
-- Name: dr18_gaia_dr2_ruwe_ruwe_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_ruwe_ruwe_idx ON minidb.dr18_gaia_dr2_ruwe USING btree (ruwe);


--
-- Name: dr18_gaia_dr2_source_astrometric_chi2_al_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_astrometric_chi2_al_idx ON minidb.dr18_gaia_dr2_source USING btree (astrometric_chi2_al);


--
-- Name: dr18_gaia_dr2_source_astrometric_excess_noise_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_astrometric_excess_noise_idx ON minidb.dr18_gaia_dr2_source USING btree (astrometric_excess_noise);


--
-- Name: dr18_gaia_dr2_source_bp_rp_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_bp_rp_idx ON minidb.dr18_gaia_dr2_source USING btree (bp_rp);


--
-- Name: dr18_gaia_dr2_source_expr_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_expr_idx ON minidb.dr18_gaia_dr2_source USING btree (((parallax - parallax_error)));


--
-- Name: dr18_gaia_dr2_source_parallax_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_parallax_idx ON minidb.dr18_gaia_dr2_source USING btree (parallax);


--
-- Name: dr18_gaia_dr2_source_phot_bp_mean_flux_over_error_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_phot_bp_mean_flux_over_error_idx ON minidb.dr18_gaia_dr2_source USING btree (phot_bp_mean_flux_over_error);


--
-- Name: dr18_gaia_dr2_source_phot_bp_mean_mag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_phot_bp_mean_mag_idx ON minidb.dr18_gaia_dr2_source USING btree (phot_bp_mean_mag);


--
-- Name: dr18_gaia_dr2_source_phot_rp_mean_mag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_source_phot_rp_mean_mag_idx ON minidb.dr18_gaia_dr2_source USING btree (phot_rp_mean_mag);


--
-- Name: dr18_gaia_dr2_wd_gmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_wd_gmag_idx ON minidb.dr18_gaia_dr2_wd USING btree (gmag);


--
-- Name: dr18_gaia_dr2_wd_pwd_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_dr2_wd_pwd_idx ON minidb.dr18_gaia_dr2_wd USING btree (pwd);


--
-- Name: dr18_gaia_unwise_agn_g_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_unwise_agn_g_idx ON minidb.dr18_gaia_unwise_agn USING btree (g);


--
-- Name: dr18_gaia_unwise_agn_prob_rf_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_unwise_agn_prob_rf_idx ON minidb.dr18_gaia_unwise_agn USING btree (prob_rf);


--
-- Name: dr18_gaia_unwise_agn_unwise_objid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaia_unwise_agn_unwise_objid_idx ON minidb.dr18_gaia_unwise_agn USING btree (unwise_objid);


--
-- Name: dr18_gaiadr2_tmass_best_neighbour_angular_distance_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaiadr2_tmass_best_neighbour_angular_distance_idx ON minidb.dr18_gaiadr2_tmass_best_neighbour USING btree (angular_distance);


--
-- Name: dr18_gaiadr2_tmass_best_neighbour_source_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaiadr2_tmass_best_neighbour_source_id_idx ON minidb.dr18_gaiadr2_tmass_best_neighbour USING btree (source_id);


--
-- Name: dr18_gaiadr2_tmass_best_neighbour_tmass_pts_key_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_gaiadr2_tmass_best_neighbour_tmass_pts_key_idx ON minidb.dr18_gaiadr2_tmass_best_neighbour USING btree (tmass_pts_key);


--
-- Name: dr18_geometric_distances_gaia_dr2_r_est_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_geometric_distances_gaia_dr2_r_est_idx ON minidb.dr18_geometric_distances_gaia_dr2 USING btree (r_est);


--
-- Name: dr18_geometric_distances_gaia_dr2_r_hi_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_geometric_distances_gaia_dr2_r_hi_idx ON minidb.dr18_geometric_distances_gaia_dr2 USING btree (r_hi);


--
-- Name: dr18_geometric_distances_gaia_dr2_r_len_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_geometric_distances_gaia_dr2_r_len_idx ON minidb.dr18_geometric_distances_gaia_dr2 USING btree (r_len);


--
-- Name: dr18_geometric_distances_gaia_dr2_r_lo_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_geometric_distances_gaia_dr2_r_lo_idx ON minidb.dr18_geometric_distances_gaia_dr2 USING btree (r_lo);


--
-- Name: dr18_glimpse_designation_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_glimpse_designation_idx ON minidb.dr18_glimpse USING btree (designation);


--
-- Name: dr18_glimpse_tmass_cntr_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_glimpse_tmass_cntr_idx ON minidb.dr18_glimpse USING btree (tmass_cntr);


--
-- Name: dr18_glimpse_tmass_designation_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_glimpse_tmass_designation_idx ON minidb.dr18_glimpse USING btree (tmass_designation);


--
-- Name: dr18_guvcat_expr_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_guvcat_expr_idx ON minidb.dr18_guvcat USING btree (((fuv_mag - nuv_mag)));


--
-- Name: dr18_guvcat_fuv_mag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_guvcat_fuv_mag_idx ON minidb.dr18_guvcat USING btree (fuv_mag);


--
-- Name: dr18_guvcat_nuv_mag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_guvcat_nuv_mag_idx ON minidb.dr18_guvcat USING btree (nuv_mag);


--
-- Name: dr18_legacy_survey_dr8_fibertotflux_g_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_fibertotflux_g_idx ON minidb.dr18_legacy_survey_dr8 USING btree (fibertotflux_g);


--
-- Name: dr18_legacy_survey_dr8_fibertotflux_r_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_fibertotflux_r_idx ON minidb.dr18_legacy_survey_dr8 USING btree (fibertotflux_r);


--
-- Name: dr18_legacy_survey_dr8_fibertotflux_z_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_fibertotflux_z_idx ON minidb.dr18_legacy_survey_dr8 USING btree (fibertotflux_z);


--
-- Name: dr18_legacy_survey_dr8_flux_g_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_flux_g_idx ON minidb.dr18_legacy_survey_dr8 USING btree (flux_g);


--
-- Name: dr18_legacy_survey_dr8_flux_r_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_flux_r_idx ON minidb.dr18_legacy_survey_dr8 USING btree (flux_r);


--
-- Name: dr18_legacy_survey_dr8_flux_w1_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_flux_w1_idx ON minidb.dr18_legacy_survey_dr8 USING btree (flux_w1);


--
-- Name: dr18_legacy_survey_dr8_flux_z_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_flux_z_idx ON minidb.dr18_legacy_survey_dr8 USING btree (flux_z);


--
-- Name: dr18_legacy_survey_dr8_gaia_phot_g_mean_mag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_gaia_phot_g_mean_mag_idx ON minidb.dr18_legacy_survey_dr8 USING btree (gaia_phot_g_mean_mag);


--
-- Name: dr18_legacy_survey_dr8_gaia_phot_g_mean_mag_idx1; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_gaia_phot_g_mean_mag_idx1 ON minidb.dr18_legacy_survey_dr8 USING btree (gaia_phot_g_mean_mag);


--
-- Name: dr18_legacy_survey_dr8_gaia_phot_rp_mean_mag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_gaia_phot_rp_mean_mag_idx ON minidb.dr18_legacy_survey_dr8 USING btree (gaia_phot_rp_mean_mag);


--
-- Name: dr18_legacy_survey_dr8_gaia_sourceid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_gaia_sourceid_idx ON minidb.dr18_legacy_survey_dr8 USING btree (gaia_sourceid);


--
-- Name: dr18_legacy_survey_dr8_maskbits_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_maskbits_idx ON minidb.dr18_legacy_survey_dr8 USING btree (maskbits);


--
-- Name: dr18_legacy_survey_dr8_nobs_g_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_nobs_g_idx ON minidb.dr18_legacy_survey_dr8 USING btree (nobs_g);


--
-- Name: dr18_legacy_survey_dr8_nobs_r_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_nobs_r_idx ON minidb.dr18_legacy_survey_dr8 USING btree (nobs_r);


--
-- Name: dr18_legacy_survey_dr8_nobs_z_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_nobs_z_idx ON minidb.dr18_legacy_survey_dr8 USING btree (nobs_z);


--
-- Name: dr18_legacy_survey_dr8_parallax_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_parallax_idx ON minidb.dr18_legacy_survey_dr8 USING btree (parallax);


--
-- Name: dr18_legacy_survey_dr8_ref_cat_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_ref_cat_idx ON minidb.dr18_legacy_survey_dr8 USING btree (ref_cat);


--
-- Name: dr18_legacy_survey_dr8_ref_epoch_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_ref_epoch_idx ON minidb.dr18_legacy_survey_dr8 USING btree (ref_epoch);


--
-- Name: dr18_legacy_survey_dr8_ref_id_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_legacy_survey_dr8_ref_id_idx ON minidb.dr18_legacy_survey_dr8 USING btree (ref_id);


--
-- Name: dr18_magnitude_carton_to_target_pk_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_magnitude_carton_to_target_pk_idx ON minidb.dr18_magnitude USING btree (carton_to_target_pk);


--
-- Name: dr18_magnitude_h_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_magnitude_h_idx ON minidb.dr18_magnitude USING btree (h);


--
-- Name: dr18_panstarrs1_extid_hi_lo_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_extid_hi_lo_idx ON minidb.dr18_panstarrs1 USING btree (extid_hi_lo);


--
-- Name: dr18_panstarrs1_flags_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_flags_idx ON minidb.dr18_panstarrs1 USING btree (flags);


--
-- Name: dr18_panstarrs1_g_flags_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_g_flags_idx ON minidb.dr18_panstarrs1 USING btree (g_flags);


--
-- Name: dr18_panstarrs1_g_stk_psf_flux_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_g_stk_psf_flux_idx ON minidb.dr18_panstarrs1 USING btree (g_stk_psf_flux);


--
-- Name: dr18_panstarrs1_i_flags_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_i_flags_idx ON minidb.dr18_panstarrs1 USING btree (i_flags);


--
-- Name: dr18_panstarrs1_i_stk_psf_flux_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_i_stk_psf_flux_idx ON minidb.dr18_panstarrs1 USING btree (i_stk_psf_flux);


--
-- Name: dr18_panstarrs1_r_flags_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_r_flags_idx ON minidb.dr18_panstarrs1 USING btree (r_flags);


--
-- Name: dr18_panstarrs1_r_stk_psf_flux_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_r_stk_psf_flux_idx ON minidb.dr18_panstarrs1 USING btree (r_stk_psf_flux);


--
-- Name: dr18_panstarrs1_stargal_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_stargal_idx ON minidb.dr18_panstarrs1 USING btree (stargal);


--
-- Name: dr18_panstarrs1_z_flags_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_z_flags_idx ON minidb.dr18_panstarrs1 USING btree (z_flags);


--
-- Name: dr18_panstarrs1_z_stk_psf_flux_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_panstarrs1_z_stk_psf_flux_idx ON minidb.dr18_panstarrs1 USING btree (z_stk_psf_flux);


--
-- Name: dr18_sagitta_av_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sagitta_av_idx ON minidb.dr18_sagitta USING btree (av);


--
-- Name: dr18_sagitta_yso_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sagitta_yso_idx ON minidb.dr18_sagitta USING btree (yso);


--
-- Name: dr18_sagitta_yso_std_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sagitta_yso_std_idx ON minidb.dr18_sagitta USING btree (yso_std);


--
-- Name: dr18_sdss_apogeeallstarmerge_r13_h_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_apogeeallstarmerge_r13_h_idx ON minidb.dr18_sdss_apogeeallstarmerge_r13 USING btree (h);


--
-- Name: dr18_sdss_apogeeallstarmerge_r13_j_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_apogeeallstarmerge_r13_j_idx ON minidb.dr18_sdss_apogeeallstarmerge_r13 USING btree (j);


--
-- Name: dr18_sdss_apogeeallstarmerge_r13_k_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_apogeeallstarmerge_r13_k_idx ON minidb.dr18_sdss_apogeeallstarmerge_r13 USING btree (k);


--
-- Name: dr18_sdss_dr13_photoobj_primary_objid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr13_photoobj_primary_objid_idx ON minidb.dr18_sdss_dr13_photoobj_primary USING btree (objid);


--
-- Name: dr18_sdss_dr16_qso_fiberid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_qso_fiberid_idx ON minidb.dr18_sdss_dr16_qso USING btree (fiberid);


--
-- Name: dr18_sdss_dr16_qso_mjd_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_qso_mjd_idx ON minidb.dr18_sdss_dr16_qso USING btree (mjd);


--
-- Name: dr18_sdss_dr16_qso_mjd_plate_fiberid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_qso_mjd_plate_fiberid_idx ON minidb.dr18_sdss_dr16_qso USING btree (mjd, plate, fiberid);


--
-- Name: dr18_sdss_dr16_qso_plate_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_qso_plate_idx ON minidb.dr18_sdss_dr16_qso USING btree (plate);


--
-- Name: dr18_sdss_dr16_specobj_bestobjid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_bestobjid_idx ON minidb.dr18_sdss_dr16_specobj USING btree (bestobjid);


--
-- Name: dr18_sdss_dr16_specobj_fiberid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_fiberid_idx ON minidb.dr18_sdss_dr16_specobj USING btree (fiberid);


--
-- Name: dr18_sdss_dr16_specobj_fluxobjid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_fluxobjid_idx ON minidb.dr18_sdss_dr16_specobj USING btree (fluxobjid);


--
-- Name: dr18_sdss_dr16_specobj_mjd_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_mjd_idx ON minidb.dr18_sdss_dr16_specobj USING btree (mjd);


--
-- Name: dr18_sdss_dr16_specobj_mjd_plate_fiberid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE UNIQUE INDEX dr18_sdss_dr16_specobj_mjd_plate_fiberid_idx ON minidb.dr18_sdss_dr16_specobj USING btree (mjd, plate, fiberid);


--
-- Name: dr18_sdss_dr16_specobj_mjd_plate_fiberid_idx1; Type: INDEX; Schema: minidb; Owner: -
--

CREATE UNIQUE INDEX dr18_sdss_dr16_specobj_mjd_plate_fiberid_idx1 ON minidb.dr18_sdss_dr16_specobj USING btree (mjd, plate, fiberid);


--
-- Name: dr18_sdss_dr16_specobj_plate_fiberid_mjd_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE UNIQUE INDEX dr18_sdss_dr16_specobj_plate_fiberid_mjd_idx ON minidb.dr18_sdss_dr16_specobj USING btree (plate, fiberid, mjd);


--
-- Name: dr18_sdss_dr16_specobj_plate_fiberid_mjd_idx1; Type: INDEX; Schema: minidb; Owner: -
--

CREATE UNIQUE INDEX dr18_sdss_dr16_specobj_plate_fiberid_mjd_idx1 ON minidb.dr18_sdss_dr16_specobj USING btree (plate, fiberid, mjd);


--
-- Name: dr18_sdss_dr16_specobj_plate_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_plate_idx ON minidb.dr18_sdss_dr16_specobj USING btree (plate);


--
-- Name: dr18_sdss_dr16_specobj_run2d_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_run2d_idx ON minidb.dr18_sdss_dr16_specobj USING btree (run2d);


--
-- Name: dr18_sdss_dr16_specobj_scienceprimary_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_scienceprimary_idx ON minidb.dr18_sdss_dr16_specobj USING btree (scienceprimary);


--
-- Name: dr18_sdss_dr16_specobj_snmedian_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_snmedian_idx ON minidb.dr18_sdss_dr16_specobj USING btree (snmedian);


--
-- Name: dr18_sdss_dr16_specobj_targetobjid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_targetobjid_idx ON minidb.dr18_sdss_dr16_specobj USING btree (targetobjid);


--
-- Name: dr18_sdss_dr16_specobj_z_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_z_idx ON minidb.dr18_sdss_dr16_specobj USING btree (z);


--
-- Name: dr18_sdss_dr16_specobj_zerr_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_zerr_idx ON minidb.dr18_sdss_dr16_specobj USING btree (zerr);


--
-- Name: dr18_sdss_dr16_specobj_zwarning_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_sdss_dr16_specobj_zwarning_idx ON minidb.dr18_sdss_dr16_specobj USING btree (zwarning);


--
-- Name: dr18_skies_v2_down_pix_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_down_pix_idx ON minidb.dr18_skies_v2 USING btree (down_pix);


--
-- Name: dr18_skies_v2_mag_neighbour_gaia_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_mag_neighbour_gaia_idx ON minidb.dr18_skies_v2 USING btree (mag_neighbour_gaia);


--
-- Name: dr18_skies_v2_mag_neighbour_ls8_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_mag_neighbour_ls8_idx ON minidb.dr18_skies_v2 USING btree (mag_neighbour_ls8);


--
-- Name: dr18_skies_v2_mag_neighbour_ps1dr2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_mag_neighbour_ps1dr2_idx ON minidb.dr18_skies_v2 USING btree (mag_neighbour_ps1dr2);


--
-- Name: dr18_skies_v2_mag_neighbour_tmass_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_mag_neighbour_tmass_idx ON minidb.dr18_skies_v2 USING btree (mag_neighbour_tmass);


--
-- Name: dr18_skies_v2_mag_neighbour_tycho2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_mag_neighbour_tycho2_idx ON minidb.dr18_skies_v2 USING btree (mag_neighbour_tycho2);


--
-- Name: dr18_skies_v2_sep_neighbour_gaia_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_sep_neighbour_gaia_idx ON minidb.dr18_skies_v2 USING btree (sep_neighbour_gaia);


--
-- Name: dr18_skies_v2_sep_neighbour_ls8_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_sep_neighbour_ls8_idx ON minidb.dr18_skies_v2 USING btree (sep_neighbour_ls8);


--
-- Name: dr18_skies_v2_sep_neighbour_ps1dr2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_sep_neighbour_ps1dr2_idx ON minidb.dr18_skies_v2 USING btree (sep_neighbour_ps1dr2);


--
-- Name: dr18_skies_v2_sep_neighbour_tmass_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_sep_neighbour_tmass_idx ON minidb.dr18_skies_v2 USING btree (sep_neighbour_tmass);


--
-- Name: dr18_skies_v2_sep_neighbour_tmass_xsc_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_sep_neighbour_tmass_xsc_idx ON minidb.dr18_skies_v2 USING btree (sep_neighbour_tmass_xsc);


--
-- Name: dr18_skies_v2_sep_neighbour_tycho2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_sep_neighbour_tycho2_idx ON minidb.dr18_skies_v2 USING btree (sep_neighbour_tycho2);


--
-- Name: dr18_skies_v2_tile_32_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skies_v2_tile_32_idx ON minidb.dr18_skies_v2 USING btree (tile_32);


--
-- Name: dr18_skymapper_dr2_allwise_cntr_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_allwise_cntr_idx ON minidb.dr18_skymapper_dr2 USING btree (allwise_cntr);


--
-- Name: dr18_skymapper_dr2_flags_psf_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_flags_psf_idx ON minidb.dr18_skymapper_dr2 USING btree (flags_psf);


--
-- Name: dr18_skymapper_dr2_g_psf_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_g_psf_idx ON minidb.dr18_skymapper_dr2 USING btree (g_psf);


--
-- Name: dr18_skymapper_dr2_gaia_dr2_id1_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_gaia_dr2_id1_idx ON minidb.dr18_skymapper_dr2 USING btree (gaia_dr2_id1);


--
-- Name: dr18_skymapper_dr2_gaia_dr2_id2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_gaia_dr2_id2_idx ON minidb.dr18_skymapper_dr2 USING btree (gaia_dr2_id2);


--
-- Name: dr18_skymapper_dr2_i_psf_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_i_psf_idx ON minidb.dr18_skymapper_dr2 USING btree (i_psf);


--
-- Name: dr18_skymapper_dr2_nimaflags_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_nimaflags_idx ON minidb.dr18_skymapper_dr2 USING btree (nimaflags);


--
-- Name: dr18_skymapper_dr2_r_psf_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_r_psf_idx ON minidb.dr18_skymapper_dr2 USING btree (r_psf);


--
-- Name: dr18_skymapper_dr2_smss_j_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_smss_j_idx ON minidb.dr18_skymapper_dr2 USING btree (smss_j);


--
-- Name: dr18_skymapper_dr2_z_psf_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_skymapper_dr2_z_psf_idx ON minidb.dr18_skymapper_dr2 USING btree (z_psf);


--
-- Name: dr18_supercosmos_classb_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classb_idx ON minidb.dr18_supercosmos USING btree (classb);


--
-- Name: dr18_supercosmos_classi_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classi_idx ON minidb.dr18_supercosmos USING btree (classi);


--
-- Name: dr18_supercosmos_classmagb_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classmagb_idx ON minidb.dr18_supercosmos USING btree (classmagb);


--
-- Name: dr18_supercosmos_classmagi_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classmagi_idx ON minidb.dr18_supercosmos USING btree (classmagi);


--
-- Name: dr18_supercosmos_classmagr1_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classmagr1_idx ON minidb.dr18_supercosmos USING btree (classmagr1);


--
-- Name: dr18_supercosmos_classmagr2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classmagr2_idx ON minidb.dr18_supercosmos USING btree (classmagr2);


--
-- Name: dr18_supercosmos_classr1_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classr1_idx ON minidb.dr18_supercosmos USING btree (classr1);


--
-- Name: dr18_supercosmos_classr2_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_supercosmos_classr2_idx ON minidb.dr18_supercosmos USING btree (classr2);


--
-- Name: dr18_target_catalogid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_target_catalogid_idx ON minidb.dr18_target USING btree (catalogid);


--
-- Name: dr18_target_q3c_ang2ipix_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_target_q3c_ang2ipix_idx ON minidb.dr18_target USING btree (public.q3c_ang2ipix(ra, "dec"));


--
-- Name: dr18_tic_v8_allwise_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_allwise_idx ON minidb.dr18_tic_v8 USING btree (allwise);


--
-- Name: dr18_tic_v8_gaia_int_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_gaia_int_idx ON minidb.dr18_tic_v8 USING btree (gaia_int);


--
-- Name: dr18_tic_v8_gaiamag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_gaiamag_idx ON minidb.dr18_tic_v8 USING btree (gaiamag);


--
-- Name: dr18_tic_v8_hmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_hmag_idx ON minidb.dr18_tic_v8 USING btree (hmag);


--
-- Name: dr18_tic_v8_kic_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_kic_idx ON minidb.dr18_tic_v8 USING btree (kic);


--
-- Name: dr18_tic_v8_logg_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_logg_idx ON minidb.dr18_tic_v8 USING btree (logg);


--
-- Name: dr18_tic_v8_objtype_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_objtype_idx ON minidb.dr18_tic_v8 USING btree (objtype);


--
-- Name: dr18_tic_v8_plx_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_plx_idx ON minidb.dr18_tic_v8 USING btree (plx);


--
-- Name: dr18_tic_v8_posflag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_posflag_idx ON minidb.dr18_tic_v8 USING btree (posflag);


--
-- Name: dr18_tic_v8_sdss_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_sdss_idx ON minidb.dr18_tic_v8 USING btree (sdss);


--
-- Name: dr18_tic_v8_teff_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_teff_idx ON minidb.dr18_tic_v8 USING btree (teff);


--
-- Name: dr18_tic_v8_tmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_tmag_idx ON minidb.dr18_tic_v8 USING btree (tmag);


--
-- Name: dr18_tic_v8_twomass_psc_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_twomass_psc_idx ON minidb.dr18_tic_v8 USING btree (twomass_psc);


--
-- Name: dr18_tic_v8_twomass_psc_pts_key_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_twomass_psc_pts_key_idx ON minidb.dr18_tic_v8 USING btree (twomass_psc_pts_key);


--
-- Name: dr18_tic_v8_tycho2_tycid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tic_v8_tycho2_tycid_idx ON minidb.dr18_tic_v8 USING btree (tycho2_tycid);


--
-- Name: dr18_twomass_psc_cc_flg_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_twomass_psc_cc_flg_idx ON minidb.dr18_twomass_psc USING btree (cc_flg);


--
-- Name: dr18_twomass_psc_designation_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE UNIQUE INDEX dr18_twomass_psc_designation_idx ON minidb.dr18_twomass_psc USING btree (designation);


--
-- Name: dr18_twomass_psc_designation_idx1; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_twomass_psc_designation_idx1 ON minidb.dr18_twomass_psc USING btree (designation);


--
-- Name: dr18_twomass_psc_gal_contam_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_twomass_psc_gal_contam_idx ON minidb.dr18_twomass_psc USING btree (gal_contam);


--
-- Name: dr18_twomass_psc_jdate_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_twomass_psc_jdate_idx ON minidb.dr18_twomass_psc USING btree (jdate);


--
-- Name: dr18_twomass_psc_ph_qual_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_twomass_psc_ph_qual_idx ON minidb.dr18_twomass_psc USING btree (ph_qual);


--
-- Name: dr18_twomass_psc_rd_flg_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_twomass_psc_rd_flg_idx ON minidb.dr18_twomass_psc USING btree (rd_flg);


--
-- Name: dr18_tycho2_btmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tycho2_btmag_idx ON minidb.dr18_tycho2 USING btree (btmag);


--
-- Name: dr18_tycho2_tycid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tycho2_tycid_idx ON minidb.dr18_tycho2 USING btree (tycid);


--
-- Name: dr18_tycho2_vtmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_tycho2_vtmag_idx ON minidb.dr18_tycho2 USING btree (vtmag);


--
-- Name: dr18_uvotssc1_name_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_uvotssc1_name_idx ON minidb.dr18_uvotssc1 USING btree (name);


--
-- Name: dr18_uvotssc1_obsid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_uvotssc1_obsid_idx ON minidb.dr18_uvotssc1 USING btree (obsid);


--
-- Name: dr18_uvotssc1_srcid_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_uvotssc1_srcid_idx ON minidb.dr18_uvotssc1 USING btree (srcid);


--
-- Name: dr18_xmm_om_suss_4_1_iauname_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_xmm_om_suss_4_1_iauname_idx ON minidb.dr18_xmm_om_suss_4_1 USING btree (iauname);


--
-- Name: dr18_yso_clustering_bp_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_yso_clustering_bp_idx ON minidb.dr18_yso_clustering USING btree (bp);


--
-- Name: dr18_yso_clustering_g_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_yso_clustering_g_idx ON minidb.dr18_yso_clustering USING btree (g);


--
-- Name: dr18_yso_clustering_h_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_yso_clustering_h_idx ON minidb.dr18_yso_clustering USING btree (h);


--
-- Name: dr18_yso_clustering_j_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_yso_clustering_j_idx ON minidb.dr18_yso_clustering USING btree (j);


--
-- Name: dr18_yso_clustering_k_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_yso_clustering_k_idx ON minidb.dr18_yso_clustering USING btree (k);


--
-- Name: dr18_yso_clustering_rp_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_yso_clustering_rp_idx ON minidb.dr18_yso_clustering USING btree (rp);


--
-- Name: dr18_zari18pms_bp_over_rp_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_zari18pms_bp_over_rp_idx ON minidb.dr18_zari18pms USING btree (bp_over_rp);


--
-- Name: dr18_zari18pms_bp_rp_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_zari18pms_bp_rp_idx ON minidb.dr18_zari18pms USING btree (bp_rp);


--
-- Name: dr18_zari18pms_bpmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_zari18pms_bpmag_idx ON minidb.dr18_zari18pms USING btree (bpmag);


--
-- Name: dr18_zari18pms_gmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_zari18pms_gmag_idx ON minidb.dr18_zari18pms USING btree (gmag);


--
-- Name: dr18_zari18pms_rpmag_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_zari18pms_rpmag_idx ON minidb.dr18_zari18pms USING btree (rpmag);


--
-- Name: dr18_zari18pms_source_idx; Type: INDEX; Schema: minidb; Owner: -
--

CREATE INDEX dr18_zari18pms_source_idx ON minidb.dr18_zari18pms USING btree (source);


--
-- Name: dr18_best_brightest dr18_best_brightest_cntr_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_best_brightest
    ADD CONSTRAINT dr18_best_brightest_cntr_fkey FOREIGN KEY (cntr) REFERENCES minidb.dr18_allwise(cntr);


--
-- Name: dr18_bhm_csc_v2 dr18_bhm_csc_v2_designation2m_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_bhm_csc_v2
    ADD CONSTRAINT dr18_bhm_csc_v2_designation2m_fkey FOREIGN KEY (designation2m) REFERENCES minidb.dr18_twomass_psc(designation);


--
-- Name: dr18_bhm_csc_v2 dr18_bhm_csc_v2_idg2_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_bhm_csc_v2
    ADD CONSTRAINT dr18_bhm_csc_v2_idg2_fkey FOREIGN KEY (idg2) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_cataclysmic_variables dr18_cataclysmic_variables_source_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_cataclysmic_variables
    ADD CONSTRAINT dr18_cataclysmic_variables_source_id_fkey FOREIGN KEY (source_id) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_catalog_to_allwise dr18_catalog_to_allwise_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_allwise
    ADD CONSTRAINT dr18_catalog_to_allwise_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_allwise(cntr);


--
-- Name: dr18_catalog_to_bhm_efeds_veto dr18_catalog_to_bhm_efeds_veto_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_bhm_efeds_veto
    ADD CONSTRAINT dr18_catalog_to_bhm_efeds_veto_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_bhm_efeds_veto(pk);


--
-- Name: dr18_catalog_to_bhm_rm_v0_2 dr18_catalog_to_bhm_rm_v0_2_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_bhm_rm_v0_2
    ADD CONSTRAINT dr18_catalog_to_bhm_rm_v0_2_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_bhm_rm_v0_2(pk);


--
-- Name: dr18_catalog_to_catwise2020 dr18_catalog_to_catwise2020_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_catwise2020
    ADD CONSTRAINT dr18_catalog_to_catwise2020_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_catwise2020(source_id);


--
-- Name: dr18_catalog_to_glimpse dr18_catalog_to_glimpse_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_glimpse
    ADD CONSTRAINT dr18_catalog_to_glimpse_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_glimpse(pk);


--
-- Name: dr18_catalog_to_guvcat dr18_catalog_to_guvcat_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_guvcat
    ADD CONSTRAINT dr18_catalog_to_guvcat_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_guvcat(objid);


--
-- Name: dr18_catalog_to_legacy_survey_dr8 dr18_catalog_to_legacy_survey_dr8_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_legacy_survey_dr8
    ADD CONSTRAINT dr18_catalog_to_legacy_survey_dr8_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_legacy_survey_dr8(ls_id);


--
-- Name: dr18_catalog_to_panstarrs1 dr18_catalog_to_panstarrs1_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_panstarrs1
    ADD CONSTRAINT dr18_catalog_to_panstarrs1_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_panstarrs1(catid_objid);


--
-- Name: dr18_catalog_to_sdss_dr13_photoobj_primary dr18_catalog_to_sdss_dr13_photoobj_primary_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_sdss_dr13_photoobj_primary
    ADD CONSTRAINT dr18_catalog_to_sdss_dr13_photoobj_primary_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_sdss_dr13_photoobj_primary(objid);


--
-- Name: dr18_catalog_to_sdss_dr16_specobj dr18_catalog_to_sdss_dr16_specobj_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_sdss_dr16_specobj
    ADD CONSTRAINT dr18_catalog_to_sdss_dr16_specobj_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_sdss_dr16_specobj(specobjid);


--
-- Name: dr18_catalog_to_skies_v2 dr18_catalog_to_skies_v2_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_skies_v2
    ADD CONSTRAINT dr18_catalog_to_skies_v2_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_skies_v2(pix_32768);


--
-- Name: dr18_catalog_to_skymapper_dr2 dr18_catalog_to_skymapper_dr2_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_skymapper_dr2
    ADD CONSTRAINT dr18_catalog_to_skymapper_dr2_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_skymapper_dr2(object_id);


--
-- Name: dr18_catalog_to_supercosmos dr18_catalog_to_supercosmos_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_supercosmos
    ADD CONSTRAINT dr18_catalog_to_supercosmos_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_supercosmos(objid);


--
-- Name: dr18_catalog_to_tic_v8 dr18_catalog_to_tic_v8_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_tic_v8
    ADD CONSTRAINT dr18_catalog_to_tic_v8_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_tic_v8(id);


--
-- Name: dr18_catalog_to_tycho2 dr18_catalog_to_tycho2_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_tycho2
    ADD CONSTRAINT dr18_catalog_to_tycho2_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_tycho2(designation);


--
-- Name: dr18_catalog_to_uvotssc1 dr18_catalog_to_uvotssc1_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_uvotssc1
    ADD CONSTRAINT dr18_catalog_to_uvotssc1_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_uvotssc1(id);


--
-- Name: dr18_catalog_to_xmm_om_suss_4_1 dr18_catalog_to_xmm_om_suss_4_1_target_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_catalog_to_xmm_om_suss_4_1
    ADD CONSTRAINT dr18_catalog_to_xmm_om_suss_4_1_target_id_fkey FOREIGN KEY (target_id) REFERENCES minidb.dr18_xmm_om_suss_4_1(pk);


--
-- Name: dr18_ebosstarget_v5 dr18_ebosstarget_v5_objid_targeting_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_ebosstarget_v5
    ADD CONSTRAINT dr18_ebosstarget_v5_objid_targeting_fkey FOREIGN KEY (objid_targeting) REFERENCES minidb.dr18_sdss_dr13_photoobj_primary(objid);


--
-- Name: dr18_gaia_dr2_ruwe dr18_gaia_dr2_ruwe_source_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaia_dr2_ruwe
    ADD CONSTRAINT dr18_gaia_dr2_ruwe_source_id_fkey FOREIGN KEY (source_id) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_gaia_dr2_wd dr18_gaia_dr2_wd_source_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaia_dr2_wd
    ADD CONSTRAINT dr18_gaia_dr2_wd_source_id_fkey FOREIGN KEY (source_id) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_gaia_unwise_agn dr18_gaia_unwise_agn_gaia_sourceid_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaia_unwise_agn
    ADD CONSTRAINT dr18_gaia_unwise_agn_gaia_sourceid_fkey FOREIGN KEY (gaia_sourceid) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_gaiadr2_tmass_best_neighbour dr18_gaiadr2_tmass_best_neighbour_source_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr18_gaiadr2_tmass_best_neighbour_source_id_fkey FOREIGN KEY (source_id) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_gaiadr2_tmass_best_neighbour dr18_gaiadr2_tmass_best_neighbour_tmass_pts_key_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_gaiadr2_tmass_best_neighbour
    ADD CONSTRAINT dr18_gaiadr2_tmass_best_neighbour_tmass_pts_key_fkey FOREIGN KEY (tmass_pts_key) REFERENCES minidb.dr18_twomass_psc(pts_key);


--
-- Name: dr18_geometric_distances_gaia_dr2 dr18_geometric_distances_gaia_dr2_source_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_geometric_distances_gaia_dr2
    ADD CONSTRAINT dr18_geometric_distances_gaia_dr2_source_id_fkey FOREIGN KEY (source_id) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_sagitta dr18_sagitta_source_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sagitta
    ADD CONSTRAINT dr18_sagitta_source_id_fkey FOREIGN KEY (source_id) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_sdss_apogeeallstarmerge_r13 dr18_sdss_apogeeallstarmerge_r13_designation_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sdss_apogeeallstarmerge_r13
    ADD CONSTRAINT dr18_sdss_apogeeallstarmerge_r13_designation_fkey FOREIGN KEY (designation) REFERENCES minidb.dr18_twomass_psc(designation);


--
-- Name: dr18_sdss_dr16_qso dr18_sdss_dr16_qso_plate_fiberid_mjd_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_sdss_dr16_qso
    ADD CONSTRAINT dr18_sdss_dr16_qso_plate_fiberid_mjd_fkey FOREIGN KEY (plate, fiberid, mjd) REFERENCES minidb.dr18_sdss_dr16_specobj(plate, fiberid, mjd);


--
-- Name: dr18_tic_v8 dr18_tic_v8_gaia_int_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_tic_v8
    ADD CONSTRAINT dr18_tic_v8_gaia_int_fkey FOREIGN KEY (gaia_int) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_tic_v8 dr18_tic_v8_twomass_psc_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_tic_v8
    ADD CONSTRAINT dr18_tic_v8_twomass_psc_fkey FOREIGN KEY (twomass_psc) REFERENCES minidb.dr18_twomass_psc(designation);


--
-- Name: dr18_yso_clustering dr18_yso_clustering_source_id_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_yso_clustering
    ADD CONSTRAINT dr18_yso_clustering_source_id_fkey FOREIGN KEY (source_id) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: dr18_zari18pms dr18_zari18pms_source_fkey; Type: FK CONSTRAINT; Schema: minidb; Owner: -
--

ALTER TABLE ONLY minidb.dr18_zari18pms
    ADD CONSTRAINT dr18_zari18pms_source_fkey FOREIGN KEY (source) REFERENCES minidb.dr18_gaia_dr2_source(source_id);


--
-- Name: SCHEMA minidb; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA minidb TO sdss;
GRANT USAGE ON SCHEMA minidb TO sdss_user;


--
-- Name: TABLE dr18_allwise; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_allwise TO sdss;
GRANT SELECT ON TABLE minidb.dr18_allwise TO sdss_user;


--
-- Name: TABLE dr18_best_brightest; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_best_brightest TO sdss;
GRANT SELECT ON TABLE minidb.dr18_best_brightest TO sdss_user;


--
-- Name: TABLE dr18_bhm_csc_v2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_bhm_csc_v2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_bhm_csc_v2 TO sdss_user;


--
-- Name: TABLE dr18_bhm_efeds_veto; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_bhm_efeds_veto TO sdss;
GRANT SELECT ON TABLE minidb.dr18_bhm_efeds_veto TO sdss_user;


--
-- Name: TABLE dr18_bhm_rm_v0_2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_bhm_rm_v0_2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_bhm_rm_v0_2 TO sdss_user;


--
-- Name: TABLE dr18_cadence; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_cadence TO sdss;
GRANT SELECT ON TABLE minidb.dr18_cadence TO sdss_user;


--
-- Name: TABLE dr18_cadence_epoch; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_cadence_epoch TO sdss;
GRANT SELECT ON TABLE minidb.dr18_cadence_epoch TO sdss_user;


--
-- Name: TABLE dr18_carton; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_carton TO sdss;
GRANT SELECT ON TABLE minidb.dr18_carton TO sdss_user;


--
-- Name: TABLE dr18_carton_to_target; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_carton_to_target TO sdss;
GRANT SELECT ON TABLE minidb.dr18_carton_to_target TO sdss_user;


--
-- Name: TABLE dr18_carton_txt; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_carton_txt TO sdss;
GRANT SELECT ON TABLE minidb.dr18_carton_txt TO sdss_user;


--
-- Name: TABLE dr18_cataclysmic_variables; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_cataclysmic_variables TO sdss;
GRANT SELECT ON TABLE minidb.dr18_cataclysmic_variables TO sdss_user;


--
-- Name: TABLE dr18_catalog; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_allwise; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_allwise TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_allwise TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_bhm_efeds_veto; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_bhm_efeds_veto TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_bhm_efeds_veto TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_bhm_rm_v0_2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_bhm_rm_v0_2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_bhm_rm_v0_2 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_catwise2020; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_catwise2020 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_catwise2020 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_glimpse; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_glimpse TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_glimpse TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_guvcat; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_guvcat TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_guvcat TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_legacy_survey_dr8; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_legacy_survey_dr8 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_legacy_survey_dr8 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_panstarrs1; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_panstarrs1 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_panstarrs1 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_sdss_dr13_photoobj_primary; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_sdss_dr13_photoobj_primary TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_sdss_dr13_photoobj_primary TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_sdss_dr16_specobj; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_sdss_dr16_specobj TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_sdss_dr16_specobj TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_skies_v2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_skies_v2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_skies_v2 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_skymapper_dr2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_skymapper_dr2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_skymapper_dr2 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_supercosmos; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_supercosmos TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_supercosmos TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_tic_v8; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_tic_v8 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_tic_v8 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_tycho2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_tycho2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_tycho2 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_uvotssc1; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_uvotssc1 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_uvotssc1 TO sdss_user;


--
-- Name: TABLE dr18_catalog_to_xmm_om_suss_4_1; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catalog_to_xmm_om_suss_4_1 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catalog_to_xmm_om_suss_4_1 TO sdss_user;


--
-- Name: TABLE dr18_category; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_category TO sdss;
GRANT SELECT ON TABLE minidb.dr18_category TO sdss_user;


--
-- Name: TABLE dr18_catwise2020; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_catwise2020 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_catwise2020 TO sdss_user;


--
-- Name: TABLE dr18_ebosstarget_v5; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_ebosstarget_v5 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_ebosstarget_v5 TO sdss_user;


--
-- Name: TABLE dr18_gaia_dr2_ruwe; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_gaia_dr2_ruwe TO sdss;
GRANT SELECT ON TABLE minidb.dr18_gaia_dr2_ruwe TO sdss_user;


--
-- Name: TABLE dr18_gaia_dr2_source; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_gaia_dr2_source TO sdss;
GRANT SELECT ON TABLE minidb.dr18_gaia_dr2_source TO sdss_user;


--
-- Name: TABLE dr18_gaia_dr2_wd; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_gaia_dr2_wd TO sdss;
GRANT SELECT ON TABLE minidb.dr18_gaia_dr2_wd TO sdss_user;


--
-- Name: TABLE dr18_gaia_unwise_agn; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_gaia_unwise_agn TO sdss;
GRANT SELECT ON TABLE minidb.dr18_gaia_unwise_agn TO sdss_user;


--
-- Name: TABLE dr18_gaiadr2_tmass_best_neighbour; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_gaiadr2_tmass_best_neighbour TO sdss;
GRANT SELECT ON TABLE minidb.dr18_gaiadr2_tmass_best_neighbour TO sdss_user;


--
-- Name: TABLE dr18_geometric_distances_gaia_dr2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_geometric_distances_gaia_dr2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_geometric_distances_gaia_dr2 TO sdss_user;


--
-- Name: TABLE dr18_glimpse; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_glimpse TO sdss;
GRANT SELECT ON TABLE minidb.dr18_glimpse TO sdss_user;


--
-- Name: TABLE dr18_guvcat; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_guvcat TO sdss;
GRANT SELECT ON TABLE minidb.dr18_guvcat TO sdss_user;


--
-- Name: TABLE dr18_instrument; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_instrument TO sdss;
GRANT SELECT ON TABLE minidb.dr18_instrument TO sdss_user;


--
-- Name: TABLE dr18_legacy_survey_dr8; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_legacy_survey_dr8 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_legacy_survey_dr8 TO sdss_user;


--
-- Name: TABLE dr18_magnitude; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_magnitude TO sdss;
GRANT SELECT ON TABLE minidb.dr18_magnitude TO sdss_user;


--
-- Name: TABLE dr18_mapper; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_mapper TO sdss;
GRANT SELECT ON TABLE minidb.dr18_mapper TO sdss_user;


--
-- Name: TABLE dr18_panstarrs1; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_panstarrs1 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_panstarrs1 TO sdss_user;


--
-- Name: TABLE dr18_sagitta; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_sagitta TO sdss;
GRANT SELECT ON TABLE minidb.dr18_sagitta TO sdss_user;


--
-- Name: TABLE dr18_sdss_apogeeallstarmerge_r13; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_sdss_apogeeallstarmerge_r13 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_sdss_apogeeallstarmerge_r13 TO sdss_user;


--
-- Name: TABLE dr18_sdss_dr13_photoobj_primary; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_sdss_dr13_photoobj_primary TO sdss;
GRANT SELECT ON TABLE minidb.dr18_sdss_dr13_photoobj_primary TO sdss_user;


--
-- Name: TABLE dr18_sdss_dr16_qso; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_sdss_dr16_qso TO sdss;
GRANT SELECT ON TABLE minidb.dr18_sdss_dr16_qso TO sdss_user;


--
-- Name: TABLE dr18_sdss_dr16_specobj; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_sdss_dr16_specobj TO sdss;
GRANT SELECT ON TABLE minidb.dr18_sdss_dr16_specobj TO sdss_user;


--
-- Name: TABLE dr18_skies_v2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_skies_v2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_skies_v2 TO sdss_user;


--
-- Name: TABLE dr18_skymapper_dr2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_skymapper_dr2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_skymapper_dr2 TO sdss_user;


--
-- Name: TABLE dr18_supercosmos; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_supercosmos TO sdss;
GRANT SELECT ON TABLE minidb.dr18_supercosmos TO sdss_user;


--
-- Name: TABLE dr18_target; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_target TO sdss;
GRANT SELECT ON TABLE minidb.dr18_target TO sdss_user;


--
-- Name: TABLE dr18_tic_v8; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_tic_v8 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_tic_v8 TO sdss_user;


--
-- Name: TABLE dr18_twomass_psc; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_twomass_psc TO sdss;
GRANT SELECT ON TABLE minidb.dr18_twomass_psc TO sdss_user;


--
-- Name: TABLE dr18_tycho2; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_tycho2 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_tycho2 TO sdss_user;


--
-- Name: TABLE dr18_uvotssc1; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_uvotssc1 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_uvotssc1 TO sdss_user;


--
-- Name: TABLE dr18_xmm_om_suss_4_1; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_xmm_om_suss_4_1 TO sdss;
GRANT SELECT ON TABLE minidb.dr18_xmm_om_suss_4_1 TO sdss_user;


--
-- Name: TABLE dr18_yso_clustering; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_yso_clustering TO sdss;
GRANT SELECT ON TABLE minidb.dr18_yso_clustering TO sdss_user;


--
-- Name: TABLE dr18_zari18pms; Type: ACL; Schema: minidb; Owner: -
--

GRANT SELECT ON TABLE minidb.dr18_zari18pms TO sdss;
GRANT SELECT ON TABLE minidb.dr18_zari18pms TO sdss_user;


--
-- PostgreSQL database dump complete
--

