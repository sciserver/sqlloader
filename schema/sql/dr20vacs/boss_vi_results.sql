create table boss_vi_results (
    ------- 
    --/H Results from visual inspection of BOSS spectra 
    --/T Catalog of redshifts/classifications/and confidence flags derived from 
    --/T visual inspections of BOSS allepoch spectra, supplemented with ML 
    --/T predictions of pipeline redshift reliability. 
    ------- 
    field int NOT NULL, --/U  --/D SDSS field identifier 
    mjd int NOT NULL, --/U days --/D SDSS MJD - last date the object was observed 
    catalogid bigint NOT NULL, --/U  --/D SDSS unique catalog identifier 
    sdss_id bigint NOT NULL, --/U  --/D SDSS unique object identifer 
    z_pipe real NOT NULL, --/U  --/D True if spectrum was visually inspected 
    has_vi bit NOT NULL, --/U  --/D Pipeline redshift, copied from spAll 
    z_vi real NOT NULL, --/U  --/D Visual inspection redshift, when available 
    z_conf_vi smallint NOT NULL, --/U  --/D The degree of confidence we have on z_vi 
    z_best real NOT NULL, --/U  --/D Best redshift available (from VI when available, from the pipeline otherwise). NaN when z_conf_best < 2 
    z_conf_best smallint NOT NULL, --/U  --/D The degree of confidence we have on z_best 
    class_best varchar(15) NOT NULL, --/U  --/D The best classification for this spectrum 
    z_pipe_reliable bit NOT NULL, --/U  --/D True when z_pipe is correct (via ML classifier) 
    z_best_reliable bit NOT NULL, --/U  --/D True if z_best is reliable, i.e. z_conf_best=3 (when we have a secure VI redshift, or the ML classifier says that z_pipe is reliable) 
);
