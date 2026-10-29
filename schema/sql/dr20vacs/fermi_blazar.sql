create table fermi_blazar (
    ------- 
    --/H Multi-component spectral classifications and redshifts for Fermi-LAT blazars observed in SDSS-V DR20. 
    --/T Value-added catalogue (VAC) of 707 Fermi-LAT blazar candidates 
    --/T cross-matched with SDSS-V DR20 BOSS spectroscopy. Each source has been 
    --/T fitted with a multi-component spectral decomposition combining a flexible 
    --/T dual power-law jet continuum, elliptical galaxy templates (SWIRE), and 
    --/T synthetic QSO templates (Temple et al. 2021) over a logarithmic redshift 
    --/T grid z=0.01--5.0. Model selection uses the corrected Akaike Information 
    --/T Criterion (AICc). The catalogue provides improved spectroscopic redshifts, 
    --/T best model classification, optical jet flux fractions, and power-law 
    --/T continuum shape parameters for sources previously misclassified or lacking 
    --/T reliable redshifts in the SDSS pipeline. A reliability flag (Z_FLAG) is 
    --/T included to indicate the confidence level of each fitted redshift and 
    --/T classification. 
    ------- 
    sdss_id bigint NOT NULL, --/U  --/D SDSS-V unique source identifier (sdss_id) from the SDSS-V catalogue database, cross-matched to the 4FGL-DR4 Fermi source. 
    mjd bigint NOT NULL, --/U  --/D Modified Julian Date of the SDSS-V BOSS spectrum used for the multi-component spectral fitting. This is used to uniquely identify the spectrum in cases where multiple spectra exist for a single source. 
    sdss_name varchar(24) NOT NULL, --/U  --/D IAU-format SDSS designation constructed from J2000 right ascension and declination (SDSS JHHMMSS.SS+DDMMSS.S). 
    fgl_name varchar(18) NOT NULL, --/U  --/D 4FGL-DR4 source name from the fourth Fermi-LAT source catalogue data release 4 (Ballet et al. 2023). 
    fgl_class varchar(5) NOT NULL, --/U  --/D Fermi source classification from 4FGL-DR4. Blazar subclasses include bll (BL Lac), fsrq (flat-spectrum radio quasar), and bcu (blazar candidate of unknown type). 
    best_model varchar(100) NOT NULL, --/U  --/D Best-fit spectral model family selected by AICc from six families: Galaxy, QSO, Powerlaw, Powerlaw+Galaxy, Powerlaw+QSO, and Powerlaw+Lines. Powerlaw+Galaxy and pure Powerlaw sources are classified as BL Lac candidates; Powerlaw+QSO and Powerlaw+Lines as FSRQ candidates. Pure Powerlaw sources (7 in DR20) have no spectral features and their redshifts and classifications are unreliable (see Z_FLAG). 
    sdss_class varchar(6) NOT NULL, --/U  --/D Spectroscopic classification from the SDSS-V automated pipeline (GALAXY, QSO, or STAR). Many blazar sources are misclassified as STAR by the SDSS pipeline due to the featureless power-law continuum dominating the spectrum. 
    z_sdss real NOT NULL, --/U  --/D Spectroscopic redshift from the SDSS-V automated pipeline. 
    z_fit float NOT NULL, --/U  --/D Best-fit spectroscopic redshift from the multi-component decomposition, derived from the maximum a posteriori (MAP) estimate over a logarithmic redshift grid z=0.01--5.0 with local refinement within dz=0.15 of the MAP solution. Sources with Z_FLAG > 0 have poorly constrained or unreliable redshifts. 
    z_fit_err float NOT NULL, --/U  --/D 1-sigma uncertainty on Z_fit from the lmfit covariance matrix at the best-fit redshift. A small value indicates the fit is locally well-constrained but does not rule out alternative redshift solutions at other values. 
    rchi2_fit float NOT NULL, --/U  --/D Reduced chi-squared of the best-fit multi-component model, evaluated on the native BOSS wavelength grid using SpectRes resampling. Sources with rchi2_fit > 3 * rchi2_sdss are flagged as poor fits and excluded from this catalogue. 
    rchi2_sdss float NOT NULL, --/U  --/D Reduced chi-squared of the best-fit SDSS pipeline model, as reported in the SDSS-V spectroscopic catalogue. Used as a quality baseline for filtering catastrophic fit failures. 
    jet_fraction float NOT NULL, --/U  --/D Fraction of total optical flux attributed to the jet power-law component at the best-fit redshift, computed as F_jet / (F_jet + F_host), where F_host is the integrated flux of the galaxy or QSO template component. Values near 1.0 indicate a jet-dominated spectrum. For Powerlaw+Lines sources this is an upper limit as the power-law component may absorb a mixture of jet synchrotron and accretion-disc continuum emission. 
    pl_alpha float NOT NULL, --/U  --/D Power-law spectral slope parameter alpha of the jet continuum model F(lambda) proportional to (lambda/lambda_0)^(-alpha). Positive values indicate a redder (steeper) spectrum; negative values a bluer (flatter) spectrum in flux density per unit wavelength. 
    pl_delta float NOT NULL, --/U  --/D Power-law curvature parameter delta controlling the spectral transition between two regimes in the dual power-law jet model. Positive delta produces a spectrum that is flatter at shorter wavelengths and steeper at longer wavelengths. Negative delta produces the opposite. delta=0 recovers a simple single power-law. 
    snr real NOT NULL, --/U  --/D Median signal-to-noise ratio per pixel across all BOSS spectral bands as reported by the SDSS-V pipeline (SN_MEDIAN_ALL). Sources with SNR < 3 are retained in the catalogue but carry lower confidence in their redshift and jet fraction estimates (Z_FLAG=3). 
    z_flag bigint NOT NULL --/U  --/D Redshift and classification reliability flag. Values are: 0 = reliable redshift and classification; 1 = unreliable, featureless power-law spectrum with no spectral anchor for redshift determination (7 sources in DR20) — fitted Z_fit and Jet_Fraction values are retained but should be treaetd with caution; 2 = low-confidence redshift, Powerlaw+Galaxy source at z > 1.8 where the SDSS wavelength coverage provides no strong rest-frame features to anchor the galaxy template; 3 = low spectral quality, SNR < 3, fitted parameters carry greater uncertainty. Users are advised to apply Z_FLAG == 0 for analyses requiring reliable redshifts and classifications.
);
