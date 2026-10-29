create table gyro_age_dwarf (
    ------- 
    --/H Gyrochronology ages for dwarf stars in MWM 
    --/T Gyrochronology ages (rotation based ages) for dwarf stars determined using 
    --/T GPgyro (Lu. et al. 2024) and gyro-interp (Bouma et al. 2023). GPgyro is 
    --/T suitable for stars > 1.5 Gyr, and gyrointerp is suitable for stars < 4 Gyr. 
    ------- 
    source_id bigint NOT NULL, --/U --/D Gaia DR3 source ID  
    sdss_id float NOT NULL, --/U --/D SDSS-V star ID  
    prot float NOT NULL, --/U Days --/D Rotation period measurements  
    prot_survey varchar(6) NOT NULL, --/U --/D Survey that provided the rotation period  
    gyrointerp_age float NOT NULL, --/U Gyr --/D Gyrochronology age output from gyro-interp  
    gyrointerp_age_p float NOT NULL, --/U Gyr --/D +1 sigma from gyro-interp  
    gyrointerp_age_m float NOT NULL, --/U Gyr --/D -1 sigma from gyro-interp  
    gyrointerp_flag varchar(5) NOT NULL, --/U --/D outside of the application limit for gyro-interp (> 4 Gyr) if flag is set  
    gpgyro_age float NOT NULL, --/U Gyr --/D Gyrochronology age output from GPgyro  
    gpgyro_age_p float NOT NULL, --/U Gyr --/D +1 sigma from GPgyro  
    gpgyro_age_m float NOT NULL, --/U Gyr --/D -1 sigma from GPgyro  
    gpgyro_flag varchar(5) NOT NULL, --/U --/D outside of the application limit for GPgyro (< 1.5 Gyr) if flag is set  
);
