create table payne4GAIN_summary (
    ------- 
    --/H Summary table of the LTE and NLTE Payne fits of red giant spectra, as well as aspcap raw values, and NLTE corrected aspcap raw values. 
    --/T We trained Payne models on grids of Turbospectrum_NLTE synthetic spectra: 
    --/T one in LTE and one in NLTE, using departure coefficient grids calculated in 
    --/T MULTI. We chi-squared fit the APOGEE DR19 spectra that fall within our 
    --/T training range (according to ASPCAP) and present the results of our fits. 
    --/T We also perform a polynomial fit to the NLTE-LTE corrections, expecting 
    --/T them to vary smoothly with the stellar parameters, and apply them to the 
    --/T aspcap raw values. The aspcap raw values are also packaged with this VAC, 
    --/T for comparison. 
    ------- 
    sdssid bigint NOT NULL, --/U  --/D SDSS-V unique source identifier 
    gaia_dr3_source_id bigint NOT NULL, --/U  --/D GAIA DR 3 unique source identifier 
    aspcap_raw_teff real NOT NULL, --/U K --/D spectroscopic teff from ASPCAP. In ASPCAP, there is a calibration that is applied after this to better agree with photometric temperatures. 
    aspcap_raw_logg real NOT NULL, --/U log(cgs) --/D spectroscopic logg from ASPCAP. In ASPCAP, there is a calibration that is applied after this to better agree with asteroseismic loggs. 
    aspcap_raw_vmicro real NOT NULL, --/U km/s --/D spectroscopic microturbulence from ASPCAP. 
    aspcap_raw_feh real NOT NULL, --/U  --/D spectroscopic [Fe/H] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_raw_cfe real NOT NULL, --/U  --/D spectroscopic [C/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_raw_nfe real NOT NULL, --/U  --/D spectroscopic [N/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_raw_mgfe real NOT NULL, --/U  --/D spectroscopic [Mg/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_mgfe real NOT NULL, --/U  --/D ASPCAP [Mg/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_alfe real NOT NULL, --/U  --/D spectroscopic [Al/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_alfe real NOT NULL, --/U  --/D ASPCAP [Al/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_mnfe real NOT NULL, --/U  --/D spectroscopic [Mn/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_mnfe real NOT NULL, --/U  --/D ASPCAP [Mn/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_nafe real NOT NULL, --/U  --/D spectroscopic [Na/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_nafe real NOT NULL, --/U  --/D ASPCAP [Na/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_cafe real NOT NULL, --/U  --/D spectroscopic [Ca/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_cafe real NOT NULL, --/U  --/D ASPCAP [Ca/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_nife real NOT NULL, --/U  --/D spectroscopic [Ni/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_nife real NOT NULL, --/U  --/D ASPCAP [Ni/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_tife real NOT NULL, --/U  --/D spectroscopic [Ti/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_tife real NOT NULL, --/U  --/D ASPCAP [Ti/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_sife real NOT NULL, --/U  --/D spectroscopic [Si/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_p4gcorr_sife real NOT NULL, --/U  --/D ASPCAP [Si/Fe] with polynomial NLTE correction from Paynes. Logarithmic ratio to solar abundance. 
    aspcap_raw_ofe real NOT NULL, --/U  --/D spectroscopic [O/Fe] from ASPCAP. Logarithmic ratio to solar abundance. 
    aspcap_spectrum_flags int NOT NULL, --/U bitflag --/D Data-level flags from ASPCAP 
    aspcap_result_flags int NOT NULL, --/U bitflag --/D Flags from initial (stellar parameter) fit in ASPCAP 
    aspcap_fe_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Fe/H] 
    aspcap_c_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [C/H] 
    aspcap_n_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [N/H] 
    aspcap_mg_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Mg/H] 
    aspcap_al_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Al/H] 
    aspcap_mn_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Mn/H] 
    aspcap_na_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Na/H] 
    aspcap_ca_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Ca/H] 
    aspcap_ni_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Ni/H] 
    aspcap_ti_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Ti/H] 
    aspcap_si_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [Si/H] 
    aspcap_o_flags int NOT NULL, --/U bitflag --/D Flags from ASPCAP windowed abundance fit for [O/H] 
    p4g_lte_dof int NOT NULL, --/U  --/D Degree of freedom of the LTE payne4GAIN fit. This is the number of unmasked points minus 26 fitting parameters 
    p4g_lte_chi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN fit 
    p4g_lte_teff real NOT NULL, --/U K --/D Teff of the LTE payne4GAIN fit 
    p4g_lte_logg real NOT NULL, --/U log(cgs) --/D logg of the LTE payne4GAIN fit 
    p4g_lte_vmicro real NOT NULL, --/U km/s --/D microturbulence of the LTE payne4GAIN fit 
    p4g_lte_feh real NOT NULL, --/U  --/D [Fe/H] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_cfe real NOT NULL, --/U  --/D [C/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_nfe real NOT NULL, --/U  --/D [N/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_mgfe real NOT NULL, --/U  --/D [Mg/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_alfe real NOT NULL, --/U  --/D [Al/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_mnfe real NOT NULL, --/U  --/D [Mn/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_nafe real NOT NULL, --/U  --/D [Na/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_cafe real NOT NULL, --/U  --/D [Ca/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_nife real NOT NULL, --/U  --/D [Ni/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_tife real NOT NULL, --/U  --/D [Ti/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_sife real NOT NULL, --/U  --/D [Si/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_ofe real NOT NULL, --/U  --/D [O/Fe] of the LTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_lte_teff_err real NOT NULL, --/U K --/D statistical error of LTE payne4GAIN Teff fit 
    p4g_lte_logg_err real NOT NULL, --/U log(cgs) --/D statistical error of LTE payne4GAIN logg fit 
    p4g_lte_vmicro_err real NOT NULL, --/U km/s --/D statistical error of LTE payne4GAIN microturbulence fit 
    p4g_lte_feh_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Fe/H] fit 
    p4g_lte_cfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [C/Fe] fit 
    p4g_lte_nfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [N/Fe] fit 
    p4g_lte_mgfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Mg/Fe] fit 
    p4g_lte_alfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Al/Fe] fit 
    p4g_lte_mnfe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Mn/Fe] fit 
    p4g_lte_nafe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Na/Fe] fit 
    p4g_lte_cafe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Ca/Fe] fit 
    p4g_lte_nife_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Ni/Fe] fit 
    p4g_lte_tife_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Ti/Fe] fit 
    p4g_lte_sife_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [Si/Fe] fit 
    p4g_lte_ofe_err real NOT NULL, --/U  --/D statistical error of LTE payne4GAIN [O/Fe] fit 
    p4g_lte_cfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [C/Fe] set to the lowest value. 
    p4g_lte_nfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [N/Fe] set to the lowest value. 
    p4g_lte_mgfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Mg/Fe] set to the lowest value. 
    p4g_lte_alfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Al/Fe] set to the lowest value. 
    p4g_lte_mnfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Mn/Fe] set to the lowest value. 
    p4g_lte_nafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Na/Fe] set to the lowest value. 
    p4g_lte_cafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Ca/Fe] set to the lowest value. 
    p4g_lte_nife_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Ni/Fe] set to the lowest value. 
    p4g_lte_tife_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Ti/Fe] set to the lowest value. 
    p4g_lte_sife_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [Si/Fe] set to the lowest value. 
    p4g_lte_ofe_uchi2 real NOT NULL, --/U  --/D chi-2 of the LTE payne4GAIN model with [O/Fe] set to the lowest value. 
    p4g_nlte_dof int NOT NULL, --/U  --/D Degree of freedom of the NLTE payne4GAIN fit. This is the number of unmasked points minus 26 fitting parameters 
    p4g_nlte_chi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN fit 
    p4g_nlte_teff real NOT NULL, --/U K --/D Teff of the NLTE payne4GAIN fit 
    p4g_nlte_logg real NOT NULL, --/U log(cgs) --/D logg of the NLTE payne4GAIN fit 
    p4g_nlte_vmicro real NOT NULL, --/U km/s --/D microturbulence of the NLTE payne4GAIN fit 
    p4g_nlte_feh real NOT NULL, --/U  --/D [Fe/H] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_cfe real NOT NULL, --/U  --/D [C/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_nfe real NOT NULL, --/U  --/D [N/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_mgfe real NOT NULL, --/U  --/D [Mg/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_alfe real NOT NULL, --/U  --/D [Al/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_mnfe real NOT NULL, --/U  --/D [Mn/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_nafe real NOT NULL, --/U  --/D [Na/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_cafe real NOT NULL, --/U  --/D [Ca/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_nife real NOT NULL, --/U  --/D [Ni/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_tife real NOT NULL, --/U  --/D [Ti/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_sife real NOT NULL, --/U  --/D [Si/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_ofe real NOT NULL, --/U  --/D [O/Fe] of the NLTE payne4GAIN fit. Logarithic ratio to solar abundance. 
    p4g_nlte_teff_err real NOT NULL, --/U K --/D statistical error of NLTE payne4GAIN teff fit 
    p4g_nlte_logg_err real NOT NULL, --/U log(cgs) --/D statistical error of NLTE payne4GAIN logg fit 
    p4g_nlte_vmicro_err real NOT NULL, --/U km/s --/D statistical error of NLTE payne4GAIN microturbulence fit 
    p4g_nlte_feh_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Fe/H] fit 
    p4g_nlte_cfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [C/Fe] fit 
    p4g_nlte_nfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [N/Fe] fit 
    p4g_nlte_mgfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Mg/Fe] fit 
    p4g_nlte_alfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Al/Fe] fit 
    p4g_nlte_mnfe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Mn/Fe] fit 
    p4g_nlte_nafe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Na/Fe] fit 
    p4g_nlte_cafe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Ca/Fe] fit 
    p4g_nlte_nife_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Ni/Fe] fit 
    p4g_nlte_tife_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Ti/Fe] fit 
    p4g_nlte_sife_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [Si/Fe] fit 
    p4g_nlte_ofe_err real NOT NULL, --/U  --/D statistical error of NLTE payne4GAIN [O/Fe] fit 
    p4g_nlte_cfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [C/Fe] set to the lowest value. 
    p4g_nlte_nfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [N/Fe] set to the lowest value. 
    p4g_nlte_mgfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Mg/Fe] set to the lowest value. 
    p4g_nlte_alfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Al/Fe] set to the lowest value. 
    p4g_nlte_mnfe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Mn/Fe] set to the lowest value. 
    p4g_nlte_nafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Na/Fe] set to the lowest value. 
    p4g_nlte_cafe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Ca/Fe] set to the lowest value. 
    p4g_nlte_nife_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Ni/Fe] set to the lowest value. 
    p4g_nlte_tife_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Ti/Fe] set to the lowest value. 
    p4g_nlte_sife_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [Si/Fe] set to the lowest value. 
    p4g_nlte_ofe_uchi2 real NOT NULL, --/U  --/D chi-2 of the NLTE payne4GAIN model with [O/Fe] set to the lowest value. 
    p4g_lte_teff_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of Teff grid, 0=not on edge 
    p4g_lte_logg_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of logg grid, 0=not on edge 
    p4g_lte_vt_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of vt grid, 0=not on edge 
    p4g_lte_feh_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Fe/H] grid, 0=not on edge 
    p4g_lte_cfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [C/Fe] grid, 0=not on edge 
    p4g_lte_nfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [N/Fe] grid, 0=not on edge 
    p4g_lte_mgfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Mg/Fe] grid, 0=not on edge 
    p4g_lte_alfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Al/Fe] grid, 0=not on edge 
    p4g_lte_mnfe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Mn/Fe] grid, 0=not on edge 
    p4g_lte_nafe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Na/Fe] grid, 0=not on edge 
    p4g_lte_cafe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Ca/Fe] grid, 0=not on edge 
    p4g_lte_nife_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Ni/Fe] grid, 0=not on edge 
    p4g_lte_tife_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Ti/Fe] grid, 0=not on edge 
    p4g_lte_sife_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [Si/Fe] grid, 0=not on edge 
    p4g_lte_ofe_gridflag int NOT NULL, --/U bitflag --/D Flag for LTE fit, 1=on edge of [O/Fe] grid, 0=not on edge 
    p4g_nlte_teff_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of Teff grid, 0=not on edge 
    p4g_nlte_logg_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of logg grid, 0=not on edge 
    p4g_nlte_vt_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of vt grid, 0=not on edge 
    p4g_nlte_feh_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Fe/H] grid, 0=not on edge 
    p4g_nlte_cfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [C/Fe] grid, 0=not on edge 
    p4g_nlte_nfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [N/Fe] grid, 0=not on edge 
    p4g_nlte_mgfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Mg/Fe] grid, 0=not on edge 
    p4g_nlte_alfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Al/Fe] grid, 0=not on edge 
    p4g_nlte_mnfe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Mn/Fe] grid, 0=not on edge 
    p4g_nlte_nafe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Na/Fe] grid, 0=not on edge 
    p4g_nlte_cafe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Ca/Fe] grid, 0=not on edge 
    p4g_nlte_nife_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Ni/Fe] grid, 0=not on edge 
    p4g_nlte_tife_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Ti/Fe] grid, 0=not on edge 
    p4g_nlte_sife_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [Si/Fe] grid, 0=not on edge 
    p4g_nlte_ofe_gridflag int NOT NULL, --/U bitflag --/D Flag for NLTE fit, 1=on edge of [O/Fe] grid, 0=not on edge 
);
