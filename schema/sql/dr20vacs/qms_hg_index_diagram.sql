create table qms_hg_index_diagram (
    ------- 
    --/H Contains the measurements and products derived for the data sample used in <a href='https://ui.adsabs.harvard.edu/abs/2025MNRAS.543.4272N'>Negrete\net al. 2025</a>.
    --/T Includes the delivered catalog comprising 28 parameters for 3082 quasars, with a single row per object. 
    --/T Each object is easily identified using the RA and DEC coordinates. Details of the sample selection and
    --/T performed analysis are described in <a href='https://ui.adsabs.harvard.edu/abs/2025MNRAS.543.4272N'>Negrete et al. 2025</a>.
    --/T The spectral identifier (SI) is as follows: 
    --/T 0.0 - No emission-line spectra; more likely a retired galaxy 
    --/T 0.1 - Spectra showing strong sky-subtraction residuals 
    --/T 0.2 - Sy2 objects, all at z < 0.5
    --/T 1.0 - Type-1 AGN showing both Ha and Hb BCs 
    --/T 1.1 - Optical spectra with z correction 
    --/T 1.9 - Sy 1.9 spectra without HbBC but with HaBC
    --/T -1.0 - UV spectra with incorrectly assigned z.
    ------- 
    object varchar(16) NOT NULL, --/U  --/D Object name 
    ra float NOT NULL, --/U deg --/D RA of the object 
    dec float NOT NULL, --/U deg --/D DEC of the object 
    catalogid bigint NOT NULL, --/U  --/D SDSS Catalog ID of the object 
    z_tw float NOT NULL, --/U  --/D Redshift used in This Work 
    z float NOT NULL, --/U  --/D Redshift extracted from the DR20 
    g_r float NOT NULL, --/U mag --/D g - r color 
    fcont_5100 float NOT NULL, --/U 10^-17 cm-2 erg s-1 --/D Continuum flux at 5100 AA 
    fcont_5100_err float NOT NULL, --/U 10^-17 cm-2 erg s-1 --/D Continuum flux at 5100 AA error 
    fhb_c4750 float NOT NULL, --/U  --/D Flux ratio of the Hb blue band and the continuum at 4750 AA 
    fcont_6400 float NOT NULL, --/U 10^-17 cm-2 erg s-1 --/D Continuum flux at 6400 AA 
    fblue_fcont float NOT NULL, --/U  --/D Flux ratio of the Ha blue band and the continuum at 6400 AA 
    fred_fcont float NOT NULL, --/U  --/D Flux ratio of the Ha red band and the continuum at 6400 AA 
    h_index float NOT NULL, --/U Angstrom --/D CaII-H band index 
    hb_index float NOT NULL, --/U Angstrom --/D Hb Lick index 
    si float NOT NULL, --/U  --/D Spectral Identifier of the object type 
    family bigint NOT NULL, --/U  --/D Identifier of the AGN-HG dominance AGND=1 INT=2 and HGD=3 
    rfeii float NOT NULL, --/U  --/D Flux ratio of FeII and Hb broad component 
    fwhm_1000 float NOT NULL, --/U km s-1 --/D FWHM of Hb broad component / 1000 
    pop varchar(2) NOT NULL, --/U  --/D Population designation in the Quasar Main Sequence 
    logmbh float NOT NULL, --/U log(Msun) --/D Logarithm of the Black Hole Mass 
    redd float NOT NULL, --/U  --/D Eddington ratio 
    l_bol float NOT NULL, --/U erg s-1 --/D Bolometric luminosity 
    lum_g float NOT NULL, --/U erg s-1 --/D Luminosity of the g band 
    lum_20cm float NOT NULL, --/U erg s-1 --/D Luminosity of the emission at 20 cm 
    rk float NOT NULL, --/U  --/D Modified Kellerman's ratio 
    lum_w3 float NOT NULL, --/U erg s-1 --/D Luminosity of the wise W3 band 
    w1_w2 float NOT NULL, --/U mag --/D W1-W2 Wise color 
    w2_w3 float NOT NULL --/U mag --/D W2-W3 Wise color 
);
