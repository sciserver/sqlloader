--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'WISE_xmatch')
	DROP TABLE WISE_xmatch
GO
--
EXEC spSetDefaultFileGroup 'WISE_xmatch'
GO
CREATE TABLE WISE_xmatch (
-----------------------------------------------------------------------------------
--/H SDSS objects that match to WISE objects have their match parameters stored here
--/T The source for this is the WISE catalog. 
-----------------------------------------------------------------------------------
      sdss_objid BIGINT NOT NULL,
      wise_cntr  BIGINT NOT NULL,
      match_dist REAL NOT NULL
)
GO
--


                                              
--=============================================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'WISE_AllSky')
	DROP TABLE WISE_AllSky
GO
--
EXEC spSetDefaultFileGroup 'WISE_AllSky'
GO
CREATE TABLE WISE_allsky (
-----------------------------------------------------------------------------------
--/H SDSS objects that match to WISE objects have their match parameters stored here
--/T The source for this is the WISE catalog. 
-----------------------------------------------------------------------------------                                           
    cntr        BIGINT NOT NULL,
    ra          FLOAT NOT NULL,
    dec         FLOAT NOT NULL,
    sigra       REAL NOT NULL,
    sigdec      REAL NOT NULL,
    sigradec    REAL NOT NULL,
    wx          REAL NOT NULL,
    wy          REAL NOT NULL,
    coadd_id    VARCHAR(13) NOT NULL,
    src         INT NOT NULL,
    rchi2       REAL NOT NULL,
    xsc_prox    REAL NOT NULL,	--/F xscprox
    tmass_key   INT NOT NULL,
    r_2mass     REAL NOT NULL,
    pa_2mass    REAL NOT NULL,
    n_2mass     TINYINT NOT NULL,
    j_m_2mass   REAL NOT NULL,
    j_msig_2mass REAL NOT NULL,
    h_m_2mass   REAL NOT NULL,
    h_msig_2mass REAL NOT NULL,
    k_m_2mass   REAL NOT NULL,
    k_msig_2mass REAL NOT NULL,
    rho12       SMALLINT NOT NULL,
    rho23       SMALLINT NOT NULL,
    rho34       SMALLINT NOT NULL,
    q12         TINYINT NOT NULL,
    q23         TINYINT NOT NULL,
    q34         TINYINT NOT NULL,
    blend_ext_flags  TINYINT NOT NULL,
    w1mpro      REAL NOT NULL,
    w1sigmpro   REAL NOT NULL,
    w1snr       REAL NOT NULL,
    w1rchi2     REAL NOT NULL,
    w1sat       REAL NOT NULL,
    w1nm        TINYINT NOT NULL,
    w1m         TINYINT NOT NULL,
    w1cov       REAL NOT NULL,
    w1frtr      REAL NOT NULL,
    w1flux      REAL NOT NULL,
    w1sigflux   REAL NOT NULL,
    w1sky       REAL NOT NULL,
    w1sigsky    REAL NOT NULL,	--/F w1sigsk
    w1conf      REAL NOT NULL,
    w1mag       REAL NOT NULL,
    w1sigmag    REAL NOT NULL,	--/F w1sigm
    w1mcor      REAL NOT NULL,
    w1magp      REAL NOT NULL,
    w1sigp1     REAL NOT NULL,
    w1sigp2     REAL NOT NULL,
    w1dmag      REAL NOT NULL,
    w1mjdmin    FLOAT NOT NULL,
    w1mjdmax    FLOAT NOT NULL,
    w1mjdmean   FLOAT NOT NULL,
    w1rsemi     REAL NOT NULL,
    w1ba        REAL NOT NULL,
    w1pa        REAL NOT NULL,
    w1gmag      REAL NOT NULL,
    w1siggmag   REAL NOT NULL,	--/F w1gerr
    w1flg       TINYINT NOT NULL,
    w1gflg      TINYINT NOT NULL,
    ph_qual_det1 TINYINT NOT NULL,	--/F phqual_det_1
    w1ndf       TINYINT NOT NULL,
    w1mlq       TINYINT NOT NULL,
    w1cc_map    TINYINT NOT NULL,
    var_flg1    TINYINT NOT NULL,	--/F var_1
    moon_lev1   TINYINT NOT NULL,	--/F moonlev_1
    satnum1     TINYINT NOT NULL,	--/F satnum_1
    w2mpro      REAL NOT NULL,
    w2sigmpro   REAL NOT NULL,
    w2snr       REAL NOT NULL,
    w2rchi2     REAL NOT NULL,
    w2sat       REAL NOT NULL,
    w2nm        TINYINT NOT NULL,
    w2m         TINYINT NOT NULL,
    w2cov       REAL NOT NULL,
    w2frtr      REAL NOT NULL,
    w2flux      REAL NOT NULL,
    w2sigflux   REAL NOT NULL,
    w2sky       REAL NOT NULL,
    w2sigsky    REAL NOT NULL,	--/F w2sigsk
    w2conf      REAL NOT NULL,
    w2mag       REAL NOT NULL,
    w2sigmag    REAL NOT NULL,	--/F w2sigm
    w2mcor      REAL NOT NULL,
    w2magp      REAL NOT NULL,
    w2sigp1     REAL NOT NULL,
    w2sigp2     REAL NOT NULL,
    w2dmag      REAL NOT NULL,
    w2mjdmin    FLOAT NOT NULL,
    w2mjdmax    FLOAT NOT NULL,
    w2mjdmean   FLOAT NOT NULL,
    w2rsemi     REAL NOT NULL,
    w2ba        REAL NOT NULL,
    w2pa        REAL NOT NULL,
    w2gmag      REAL NOT NULL,
    w2siggmag   REAL NOT NULL,	--/F w2gerr
    w2flg       TINYINT NOT NULL,
    w2gflg      TINYINT NOT NULL,
    ph_qual_det2 TINYINT NOT NULL,	--/F phqual_det_2
    w2ndf       TINYINT NOT NULL,
    w2mlq       TINYINT NOT NULL,
    w2cc_map    TINYINT NOT NULL,
    var_flg2    TINYINT NOT NULL,	--/F var_2
    moon_lev2   TINYINT NOT NULL,	--/F moonlev_2
    satnum2     TINYINT NOT NULL,	--/F satnum_2
    w3mpro      REAL NOT NULL,
    w3sigmpro   REAL NOT NULL,
    w3snr       REAL NOT NULL,
    w3rchi2     REAL NOT NULL,
    w3sat       REAL NOT NULL,
    w3nm        TINYINT NOT NULL,
    w3m         TINYINT NOT NULL,
    w3cov       REAL NOT NULL,
    w3frtr      REAL NOT NULL,
    w3flux      REAL NOT NULL,
    w3sigflux   REAL NOT NULL,
    w3sky       REAL NOT NULL,
    w3sigsky    REAL NOT NULL,	--/F w3sigsk
    w3conf      REAL NOT NULL,
    w3mag       REAL NOT NULL,
    w3sigmag    REAL NOT NULL,	--/F w3sigm
    w3mcor      REAL NOT NULL,
    w3magp      REAL NOT NULL,
    w3sigp1     REAL NOT NULL,
    w3sigp2     REAL NOT NULL,
    w3dmag      REAL NOT NULL,
    w3mjdmin    FLOAT NOT NULL,
    w3mjdmax    FLOAT NOT NULL,
    w3mjdmean   FLOAT NOT NULL,
    w3rsemi     REAL NOT NULL,
    w3ba        REAL NOT NULL,
    w3pa        REAL NOT NULL,
    w3gmag      REAL NOT NULL,
    w3siggmag   REAL NOT NULL,	--/F w3gerr
    w3flg       TINYINT NOT NULL,
    w3gflg      TINYINT NOT NULL,
    ph_qual_det3 TINYINT NOT NULL,	--/F phqual_det_3
    w3ndf       TINYINT NOT NULL,
    w3mlq       TINYINT NOT NULL,
    w3cc_map    TINYINT NOT NULL,
    var_flg3    TINYINT NOT NULL,	--/F var_3
    moon_lev3   TINYINT NOT NULL,	--/F moonlev_3
    satnum3     TINYINT NOT NULL,	--/F satnum_3
    w4mpro      REAL NOT NULL,
    w4sigmpro   REAL NOT NULL,
    w4snr       REAL NOT NULL,
    w4rchi2     REAL NOT NULL,
    w4sat       REAL NOT NULL,
    w4nm        TINYINT NOT NULL,
    w4m         TINYINT NOT NULL,
    w4cov       REAL NOT NULL,
    w4frtr      REAL NOT NULL,
    w4flux      REAL NOT NULL,
    w4sigflux   REAL NOT NULL,
    w4sky       REAL NOT NULL,
    w4sigsky    REAL NOT NULL,	--/F w4sigsk
    w4conf      REAL NOT NULL,
    w4mag       REAL NOT NULL,
    w4sigmag    REAL NOT NULL,	--/F w4sigm
    w4mcor      REAL NOT NULL,
    w4magp      REAL NOT NULL,
    w4sigp1     REAL NOT NULL,
    w4sigp2     REAL NOT NULL,
    w4dmag      REAL NOT NULL,
    w4mjdmin    FLOAT NOT NULL,
    w4mjdmax    FLOAT NOT NULL,
    w4mjdmean   FLOAT NOT NULL,
    w4rsemi     REAL NOT NULL,
    w4ba        REAL NOT NULL,
    w4pa        REAL NOT NULL,
    w4gmag      REAL NOT NULL,
    w4siggmag   REAL NOT NULL,	--/F w4gerr
    w4flg       TINYINT NOT NULL,
    w4gflg      TINYINT NOT NULL,
    ph_qual_det4 TINYINT NOT NULL,	--/F phqual_det_4
    w4ndf       TINYINT NOT NULL,
    w4mlq       TINYINT NOT NULL,
    w4cc_map    TINYINT NOT NULL,
    var_flg4    TINYINT NOT NULL,	--/F var_4
    moon_lev4   TINYINT NOT NULL,	--/F moonlev_4
    satnum4     TINYINT NOT NULL,	--/F satnum_4
    w1mag_1     REAL NOT NULL,
    w1sigmag_1  REAL NOT NULL,	--/F w1sigm_1
    w1flg_1     TINYINT NOT NULL,
    w1mag_2     REAL NOT NULL,
    w1sigmag_2  REAL NOT NULL,	--/F w1sigm_2
    w1flg_2     TINYINT NOT NULL,
    w1mag_3     REAL NOT NULL,
    w1sigmag_3  REAL NOT NULL,	--/F w1sigm_3
    w1flg_3     TINYINT NOT NULL,
    w1mag_4     REAL NOT NULL,
    w1sigmag_4  REAL NOT NULL,	--/F w1sigm_4
    w1flg_4     TINYINT NOT NULL,
    w1mag_5     REAL NOT NULL,
    w1sigmag_5  REAL NOT NULL,	--/F w1sigm_5
    w1flg_5     TINYINT NOT NULL,
    w1mag_6     REAL NOT NULL,
    w1sigmag_6  REAL NOT NULL,	--/F w1sigm_6
    w1flg_6     TINYINT NOT NULL,
    w1mag_7     REAL NOT NULL,
    w1sigmag_7  REAL NOT NULL,	--/F w1sigm_7
    w1flg_7     TINYINT NOT NULL,
    w1mag_8     REAL NOT NULL,
    w1sigmag_8  REAL NOT NULL,	--/F w1sigm_8
    w1flg_8     TINYINT NOT NULL,
    w2mag_1     REAL NOT NULL,
    w2sigmag_1  REAL NOT NULL,	--/F w2sigm_1
    w2flg_1     TINYINT NOT NULL,
    w2mag_2     REAL NOT NULL,
    w2sigmag_2  REAL NOT NULL,	--/F w2sigm_2
    w2flg_2     TINYINT NOT NULL,
    w2mag_3     REAL NOT NULL,
    w2sigmag_3  REAL NOT NULL,	--/F w2sigm_3
    w2flg_3     TINYINT NOT NULL,
    w2mag_4     REAL NOT NULL,
    w2sigmag_4  REAL NOT NULL,	--/F w2sigm_4
    w2flg_4     TINYINT NOT NULL,
    w2mag_5     REAL NOT NULL,
    w2sigmag_5  REAL NOT NULL,	--/F w2sigm_5
    w2flg_5     TINYINT NOT NULL,
    w2mag_6     REAL NOT NULL,
    w2sigmag_6  REAL NOT NULL,	--/F w2sigm_6
    w2flg_6     TINYINT NOT NULL,
    w2mag_7     REAL NOT NULL,
    w2sigmag_7  REAL NOT NULL,	--/F w2sigm_7
    w2flg_7     TINYINT NOT NULL,
    w2mag_8     REAL NOT NULL,
    w2sigmag_8  REAL NOT NULL,	--/F w2sigm_8
    w2flg_8     TINYINT NOT NULL,
    w3mag_1     REAL NOT NULL,
    w3sigmag_1  REAL NOT NULL,	--/F w3sigm_1
    w3flg_1     TINYINT NOT NULL,
    w3mag_2     REAL NOT NULL,
    w3sigmag_2  REAL NOT NULL,	--/F w3sigm_2
    w3flg_2     TINYINT NOT NULL,
    w3mag_3     REAL NOT NULL,
    w3sigmag_3  REAL NOT NULL,	--/F w3sigm_3
    w3flg_3     TINYINT NOT NULL,
    w3mag_4     REAL NOT NULL,
    w3sigmag_4  REAL NOT NULL,	--/F w3sigm_4
    w3flg_4     TINYINT NOT NULL,
    w3mag_5     REAL NOT NULL,
    w3sigmag_5  REAL NOT NULL,	--/F w3sigm_5
    w3flg_5     TINYINT NOT NULL,
    w3mag_6     REAL NOT NULL,
    w3sigmag_6  REAL NOT NULL,	--/F w3sigm_6
    w3flg_6     TINYINT NOT NULL,
    w3mag_7     REAL NOT NULL,
    w3sigmag_7  REAL NOT NULL,	--/F w3sigm_7
    w3flg_7     TINYINT NOT NULL,
    w3mag_8     REAL NOT NULL,
    w3sigmag_8  REAL NOT NULL,	--/F w3sigm_8
    w3flg_8     TINYINT NOT NULL,
    w4mag_1     REAL NOT NULL,
    w4sigmag_1  REAL NOT NULL,	--/F w4sigm_1
    w4flg_1     TINYINT NOT NULL,
    w4mag_2     REAL NOT NULL,
    w4sigmag_2  REAL NOT NULL,	--/F w4sigm_2
    w4flg_2     TINYINT NOT NULL,
    w4mag_3     REAL NOT NULL,
    w4sigmag_3  REAL NOT NULL,	--/F w4sigm_3
    w4flg_3     TINYINT NOT NULL,
    w4mag_4     REAL NOT NULL,
    w4sigmag_4  REAL NOT NULL,	--/F w4sigm_4
    w4flg_4     TINYINT NOT NULL,
    w4mag_5     REAL NOT NULL,
    w4sigmag_5  REAL NOT NULL,	--/F w4sigm_5
    w4flg_5     TINYINT NOT NULL,
    w4mag_6     REAL NOT NULL,
    w4sigmag_6  REAL NOT NULL,	--/F w4sigm_6
    w4flg_6     TINYINT NOT NULL,
    w4mag_7     REAL NOT NULL,
    w4sigmag_7  REAL NOT NULL,	--/F w4sigm_7
    w4flg_7     TINYINT NOT NULL,
    w4mag_8     REAL NOT NULL,
    w4sigmag_8  REAL NOT NULL,	--/F w4sigm_8
    w4flg_8     TINYINT NOT NULL
);

