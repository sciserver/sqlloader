-- Create the wiseForced table.

EXEC spSetDefaultFileGroup 'wiseForced'
GO
CREATE TABLE wiseForced (
-------------------------------------------------------------------------------
--/H WISE forced-photometry of SDSS primary sources.
--/T This table contains one entry for each SDSS primary object.
--/T See http://arxiv.org/abs/1410.7397 for the method.
-------------------------------------------------------------------------------
	objID bigint NOT NULL,	--/D Unique SDSS identifier composed from [skyVersion,rerun,run,camcol,field,obj].
	ra float NOT NULL,	--/D SDSS right ascension, J2000 --/U deg
	dec float NOT NULL,	--/D SDSS declination, J2000 --/U deg
	has_wise_phot bit NOT NULL,	--/D Does WISE forced photometry exist for this source?
	x real NOT NULL,	--/D FITS pixel coordinate in the unWISE tile
	y real NOT NULL,	--/D FITS pixel coordinate in the unWISE tile
	treated_as_pointsource bit NOT NULL,	--/D Was this source treated as a point source for photometry purposes?
	coadd_id char(8) NOT NULL,	--/D unWISE tile identification, RRRR[pm]DDD, RRRR = int(10 * RA), DDD = int(10 * Dec), [pm] = sign(Dec), eg 2052p620
	w1_nanomaggies real NOT NULL,	--/D W1 flux. Fluxes are presented in the Vega system, NOT AB. 1 nmgy means Vega mag 22.5 --/U Vega mag
	w1_nanomaggies_ivar real NOT NULL,	--/D Inverse-variance uncertainty for w1_nanomaggies --/U 1/(Vega mag)^2
	w1_mag real NOT NULL,	--/D W1 magnitude. w1_nanomaggies converted to (Vega) magnitudes. --/U Vega mag
	w1_mag_err real NOT NULL,	--/D W1 magnitude uncertainty --/U Vega mag
	w1_prochi2 real NOT NULL,	--/D Profile-weighted chi-squared (goodness of fit)
	w1_pronpix real NOT NULL,	--/D Profile-weighted number of WISE exposures in coadd
	w1_profracflux real NOT NULL,	--/D Profile-weighted fraction of flux coming from other sources; blendedness measure.
	w1_proflux real NOT NULL,	--/D Profile-weighted flux coming from other sources
	w1_npix real NOT NULL,	--/D Number of pixels used in fit
	w2_nanomaggies real NOT NULL,	--/D W2 flux. Fluxes are presented in the Vega system, NOT AB. 1 nmgy means Vega mag 22.5 --/U Vega mag
	w2_nanomaggies_ivar real NOT NULL,	--/D Inverse-variance uncertainty for w2_nanomaggies --/U 1/(Vega mag)^2
	w2_mag real NOT NULL,	--/D W2 magnitude. w2_nanomaggies converted to (Vega) magnitudes. --/U Vega mag
	w2_mag_err real NOT NULL,	--/D W2 magnitude uncertainty --/U Vega mag
	w2_prochi2 real NOT NULL,	--/D Profile-weighted chi-squared (goodness of fit)
	w2_pronpix real NOT NULL,	--/D Profile-weighted number of WISE exposures in coadd
	w2_profracflux real NOT NULL,	--/D Profile-weighted fraction of flux coming from other sources; blendedness measure.
	w2_proflux real NOT NULL,	--/D Profile-weighted flux coming from other sources
	w2_npix real NOT NULL,	--/D Number of pixels used in fit
)
GO

