create table qms_hg_h_hb_indices (
    ------- 
    --/H This table contains the measurements of the CaII-H and Hb indices for an extended sample of quasars. Used to disentangle the influence of the host galaxy in quasar spectra.
    --/T Contains the measurements of the CaII-H and Hb indices for a 
    --/T more comprehensive sample (6439 quasars), selected by having 0.01 < z < 0.8, 
    --/T SN_MEDIAN_ALL > 15, FIRSTCARTON containing 'bhm' in the label, and CLASS = QSO.
    ------- 
    object varchar(16) NOT NULL, --/U  --/D Object name 
    ra float NOT NULL, --/U deg --/D RA of the object 
    dec float NOT NULL, --/U deg --/D DEC of the object 
    catalogid bigint NOT NULL, --/U  --/D SDSS Catalog ID of the object 
    h_index float NOT NULL, --/U Angstrom --/D CaII-H band index 
    hb_index float NOT NULL --/U Angstrom --/D Hb Lick index
);
