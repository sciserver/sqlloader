--======================================================================
--   galSpecTables.sql
--   2009-12-29 Mike Blanton and Ani Thakar
------------------------------------------------------------------------
--  galSpec Schema for SkyServer  Dec-29-09
------------------------------------------------------------------------
-- History:
--* 2009-12-29  Ani: Adapted from sas-sql.
--* 2011-09-27  Ani: Fixed inst_res and chisq units in galSpecLine
--*             as per PR#1404.
--* 2015-06-11  Ani: Updated description of galSpecExtra table (PR #2329).
------------------------------------------------------------------------

SET NOCOUNT ON;
GO

--=============================================================
IF  EXISTS (SELECT TABLE_NAME 
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_NAME = N'galSpecExtra')
    BEGIN
	DROP TABLE galSpecExtra
    END
GO
--
EXEC spSetDefaultFileGroup 'galSpecExtra'
GO
CREATE TABLE galSpecExtra (
-------------------------------------------------------------------------------
--/H Estimated physical parameters for all galaxies in the MPA-JHU spectroscopic catalogue.
--/T The estimates for stellar mass are derived using the methodology described in Kauffmann
--/T et al (2003), applied to photometric data as described in Salim et al (2007). The star
--/T formation rates are derived as discussed in Brinchmann et al (2004), but the aperture
--/T corrections are done by estimating SFRs from SED fits to the photometry outside the
--/T fiber following the methodology in Salim et al (2007).
-------------------------------------------------------------------------------
specObjID       bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
bptclass			smallint  NOT NULL,  --/D Emission line classification based on the BPT diagram using the methodology described in Brinchmann et al (2004). -1 means unclassifiable, 1 is star-forming, 2 means low S/N star-forming, 3 is composite, 4 AGN (excluding liners) and 5 is a low S/N LINER.  
oh_p2p5				real      NOT NULL,  --/D The 2.5 percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.
oh_p16				real      NOT NULL,  --/D The 16 percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.
oh_p50				real      NOT NULL,  --/D The median estimate of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.
oh_p84				real      NOT NULL,  --/D The 84th percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.
oh_p97p5			real      NOT NULL,  --/D The 97.5 percentile of the Oxygen abundance derived using Charlot & Longhetti models. The values are reported as 12 + Log O/H. See Tremonti et al (2004) and Brinchmann et al (2004) for details.
oh_entropy			real 	  NOT NULL,  --/D The entropy (Sum p*lg(p)) of the PDF of 12 + Log O/H 
lgm_tot_p2p5			real	  NOT NULL,  --/U Log solar masses --/D The 2.5 percentile of the Log total stellar mass PDF using model photometry. 
lgm_tot_p16			real	  NOT NULL,  --/U Log solar masses --/D The 16th percentile of the Log total stellar mass PDF using model photometry. 
lgm_tot_p50			real	  NOT NULL,  --/U Log solar masses --/D The median estimate of the Log total stellar mass PDF using model photometry. 
lgm_tot_p84			real	  NOT NULL,  --/U Log solar masses --/D The 84th percentile of the Log total stellar mass PDF using model photometry. 
lgm_tot_p97p5			real	  NOT NULL,  --/U Log solar masses --/D The 97.5 percentile of the Log total stellar mass PDF using model photometry. 
lgm_fib_p2p5			real	  NOT NULL,  --/U Log solar masses --/D The 2.5 percentile of the Log stellar mass within the fibre PDF using fibre photometry. 
lgm_fib_p16			real	  NOT NULL,  --/U Log solar masses --/D The 16th percentile of the Log stellar mass within the fibre PDF using fibre photometry. 
lgm_fib_p50			real	  NOT NULL,  --/U Log solar masses --/D The median estimate of the Log stellar mass within the fibre PDF using fibre photometry. 
lgm_fib_p84			real	  NOT NULL,  --/U Log solar masses --/D The 84th percentile of the Log stellar mass within the fibre PDF using fibre photometry. 
lgm_fib_p97p5			real	  NOT NULL,  --/U Log solar masses --/D The 97.5 percentile of the Log stellar mass within the fibre PDF using fibre photometry. 
sfr_tot_p2p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 2.5 percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
sfr_tot_p16			real	  NOT NULL,  --/U Log Msun/yr --/D The 16th percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
sfr_tot_p50			real	  NOT NULL,  --/U Log Msun/yr --/D The median estimate of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
sfr_tot_p84			real	  NOT NULL,  --/U Log Msun/yr --/D The 84th percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
sfr_tot_p97p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 97.5 percentile of the Log total SFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
sfr_tot_entropy			real 	  NOT NULL,  --/D The entropy (Sum p*lg(p)) of the PDF of the total SFR 
sfr_fib_p2p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 2.5 percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
sfr_fib_p16			real	  NOT NULL,  --/U Log Msun/yr --/D The 16th percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
sfr_fib_p50			real	  NOT NULL,  --/U Log Msun/yr --/D The median estimate of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
sfr_fib_p84			real	  NOT NULL,  --/U Log Msun/yr --/D The 84th percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
sfr_fib_p97p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 97.5 percentile of the Log SFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
sfr_fib_entropy			real 	  NOT NULL,  --/D The entropy (Sum p*lg(p)) of the PDF of the fiber SFR 
specsfr_tot_p2p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 2.5 percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
specsfr_tot_p16			real	  NOT NULL,  --/U Log Msun/yr --/D The 16th percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
specsfr_tot_p50			real	  NOT NULL,  --/U Log Msun/yr --/D The median estimate of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
specsfr_tot_p84			real	  NOT NULL,  --/U Log Msun/yr --/D The 84th percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
specsfr_tot_p97p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 97.5 percentile of the Log total SPECSFR PDF. This is derived by combining emission line measurements from within the fibre where possible and aperture corrections are done by fitting models ala Gallazzi et al (2005), Salim et al (2007) to the photometry outside the fibre. For those objects where the emission lines within the fibre do not provide an estimate of the SFR, model fits were made to the integrated photometry. 
specsfr_tot_entropy			real 	  NOT NULL,  --/D The entropy (Sum p*lg(p)) of the PDF of the total SPECSFR 
specsfr_fib_p2p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 2.5 percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
specsfr_fib_p16			real	  NOT NULL,  --/U Log Msun/yr --/D The 16th percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
specsfr_fib_p50			real	  NOT NULL,  --/U Log Msun/yr --/D The median estimate of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
specsfr_fib_p84			real	  NOT NULL,  --/U Log Msun/yr --/D The 84th percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
specsfr_fib_p97p5			real	  NOT NULL,  --/U Log Msun/yr --/D The 97.5 percentile of the Log SPECSFR within the fiber PDF. For galaxies of the star-forming class, emission lines were used (c.f. Brinchmann et al 2004) while for others models were fit to the fibre photometry.. 
specsfr_fib_entropy			real 	  NOT NULL,  --/D The entropy (Sum p*lg(p)) of the PDF of the fiber SPECSFR 
)
GO


--=============================================================
IF  EXISTS (SELECT TABLE_NAME 
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_NAME = N'galSpecIndx')
    BEGIN
	DROP TABLE galSpecindx
    END
GO
--
EXEC spSetDefaultFileGroup 'galSpecIndx'
GO
CREATE TABLE galSpecIndx (
-------------------------------------------------------------------------------
--/H Index measurements of spectra from the MPA-JHU spectroscopic catalogue.
--/T For each index, we give our estimate and error bar.  Measurements
--/T performed as described in Brinchmann et al. 2004.
-------------------------------------------------------------------------------
specObjID       bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
lick_cn1                             real  NOT NULL,  --/U mag --/D Restframe index measurement --/F LICK_CN1 
lick_cn1_err                         real  NOT NULL,  --/U mag --/D Error on index measurement --/F LICK_CN1_ERR 
lick_cn1_model                       real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F LICK_CN1_MODEL 
lick_cn1_sub                         real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_CN1_SUB 
lick_cn1_sub_err                     real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F LICK_CN1_SUB_ERR 
lick_cn2                             real  NOT NULL,  --/U mag --/D Restframe index measurement --/F LICK_CN2 
lick_cn2_err                         real  NOT NULL,  --/U mag --/D Error on index measurement --/F LICK_CN2_ERR 
lick_cn2_model                       real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F LICK_CN2_MODEL 
lick_cn2_sub                         real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_CN2_SUB 
lick_cn2_sub_err                     real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F LICK_CN2_SUB_ERR 
lick_ca4227                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_CA4227 
lick_ca4227_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_CA4227_ERR 
lick_ca4227_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_CA4227_MODEL 
lick_ca4227_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_CA4227_SUB 
lick_ca4227_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_CA4227_SUB_ERR 
lick_g4300                           real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_G4300 
lick_g4300_err                       real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_G4300_ERR 
lick_g4300_model                     real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_G4300_MODEL 
lick_g4300_sub                       real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_G4300_SUB 
lick_g4300_sub_err                   real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_G4300_SUB_ERR 
lick_fe4383                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE4383 
lick_fe4383_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE4383_ERR 
lick_fe4383_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE4383_MODEL 
lick_fe4383_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE4383_SUB 
lick_fe4383_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE4383_SUB_ERR 
lick_ca4455                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_CA4455 
lick_ca4455_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_CA4455_ERR 
lick_ca4455_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_CA4455_MODEL 
lick_ca4455_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_CA4455_SUB 
lick_ca4455_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_CA4455_SUB_ERR 
lick_fe4531                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE4531 
lick_fe4531_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE4531_ERR 
lick_fe4531_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE4531_MODEL 
lick_fe4531_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE4531_SUB 
lick_fe4531_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE4531_SUB_ERR 
lick_c4668                           real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_C4668 
lick_c4668_err                       real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_C4668_ERR 
lick_c4668_model                     real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_C4668_MODEL 
lick_c4668_sub                       real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_C4668_SUB 
lick_c4668_sub_err                   real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_C4668_SUB_ERR 
lick_hb                              real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_HB 
lick_hb_err                          real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_HB_ERR 
lick_hb_model                        real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_HB_MODEL 
lick_hb_sub                          real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_HB_SUB 
lick_hb_sub_err                      real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_HB_SUB_ERR 
lick_fe5015                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE5015 
lick_fe5015_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE5015_ERR 
lick_fe5015_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE5015_MODEL 
lick_fe5015_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE5015_SUB 
lick_fe5015_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE5015_SUB_ERR 
lick_mg1                             real  NOT NULL,  --/U mag --/D Restframe index measurement --/F LICK_MG1 
lick_mg1_err                         real  NOT NULL,  --/U mag --/D Error on index measurement --/F LICK_MG1_ERR 
lick_mg1_model                       real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F LICK_MG1_MODEL 
lick_mg1_sub                         real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_MG1_SUB 
lick_mg1_sub_err                     real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F LICK_MG1_SUB_ERR 
lick_mg2                             real  NOT NULL,  --/U mag --/D Restframe index measurement --/F LICK_MG2 
lick_mg2_err                         real  NOT NULL,  --/U mag --/D Error on index measurement --/F LICK_MG2_ERR 
lick_mg2_model                       real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F LICK_MG2_MODEL 
lick_mg2_sub                         real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_MG2_SUB 
lick_mg2_sub_err                     real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F LICK_MG2_SUB_ERR 
lick_mgb                             real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_MGB 
lick_mgb_err                         real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_MGB_ERR 
lick_mgb_model                       real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_MGB_MODEL 
lick_mgb_sub                         real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_MGB_SUB 
lick_mgb_sub_err                     real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_MGB_SUB_ERR 
lick_fe5270                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE5270 
lick_fe5270_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE5270_ERR 
lick_fe5270_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE5270_MODEL 
lick_fe5270_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE5270_SUB 
lick_fe5270_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE5270_SUB_ERR 
lick_fe5335                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE5335 
lick_fe5335_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE5335_ERR 
lick_fe5335_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE5335_MODEL 
lick_fe5335_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE5335_SUB 
lick_fe5335_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE5335_SUB_ERR 
lick_fe5406                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE5406 
lick_fe5406_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE5406_ERR 
lick_fe5406_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE5406_MODEL 
lick_fe5406_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE5406_SUB 
lick_fe5406_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE5406_SUB_ERR 
lick_fe5709                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE5709 
lick_fe5709_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE5709_ERR 
lick_fe5709_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE5709_MODEL 
lick_fe5709_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE5709_SUB 
lick_fe5709_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE5709_SUB_ERR 
lick_fe5782                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_FE5782 
lick_fe5782_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_FE5782_ERR 
lick_fe5782_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_FE5782_MODEL 
lick_fe5782_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_FE5782_SUB 
lick_fe5782_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_FE5782_SUB_ERR 
lick_nad                             real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_NAD 
lick_nad_err                         real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_NAD_ERR 
lick_nad_model                       real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_NAD_MODEL 
lick_nad_sub                         real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_NAD_SUB 
lick_nad_sub_err                     real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_NAD_SUB_ERR 
lick_tio1                            real  NOT NULL,  --/U mag --/D Restframe index measurement --/F LICK_TIO1 
lick_tio1_err                        real  NOT NULL,  --/U mag --/D Error on index measurement --/F LICK_TIO1_ERR 
lick_tio1_model                      real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F LICK_TIO1_MODEL 
lick_tio1_sub                        real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_TIO1_SUB 
lick_tio1_sub_err                    real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F LICK_TIO1_SUB_ERR 
lick_tio2                            real  NOT NULL,  --/U mag --/D Restframe index measurement --/F LICK_TIO2 
lick_tio2_err                        real  NOT NULL,  --/U mag --/D Error on index measurement --/F LICK_TIO2_ERR 
lick_tio2_model                      real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F LICK_TIO2_MODEL 
lick_tio2_sub                        real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_TIO2_SUB 
lick_tio2_sub_err                    real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F LICK_TIO2_SUB_ERR 
lick_hd_a                            real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_HD_A 
lick_hd_a_err                        real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_HD_A_ERR 
lick_hd_a_model                      real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_HD_A_MODEL 
lick_hd_a_sub                        real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_HD_A_SUB 
lick_hd_a_sub_err                    real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_HD_A_SUB_ERR 
lick_hg_a                            real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_HG_A 
lick_hg_a_err                        real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_HG_A_ERR 
lick_hg_a_model                      real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_HG_A_MODEL 
lick_hg_a_sub                        real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_HG_A_SUB 
lick_hg_a_sub_err                    real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_HG_A_SUB_ERR 
lick_hd_f                            real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_HD_F 
lick_hd_f_err                        real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_HD_F_ERR 
lick_hd_f_model                      real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_HD_F_MODEL 
lick_hd_f_sub                        real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_HD_F_SUB 
lick_hd_f_sub_err                    real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_HD_F_SUB_ERR 
lick_hg_f                            real  NOT NULL,  --/U A --/D Restframe index measurement --/F LICK_HG_F 
lick_hg_f_err                        real  NOT NULL,  --/U A --/D Error on index measurement --/F LICK_HG_F_ERR 
lick_hg_f_model                      real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F LICK_HG_F_MODEL 
lick_hg_f_sub                        real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F LICK_HG_F_SUB 
lick_hg_f_sub_err                    real  NOT NULL,  --/U A --/D Error in the above index measurement --/F LICK_HG_F_SUB_ERR 
dtt_caii8498                         real  NOT NULL,  --/U A --/D Restframe index measurement --/F DTT_CAII8498 
dtt_caii8498_err                     real  NOT NULL,  --/U A --/D Error on index measurement --/F DTT_CAII8498_ERR 
dtt_caii8498_model                   real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F DTT_CAII8498_MODEL 
dtt_caii8498_sub                     real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F DTT_CAII8498_SUB 
dtt_caii8498_sub_err                 real  NOT NULL,  --/U A --/D Error in the above index measurement --/F DTT_CAII8498_SUB_ERR 
dtt_caii8542                         real  NOT NULL,  --/U A --/D Restframe index measurement --/F DTT_CAII8542 
dtt_caii8542_err                     real  NOT NULL,  --/U A --/D Error on index measurement --/F DTT_CAII8542_ERR 
dtt_caii8542_model                   real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F DTT_CAII8542_MODEL 
dtt_caii8542_sub                     real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F DTT_CAII8542_SUB 
dtt_caii8542_sub_err                 real  NOT NULL,  --/U A --/D Error in the above index measurement --/F DTT_CAII8542_SUB_ERR 
dtt_caii8662                         real  NOT NULL,  --/U A --/D Restframe index measurement --/F DTT_CAII8662 
dtt_caii8662_err                     real  NOT NULL,  --/U A --/D Error on index measurement --/F DTT_CAII8662_ERR 
dtt_caii8662_model                   real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F DTT_CAII8662_MODEL 
dtt_caii8662_sub                     real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F DTT_CAII8662_SUB 
dtt_caii8662_sub_err                 real  NOT NULL,  --/U A --/D Error in the above index measurement --/F DTT_CAII8662_SUB_ERR 
dtt_mgi8807                          real  NOT NULL,  --/U A --/D Restframe index measurement --/F DTT_MGI8807 
dtt_mgi8807_err                      real  NOT NULL,  --/U A --/D Error on index measurement --/F DTT_MGI8807_ERR 
dtt_mgi8807_model                    real  NOT NULL,  --/U A --/D Index of best fit model spectrum --/F DTT_MGI8807_MODEL 
dtt_mgi8807_sub                      real  NOT NULL,  --/U A --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F DTT_MGI8807_SUB 
dtt_mgi8807_sub_err                  real  NOT NULL,  --/U A --/D Error in the above index measurement --/F DTT_MGI8807_SUB_ERR 
bh_cnb                               real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_CNB 
bh_cnb_err                           real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_CNB_ERR 
bh_cnb_model                         real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_CNB_MODEL 
bh_cnb_sub                           real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_CNB_SUB 
bh_cnb_sub_err                       real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_CNB_SUB_ERR 
bh_hk                                real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_HK 
bh_hk_err                            real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_HK_ERR 
bh_hk_model                          real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_HK_MODEL 
bh_hk_sub                            real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_HK_SUB 
bh_hk_sub_err                        real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_HK_SUB_ERR 
bh_cai                               real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_CAI 
bh_cai_err                           real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_CAI_ERR 
bh_cai_model                         real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_CAI_MODEL 
bh_cai_sub                           real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_CAI_SUB 
bh_cai_sub_err                       real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_CAI_SUB_ERR 
bh_g                                 real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_G 
bh_g_err                             real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_G_ERR 
bh_g_model                           real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_G_MODEL 
bh_g_sub                             real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_G_SUB 
bh_g_sub_err                         real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_G_SUB_ERR 
bh_hb                                real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_HB 
bh_hb_err                            real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_HB_ERR 
bh_hb_model                          real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_HB_MODEL 
bh_hb_sub                            real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_HB_SUB 
bh_hb_sub_err                        real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_HB_SUB_ERR 
bh_mgg                               real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_MGG 
bh_mgg_err                           real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_MGG_ERR 
bh_mgg_model                         real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_MGG_MODEL 
bh_mgg_sub                           real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_MGG_SUB 
bh_mgg_sub_err                       real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_MGG_SUB_ERR 
bh_mh                                real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_MH 
bh_mh_err                            real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_MH_ERR 
bh_mh_model                          real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_MH_MODEL 
bh_mh_sub                            real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_MH_SUB 
bh_mh_sub_err                        real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_MH_SUB_ERR 
bh_fc                                real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_FC 
bh_fc_err                            real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_FC_ERR 
bh_fc_model                          real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_FC_MODEL 
bh_fc_sub                            real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_FC_SUB 
bh_fc_sub_err                        real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_FC_SUB_ERR 
bh_nad                               real  NOT NULL,  --/U mag --/D Restframe index measurement --/F BH_NAD 
bh_nad_err                           real  NOT NULL,  --/U mag --/D Error on index measurement --/F BH_NAD_ERR 
bh_nad_model                         real  NOT NULL,  --/U mag --/D Index of best fit model spectrum --/F BH_NAD_MODEL 
bh_nad_sub                           real  NOT NULL,  --/U mag --/D Restframe index measurement on the data after subtracting all 3-sigma emission lines --/F BH_NAD_SUB 
bh_nad_sub_err                       real  NOT NULL,  --/U mag --/D Error in the above index measurement --/F BH_NAD_SUB_ERR 
d4000                                real  NOT NULL,  --/D 4000AA break, Bruzual (1983) definition --/F D4000 
d4000_err                            real  NOT NULL,  --/D Uncertainty estimate for 4000AA break, Bruzual (1983) definition  --/F D4000_ERR 
d4000_model                          real  NOT NULL,  --/D 4000AA break, Bruzual (1983) definition measured off best-fit CB08 model --/F D4000_MODEL 
d4000_sub                            real  NOT NULL,  --/D 4000AA break, Bruzual (1983) definition after correction for emission lines --/F D4000_SUB 
d4000_sub_err                        real  NOT NULL,  --/D Uncertainty estimate for 4000AA break, Bruzual (1983) definition after correction for emission lines --/F D4000_SUB_ERR 
d4000_n                              real  NOT NULL,  --/D 4000AA break, Balogh et al (1999) definition --/F D4000_N									   
d4000_n_err                          real  NOT NULL,  --/D Uncertainty estimate for 4000AA break, Balogh et al (1999) definition  --/F D4000_N_ERR 					   
d4000_n_model                        real  NOT NULL,  --/D 4000AA break, Balogh et al (1999) definition measured off best-fit CB08 model --/F D4000_N_MODEL 				   
d4000_n_sub                          real  NOT NULL,  --/D 4000AA break, Balogh et al (1999) definition after correction for emission lines --/F D4000_N_SUB 				   
d4000_n_sub_err                      real  NOT NULL,  --/D Uncertainty estimate for 4000AA break, Balogh et al (1999) definition after correction for emission lines --/F D4000_N_SUB_ERR
d4000_red                            real  NOT NULL,  --/D The flux in the red window of the Bruzual (1983) definition of D4000 --/F D4000_RED 
d4000_blue                           real  NOT NULL,  --/D The flux in the blue window of the Bruzual (1983) definition of D4000 --/F D4000_BLUE 
d4000_n_red                          real  NOT NULL,  --/D The flux in the red window of the Balogh et al (1999) definition of D4000  --/F D4000_N_RED 
d4000_n_blue                         real  NOT NULL,  --/D The flux in the blue window of the Balogh et al (1999) definition of D4000   --/F D4000_N_BLUE 
d4000_sub_red                        real  NOT NULL,  --/D The flux in the red window of the Bruzual (1983) definition of D4000 after subtraction of emission lines  --/F D4000_SUB_RED 
d4000_sub_blue                       real  NOT NULL,  --/D The flux in the blue window of the Bruzual (1983) definition of D4000 after subtraction of emission lines --/F D4000_SUB_BLUE 
d4000_n_sub_red                      real  NOT NULL,  --/D The flux in the red window of the Balogh et al (1999) definition of D4000 after subtraction of emission lines  --/F D4000_N_SUB_RED 
d4000_n_sub_blue                     real  NOT NULL,  --/D The flux in the blue window of the Balogh et al (1999)q definition of D4000 after subtraction of emission lines --/F D4000_N_SUB_BLUE 
tauv_model_040                       real  NOT NULL,  --/D Dust attenuation of the best fit Z=0.004 CB08 model         --/F TAUV_MODEL_040 
model_coef_040                       real  NOT NULL,  --/D The scaling coefficients of the best fit Z=0.004 CB08 model --/F MODEL_COEF_040 
model_chisq_040                      real  NOT NULL,  --/D The chi^2 of the best fit Z=0.004 CB08 model                --/F MODEL_CHISQ_040 
tauv_model_080                       real  NOT NULL,  --/D Dust attenuation of the best fit Z=0.008 CB08 model         --/F TAUV_MODEL_080 
model_coef_080                       real  NOT NULL,  --/D The scaling coefficients of the best fit Z=0.008 CB08 model --/F MODEL_COEF_080 
model_chisq_080                      real  NOT NULL,  --/D The chi^2 of the best fit Z=0.008 CB08 model                --/F MODEL_CHISQ_080 
tauv_model_170                       real  NOT NULL,  --/D Dust attenuation of the best fit Z=0.017 CB08 model         --/F TAUV_MODEL_170 
model_coef_170                       real  NOT NULL,  --/D The scaling coefficients of the best fit Z=0.017 CB08 model --/F MODEL_COEF_170 
model_chisq_170                      real  NOT NULL,  --/D The chi^2 of the best fit Z=0.017 CB08 model                --/F MODEL_CHISQ_170 
tauv_model_400                       real  NOT NULL,  --/D Dust attenuation of the best fit Z=0.04 CB08 model         --/F TAUV_MODEL_400 
model_coef_400                       real  NOT NULL,  --/D The scaling coefficients of the best fit Z=0.04 CB08 model --/F MODEL_COEF_400 
model_chisq_400                      real  NOT NULL,  --/D The chi^2 of the best fit Z=0.04 CB08 model                --/F MODEL_CHISQ_400 
best_model_z                         real  NOT NULL,  --/D Metallicity of best fitting (min chisq) model Z = 0.004 / 0.017 / 0.050 (0.2 1.0, 2.5 x solar) --/F BEST_MODEL_Z 
tauv_cont                            real  NOT NULL,  --/D V-band optical depth (TauV = A_V / 1.086) affecting the stars from best fit model (best of 4 Z's) --/F TAUV_CONT 
model_coef                           real  NOT NULL,  --/D Coeficients of best fit model (best of 4 Z's) --/F MODEL_COEF 
model_chisq                          real  NOT NULL,  --/D Reduced chi-squared of best fit model (best of 4 Z's) --/F MODEL_CHISQ 
)
GO


--=============================================================
IF  EXISTS (SELECT TABLE_NAME 
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_NAME = N'galSpecInfo')
    BEGIN
	DROP TABLE galSpecInfo
    END
GO
--
EXEC spSetDefaultFileGroup 'galSpecInfo'
GO
CREATE TABLE galSpecInfo (
-------------------------------------------------------------------------------
--/H General information for the MPA-JHU spectroscopic re-analysis
--/T This table contains one entry per spectroscopic observation
--/T It may be joined with the other galSpec tables with the
--/T measurements, or to specObjAll, using specObjId.  Numbers
--/T given here are for the version of data used by the MPA-JHU
--/T and may not be in perfect agreement with specObjAll.
-------------------------------------------------------------------------------
specObjID       bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
plateid                          smallint  NOT NULL,  --/D Plate number 
mjd                                 [int]  NOT NULL,  --/D Modified Julian Date of plate observation 
fiberid                          smallint  NOT NULL,  --/D Fiber number (1 - 640) 
ra                                   real  NOT NULL,  --/U degrees --/D Right Ascention of drilled fiber position 
dec                                  real  NOT NULL,  --/U degrees --/D Declination of drilled fiber position 
primtarget                       smallint  NOT NULL,  --/D Primary Target Flag (MAIN galaxy = 64) 
sectarget                        smallint  NOT NULL,  --/D Secondary Target Flag (QA = 8) 
targettype                       varchar(32)  NOT NULL,  --/D Text version of primary target (GALAXY/QA/QSO/ROSAT_D) 
spectrotype                      varchar(32)  NOT NULL,  --/D Schlegel classification of spectrum ... code is only run where this is set to "GALAXY" 
subclass                         varchar(32)  NOT NULL,  --/D Schlegel subclass from PCA analysis -- not alwasy correct!! AGN/BROADLINE/STARBURST/STARFORMING 
z                                    real  NOT NULL,  --/D Redshift from Schlegel 
z_err                                real  NOT NULL,  --/D Redshift error 
z_warning                        smallint  NOT NULL,  --/D Bad redshift if this is non-zero -- see Schlegel data model 
v_disp                               real  NOT NULL,  --/U km/s --/D Velocity dispersion from Schlegel 
v_disp_err                           real  NOT NULL,  --/U km/s --/D Velocity dispersion error (negative for invalid fit) 
sn_median                            real  NOT NULL,  --/D Median S/N per pixel of the whole spectrum 
e_bv_sfd                             real  NOT NULL,  --/D E(B-V) of foreground reddening from SFD maps 
release                          varchar(32)  NOT NULL,  --/D Data Release (dr1/dr2/dr3/dr4) 
reliable                        smallint   NOT NULL,  --/D has "reliable" line measurements and physical parameters
)
GO


--=============================================================
IF  EXISTS (SELECT TABLE_NAME 
	FROM INFORMATION_SCHEMA.TABLES 
	WHERE TABLE_NAME = N'galSpecLine')
    BEGIN
	DROP TABLE galSpecLine
    END
GO
--
EXEC spSetDefaultFileGroup 'galSpecLine'
GO
CREATE TABLE galSpecLine (
-------------------------------------------------------------------------------
--/H Emission line measurements from MPA-JHU spectroscopic reanalysis
--/T The table contains one entry per spectroscopic observation derived as 
--/T described in Tremonti et al (2004) and Brinchmann et al (2004).
-------------------------------------------------------------------------------
specObjID       bigint NOT NULL, --/D Unique ID --/K ID_CATALOG
sigma_balmer                         real  NOT NULL,  --/U km/s --/D Velocity dispersion (sigma not FWHM) measured simultaneously in all of the Balmer lines 
sigma_balmer_err                     real  NOT NULL,  --/U km/s --/D Error in the above 
sigma_forbidden                      real  NOT NULL,  --/U km/s --/D Velocity dispersion (sigma not FWHM) measured simultaneously in all the forbidden lines 
sigma_forbidden_err                  real  NOT NULL,  --/U km/s --/D Error in the above 
v_off_balmer                         real  NOT NULL,  --/U km/s --/D Velocity offset of the Balmer lines from the measured redshift 
v_off_balmer_err                     real  NOT NULL,  --/U km/s --/D Error in the above 
v_off_forbidden                      real  NOT NULL,  --/U km/s --/D Velocity offset of the forbidden lines from the measured redshift 
v_off_forbidden_err                  real  NOT NULL,  --/U km/s --/D Error in the above 
oii_3726_cont                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
oii_3726_cont_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
oii_3726_reqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
oii_3726_reqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oii_3726_eqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
oii_3726_eqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oii_3726_flux                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
oii_3726_flux_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
oii_3726_inst_res                    real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
oii_3726_chisq                       real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
oii_3729_cont                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
oii_3729_cont_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
oii_3729_reqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
oii_3729_reqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oii_3729_eqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
oii_3729_eqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oii_3729_flux                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
oii_3729_flux_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
oii_3729_inst_res                    real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
oii_3729_chisq                       real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
neiii_3869_cont                      real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
neiii_3869_cont_err                  real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
neiii_3869_reqw                      real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
neiii_3869_reqw_err                  real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
neiii_3869_eqw                       real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
neiii_3869_eqw_err                   real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
neiii_3869_flux                      real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
neiii_3869_flux_err                  real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
neiii_3869_inst_res                  real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
neiii_3869_chisq                     real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
h_delta_cont                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
h_delta_cont_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
h_delta_reqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
h_delta_reqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_delta_eqw                          real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
h_delta_eqw_err                      real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_delta_flux                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
h_delta_flux_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
h_delta_inst_res                     real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
h_delta_chisq                        real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
h_gamma_cont                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
h_gamma_cont_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
h_gamma_reqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
h_gamma_reqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_gamma_eqw                          real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
h_gamma_eqw_err                      real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_gamma_flux                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
h_gamma_flux_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
h_gamma_inst_res                     real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
h_gamma_chisq                        real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
oiii_4363_cont                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
oiii_4363_cont_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
oiii_4363_reqw                       real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
oiii_4363_reqw_err                   real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oiii_4363_eqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
oiii_4363_eqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oiii_4363_flux                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
oiii_4363_flux_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
oiii_4363_inst_res                   real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
oiii_4363_chisq                      real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
h_beta_cont                          real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
h_beta_cont_err                      real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
h_beta_reqw                          real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
h_beta_reqw_err                      real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_beta_eqw                           real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
h_beta_eqw_err                       real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_beta_flux                          real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
h_beta_flux_err                      real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
h_beta_inst_res                      real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
h_beta_chisq                         real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
oiii_4959_cont                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
oiii_4959_cont_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
oiii_4959_reqw                       real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
oiii_4959_reqw_err                   real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oiii_4959_eqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
oiii_4959_eqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oiii_4959_flux                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
oiii_4959_flux_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
oiii_4959_inst_res                   real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
oiii_4959_chisq                      real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
oiii_5007_cont                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
oiii_5007_cont_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
oiii_5007_reqw                       real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
oiii_5007_reqw_err                   real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oiii_5007_eqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
oiii_5007_eqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oiii_5007_flux                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
oiii_5007_flux_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
oiii_5007_inst_res                      real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
oiii_5007_chisq                      real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
hei_5876_cont                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
hei_5876_cont_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
hei_5876_reqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
hei_5876_reqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
hei_5876_eqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
hei_5876_eqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
hei_5876_flux                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
hei_5876_flux_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
hei_5876_inst_res                    real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
hei_5876_chisq                       real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
oi_6300_cont                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
oi_6300_cont_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
oi_6300_reqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
oi_6300_reqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oi_6300_eqw                          real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
oi_6300_eqw_err                      real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
oi_6300_flux                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
oi_6300_flux_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
oi_6300_inst_res                     real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
oi_6300_chisq                        real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
nii_6548_cont                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
nii_6548_cont_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
nii_6548_reqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
nii_6548_reqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
nii_6548_eqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
nii_6548_eqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
nii_6548_flux                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
nii_6548_flux_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
nii_6548_inst_res                    real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
nii_6548_chisq                       real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
h_alpha_cont                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
h_alpha_cont_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
h_alpha_reqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
h_alpha_reqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_alpha_eqw                          real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
h_alpha_eqw_err                      real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
h_alpha_flux                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
h_alpha_flux_err                     real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
h_alpha_inst_res                     real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
h_alpha_chisq                        real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
nii_6584_cont                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
nii_6584_cont_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
nii_6584_reqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
nii_6584_reqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
nii_6584_eqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
nii_6584_eqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
nii_6584_flux                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
nii_6584_flux_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
nii_6584_inst_res                    real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
nii_6584_chisq                       real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
sii_6717_cont                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
sii_6717_cont_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
sii_6717_reqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
sii_6717_reqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
sii_6717_eqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
sii_6717_eqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
sii_6717_flux                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
sii_6717_flux_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
sii_6717_inst_res                    real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
sii_6717_chisq                       real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
sii_6731_cont                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
sii_6731_cont_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
sii_6731_reqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
sii_6731_reqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
sii_6731_eqw                         real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
sii_6731_eqw_err                     real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
sii_6731_flux                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
sii_6731_flux_err                    real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
sii_6731_inst_res                    real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
sii_6731_chisq                       real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
ariii7135_cont                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Continuum at line center from 200 pixel median smoothing of the emission-line subtracted continuum 
ariii7135_cont_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2/AA --/D Error in the continuum computed from the variance in the band pass  
ariii7135_reqw                       real  NOT NULL,  --/U Ang --/D The equivalent width of the continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative). In this case the continuum comes from a running 200 pixel median and does not properly account for stellar absorption. In general the EQW measurements provide a better measure of the true equivalent width. The purpose of this measurement is to help characterize the stellar absorption effecting the line. (EW_stellar = REQW - EQW) 
ariii7135_reqw_err                   real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
ariii7135_eqw                        real  NOT NULL,  --/U Ang --/D The equivalent width of the CB08 continuum-subtracted emission line computed from straight integration over the bandpasses listed below (emisison is negative) . This properly takes into account stellar absorption. Note that it will not be correct in the case of blended lines (ie NII & H-alpha) -- instead use FLUX/CONT. 
ariii7135_eqw_err                    real  NOT NULL,  --/U Ang --/D Error in the equivalent width described above 
ariii7135_flux                       real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Flux from Gaussian fit to continuum subtracted data. (Note that the fit is done simultaneously to all the lines so de-blending happens automatically) 
ariii7135_flux_err                   real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D Error in the flux  
ariii7135_inst_res                      real  NOT NULL,  --/U km/s --/D Instrumental resolution at the line center (measured for each spectrum from the ARC lamps) 
ariii7135_chisq                      real  NOT NULL,  --/U  --/D Reduced chi-squared of the line fit over the bandpass used for the EW measurement 
oii_sigma                            real  NOT NULL,  --/U km/s --/D The width of the [O II] line in a free fit (ie. not tied to other emission lines) 
oii_flux                             real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D The flux of the [O II] doublet from a free fit. 
oii_flux_err                         real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D The estimated uncertainty on OII_FLUX 
oii_voff                             real  NOT NULL,  --/U km/s --/D The velocity offset of the [O II] doublet from a free fit 
oii_chi2                             real  NOT NULL,  --/D chi^2 of the fit to the [O II] line in free fit 
oiii_sigma                           real  NOT NULL,  --/U km/s --/D The width of the [O III]5007 line in a free fit (ie. not tied to other emission lines) 
oiii_flux                            real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D The flux of the [O III]5007 line from a free fit. 
oiii_flux_err                        real  NOT NULL,  --/U 1e-17 erg/s/cm^2 --/D The estimated uncertainty on OIII_FLUX 
oiii_voff                            real  NOT NULL,  --/U km/s --/D The velocity offset of the [O III]5007 line from a free fit 
oiii_chi2                            real  NOT NULL,  --/D chi^2 of the fit to the [O III]5007 line in free fit 
spectofiber                          real  NOT NULL,  --/D The multiplicative scale factor applied to the original flux and error spectra prior to measurement of the emission lines to improve the spectrophotometric accuracy.  The rescaling insures that a synthetic r-band magnitude computed from the spectrum matches the r-band fiber magnitude measured by the photometric pipeline. 
)
GO


-- revert to primary file group
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[galSpecTables.sql]: galSpec tables and related functions created'
GO
