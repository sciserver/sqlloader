create table da_dwd_candidates (
    ------- 
    --/H DA double white dwarf binary candidates
    --/T Summarises the result of the analysis 
    --/T to discover DA double white dwarf binary candidates in SDSS-V DR19. 
    --/T We report the SDSS-ID, Gaia DR3 ID, ra, dec, and the RV variability parameter (eta).
    --/T Full details of the target selection, analysis, binary candidates, 
    --/T and the subsequent constraints on the binary population are presented 
    --/T in <a href="https://ui.adsabs.harvard.edu/abs/2026ApJ..1002..207A">Adamane Pallathadka et al. (2026)</a>. 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID of the WD 
    gaia_dr3_id bigint NOT NULL, --/U  --/D Gaia DR3 ID of the WD 
    ra real NOT NULL, --/U deg --/D Right Ascention J2000 
    dec real NOT NULL, --/U deg --/D Declination J2000 
    eta float NOT NULL --/U  --/D Radial Velocity variability parameter 
);
