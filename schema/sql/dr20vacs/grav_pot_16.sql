create table GravPot16 (
    ------- 
    --/H Main orbital elements of DR20 stars using GravPot16. 
    --/T Contains the median statistics of 50 ensemble of orbits for each 
    --/T star, integrated over a 3 Gyr timespan. Orbits were computed in a model 
    --/T configuration with bar patterns speed of 41 km/s/kpc 
    --/T (<a href="https://ui.adsabs.harvard.edu/abs/2019MNRAS.488.4552S">Sanders et al. 2019</a>). 
    --/T To the Galactic orbits, we adopt a solar position of R_sun = 8.178 kpc 
    --/T (<a href="https://ui.adsabs.harvard.edu/abs/2019A&A...625L..10G">Gravity Collaboration et al. 2019</a>)
    --/T , Z_sun = 25 pc (<a href="https://ui.adsabs.harvard.edu/abs/2008ApJ...673..864J">Jurić 2008</a>), 
    --/T and solar motion of [U_sun, V_LSR + V_sun, W_sun] = [11.10, 248.5, 7.25] km/s, 
    --/T in line with <a href="https://ui.adsabs.harvard.edu/abs/2011AN....332..461B">Brunthaler et al. 2011</a> 
    --/T and <a href="https://ui.adsabs.harvard.edu/abs/2020ApJ...892...39R">Reid & Brunthaler 2020</a>. 
    --/T We assumed a bar angle of 20 degrees, and a bar mass of 11 billions Solar mass, 
    --/T in line with Fernández Trincado (2017, PhD.-Thesis) and <a href="https://https://ui.adsabs.harvard.edu/abs/2020MNRAS.495.4113F">Fernández-Trincado et al. 2020</a>.
    ------- 
    ids int NOT NULL, --/U  --/D SDSS-5 unique identifier 
    ruwe real NOT NULL, --/U  --/D Renormalised Unit Weight Error 
    peri_c float NOT NULL, --/U kpc --/D Perigalactocentric distance computed using the central values of the observables. 
    apo_c float NOT NULL, --/U kpc --/D Apogalactocentric distance computed using the central values of the observables. 
    zmax_c float NOT NULL, --/U kpc --/D Maximum vertical excursion from the Galactic plane computed using the central values of the observables. 
    eccentricity_c float NOT NULL, --/U  --/D Orbital eccentricity computed using the central values of the observables. 
    ej_c float NOT NULL, --/U x100 km**2/s**2 --/D Orbital Jacobi constant computed using the central values of the observables. 
    emean_c float NOT NULL, --/U x100 km**2/s**2 --/D Mean Total orbital energy computed using the central values of the observables. 
    emin_c float NOT NULL, --/U x100 km**2/s**2 --/D Minimum Total orbital energy computed using the central values of the observables. 
    emax_c float NOT NULL, --/U x100 km**2/s**2 --/D Maximum Total orbital energy computed using the central values of the observables. 
    lxmin_c smallint NOT NULL, --/U x10 km/s kpc --/D Minimum x-component of the angular momentum computed using the central values of the observables. 
    lxmax_c smallint NOT NULL, --/U x10 km/s kpc --/D Maximum x-component of the angular momentum computed using the central values of the observables. 
    lymin_c smallint NOT NULL, --/U x10 km/s kpc --/D Minimum y-component of the angular momentum computed using the central values of the observables. 
    lymax_c smallint NOT NULL, --/U x10 km/s kpc --/D Maximum y-component of the angular momentum computed using the central values of the observables. 
    lzmin_c smallint NOT NULL, --/U x10 km/s kpc --/D Minimum z-component of the angular momentum computed using the central values of the observables. 
    lzmax_c smallint NOT NULL, --/U x10 km/s kpc --/D Maximum z-component of the angular momentum computed using the central values of the observables. 
    lx_mean_c smallint NOT NULL, --/U x10 km/s kpc --/D Mean x-component of the angular momentum computed using the central values of the observables. 
    ly_mean_c smallint NOT NULL, --/U x10 km/s kpc --/D Mean y-component of the angular momentum computed using the central values of the observables. 
    lz_mean_c smallint NOT NULL, --/U x10 km/s kpc --/D Mean z-component of the angular momentum computed using the central values of the observables. 
    peri_ps41 real NOT NULL, --/U kpc --/D Perigalactocentric distance computed using a Monte Carlo approach. 
    error_peri_ps41 real NOT NULL, --/U kpc --/D Error - Perigalactocentric distance computed using a Monte Carlo approach. 
    apo_ps41 real NOT NULL, --/U kpc --/D Apogalactocentric distance computed using a Monte Carlo approach. 
    error_apo_ps41 real NOT NULL, --/U kpc --/D Error - Apogalactocentric distance computed using a Monte Carlo approach. 
    zmax_ps41 real NOT NULL, --/U kpc --/D Maximum vertical excursion from the Galactic plane computed using a Monte Carlo approach. 
    error_zmax_ps41 real NOT NULL, --/U kpc --/D Error - Maximum vertical excursion from the Galactic plane computed using a Monte Carlo approach. 
    e_ps41 real NOT NULL, --/U  --/D Orbital eccentricity computed using a Monte Carlo approach. 
    error_e_ps41 real NOT NULL, --/U  --/D Error - Orbital eccentricity computed using a Monte Carlo approach. 
    ej_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Orbital Jacobi constant computed using a Monte Carlo approach. 
    error_ej_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Orbital Jacobi constant computed using a Monte Carlo approach. 
    emean_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Mean Total orbital energy computed using a Monte Carlo approach. 
    error_emean_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Mean Total orbital energy computed using a Monte Carlo approach. 
    emin_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Minimum Total orbital energy computed using a Monte Carlo approach. 
    error_emin_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Minimum Total orbital energy computed using a Monte Carlo approach. 
    emax_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Maximum Total orbital energy using a Monte Carlo approach. 
    error_emax_ps41 real NOT NULL, --/U x100 km**2/s**2 --/D Error - Maximum Total orbital energy using a Monte Carlo approach. 
    lxmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Minimum x-component of the angular momentum using a Monte Carlo approach. 
    error_lxmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Minimum x-component of the angular momentum using a Monte Carlo approach. 
    lxmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Maximum x-component of the angular momentum using a Monte Carlo approach. 
    error_lxmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Maximum x-component of the angular momentum using a Monte Carlo approach. 
    lymin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Minimum y-component of the angular momentum using a Monte Carlo approach. 
    error_lymin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Minimum y-component of the angular momentum using a Monte Carlo approach. 
    lymax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Maximum y-component of the angular momentum using a Monte Carlo approach. 
    error_lymax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Maximum y-component of the angular momentum using a Monte Carlo approach. 
    lzmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Minimum z-component of the angular momentum using a Monte Carlo approach. 
    error_lzmin_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Minimum z-component of the angular momentum using a Monte Carlo approach. 
    lzmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Maximum z-component of the angular momentum using a Monte Carlo approach. 
    error_lzmax_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Maximum z-component of the angular momentum using a Monte Carlo approach. 
    lxmean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Mean x-component of the angular momentum computed using a Monte Carlo approach. 
    error_lxmean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Mean x-component of the angular momentum computed using a Monte Carlo approach. 
    lymean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Mean y-component of the angular momentum computed using a Monte Carlo approach. 
    error_lymean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Error - Mean y-component of the angular momentum computed using a Monte Carlo approach. 
    lzmean_ps41 real NOT NULL, --/U x10 km/s kpc --/D Mean z-component of the angular momentum computed using a Monte Carlo approach. 
    error_lzmean_ps41 real NOT NULL --/U x10 km/s kpc --/D Error - Mean z-component of the angular momentum computed using a Monte Carlo approach. 
);
