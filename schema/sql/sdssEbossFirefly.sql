CREATE TABLE sdssEbossFirefly (
-------------------------------------------------------------------------------------
--/H Contains the measured stellar population parameters for a spectrum.
--
--/T This is a base table containing spectroscopic
--/T information and the results of the FIREFLY fits on
--/T the DR16 speclite spectra observed by SDSS (run2d=26) and BOSS, eBOSS (run2d=v5_13_0),
--/T This run used the Chabrier stellar initial mass function, the MILES and ELODIE libraries.
--/T Redshifts used for BOSS and eBOSS plates is the NOQSO version
----------------------------------------------------------------------------------
SPECOBJID                                                             numeric(20,0)   NOT NULL, --/U no unit --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D     --/F SPECOBJID
RUN2D                                                                 varchar(16)   NOT NULL, --/U no unit --/D version of the 2d reduction pipeline		      --/F RUN2D
RUN1D                                                                 varchar(16)   NOT NULL, --/U no unit --/D version of the 1d reduction pipeline	              --/F RUN1D
PLATE  		                                                      int       NOT NULL, --/U no unit --/D Plate number                                              --/F PLATE
MJD    		                                                      int       NOT NULL, --/U days    --/D MJD of observation					      --/F MJD
FIBERID		                                                      int       NOT NULL, --/U no unit --/D Fiber identification number 			      --/F FIBERID
RA		                                                      float    NOT NULL, --/U degrees --/D Right ascension of fiber, J2000 			      --/F RA
DEC	                                                              float    NOT NULL, --/U degrees --/D Declination of fiber, J2000 				      --/F DEC
Z_NOQSO			                                              real     NOT NULL, --/U no unit --/D Best redshift 					      --/F Z_NOQSO
Z_ERR_NOQSO 		                                              real     NOT NULL, --/U no unit --/D Error in redshift  					      --/F Z_ERR_NOQSO
CLASS_NOQSO                       	                              varchar(16)   NOT NULL, --/U no unit --/D Classification in redshift 			      --/F CLASS_NOQSO
Chabrier_MILES_age_lightW                                             real     NOT NULL, --/U age in years (light weighted)
Chabrier_MILES_age_lightW_up_1sig                                     real     NOT NULL, --/U
Chabrier_MILES_age_lightW_low_1sig                                    real     NOT NULL, --/U
Chabrier_MILES_age_lightW_up_2sig                                     real     NOT NULL, --/U
Chabrier_MILES_age_lightW_low_2sig                                    real     NOT NULL, --/U
Chabrier_MILES_metallicity_lightW                                     real     NOT NULL, --/U  metallicity in solar metallicities (light weighted)
Chabrier_MILES_metallicity_lightW_up_1sig                             real     NOT NULL, --/U 
Chabrier_MILES_metallicity_lightW_low_1sig                            real     NOT NULL, --/U 
Chabrier_MILES_metallicity_lightW_up_2sig                             real     NOT NULL, --/U 
Chabrier_MILES_metallicity_lightW_low_2sig                            real     NOT NULL, --/U 
Chabrier_MILES_age_massW     		                              real     NOT NULL, --/U age in years (mass weighted)
Chabrier_MILES_age_massW_up_1sig                                      real     NOT NULL, --/U 
Chabrier_MILES_age_massW_low_1sig                                     real     NOT NULL, --/U 
Chabrier_MILES_age_massW_up_2sig                                      real     NOT NULL, --/U 
Chabrier_MILES_age_massW_low_2sig                                     real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW                                      real     NOT NULL, --/U metallicity in solar metallicities (mass weighted)
Chabrier_MILES_metallicity_massW_up_1sig                              real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW_low_1sig                             real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW_up_2sig                              real     NOT NULL, --/U 
Chabrier_MILES_metallicity_massW_low_2sig                             real     NOT NULL, --/U 
Chabrier_MILES_total_mass                                             real     NOT NULL, --/U mass in solar mass
Chabrier_MILES_total_mass_up_1sig                                     real     NOT NULL, --/U 
Chabrier_MILES_total_mass_low_1sig                                    real     NOT NULL, --/U 
Chabrier_MILES_total_mass_up_2sig                                     real     NOT NULL, --/U 
Chabrier_MILES_total_mass_low_2sig                                    real     NOT NULL, --/U 
Chabrier_MILES_spm_EBV                                                real     NOT NULL, --/U E(B-V) mag
Chabrier_MILES_nComponentsSSP                                         real     NOT NULL, --/U number of components
Chabrier_ELODIE_age_lightW                                            real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_up_1sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_low_1sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_up_2sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_age_lightW_low_2sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW                                    real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_up_1sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_low_1sig                           real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_up_2sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_lightW_low_2sig                           real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW                                             real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_up_1sig                                     real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_low_1sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_up_2sig                                     real     NOT NULL, --/U 
Chabrier_ELODIE_age_massW_low_2sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW                                     real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_up_1sig                             real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_low_1sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_up_2sig                             real     NOT NULL, --/U 
Chabrier_ELODIE_metallicity_massW_low_2sig                            real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass                                            real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_up_1sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_low_1sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_up_2sig                                    real     NOT NULL, --/U 
Chabrier_ELODIE_total_mass_low_2sig                                   real     NOT NULL, --/U 
Chabrier_ELODIE_spm_EBV                                               real     NOT NULL, --/U 
Chabrier_ELODIE_nComponentsSSP                                        real     NOT NULL, --/U 
)

