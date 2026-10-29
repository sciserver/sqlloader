create table da_dwd_rvs (
    ------- 
    --/H Radial Velocities for DA double white dwarf binary candidate observed exposures
    --/T Summarise the result of the analysis 
    --/T to discover DA double white dwarf binary candidates in SDSS-V DR19. 
    --/T We report the SDSS-ID, Gaia DR3 ID, RV, RV error, and observation time
    --/T Full details of the target selection, analysis, binary candidates, 
    --/T and the subsequent constraints on the binary population are presented 
    --/T in <a href="https://ui.adsabs.harvard.edu/abs/2026ApJ..1002..207A">Adamane Pallathadka et al. (2026)</a>.
    ------- 
    exposure_num int NOT NULL, --/U  --/D exposure number as a sequential index 
    sdss_id bigint NOT NULL, --/U  --/D SDSS ID of the WD 
    gaia_dr3_id bigint NOT NULL, --/U  --/D Gaia DR3 ID of the WD 
    rv float NOT NULL, --/U km/s --/D Radial Velocity measured using different SDSS-V exposures 
    erv float NOT NULL, --/U km/s --/D Measured error in the radial velocity 
    tai float NOT NULL --/U s --/D Mid-exposure observation time 
);
