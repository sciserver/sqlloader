USE [BestDR18]
GO
/****** Object:  UserDefinedFunction [dbo].[fAspcapElemErrs]    Script Date: 3/8/2023 12:43:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
ALTER FUNCTION [dbo].[fAspcapElemErrs] (@aspcap_id VARCHAR(64))
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
--/T <li> ce_fe_err real NOT NULL,      -- external uncertainty for empirically calibrated [Ce/Fe] from ASPCAP
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
    ce_fe_err real NOT NULL
  ) AS 
BEGIN
	INSERT @etab
	SELECT
      c_fe_err
      ,ci_fe_err
      ,n_fe_err
      ,o_fe_err
      ,na_fe_err
      ,mg_fe_err
      ,al_fe_err
      ,si_fe_err
      ,p_fe_err
      ,s_fe_err
      ,k_fe_err
      ,ca_fe_err
      ,ti_fe_err
      ,tiii_fe_err
      ,v_fe_err
      ,cr_fe_err
      ,mn_fe_err
      ,fe_h_err
      ,co_fe_err
      ,ni_fe_err
      ,cu_fe_err
      ,ce_fe_err
	FROM aspcapStar WHERE aspcap_id = @aspcap_id
  RETURN
  END



