--=========================================================
--  GalaxyZooTables.sql
--  2010-12-12	Michael Blanton
-----------------------------------------------------------
--  Resolve tables.
-----------------------------------------------------------
-- History:
--* 2011-01-14  Ani: Copied in schema for tables from sas-sql.
--=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zooConfidence')
	DROP TABLE zooConfidence
GO
EXEC spSetDefaultFileGroup 'zooConfidence'
GO
CREATE TABLE zooConfidence (
-----------------------------------------------------------------------------------
--/H Measures of classification confidence from Galaxy Zoo.
--/T Only galaxies with spectra in DR7 are included (those in the zooSpec table).
--/T This information is identical to that in Galaxy Zoo 1 Table 4.
--/T The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the
--/T data release is described in Lintott et al. 2010. Anyone making use of the 
--/T data should cite at least one of these papers in any resulting publications.
-----------------------------------------------------------------------------------
  specobjid bigint NOT NULL, --/D match to DR8 spectrum object
	objid bigint NOT NULL, --/D DR8 ObjID
	dr7objid bigint NOT NULL, --/D DR7 ObjID
  ra real NOT NULL, --/D Right Ascension, J2000 deg
  dec real NOT NULL, --/D Declination, J2000 deg
	rastring varchar(11) NOT NULL, --/D Right ascension in sexagesimal
	decstring varchar(11) NOT NULL, --/D Declination in sexagesimal
	f_unclass_clean float NOT NULL, --/D fraction of galaxies in same bin that are unclassified, clean condition
	f_misclass_clean float NOT NULL, --/D fraction of galaxies in same bin that are misclassified, clean condition
	avcorr_clean float NOT NULL, --/D average bias correction in bin, clean condition
	stdcorr_clean float NOT NULL, --/D std dev of bias corrections in bin, clean condition
	f_misclass_greater float NOT NULL, --/D fraction of galaxies in same bin that are misclassified, greater condition
	avcorr_greater float NOT NULL, --/D average bias correction in bin, greater condition
	stdcorr_greater float NOT NULL --/D std dev of bias corrections in bin, greater condition
)


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zooMirrorBias')
	DROP TABLE zooMirrorBias
GO
EXEC spSetDefaultFileGroup 'zooMirrorBias'
GO
CREATE TABLE zooMirrorBias (
-----------------------------------------------------------------------------------
--/H Results from the bias study using mirrored images from Galaxy Zoo
--/T This information is identical to that in Galaxy Zoo 1 Table 5.
--/T The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the
--/T data release is described in Lintott et al. 2010. Anyone making use of the 
--/T data should cite at least one of these papers in any resulting publications.
-----------------------------------------------------------------------------------
  specobjid bigint NOT NULL, --/D match to DR8 spectrum object
	objid bigint NOT NULL, --/D DR8 ObjID
	dr7objid bigint NOT NULL, --/D DR7 ObjID
  ra real NOT NULL, --/D Right Ascension, J2000 deg
  dec real NOT NULL, --/D Declination, J2000 deg
	rastring varchar(11) NOT NULL, --/D Right ascension in sexagesimal
	decstring varchar(11) NOT NULL, --/D Declination in sexagesimal
	nvote_mr1 int NOT NULL, --/D number of votes, vertical mirroring
	p_el_mr1 float NOT NULL, --/D fraction of votes for elliptical, vertical mirroring
	p_cw_mr1 float NOT NULL, --/D fraction of votes for clockwise spiral, vertical mirroring
	p_acw_mr1 float NOT NULL, --/D fraction of votes for anticlockwise spiral, vertical mirroring
	p_edge_mr1 float NOT NULL, --/D fraction of votes for edge-on disk, vertical mirroring
	p_dk_mr1 float NOT NULL, --/D fraction of votes for don't know, vertical mirroring
	p_mg_mr1 float NOT NULL, --/D fraction of votes for merger, vertical mirroring
	p_cs_mr1 float NOT NULL, --/D fraction of votes for combined spiral, vertical mirroring
	nvote_mr2 int NOT NULL, --/D number of votes, diagonal mirroring
	p_el_mr2 float NOT NULL, --/D fraction of votes for elliptical, diagonal mirroring
	p_cw_mr2 float NOT NULL, --/D fraction of votes for clockwise spiral, diagonal mirroring
	p_acw_mr2 float NOT NULL, --/D fraction of votes for anticlockwise spiral, diagonal mirroring
	p_edge_mr2 float NOT NULL, --/D fraction of votes for edge-on disk, diagonal mirroring
	p_dk_mr2 float NOT NULL, --/D fraction of votes for don't know, diagonal mirroring
	p_mg_mr2 float NOT NULL, --/D fraction of votes for merger, diagonal mirroring
	p_cs_mr2 float NOT NULL --/D fraction of votes for combined spiral, diagonal mirroring

)



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zooMonochromeBias')
	DROP TABLE zooMonochromeBias
GO
EXEC spSetDefaultFileGroup 'zooMonochromeBias'
GO
CREATE TABLE zooMonochromeBias (
-----------------------------------------------------------------------------------
--/H Results from the bias study that introduced monochrome images in Galaxy Zoo.
--/T This information is identical to that in Galaxy Zoo 1 Table 6.
--/T The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the
--/T data release is described in Lintott et al. 2010. Anyone making use of the 
--/T data should cite at least one of these papers in any resulting publications.
-----------------------------------------------------------------------------------
  specobjid bigint NOT NULL, --/D match to DR8 spectrum object
	objid bigint NOT NULL, --/D DR8 ObjID
	dr7objid bigint NOT NULL, --/D DR7 ObjID
  ra real NOT NULL, --/D Right Ascension, J2000 deg
  dec real NOT NULL, --/D Declination, J2000 deg
	rastring varchar(11) NOT NULL, --/D Right ascension in sexagesimal
	decstring varchar(11) NOT NULL, --/D Declination in sexagesimal
	nvote_mon int NOT NULL, --/D number of votes, monochrome
	p_el_mon float NOT NULL, --/D fraction of votes for elliptical, monochrome
	p_cw_mon float NOT NULL, --/D fraction of votes for clockwise spiral, monochrome
	p_acw_mon float NOT NULL, --/D fraction of votes for anticlockwise spiral, monochrome
	p_edge_mon float NOT NULL, --/D fraction of votes for edge-on disk, monochrome
	p_dk_mon float NOT NULL, --/D fraction of votes for don't know, monochrome
	p_mg_mon float NOT NULL, --/D fraction of votes for merger, monochrome
	p_cs_mon float NOT NULL --/D fraction of votes for combined spiral (cw + acw + edge-on), monochrome
)

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zooNoSpec')
	DROP TABLE zooNoSpec
GO
EXEC spSetDefaultFileGroup 'zooNoSpec'
GO
CREATE TABLE zooNoSpec (
-----------------------------------------------------------------------------------
--/H Morphology classifications of galaxies without spectra from Galaxy Zoo 
--/T This information is identical to that in Galaxy Zoo 1 Table 3. 
--/T Some objects may have spectroscopic matches in DR8 (though they did 
--/T not in DR7) It is not possible to estimate the bias in the sample, and so 
--/T only the fraction of the vote in each of the six categories is given.
--/T The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the
--/T data release is described in Lintott et al. 2010. Anyone making use of the 
--/T data should cite at least one of these papers in any resulting publications.
-----------------------------------------------------------------------------------
  specobjid bigint NOT NULL, --/D match to DR8 spectrum object
	objid bigint NOT NULL, --/D DR8 ObjID
	dr7objid bigint NOT NULL, --/D DR7 ObjID
  ra real NOT NULL, --/D Right Ascension, J2000 deg
  dec real NOT NULL, --/D Declination, J2000 deg
	rastring varchar(11) NOT NULL, --/D Right ascension in sexagesimal
	nvote int NOT NULL, --/D number of votes
	p_el float NOT NULL, --/D fraction of votes for elliptical
	p_cw float NOT NULL, --/D fraction of votes for clockwise spiral
	p_acw float NOT NULL, --/D fraction of votes for anticlockwise spiral
	p_edge float NOT NULL, --/D fraction of votes for edge-on disk
	p_dk float NOT NULL, --/D fraction of votes for don't know
	p_mg float NOT NULL, --/D fraction of votes for merger
	p_cs float NOT NULL --/D fraction of votes for combined spiral - cw + acw + edge-on
)


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zooSpec')
	DROP TABLE zooSpec
GO
EXEC spSetDefaultFileGroup 'zooSpec'
GO
CREATE TABLE zooSpec (
-----------------------------------------------------------------------------------
--/H Morphological classifications of spectroscopic galaxies from Galaxy Zoo
--/T This information is identical to that in Galaxy Zoo 1 Table 2.
--/T This table includes galaxies with spectra in SDSS Data Release 7.
--/T The fraction of the vote in each of the six categories is given, along with 
--/T debiased votes in elliptical and spiral categories and flags identifying 
--/T systems as classified as spiral, elliptical or uncertain.
--/T The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the
--/T data release is described in Lintott et al. 2010. Anyone making use of the 
--/T data should cite at least one of these papers in any resulting publications.
-----------------------------------------------------------------------------------
  specobjid bigint NOT NULL, --/D match to DR8 spectrum object
	objid bigint NOT NULL, --/D DR8 ObjID
	dr7objid bigint NOT NULL, --/D DR7 ObjID
  ra real NOT NULL, --/D Right Ascension, J2000 deg
  dec real NOT NULL, --/D Declination, J2000 deg
	rastring varchar(11) NOT NULL, --/D Right ascension in sexagesimal
	decstring varchar(11) NOT NULL, --/D Declination in sexagesimal
	nvote int NOT NULL, --/D number of votes
	p_el float NOT NULL, --/D fraction of votes for elliptical
	p_cw float NOT NULL, --/D fraction of votes for clockwise spiral
	p_acw float NOT NULL, --/D fraction of votes for anticlockwise spiral
	p_edge float NOT NULL, --/D fraction of votes for edge-on disk
	p_dk float NOT NULL, --/D fraction of votes for don't know
	p_mg float NOT NULL, --/D fraction of votes for merger
	p_cs float NOT NULL, --/D fraction of votes for combined spiral - cw + acw + edge-on
	p_el_debiased float NOT NULL, --/D debiased fraction of votes for elliptical
	p_cs_debiased float NOT NULL, --/D debiased fraction of votes for combined spiral
	spiral int NOT NULL, --/D flag for combined spiral - 1 if debiased spiral fraction > 0.8, 0 otherwise
	elliptical int NOT NULL, --/D flag for elliptical - 1 if debiased elliptical fraction > 0.8, 0 otherwise
	uncertain int NOT NULL --/D flag for uncertain type - 1 if both spiral and elliptical flags are 0
)



--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zooVotes')
	DROP TABLE zooVotes
GO
EXEC spSetDefaultFileGroup 'zooVotes'
GO
CREATE TABLE zooVotes (
-----------------------------------------------------------------------------------
--/H Vote breakdown in Galaxy Zoo results.
--/T Fraction of votes in each of the six categories, combining results from the main 
--/T and bias studies. This information is identical to that in Galaxy Zoo 1 Table 7.
--/T The project is described in Lintott et al., 2008, MNRAS, 389, 1179 and the
--/T data release is described in Lintott et al. 2010. Anyone making use of the 
--/T data should cite at least one of these papers in any resulting publications.
-----------------------------------------------------------------------------------
  specobjid bigint NOT NULL, --/D match to DR8 spectrum object
	objid bigint NOT NULL, --/D DR8 ObjID
	dr7objid bigint NOT NULL, --/D DR7 ObjID
  ra real NOT NULL, --/D Right Ascension, J2000 deg
  dec real NOT NULL, --/D Declination, J2000 deg
	rastring varchar(11) NOT NULL, --/D Right ascension in sexagesimal
	decstring varchar(11) NOT NULL, --/D Declination in sexagesimal
	nvote_tot int NOT NULL, --/D Total votes
	nvote_std int NOT NULL, --/D Total votes for the standard classification
	nvote_mr1 int NOT NULL, --/D Total votes for the vertical mirrored classification
	nvote_mr2 int NOT NULL, --/D Total votes for the diagonally mirrored classification
	nvote_mon int NOT NULL, --/D Total votes for the monochrome classification
	p_el float NOT NULL, --/D Fraction of votes for elliptical
	p_cw float NOT NULL, --/D Fraction of votes for clockwise spiral
	p_acw float NOT NULL, --/D Fraction of votes for anticlockwise spiral
	p_edge float NOT NULL, --/D Fraction of votes for edge-on disk
	p_dk float NOT NULL, --/D Fraction of votes for don't know
	p_mg float NOT NULL, --/D Fraction of votes for merger
	p_cs float NOT NULL --/D Fraction of votes for combined spiral - cw + acw + edge-on
)


--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[GalaxyZooTables.sql]: Galaxy Zoo tables created'
GO
