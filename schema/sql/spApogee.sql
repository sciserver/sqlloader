--==============================================================
--   spApogee.sql
--   2016-04-27 Ani Thakar
----------------------------------------------------------------
-- Functions to return groups of APOGEE columns (for convenience)
----------------------------------------------------------------
--* 2016-04-27 Ani: Created inital version as per JOn Holtzman request.
--* 2016-05-13 Ani: Updated description of fAspcapFelem* functions.
--* 2016-05-18 Ani: Removed dbo. prefix from function definitions and also.
--*                 trailing spaces from some functions.
--* 2016-05-19 Ani: Removed multiple instances of links to flag docs.
--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapParamsAll' ) 
	DROP FUNCTION fAspcapParamsAll
GO
--
CREATE FUNCTION fAspcapParamsAll (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap parameters along with their errors and flags.
-------------------------------------------------------------
--/T This function returns the APOGEE aspcapStar parameters for a given aspcap_id, along with their associated errors and flags.
--/T <p>returned table:
--/T <li> teff real NOT NULL,			-- Empirically calibrated temperature from ASPCAP 
--/T <li> teff_err real NOT NULL,		-- external uncertainty estimate for calibrated temperature from ASPCAP
--/T <li> teff_flag int NOT NULL,		-- PARAMFLAG for effective temperature (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
--/T <li> logg real NOT NULL,			-- empirically calibrated log gravity from ASPCAP
--/T <li> logg_err real NOT NULL,		-- external uncertainty estimate for log gravity from ASPCAP
--/T <li> logg_flag int NOT NULL,		-- PARAMFLAG for log g
--/T <li> vmicro real NOT NULL,			-- microturbulent velocity (fit for dwarfs, f(log g) for giants)
--/T <li> vmacro real NOT NULL,			-- macroturbulent velocity (f(log Teff,[M/H]) for giants)
--/T <li> vsini real NOT NULL,			-- rotation+macroturbulent velocity (fit for dwarfs)
--/T <li> m_h real NOT NULL,			-- calibrated [M/H]
--/T <li> m_h_err real NOT NULL,		-- calibrated [M/H] uncertainty
--/T <li> m_h_flag int NOT NULL,		-- PARAMFLAG for [M/H]
--/T <li> alpha_m real NOT NULL,		-- calibrated [M/H]
--/T <li> alpha_m_err real NOT NULL,	-- calibrated [M/H] uncertainty
--/T <li> alpha_m_flag int NOT NULL,	-- PARAMFLAG for [alpha/M]
--/T <br> Sample call to get aspcap param errors:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from  aspcapStar a CROSS APPLY dbo.fAspcapParamsAll( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapParams, fAspcapParamErrs, fAspcapParamFlags
-------------------------------------------------------------
  RETURNS @ptab TABLE (
    teff real NOT NULL,
    teff_err real NOT NULL,
    teff_flag int NOT NULL,
    logg real NOT NULL,
    logg_err real NOT NULL,
    logg_flag int NOT NULL,
    vmicro real NOT NULL,
    vmacro real NOT NULL,
    vsini real NOT NULL,
    m_h real NOT NULL,
    m_h_err real NOT NULL,
    m_h_flag int NOT NULL,
    alpha_m real NOT NULL,
    alpha_m_err real NOT NULL,
    alpha_m_flag int NOT NULL
  ) AS 
BEGIN
	INSERT @ptab	SELECT 
	    teff,
	    teff_err,
	    teff_flag,
	    logg real,
	    logg_err,
	    logg_flag,
	    vmicro,
	    vmacro,
	    vsini,
	    m_h real,
	    m_h_err,
	    m_h_flag,
	    alpha_m,
	    alpha_m_err,
	    alpha_m_flag
	FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapParams' ) 
	DROP FUNCTION fAspcapParams
GO
--
CREATE FUNCTION fAspcapParams (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap parameters.
-------------------------------------------------------------
--/T This function returns the APOGEE aspcapStar parameters for a given aspcap_id.
--/T <p>returned table:
--/T <li> teff real NOT NULL,		-- Empirically calibrated temperature from ASPCAP 
--/T <li> logg real NOT NULL,		-- empirically calibrated log gravity from ASPCAP
--/T <li> vmicro real NOT NULL,		-- microturbulent velocity (fit for dwarfs, f(log g) for giants)
--/T <li> vmacro real NOT NULL,		-- macroturbulent velocity (f(log Teff,[M/H]) for giants)
--/T <li> vsini real NOT NULL,		-- rotation+macroturbulent velocity (fit for dwarfs)
--/T <li> m_h real NOT NULL,		-- calibrated [M/H]
--/T <li> alpha_m real NOT NULL,	-- calibrated [M/H]
--/T <br> Sample call to get aspcap params:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from  aspcapStar a CROSS APPLY dbo.fAspcapParams( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapParamsAll, fAspcapParamErrs, fAspcapParamFlags
-------------------------------------------------------------
  RETURNS @ptab TABLE (
    teff real NOT NULL,
    logg real NOT NULL,
    vmicro real NOT NULL,
    vmacro real NOT NULL,
    vsini real NOT NULL,
    m_h real NOT NULL,
    alpha_m real NOT NULL
  ) AS 
BEGIN
	INSERT @ptab	SELECT 
	    teff,
	    logg real,
	    vmicro,
	    vmacro,
	    vsini,
	    m_h real,
	    alpha_m
	FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapParamErrs' ) 
	DROP FUNCTION fAspcapParamErrs
GO
--
CREATE FUNCTION fAspcapParamErrs (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap parameter errors.
-------------------------------------------------------------
--/T This function returns the errors associated with APOGEE aspcapStar parameters for a given aspcap_id.
--/T <p>returned table:
--/T <li> teff_err real NOT NULL, --/U deg K  --/D external uncertainty estimate for calibrated temperature from ASPCAP
--/T <li> logg_err real NOT NULL, --/U dex --/D external uncertainty estimate for log gravity from ASPCAP
--/T <li> m_h_err real NOT NULL, --/U dex --/D calibrated [M/H] uncertainty
--/T <li> alpha_m_err real NOT NULL --/U dex --/D calibrated [M/H] uncertainty
--/T <br> Sample call to get aspcap param errors:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from  aspcapStar a CROSS APPLY dbo.fAspcapParamErrs( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapParamsAll, fAspcapParams, fAspcapParamFlags
-------------------------------------------------------------
  RETURNS @ptab TABLE (
    teff_err real NOT NULL,
    logg_err real NOT NULL,
    m_h_err real NOT NULL,
    alpha_m_err real NOT NULL
  ) AS 
BEGIN
	INSERT @ptab	SELECT 
	    teff_err,
	    logg_err,
	    m_h_err,
	    alpha_m_err
	FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapParamFlags' ) 
	DROP FUNCTION fAspcapParamFlags
GO
--
CREATE FUNCTION fAspcapParamFlags (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap parameter flags.
-------------------------------------------------------------
--/T This function returns the flags associated with APOGEE aspcapStar parameters for a given aspcap_id.
--/T <p>returned table:
--/T <li> teff_flag int NOT NULL, --/F paramflag 0 --/D PARAMFLAG for effective temperature (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_PARAMFLAG)
--/T <li> logg_flag int NOT NULL, --/F paramflag 1 --/D PARAMFLAG for log g
--/T <li> m_h_flag int NOT NULL, --/F paramflag 3 --/D PARAMFLAG for [M/H]
--/T <li> alpha_m_flag int NOT NULL --/F paramflag 6 --/D PARAMFLAG for [alpha/M]
--/T <br> Sample call to get aspcap param flags:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from  aspcapStar a CROSS APPLY dbo.fAspcapParamFlags( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapParamsAll, fAspcapParams, fAspcapParamErrs
-------------------------------------------------------------
  RETURNS @ptab TABLE (
    teff_flag int NOT NULL,
    logg_flag int NOT NULL,
    m_h_flag int NOT NULL,
    alpha_m_flag int NOT NULL
  ) AS 
BEGIN
	INSERT @ptab	SELECT 
	    teff_flag,
	    logg_flag,
	    m_h_flag,
	    alpha_m_flag
	FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapElemsAll' ) 
	DROP FUNCTION fAspcapElemsAll
GO
--
CREATE FUNCTION fAspcapElemsAll (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap element abundances along with their errors and flags.
-------------------------------------------------------------
--/T This function returns the APOGEE aspcapStar element abundances for a given aspcap_id, along with their associated errors and flags.
--/T <p>returned table:
--/T <li> c_fe real NOT NULL,         -- empirically calibrated [C/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals
--/T <li> c_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [C/Fe] from ASPCAP
--/T <li> c_fe_flag int NOT NULL,     -- ELEMFLAG for C (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
--/T <li> ci_fe real NOT NULL,        -- empirically calibrated [CI/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals
--/T <li> ci_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [CI/Fe] from ASPCAP
--/T <li> ci_fe_flag int NOT NULL,    -- ELEMFLAG for CI
--/T <li> n_fe real NOT NULL,         -- empirically calibrated [N/Fe] from ASPCAP; [N/Fe] is calculated as (ASPCAP [N/M])+param_metals
--/T <li> n_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [N/Fe] from ASPCAP
--/T <li> n_fe_flag int NOT NULL,     -- ELEMFLAG for N
--/T <li> o_fe real NOT NULL,         -- empirically calibrated [O/Fe] from ASPCAP; [O/Fe] is calculated as (ASPCAP [O/M])+param_metals
--/T <li> o_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [O/Fe] from ASPCAP
--/T <li> o_fe_flag int NOT NULL,     -- ELEMFLAG for O
--/T <li> na_fe real NOT NULL,        -- empirically calibrated [Na/Fe] from ASPCAP
--/T <li> na_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Na/Fe] from ASPCAP
--/T <li> na_fe_flag int NOT NULL,    -- ELEMFLAG for Na
--/T <li> mg_fe real NOT NULL,        -- empirically calibrated [Mg/Fe] from ASPCAP; [Mg/Fe] is calculated as (ASPCAP [Mg/M])+param_metals
--/T <li> mg_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Mg/Fe] from ASPCAP
--/T <li> mg_fe_flag int NOT NULL,    -- ELEMFLAG for Mg
--/T <li> al_fe real NOT NULL,        -- empirically calibrated [Al/Fe] from ASPCAP
--/T <li> al_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Al/Fe] from ASPCAP
--/T <li> al_fe_flag int NOT NULL,    -- ELEMFLAG for Al
--/T <li> si_fe real NOT NULL,        -- empirically calibrated [Si/Fe] from ASPCAP; [Si/Fe] is calculated as (ASPCAP [Si/M])+param_metals
--/T <li> si_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Si/Fe] from ASPCAP
--/T <li> si_fe_flag int NOT NULL,    -- ELEMFLAG for Si
--/T <li> p_fe real NOT NULL,         -- empirically calibrated [P/Fe] from ASPCAP; [P/Fe] is calculated as (ASPCAP [P/M])+param_metals
--/T <li> p_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [P/Fe] from ASPCAP
--/T <li> p_fe_flag int NOT NULL,     -- ELEMFLAG for Si
--/T <li> s_fe real NOT NULL,         -- empirically calibrated [S/Fe] from ASPCAP; [S/Fe] is calculated as (ASPCAP [S/M])+param_metals
--/T <li> s_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [S/Fe] from ASPCAP
--/T <li> s_fe_flag int NOT NULL,     -- ELEMFLAG for S
--/T <li> k_fe real NOT NULL,         -- empirically calibrated [K/Fe] from ASPCAP
--/T <li> k_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [K/Fe] from ASPCAP
--/T <li> k_fe_flag int NOT NULL,     -- ELEMFLAG for K
--/T <li> ca_fe real NOT NULL,        -- empirically calibrated [Ca/Fe] from ASPCAP ; [Ca/Fe] is calculated as (ASPCAP [Ca/M])+param_metals
--/T <li> ca_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Ca/Fe] from ASPCAP
--/T <li> ca_fe_flag int NOT NULL,    -- ELEMFLAG for Ca
--/T <li> ti_fe real NOT NULL,        -- empirically calibrated [Ti/Fe] from ASPCAP; [Ti/Fe] is calculated as (ASPCAP [Ti/M])+param_metals
--/T <li> ti_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Ti/Fe] from ASPCAP
--/T <li> ti_fe_flag int NOT NULL,    -- ELEMFLAG for Ti
--/T <li> tiii_fe real NOT NULL,      -- empirically calibrated [TiII/Fe] from ASPCAP; [TiII/Fe] is calculated as (ASPCAP [TiII/M])+param_metals
--/T <li> tiii_fe_err real NOT NULL,  -- external uncertainty for empirically calibrated [TiII/Fe] from ASPCAP
--/T <li> tiii_fe_flag int NOT NULL,  -- ELEMFLAG for TiII
--/T <li> v_fe real NOT NULL,         -- empirically calibrated [V/Fe] from ASPCAP
--/T <li> v_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [V/Fe] from ASPCAP
--/T <li> v_fe_flag int NOT NULL,     -- ELEMFLAG for V
--/T <li> cr_fe real NOT NULL,        -- empirically calibrated [Cr/Fe] from ASPCAP
--/T <li> cr_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Cr/Fe] from ASPCAP
--/T <li> cr_fe_flag int NOT NULL,    -- ELEMFLAG for Cr
--/T <li> mn_fe real NOT NULL,        -- empirically calibrated [Mn/Fe] from ASPCAP
--/T <li> mn_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Mn/Fe] from ASPCAP
--/T <li> mn_fe_flag int NOT NULL,    -- ELEMFLAG for Mn
--/T <li> fe_h real NOT NULL,         -- empirically calibrated [Fe/H] from ASPCAP
--/T <li> fe_h_err real NOT NULL,     -- external uncertainty for empirically calibrated [Fe/H] from ASPCAP
--/T <li> fe_h_flag int NOT NULL,     -- ELEMFLAG for Fe
--/T <li> co_fe real NOT NULL,        -- empirically calibrated [Co/Fe] from ASPCAP
--/T <li> co_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Co/Fe] from ASPCAP
--/T <li> co_fe_flag int NOT NULL,    -- ELEMFLAG for Co
--/T <li> ni_fe real NOT NULL,        -- empirically calibrated [Ni/Fe] from ASPCAP
--/T <li> ni_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Ni/Fe] from ASPCAP
--/T <li> ni_fe_flag int NOT NULL,    -- ELEMFLAG for Ni
--/T <li> cu_fe real NOT NULL,        -- empirically calibrated [Cu/Fe] from ASPCAP
--/T <li> cu_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Cu/Fe] from ASPCAP
--/T <li> cu_fe_flag int NOT NULL,    -- ELEMFLAG for Cu
--/T <li> ge_fe real NOT NULL,        -- empirically calibrated [Ge/Fe] from ASPCAP
--/T <li> ge_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Ge/Fe] from ASPCAP
--/T <li> ge_fe_flag int NOT NULL,    -- ELEMFLAG for Ge
--/T <li> rb_fe real NOT NULL,        -- empirically calibrated [Rb/Fe] from ASPCAP
--/T <li> rb_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Rb/Fe] from ASPCAP
--/T <li> rb_fe_flag int NOT NULL,    -- ELEMFLAG for Rb
--/T <li> y_fe real NOT NULL,         -- empirically calibrated [Y/Fe] from ASPCAP
--/T <li> y_fe_err real NOT NULL,     -- external uncertainty for empirically calibrated [Y/Fe] from ASPCAP
--/T <li> y_fe_flag int NOT NULL,     -- ELEMFLAG for Y
--/T <li> nd_fe real NOT NULL,        -- empirically calibrated [Nd/Fe] from ASPCAP
--/T <li> nd_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [Nd/Fe] from ASPCAP
--/T <li> nd_fe_flag int NOT NULL,    -- ELEMFLAG for Nd                  --/T <br> Sample call to return aspcap params
--/T <br> Sample call to get aspcap element abundances with errors and flags:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from aspcapStar a CROSS APPLY dbo.fAspcapElemsAll( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapElems, fAspcapElemErrs, fAspcapElemFlags
-------------------------------------------------------------
  RETURNS @etab TABLE (
    c_fe real NOT NULL,
    c_fe_err real NOT NULL,
    c_fe_flag int NOT NULL,
    ci_fe real NOT NULL,
    ci_fe_err real NOT NULL,
    ci_fe_flag int NOT NULL,
    n_fe real NOT NULL,
    n_fe_err real NOT NULL,
    n_fe_flag int NOT NULL,
    o_fe real NOT NULL,
    o_fe_err real NOT NULL,
    o_fe_flag int NOT NULL,
    na_fe real NOT NULL,
    na_fe_err real NOT NULL,
    na_fe_flag int NOT NULL,
    mg_fe real NOT NULL,
    mg_fe_err real NOT NULL,
    mg_fe_flag int NOT NULL,
    al_fe real NOT NULL,
    al_fe_err real NOT NULL,
    al_fe_flag int NOT NULL,
    si_fe real NOT NULL,
    si_fe_err real NOT NULL,
    si_fe_flag int NOT NULL,
    p_fe real NOT NULL,
    p_fe_err real NOT NULL,
    p_fe_flag int NOT NULL,
    s_fe real NOT NULL,
    s_fe_err real NOT NULL,
    s_fe_flag int NOT NULL,
    k_fe real NOT NULL,
    k_fe_err real NOT NULL,
    k_fe_flag int NOT NULL,
    ca_fe real NOT NULL,
    ca_fe_err real NOT NULL,
    ca_fe_flag int NOT NULL,
    ti_fe real NOT NULL,
    ti_fe_err real NOT NULL,
    ti_fe_flag int NOT NULL,
    tiii_fe real NOT NULL,
    tiii_fe_err real NOT NULL,
    tiii_fe_flag int NOT NULL,
    v_fe real NOT NULL,
    v_fe_err real NOT NULL,
    v_fe_flag int NOT NULL,
    cr_fe real NOT NULL,
    cr_fe_err real NOT NULL,
    cr_fe_flag int NOT NULL,
    mn_fe real NOT NULL,
    mn_fe_err real NOT NULL,
    mn_fe_flag int NOT NULL,
    fe_h real NOT NULL,
    fe_h_err real NOT NULL,
    fe_h_flag int NOT NULL,
    co_fe real NOT NULL,
    co_fe_err real NOT NULL,
    co_fe_flag int NOT NULL,
    ni_fe real NOT NULL,
    ni_fe_err real NOT NULL,
    ni_fe_flag int NOT NULL,
    cu_fe real NOT NULL,
    cu_fe_err real NOT NULL,
    cu_fe_flag int NOT NULL,
    ge_fe real NOT NULL,
    ge_fe_err real NOT NULL,
    ge_fe_flag int NOT NULL,
    rb_fe real NOT NULL,
    rb_fe_err real NOT NULL,
    rb_fe_flag int NOT NULL,
    y_fe real NOT NULL,
    y_fe_err real NOT NULL,
    y_fe_flag int NOT NULL,
    nd_fe real NOT NULL,
    nd_fe_err real NOT NULL,
    nd_fe_flag int NOT NULL
  ) AS 
BEGIN
	INSERT @etab
		SELECT 
            c_fe,
            c_fe_err,
            c_fe_flag,
            ci_fe,
            ci_fe_err,
            ci_fe_flag,
            n_fe,
            n_fe_err,
            n_fe_flag,
            o_fe,
            o_fe_err,
            o_fe_flag,
            na_fe,
            na_fe_err,
            na_fe_flag,
            mg_fe,
            mg_fe_err,
            mg_fe_flag,
            al_fe,
            al_fe_err,
            al_fe_flag,
            si_fe,
            si_fe_err,
            si_fe_flag,
            p_fe,
            p_fe_err,
            p_fe_flag,
            s_fe,
            s_fe_err,
            s_fe_flag,
            k_fe,
            k_fe_err,
            k_fe_flag,
            ca_fe,
            ca_fe_err,
            ca_fe_flag,
            ti_fe,
            ti_fe_err,
            ti_fe_flag,
            tiii_fe,
            tiii_fe_err,
            tiii_fe_flag,
            v_fe,
            v_fe_err,
            v_fe_flag,
            cr_fe,
            cr_fe_err,
            cr_fe_flag,
            mn_fe,
            mn_fe_err,
            mn_fe_flag,
            fe_h,
            fe_h_err,
            fe_h_flag,
            co_fe,
            co_fe_err,
            co_fe_flag,
            ni_fe,
            ni_fe_err,
            ni_fe_flag,
            cu_fe,
            cu_fe_err,
            cu_fe_flag,
            ge_fe,
            ge_fe_err,
            ge_fe_flag,
            rb_fe,
            rb_fe_err,
            rb_fe_flag,
            y_fe,
            y_fe_err,
            y_fe_flag,
            nd_fe,
            nd_fe_err,
            nd_fe_flag
		FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapElems' ) 
	DROP FUNCTION fAspcapElems
GO
--
CREATE FUNCTION fAspcapElems (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap element abundances.
-------------------------------------------------------------
--/T This function returns the APOGEE aspcapStar element abundances for a given aspcap_id.
--/T <p>returned table:
--/T <li> c_fe real NOT NULL,           -- empirically calibrated [C/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals
--/T <li> ci_fe real NOT NULL,          -- empirically calibrated [CI/Fe] from ASPCAP; [C/Fe] is calculated as (ASPCAP [C/M])+param_metals
--/T <li> n_fe real NOT NULL,           -- empirically calibrated [N/Fe] from ASPCAP; [N/Fe] is calculated as (ASPCAP [N/M])+param_metals
--/T <li> o_fe real NOT NULL,           -- empirically calibrated [O/Fe] from ASPCAP; [O/Fe] is calculated as (ASPCAP [O/M])+param_metals
--/T <li> na_fe real NOT NULL,          -- empirically calibrated [Na/Fe] from ASPCAP
--/T <li> mg_fe real NOT NULL,          -- empirically calibrated [Mg/Fe] from ASPCAP; [Mg/Fe] is calculated as (ASPCAP [Mg/M])+param_metals
--/T <li> al_fe real NOT NULL,          -- empirically calibrated [Al/Fe] from ASPCAP
--/T <li> si_fe real NOT NULL,          -- empirically calibrated [Si/Fe] from ASPCAP; [Si/Fe] is calculated as (ASPCAP [Si/M])+param_metals
--/T <li> p_fe real NOT NULL,           -- empirically calibrated [P/Fe] from ASPCAP; [P/Fe] is calculated as (ASPCAP [P/M])+param_metals
--/T <li> s_fe real NOT NULL,           -- empirically calibrated [S/Fe] from ASPCAP; [S/Fe] is calculated as (ASPCAP [S/M])+param_metals
--/T <li> k_fe real NOT NULL,           -- empirically calibrated [K/Fe] from ASPCAP
--/T <li> ca_fe real NOT NULL,          -- empirically calibrated [Ca/Fe] from ASPCAP ; [Ca/Fe] is calculated as (ASPCAP [Ca/M])+param_metals
--/T <li> ti_fe real NOT NULL,          -- empirically calibrated [Ti/Fe] from ASPCAP; [Ti/Fe] is calculated as (ASPCAP [Ti/M])+param_metals
--/T <li> tiii_fe real NOT NULL,        -- empirically calibrated [TiII/Fe] from ASPCAP; [TiII/Fe] is calculated as (ASPCAP [TiII/M])+param_metals
--/T <li> v_fe real NOT NULL,           -- empirically calibrated [V/Fe] from ASPCAP
--/T <li> cr_fe real NOT NULL,          -- empirically calibrated [Cr/Fe] from ASPCAP
--/T <li> mn_fe real NOT NULL,          -- empirically calibrated [Mn/Fe] from ASPCAP
--/T <li> fe_h real NOT NULL,           -- empirically calibrated [Fe/H] from ASPCAP
--/T <li> co_fe real NOT NULL,          -- empirically calibrated [Co/Fe] from ASPCAP
--/T <li> ni_fe real NOT NULL,          -- empirically calibrated [Ni/Fe] from ASPCAP
--/T <li> cu_fe real NOT NULL,          -- empirically calibrated [Cu/Fe] from ASPCAP
--/T <li> ge_fe real NOT NULL,          -- empirically calibrated [Ge/Fe] from ASPCAP
--/T <li> rb_fe real NOT NULL,          -- empirically calibrated [Rb/Fe] from ASPCAP
--/T <li> y_fe real NOT NULL,           -- empirically calibrated [Y/Fe] from ASPCAP
--/T <li> nd_fe real NOT NULL,          -- empirically calibrated [Nd/Fe] from ASPCAP
--/T <br> Sample call to get aspcap element abundances:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from aspcapStar a CROSS APPLY dbo.fAspcapElems( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapElemsAll, fAspcapElemErrs, fAspcapElemFlags
-------------------------------------------------------------
  RETURNS @etab TABLE (
    c_fe real NOT NULL,
    ci_fe real NOT NULL,
    n_fe real NOT NULL,
    o_fe real NOT NULL,
    na_fe real NOT NULL,
    mg_fe real NOT NULL,
    al_fe real NOT NULL,
    si_fe real NOT NULL,
    p_fe real NOT NULL,
    s_fe real NOT NULL,
    k_fe real NOT NULL,
    ca_fe real NOT NULL,
    ti_fe real NOT NULL,
    tiii_fe real NOT NULL,
    v_fe real NOT NULL,
    cr_fe real NOT NULL,
    mn_fe real NOT NULL,
    fe_h real NOT NULL,
    co_fe real NOT NULL,
    ni_fe real NOT NULL,
    cu_fe real NOT NULL,
    ge_fe real NOT NULL,
    rb_fe real NOT NULL,
    y_fe real NOT NULL,
    nd_fe real NOT NULL
  ) AS 
BEGIN
	INSERT @etab
		SELECT 
            c_fe,
            ci_fe,
            n_fe,
            o_fe,
            na_fe,
            mg_fe,
            al_fe,
            si_fe,
            p_fe,
            s_fe,
            k_fe,
            ca_fe,
            ti_fe,
            tiii_fe,
            v_fe,
            cr_fe,
            mn_fe,
            fe_h,
            co_fe,
            ni_fe,
            cu_fe,
            ge_fe,
            rb_fe,
            y_fe,
            nd_fe
		FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapElemErrs' ) 
	DROP FUNCTION fAspcapElemErrs
GO
--
CREATE FUNCTION fAspcapElemErrs (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap element abundance errors.
-------------------------------------------------------------
--/T This function returns the errors associated with APOGEE aspcapStar element abundances for a given aspcap_id.
--/T <p>returned table:
--/T <li> c_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [C/Fe] from ASPCAP
--/T <li> ci_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [CI/Fe] from ASPCAP
--/T <li> n_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [N/Fe] from ASPCAP
--/T <li> o_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [O/Fe] from ASPCAP
--/T <li> na_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Na/Fe] from ASPCAP
--/T <li> mg_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Mg/Fe] from ASPCAP
--/T <li> al_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Al/Fe] from ASPCAP
--/T <li> si_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Si/Fe] from ASPCAP
--/T <li> p_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [P/Fe] from ASPCAP
--/T <li> s_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [S/Fe] from ASPCAP
--/T <li> k_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [K/Fe] from ASPCAP
--/T <li> ca_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Ca/Fe] from ASPCAP
--/T <li> ti_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Ti/Fe] from ASPCAP
--/T <li> tiii_fe_err real NOT NULL,    -- external uncertainty for empirically calibrated [TiII/Fe] from ASPCAP
--/T <li> v_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [V/Fe] from ASPCAP
--/T <li> cr_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Cr/Fe] from ASPCAP
--/T <li> mn_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Mn/Fe] from ASPCAP
--/T <li> fe_h_err real NOT NULL,       -- external uncertainty for empirically calibrated [Fe/H] from ASPCAP
--/T <li> co_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Co/Fe] from ASPCAP
--/T <li> ni_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Ni/Fe] from ASPCAP
--/T <li> cu_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Cu/Fe] from ASPCAP
--/T <li> ge_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Ge/Fe] from ASPCAP
--/T <li> rb_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Rb/Fe] from ASPCAP
--/T <li> y_fe_err real NOT NULL,       -- external uncertainty for empirically calibrated [Y/Fe] from ASPCAP
--/T <li> nd_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Nd/Fe] from ASPCAP
--/T <br> Sample call to get aspcap element abundance errors:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from aspcapStar a CROSS APPLY dbo.fAspcapElemErrs( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapElemsAll, fAspcapElems, fAspcapElemFlags
-------------------------------------------------------------
  RETURNS @etab TABLE (
    c_fe_err real NOT NULL,
    ci_fe_err real NOT NULL,
    n_fe_err real NOT NULL,
    o_fe_err real NOT NULL,
    na_fe_err real NOT NULL,
    mg_fe_err real NOT NULL,
    al_fe_err real NOT NULL,
    si_fe_err real NOT NULL,
    p_fe_err real NOT NULL,
    s_fe_err real NOT NULL,
    k_fe_err real NOT NULL,
    ca_fe_err real NOT NULL,
    ti_fe_err real NOT NULL,
    tiii_fe_err real NOT NULL,
    v_fe_err real NOT NULL,
    cr_fe_err real NOT NULL,
    mn_fe_err real NOT NULL,
    fe_h_err real NOT NULL,
    co_fe_err real NOT NULL,
    ni_fe_err real NOT NULL,
    cu_fe_err real NOT NULL,
    ge_fe_err real NOT NULL,
    rb_fe_err real NOT NULL,
    y_fe_err real NOT NULL,
    nd_fe_err real NOT NULL
  ) AS 
BEGIN
	INSERT @etab
		SELECT 
            c_fe_err,
            ci_fe_err,
            n_fe_err,
            o_fe_err,
            na_fe_err,
            mg_fe_err,
            al_fe_err,
            si_fe_err,
            p_fe_err,
            s_fe_err,
            k_fe_err,
            ca_fe_err,
            ti_fe_err,
            tiii_fe_err,
            v_fe_err,
            cr_fe_err,
            mn_fe_err,
            fe_h_err,
            co_fe_err,
            ni_fe_err,
            cu_fe_err,
            ge_fe_err,
            rb_fe_err,
            y_fe_err,
            nd_fe_err
		FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapElemFlags' ) 
	DROP FUNCTION fAspcapElemFlags
GO
--
CREATE FUNCTION fAspcapElemFlags (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of APOGEE aspcap element abundance flags.
-------------------------------------------------------------
--/T This function returns the flags associated with APOGEE aspcapStar element abundances for a given aspcap_id.
--/T <p>returned table:
--/T <li> c_fe_flag int NOT NULL,       -- ELEMFLAG for C (see http://www.sdss.org/dr12/algorithms/bitmasks/#APOGEE_ELEMFLAG)
--/T <li> ci_fe_flag int NOT NULL,      -- ELEMFLAG for CI
--/T <li> n_fe_flag int NOT NULL,       -- ELEMFLAG for N
--/T <li> o_fe_flag int NOT NULL,       -- ELEMFLAG for O
--/T <li> na_fe_flag int NOT NULL,      -- ELEMFLAG for Na
--/T <li> mg_fe_flag int NOT NULL,      -- ELEMFLAG for Mg
--/T <li> al_fe_flag int NOT NULL,      -- ELEMFLAG for Al
--/T <li> si_fe_flag int NOT NULL,      -- ELEMFLAG for Si
--/T <li> p_fe_flag int NOT NULL,       -- ELEMFLAG for Si
--/T <li> s_fe_flag int NOT NULL,       -- ELEMFLAG for S
--/T <li> k_fe_flag int NOT NULL,       -- ELEMFLAG for K
--/T <li> ca_fe_flag int NOT NULL,      -- ELEMFLAG for Ca
--/T <li> ti_fe_flag int NOT NULL,      -- ELEMFLAG for Ti
--/T <li> tiii_fe_flag int NOT NULL,    -- ELEMFLAG for TiII
--/T <li> v_fe_flag int NOT NULL,       -- ELEMFLAG for V
--/T <li> cr_fe_flag int NOT NULL,      -- ELEMFLAG for Cr
--/T <li> mn_fe_flag int NOT NULL,      -- ELEMFLAG for Mn
--/T <li> fe_h_flag int NOT NULL,       -- ELEMFLAG for Fe
--/T <li> co_fe_flag int NOT NULL,      -- ELEMFLAG for Co
--/T <li> ni_fe_flag int NOT NULL,      -- ELEMFLAG for Ni
--/T <li> cu_fe_flag int NOT NULL,      -- ELEMFLAG for Cu
--/T <li> ge_fe_flag int NOT NULL,      -- ELEMFLAG for Ge
--/T <li> rb_fe_flag int NOT NULL,      -- ELEMFLAG for Rb
--/T <li> y_fe_flag int NOT NULL,       -- ELEMFLAG for Y
--/T <li> nd_fe_flag int NOT NULL,      -- ELEMFLAG for Nd
--/T <br> Sample call to get aspcap element abundance flags:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from aspcapStar a CROSS APPLY dbo.fAspcapElemFlags( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapElems, fAspcapElemErrs, fAspcapElemsAll
-------------------------------------------------------------
  RETURNS @etab TABLE (
    c_fe_flag int NOT NULL,
    ci_fe_flag int NOT NULL,
    n_fe_flag int NOT NULL,
    o_fe_flag int NOT NULL,
    na_fe_flag int NOT NULL,
    mg_fe_flag int NOT NULL,
    al_fe_flag int NOT NULL,
    si_fe_flag int NOT NULL,
    p_fe_flag int NOT NULL,
    s_fe_flag int NOT NULL,
    k_fe_flag int NOT NULL,
    ca_fe_flag int NOT NULL,
    ti_fe_flag int NOT NULL,
    tiii_fe_flag int NOT NULL,
    v_fe_flag int NOT NULL,
    cr_fe_flag int NOT NULL,
    mn_fe_flag int NOT NULL,
    fe_h_flag int NOT NULL,
    co_fe_flag int NOT NULL,
    ni_fe_flag int NOT NULL,
    cu_fe_flag int NOT NULL,
    ge_fe_flag int NOT NULL,
    rb_fe_flag int NOT NULL,
    y_fe_flag int NOT NULL,
    nd_fe_flag int NOT NULL
  ) AS 
BEGIN
	INSERT @etab
		SELECT 
            c_fe_flag,
            ci_fe_flag,
            n_fe_flag,
            o_fe_flag,
            na_fe_flag,
            mg_fe_flag,
            al_fe_flag,
            si_fe_flag,
            p_fe_flag,
            s_fe_flag,
            k_fe_flag,
            ca_fe_flag,
            ti_fe_flag,
            tiii_fe_flag,
            v_fe_flag,
            cr_fe_flag,
            mn_fe_flag,
            fe_h_flag,
            co_fe_flag,
            ni_fe_flag,
            cu_fe_flag,
            ge_fe_flag,
            rb_fe_flag,
            y_fe_flag,
            nd_fe_flag
		FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapFelemsAll' ) 
	DROP FUNCTION fAspcapFelemsAll
GO
--
CREATE FUNCTION fAspcapFelemsAll (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of uncalibrated APOGEE aspcap abundance ratios along with their errors.
-------------------------------------------------------------
--/T This function returns the APOGEE aspcapStar uncalibrated abundance ratios as determined
--/T by the ASPCAP [FERRE] pipeline (abundance windows employed), along with their errors 
--/T for a given aspcap_id.
--/T <p>returned table:
--/T <li> felem_c_m real NOT NULL,              -- original fit [C/M]
--/T <li> felem_c_m_err real NOT NULL,          -- original fit uncertainty [C/M]
--/T <li> felem_ci_m real NOT NULL,             -- original fit [CI/M]
--/T <li> felem_ci_m_err real NOT NULL,         -- original fit uncertainty [CI/M]
--/T <li> felem_n_m real NOT NULL,              -- original fit [N/M]
--/T <li> felem_n_m_err real NOT NULL,          -- original fit uncertainty [N/M]
--/T <li> felem_o_m real NOT NULL,              -- original fit [O/M]
--/T <li> felem_o_m_err real NOT NULL,          -- original fit uncertainty [O/M]
--/T <li> felem_na_h real NOT NULL,             -- original fit [Na/H]
--/T <li> felem_na_h_err real NOT NULL,         -- original fit uncertainty [Na/H]
--/T <li> felem_mg_m real NOT NULL,             -- original fit [Mg/M]
--/T <li> felem_mg_m_err real NOT NULL,         -- original fit uncertainty [Mg/M]
--/T <li> felem_al_h real NOT NULL,             -- original fit [Al/H]
--/T <li> felem_al_h_err real NOT NULL,         -- original fit uncertainty [Al/H]
--/T <li> felem_si_m real NOT NULL,             -- original fit [Si/M]
--/T <li> felem_si_m_err real NOT NULL,         -- original fit uncertainty [Si/M]
--/T <li> felem_p_m real NOT NULL,              -- original fit [P/M]
--/T <li> felem_p_m_err real NOT NULL,          -- original fit uncertainty [P/M]
--/T <li> felem_s_m real NOT NULL,              -- original fit [S/M]
--/T <li> felem_s_m_err real NOT NULL,          -- original fit uncertainty [S/M]
--/T <li> felem_k_h real NOT NULL,              -- original fit [K/H]
--/T <li> felem_k_h_err real NOT NULL,          -- original fit uncertainty [K/H]
--/T <li> felem_ca_m real NOT NULL,             -- original fit [Ca/M]
--/T <li> felem_ca_m_err real NOT NULL,         -- original fit uncertainty [Ca/M]
--/T <li> felem_ti_m real NOT NULL,             -- original fit [Ti/M]
--/T <li> felem_ti_m_err real NOT NULL,         -- original fit uncertainty [Ti/M]
--/T <li> felem_tiii_m real NOT NULL,           -- original fit [TiII/M]
--/T <li> felem_tiii_m_err real NOT NULL,       -- original fit uncertainty [TiII/M]
--/T <li> felem_v_h real NOT NULL,              -- original fit [V/H]
--/T <li> felem_v_h_err real NOT NULL,          -- original fit uncertainty [V/H]
--/T <li> felem_cr_h real NOT NULL,             -- original fit [Cr/H]
--/T <li> felem_cr_h_err real NOT NULL,         -- original fit uncertainty [Cr/H]
--/T <li> felem_mn_h real NOT NULL,             -- original fit [Mn/H]
--/T <li> felem_mn_h_err real NOT NULL,         -- original fit uncertainty [Mn/H]
--/T <li> felem_fe_h real NOT NULL,             -- original fit [Fe/H]
--/T <li> felem_fe_h_err real NOT NULL,         -- original fit uncertainty [Fe/H]
--/T <li> felem_co_h real NOT NULL,             -- original fit [Co/H]
--/T <li> felem_co_h_err real NOT NULL,         -- original fit uncertainty [Co/H]
--/T <li> felem_ni_h real NOT NULL,             -- original fit [Ni/H]
--/T <li> felem_ni_h_err real NOT NULL,         -- original fit uncertainty [Ni/H]
--/T <li> felem_cu_h real NOT NULL,             -- original fit [Cu/H]
--/T <li> felem_cu_h_err real NOT NULL,         -- original fit uncertainty [Cu/H]
--/T <li> felem_ge_h real NOT NULL,             -- original fit [Ge/H]
--/T <li> felem_ge_h_err real NOT NULL,         -- original fit uncertainty [Ge/H]
--/T <li> felem_rb_h real NOT NULL,             -- original fit [Rb/H]
--/T <li> felem_rb_h_err real NOT NULL,         -- original fit uncertainty [Rb/H]
--/T <li> felem_y_h real NOT NULL,              -- original fit [Y/H]
--/T <li> felem_y_h_err real NOT NULL,          -- original fit uncertainty [Y/H]
--/T <li> felem_nd_h real NOT NULL,             -- original fit [Nd/H]
--/T <li> felem_nd_h_err real NOT NULL          -- original fit uncertainty [Nd/H]
--/T <br> Sample call to get aspcap element abundances:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from aspcapStar a CROSS APPLY dbo.fAspcapFelemsAll( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapFelems, fAspcapFelemErrs
-------------------------------------------------------------
  RETURNS @ftab TABLE (
    felem_c_m real NOT NULL,
    felem_c_m_err real NOT NULL,
    felem_ci_m real NOT NULL,
    felem_ci_m_err real NOT NULL,
    felem_n_m real NOT NULL,
    felem_n_m_err real NOT NULL,
    felem_o_m real NOT NULL,
    felem_o_m_err real NOT NULL,
    felem_na_h real NOT NULL,
    felem_na_h_err real NOT NULL,
    felem_mg_m real NOT NULL,
    felem_mg_m_err real NOT NULL,
    felem_al_h real NOT NULL,
    felem_al_h_err real NOT NULL,
    felem_si_m real NOT NULL,
    felem_si_m_err real NOT NULL,
    felem_p_m real NOT NULL,
    felem_p_m_err real NOT NULL,
    felem_s_m real NOT NULL,
    felem_s_m_err real NOT NULL,
    felem_k_h real NOT NULL,
    felem_k_h_err real NOT NULL,
    felem_ca_m real NOT NULL,
    felem_ca_m_err real NOT NULL,
    felem_ti_m real NOT NULL,
    felem_ti_m_err real NOT NULL,
    felem_tiii_m real NOT NULL,
    felem_tiii_m_err real NOT NULL,
    felem_v_h real NOT NULL,
    felem_v_h_err real NOT NULL,
    felem_cr_h real NOT NULL,
    felem_cr_h_err real NOT NULL,
    felem_mn_h real NOT NULL,
    felem_mn_h_err real NOT NULL,
    felem_fe_h real NOT NULL,
    felem_fe_h_err real NOT NULL,
    felem_co_h real NOT NULL,
    felem_co_h_err real NOT NULL,
    felem_ni_h real NOT NULL,
    felem_ni_h_err real NOT NULL,
    felem_cu_h real NOT NULL,
    felem_cu_h_err real NOT NULL,
    felem_ge_h real NOT NULL,
    felem_ge_h_err real NOT NULL,
    felem_rb_h real NOT NULL,
    felem_rb_h_err real NOT NULL,
    felem_y_h real NOT NULL,
    felem_y_h_err real NOT NULL,
    felem_nd_h real NOT NULL,
    felem_nd_h_err real NOT NULL
  ) AS 
BEGIN
	INSERT @ftab
		SELECT 
            felem_c_m,
            felem_c_m_err,
            felem_ci_m,
            felem_ci_m_err,
            felem_n_m,
            felem_n_m_err,
            felem_o_m,
            felem_o_m_err,
            felem_na_h,
            felem_na_h_err,
            felem_mg_m,
            felem_mg_m_err,
            felem_al_h,
            felem_al_h_err,
            felem_si_m,
            felem_si_m_err,
            felem_p_m,
            felem_p_m_err,
            felem_s_m,
            felem_s_m_err,
            felem_k_h,
            felem_k_h_err,
            felem_ca_m,
            felem_ca_m_err,
            felem_ti_m,
            felem_ti_m_err,
            felem_tiii_m,
            felem_tiii_m_err,
            felem_v_h,
            felem_v_h_err,
            felem_cr_h,
            felem_cr_h_err,
            felem_mn_h,
            felem_mn_h_err,
            felem_fe_h,
            felem_fe_h_err,
            felem_co_h,
            felem_co_h_err,
            felem_ni_h,
            felem_ni_h_err,
            felem_cu_h,
            felem_cu_h_err,
            felem_ge_h,
            felem_ge_h_err,
            felem_rb_h,
            felem_rb_h_err,
            felem_y_h,
            felem_y_h_err,
            felem_nd_h,
            felem_nd_h_err
		FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO



--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapFelems' ) 
	DROP FUNCTION fAspcapFelems
GO
--
CREATE FUNCTION fAspcapFelems (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of uncalibrated APOGEE aspcap abundance ratios.
-------------------------------------------------------------
--/T This function returns the APOGEE aspcapStar uncalibrated abundance ratios as determined
--/T by the ASPCAP [FERRE] pipeline (abundance windows employed). 
--/T <p>returned table:
--/T <li> felem_c_m real NOT NULL,      -- original fit [C/M]
--/T <li> felem_ci_m real NOT NULL,     -- original fit [CI/M]
--/T <li> felem_n_m real NOT NULL,      -- original fit [N/M]
--/T <li> felem_o_m real NOT NULL,      -- original fit [O/M]
--/T <li> felem_na_h real NOT NULL,     -- original fit [Na/H]
--/T <li> felem_mg_m real NOT NULL,     -- original fit [Mg/M]
--/T <li> felem_al_h real NOT NULL,     -- original fit [Al/H]
--/T <li> felem_si_m real NOT NULL,     -- original fit [Si/M]
--/T <li> felem_p_m real NOT NULL,      -- original fit [P/M]
--/T <li> felem_s_m real NOT NULL,      -- original fit [S/M]
--/T <li> felem_k_h real NOT NULL,      -- original fit [K/H]
--/T <li> felem_ca_m real NOT NULL,     -- original fit [Ca/M]
--/T <li> felem_ti_m real NOT NULL,     -- original fit [Ti/M]
--/T <li> felem_tiii_m real NOT NULL,   -- original fit [TiII/M]
--/T <li> felem_v_h real NOT NULL,      -- original fit [V/H]
--/T <li> felem_cr_h real NOT NULL,     -- original fit [Cr/H]
--/T <li> felem_mn_h real NOT NULL,     -- original fit [Mn/H]
--/T <li> felem_fe_h real NOT NULL,     -- original fit [Fe/H]
--/T <li> felem_co_h real NOT NULL,     -- original fit [Co/H]
--/T <li> felem_ni_h real NOT NULL,     -- original fit [Ni/H]
--/T <li> felem_cu_h real NOT NULL,     -- original fit [Cu/H]
--/T <li> felem_ge_h real NOT NULL,     -- original fit [Ge/H]
--/T <li> felem_rb_h real NOT NULL,     -- original fit [Rb/H]
--/T <li> felem_y_h real NOT NULL,      -- original fit [Y/H]
--/T <li> felem_nd_h real NOT NULL,     -- original fit [Nd/H]
--/T <br> Sample call to get aspcap element abundances:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from aspcapStar a CROSS APPLY dbo.fAspcapFelems( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapFelemsAll, fAspcapFelemErrs
-------------------------------------------------------------
  RETURNS @ftab TABLE (
    felem_c_m real NOT NULL,
    felem_ci_m real NOT NULL,
    felem_n_m real NOT NULL,
    felem_o_m real NOT NULL,
    felem_na_h real NOT NULL,
    felem_mg_m real NOT NULL,
    felem_al_h real NOT NULL,
    felem_si_m real NOT NULL,
    felem_p_m real NOT NULL,
    felem_s_m real NOT NULL,
    felem_k_h real NOT NULL,
    felem_ca_m real NOT NULL,
    felem_ti_m real NOT NULL,
    felem_tiii_m real NOT NULL,
    felem_v_h real NOT NULL,
    felem_cr_h real NOT NULL,
    felem_mn_h real NOT NULL,
    felem_fe_h real NOT NULL,
    felem_co_h real NOT NULL,
    felem_ni_h real NOT NULL,
    felem_cu_h real NOT NULL,
    felem_ge_h real NOT NULL,
    felem_rb_h real NOT NULL,
    felem_y_h real NOT NULL,
    felem_nd_h real NOT NULL
  ) AS 
BEGIN
	INSERT @ftab
		SELECT 
            felem_c_m,
            felem_ci_m,
            felem_n_m,
            felem_o_m,
            felem_na_h,
            felem_mg_m,
            felem_al_h,
            felem_si_m,
            felem_p_m,
            felem_s_m,
            felem_k_h,
            felem_ca_m,
            felem_ti_m,
            felem_tiii_m,
            felem_v_h,
            felem_cr_h,
            felem_mn_h,
            felem_fe_h,
            felem_co_h,
            felem_ni_h,
            felem_cu_h,
            felem_ge_h,
            felem_rb_h,
            felem_y_h,
            felem_nd_h
		FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO


--======================================================================
IF EXISTS (SELECT name FROM sysobjects 
           WHERE  name = N'fAspcapFelemErrs' ) 
	DROP FUNCTION fAspcapFelemErrs
GO
--
CREATE FUNCTION fAspcapFelemErrs (@aspcap_id VARCHAR(64))
-------------------------------------------------------------
--/H Returns table of errors associated with uncalibrated APOGEE aspcap abundance ratios.
-------------------------------------------------------------
--/T This function returns the errors associated with APOGEE aspcapStar uncalibrated 
--/T abundance ratios as determined by the ASPCAP [FERRE] pipeline (abundance windows 
--/T employed).
--/T <p>returned table:
--/T <li> felem_c_m_err real NOT NULL,          -- original fit uncertainty [C/M]
--/T <li> felem_ci_m_err real NOT NULL,         -- original fit uncertainty [CI/M]
--/T <li> felem_n_m_err real NOT NULL,          -- original fit uncertainty [N/M]
--/T <li> felem_o_m_err real NOT NULL,          -- original fit uncertainty [O/M]
--/T <li> felem_na_h_err real NOT NULL,         -- original fit uncertainty [Na/H]
--/T <li> felem_mg_m_err real NOT NULL,         -- original fit uncertainty [Mg/M]
--/T <li> felem_al_h_err real NOT NULL,         -- original fit uncertainty [Al/H]
--/T <li> felem_si_m_err real NOT NULL,         -- original fit uncertainty [Si/M]
--/T <li> felem_p_m_err real NOT NULL,          -- original fit uncertainty [P/M]
--/T <li> felem_s_m_err real NOT NULL,          -- original fit uncertainty [S/M]
--/T <li> felem_k_h_err real NOT NULL,          -- original fit uncertainty [K/H]
--/T <li> felem_ca_m_err real NOT NULL,         -- original fit uncertainty [Ca/M]
--/T <li> felem_ti_m_err real NOT NULL,         -- original fit uncertainty [Ti/M]
--/T <li> felem_tiii_m_err real NOT NULL,       -- original fit uncertainty [TiII/M]
--/T <li> felem_v_h_err real NOT NULL,          -- original fit uncertainty [V/H]
--/T <li> felem_cr_h_err real NOT NULL,         -- original fit uncertainty [Cr/H]
--/T <li> felem_mn_h_err real NOT NULL,         -- original fit uncertainty [Mn/H]
--/T <li> felem_fe_h_err real NOT NULL,         -- original fit uncertainty [Fe/H]
--/T <li> felem_co_h_err real NOT NULL,         -- original fit uncertainty [Co/H]
--/T <li> felem_ni_h_err real NOT NULL,         -- original fit uncertainty [Ni/H]
--/T <li> felem_cu_h_err real NOT NULL,         -- original fit uncertainty [Cu/H]
--/T <li> felem_ge_h_err real NOT NULL,         -- original fit uncertainty [Ge/H]
--/T <li> felem_rb_h_err real NOT NULL,         -- original fit uncertainty [Rb/H]
--/T <li> felem_y_h_err real NOT NULL,          -- original fit uncertainty [Y/H]
--/T <li> felem_nd_h_err real NOT NULL          -- original fit uncertainty [Nd/H]
--/T <br> Sample call to get aspcap element abundances:
--/T <br><samp>
--/T <br>select TOP 10 a.apstar_id, b.*
--/T <br> from aspcapStar a CROSS APPLY dbo.fAspcapFelemErrs( a.aspcap_id ) b
--/T </samp>
--/T <br>see also fAspcapFelemsAll, fAspcapFelems
-------------------------------------------------------------
  RETURNS @ftab TABLE (
    felem_c_m_err real NOT NULL,
    felem_ci_m_err real NOT NULL,
    felem_n_m_err real NOT NULL,
    felem_o_m_err real NOT NULL,
    felem_na_h_err real NOT NULL,
    felem_mg_m_err real NOT NULL,
    felem_al_h_err real NOT NULL,
    felem_si_m_err real NOT NULL,
    felem_p_m_err real NOT NULL,
    felem_s_m_err real NOT NULL,
    felem_k_h_err real NOT NULL,
    felem_ca_m_err real NOT NULL,
    felem_ti_m_err real NOT NULL,
    felem_tiii_m_err real NOT NULL,
    felem_v_h_err real NOT NULL,
    felem_cr_h_err real NOT NULL,
    felem_mn_h_err real NOT NULL,
    felem_fe_h_err real NOT NULL,
    felem_co_h_err real NOT NULL,
    felem_ni_h_err real NOT NULL,
    felem_cu_h_err real NOT NULL,
    felem_ge_h_err real NOT NULL,
    felem_rb_h_err real NOT NULL,
    felem_y_h_err real NOT NULL,
    felem_nd_h_err real NOT NULL
  ) AS 
BEGIN
	INSERT @ftab
		SELECT 
            felem_c_m_err,
            felem_ci_m_err,
            felem_n_m_err,
            felem_o_m_err,
            felem_na_h_err,
            felem_mg_m_err,
            felem_al_h_err,
            felem_si_m_err,
            felem_p_m_err,
            felem_s_m_err,
            felem_k_h_err,
            felem_ca_m_err,
            felem_ti_m_err,
            felem_tiii_m_err,
            felem_v_h_err,
            felem_cr_h_err,
            felem_mn_h_err,
            felem_fe_h_err,
            felem_co_h_err,
            felem_ni_h_err,
            felem_cu_h_err,
            felem_ge_h_err,
            felem_rb_h_err,
            felem_y_h_err,
            felem_nd_h_err
		FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END
GO

