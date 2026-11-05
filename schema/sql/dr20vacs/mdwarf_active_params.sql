create table mdwarf_active_params (
    ------- 
    --/H Spectral subtypes, morphology classes, H-alpha equivalent widths, and 3D Galactic space velocities for K/M dwarfs in SDSS DR20. 
    --/T This VAC compares BOSS spectra of low-mass stars to a set of 536 empirical 
    --/T spectral templates assembled from earlier SDSS optical spectra (Galligan & Lepine 2026, in press), 
    --/T which span a broad range of effective temperatures and metallicities. 
    --/T BOSS spectra are matched to their best-fit templates to assign: 
    --/T (1) a spectral subtype, which range from K5.0-M8.5 with half-subtype resolution, 
    --/T (2) a "morphology class", which range from 0.5 to 12.5 in half-integer steps, 12.5 in half-integer steps, 
    --/T (3) H&alpha; equivalent widths, and 
    --/T (4) calculated UVW velocities relative to the Sun. 
    ------- 
    sdssid int NOT NULL, --/U  --/D SDSS-V unique identifier 
    gaiadr3_source bigint NOT NULL, --/U  --/D Gaia DR3 Source ID 
    u float NOT NULL, --/U km/s --/D Velocity toward/away the Galactic center 
    v float NOT NULL, --/U km/s --/D Rotational velocity around the Galactic center 
    vmix float NOT NULL, --/U km/s --/D velocity transformation of Xmix, proxy for angular momentum (<a href="https://doi.org/10.1093/mnras/staa1987">Hunt et al. 2020</a>) 
    w float NOT NULL, --/U km/s --/D Velocity toward/away the North Galactic Pole 
    st real NOT NULL, --/U  --/D numeric spectral subtype 
    mc real NOT NULL, --/U  --/D morphology class 
    ha_ew float NOT NULL --/U Angstroms --/D H-alpha equivalent width 
);
