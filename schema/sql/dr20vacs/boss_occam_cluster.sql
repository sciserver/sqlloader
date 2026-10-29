create table boss_occam_cluster (
    ------- 
    --/H The BOSS OCCAM cluster summary table provides mean cluster parameters for open clusters. 
    --/T The BOSS OCCAM cluster summary table provides a comprehensive, uniform 
    --/T dataset for open clusters. It contains mean 5-D astrometry from Gaia 
    --/T (<a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a>), 
    --/T age and distance information (<a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    --/T and <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a>), 
    --/T mean orbital parameters calculated using Gala 
    --/T (<a href="https://ui.adsabs.harvard.edu/abs/2017JOSS....2..388P">Adrian M. Price-Whelan 2017</a>), 
    --/T an orbital dynamics code, and mean radial velocities and chemical abundances from MWM/BOSS.
    ------- 
    name varchar(20) NOT NULL, --/U  --/D Open cluster name 
    glon float NOT NULL, --/U deg --/D Galactic longitude 
    glat float NOT NULL, --/U deg --/D Galactic latitude 
    radeg float NOT NULL, --/U deg --/D Right ascension in degrees 
    dedeg float NOT NULL, --/U deg --/D Declination in degrees 
    eh_radius float NOT NULL, --/U deg --/D Total radius of the cluster including tidal tails from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmra float NOT NULL, --/U mas/yr --/D Mean proper motion in RA multiplied by cos(DE) from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmra_err float NOT NULL, --/U mas/yr --/D Standard error of EH_PMRA from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmde float NOT NULL, --/U mas/yr --/D Mean proper motion in DE from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    eh_pmde_err float NOT NULL, --/U mas/yr --/D Standard error in EH_PMDE from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    v_rad float NOT NULL, --/U km/s --/D Mean radial velocity of cluster members 
    v_rad_err float NOT NULL, --/U km/s --/D 1-sigma V_RAD dispersion 
    r_gc_eh float NOT NULL, --/U kpc --/D Distance from the Galactic center using distances from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    r_gc_cav float NOT NULL, --/U kpc --/D Distance from the Galactic center from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    eh_logage float NOT NULL, --/U yr --/D logAge of the cluster from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    cav_logage float NOT NULL, --/U yr --/D logAge of the cluster from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    r_guide float NOT NULL, --/U kpc --/D Guiding Center radius 
    z_height float NOT NULL, --/U kpc --/D Current Z position from orbit calculations 
    z_max float NOT NULL, --/U kpc --/D Maximum Z position from orbit calculations 
    azimuth_angle float NOT NULL, --/U deg --/D Azimuthal angle relative to Galactic center 
    eccentricity float NOT NULL, --/U  --/D Average eccentricity of calculated cluster orbits 
    z_period_avg float NOT NULL, --/U Myr --/D Average period in the Z coordinate 
    radial_period_avg float NOT NULL, --/U Myr --/D Average radial period of the cluster 
    fe_h float NOT NULL, --/U dex --/D Mean [Fe/H] 
    fe_h_err float NOT NULL, --/U dex --/D 1-sigma [Fe/H] dispersion 
    alpha_m float NOT NULL, --/U dex --/D Mean [alpha/M] 
    alpha_m_err float NOT NULL, --/U dex --/D 1-sigma [alpha/M] dispersion 
    num_full_members bigint NOT NULL, --/U  --/D Number of full cluster members (PM, RV and [Fe/H]) 
    num_pmrv_members bigint NOT NULL, --/U  --/D Number of cluster proper motion and radial velocity members 
    occam_qual bigint NOT NULL, --/U  --/D Visual CMD quality Flag; 1: less than 5 stars 2: 5 or more stars 
    cav_qual bigint NOT NULL, --/U  --/D Quality flag from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    eh_dist float NOT NULL, --/U pc --/D Distance from solar neighborhood from <a href="https://ui.adsabs.harvard.edu/abs/2024A%26A...686A..42H">Hunt & Reffert 2024</a> 
    cav_dist float NOT NULL, --/U pc --/D Distance from solar neighborhood from <a href="https://ui.adsabs.harvard.edu/abs/2024AJ....167...12C">Cavallo et al. 2024</a> 
    x float NOT NULL, --/U pc --/D Galactocentric X coordinate 
    y float NOT NULL, --/U pc --/D Galactocentric Y coordinate 
    z float NOT NULL, --/U pc --/D Galactocentric Z coordinate 
);
