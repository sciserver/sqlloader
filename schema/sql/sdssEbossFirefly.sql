CREATE TABLE sdssEbossFirefly (
-------------------------------------------------------------------------------------
--/H Contains the measured stellar population parameters for a spectrum.
--
--/T This is a base table containing spectroscopic
--/T information and the results of the FIREFLY fits on
--/T the DR14 speclite spectra observed by SDSS (run2d=26) and eBOSS (run2d=v5_10_0)
--/T This run used the Kroupa, Salpeteror Chabrier stellar initial mass function.
--/T Redshifts used for BOSS and eBOSS plates is the Z_NOQSO version.
----------------------------------------------------------------------------------
SPECOBJID                             bigint   NOT NULL, --/U no unit --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D     --/F SPECOBJID
BESTOBJID                             bigint   NOT NULL, --/U no unit --/D Object ID of photoObj match (position-based)	             --/F BESTOBJID                                   
RUN2D                                 varchar(7)   NOT NULL, --/U no unit --/D version of the 2d reduction pipeline		 	             --/F RUN2D                                                        
RUN1D                                 varchar(7)   NOT NULL, --/U no unit --/D version of the 1d reduction pipeline			             --/F RUN1D            
PLATE  		                          int       NOT NULL, --/U no unit --/D Plate number 									             --/F PLATE  		     
MJD    		                          int       NOT NULL, --/U days    --/D MJD of observation								             --/F MJD    		     
FIBERID		                          int       NOT NULL, --/U no unit --/D Fiber identification number 					             --/F FIBERID		     
PLUG_RA		                          float    NOT NULL, --/U degrees --/D Right ascension of fiber, J2000 				             --/F PLUG_RA		     
PLUG_DEC	                          float    NOT NULL, --/U degrees --/D Declination of fiber, J2000 					             --/F PLUG_DEC	     
Z			                          real     NOT NULL, --/U no unit --/D Best redshift 							 		             --/F Z			     
Z_ERR 		                          real     NOT NULL, --/U no unit --/D Error in redshift  							             	 --/F Z_ERR		     
CLASS                       		  varchar(6)   NOT NULL, --/U no unit --/D Classification in redshift 					                 --/F CLASS 
ZWARNING			int not NULL, --/U no unit --/D Bitmask of warning values; 0 means all is well  --F/ ZWARNING
SN_MEDIAN_ALL                         float NOT NULL, --/U no unit --/D Median signal-to-noise over all good pixels --/F SN_MEDIAN_ALL 
Chabrier_MILES_age_lightW 		      float     NOT NULL, --/U years	    	 --/D light weighted age , Chabrier IMF MILES library 	                   
Chabrier_MILES_age_lightW_up          float     NOT NULL, --/U years    	     --/D light weighted age upper value, Chabrier IMF MILES library  	            
Chabrier_MILES_age_lightW_low         float     NOT NULL, --/U years             --/D light weighted age lower value, Chabrier IMF MILES library              
Chabrier_MILES_metallicity_lightW     float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity, Chabrier IMF MILES library    
Chabrier_MILES_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity upper value, Chabrier IMF MILES library  
Chabrier_MILES_metallicity_lightW_low float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity lower value, Chabrier IMF MILES library  
Chabrier_MILES_stellar_mass 		  float     NOT NULL, --/U solar mass        --/D stellar mass, Chabrier IMF MILES library 									
Chabrier_MILES_stellar_mass_up        float     NOT NULL, --/U solar mass        --/D stellar mass upper value, Chabrier IMF MILES library 	                    
Chabrier_MILES_stellar_mass_low       float     NOT NULL, --/U solar mass        --/D stellar mass lower value, Chabrier IMF MILES library 	                    
Chabrier_MILES_spm_EBV 			      float     NOT NULL, --/U no unit           --/D reddenning fitted, Chabrier IMF MILES library  		                           
Chabrier_MILES_nComponentsSSP         float     NOT NULL, --/U no unit           --/D number of single stellar population components, Chabrier IMF MILES library    
Chabrier_MILES_chi2                   float     NOT NULL, --/U no unit           --/D chi squared, Chabrier IMF MILES library                                       
Chabrier_MILES_ndof                   float     NOT NULL, --/U no unit           --/D number of degrees of freedom, Chabrier IMF MILES library                      
Salpeter_MILES_age_lightW 		      float     NOT NULL, --/U years	    	 --/D light weighted age, Salpeter IMF MILES library 	                   
Salpeter_MILES_age_lightW_up          float     NOT NULL, --/U years    	     --/D light weighted age upper value, Salpeter IMF MILES library           
Salpeter_MILES_age_lightW_low         float     NOT NULL, --/U years             --/D light weighted age lower value, Salpeter IMF MILES library             
Salpeter_MILES_metallicity_lightW     float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity, Salpeter IMF MILES library    
Salpeter_MILES_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity upper value, Salpeter IMF MILES library  
Salpeter_MILES_metallicity_lightW_low float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity lower value, Salpeter IMF MILES library  
Salpeter_MILES_stellar_mass 		  float     NOT NULL, --/U solar mass        --/D stellar mass, Salpeter IMF MILES library 									
Salpeter_MILES_stellar_mass_up        float     NOT NULL, --/U solar mass        --/D stellar mass upper value, Salpeter IMF MILES library 	                    
Salpeter_MILES_stellar_mass_low       float     NOT NULL, --/U solar mass        --/D stellar mass lower value, Salpeter IMF MILES library 	                    
Salpeter_MILES_spm_EBV 			      float     NOT NULL, --/U no unit           --/D reddenning fitted, Salpeter IMF MILES library  		                           
Salpeter_MILES_nComponentsSSP         float     NOT NULL, --/U no unit           --/D number of single stellar population components, Salpeter IMF MILES library    
Salpeter_MILES_chi2                   float     NOT NULL, --/U no unit           --/D chi squared, Salpeter IMF MILES library                                       
Salpeter_MILES_ndof                   float     NOT NULL, --/U no unit           --/D number of degrees of freedom, Salpeter IMF MILES library                      
Kroupa_MILES_age_lightW 		      float     NOT NULL, --/U years	    	 --/D light weighted age, Kroupa IMF MILES library 	                   
Kroupa_MILES_age_lightW_up          float     NOT NULL, --/U years    	         --/D light weighted age upper value, Kroupa IMF MILES library           
Kroupa_MILES_age_lightW_low         float     NOT NULL, --/U years               --/D light weighted age lower value, Kroupa IMF MILES library            
Kroupa_MILES_metallicity_lightW     float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity, Kroupa IMF MILES library
Kroupa_MILES_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity upper value, Kroupa IMF MILES library
Kroupa_MILES_metallicity_lightW_low float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity lower value, Kroupa IMF MILES library
Kroupa_MILES_stellar_mass 		  float     NOT NULL, --/U solar mass            --/D stellar mass, Kroupa IMF MILES library 									
Kroupa_MILES_stellar_mass_up        float     NOT NULL, --/U solar mass          --/D stellar mass upper value, Kroupa IMF MILES library 	                    
Kroupa_MILES_stellar_mass_low       float     NOT NULL, --/U solar mass          --/D stellar mass lower value, Kroupa IMF MILES library 	                    
Kroupa_MILES_spm_EBV 			      float     NOT NULL, --/U no unit           --/D reddenning fitted, Kroupa IMF MILES library  		                       
Kroupa_MILES_nComponentsSSP         float     NOT NULL, --/U no unit             --/D number of single stellar population components, Kroupa IMF MILES library
Kroupa_MILES_chi2                   float     NOT NULL, --/U no unit             --/D chi squared, Kroupa IMF MILES library                                   
Kroupa_MILES_ndof                   float     NOT NULL, --/U no unit             --/D number of degrees of freedom, Kroupa IMF MILES library                  
Chabrier_ELODIE_age_lightW 		      float     NOT NULL, --/U years	    	  --/D light weighted age, Chabrier IMF ELODIE library 	                   
Chabrier_ELODIE_age_lightW_up          float     NOT NULL, --/U years    	      --/D light weighted age upper value, Chabrier IMF ELODIE library  	            
Chabrier_ELODIE_age_lightW_low         float     NOT NULL, --/U years             --/D light weighted age lower value, Chabrier IMF ELODIE library             
Chabrier_ELODIE_metallicity_lightW     float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity, Chabrier IMF ELODIE library    
Chabrier_ELODIE_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity upper value, Chabrier IMF ELODIE library 
Chabrier_ELODIE_metallicity_lightW_low float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity lower value, Chabrier IMF ELODIE library 
Chabrier_ELODIE_stellar_mass_up        float     NOT NULL, --/U solar mass        --/D stellar mass upper value, Chabrier IMF ELODIE library 	                    
Chabrier_ELODIE_stellar_mass_low       float     NOT NULL, --/U solar mass        --/D stellar mass lower value, Chabrier IMF ELODIE library 	                    
Chabrier_ELODIE_spm_EBV 			      float     NOT NULL, --/U no unit        --/D reddenning fitted, Chabrier IMF ELODIE library  		                           
Chabrier_ELODIE_nComponentsSSP         float     NOT NULL, --/U no unit           --/D number of single stellar population components, Chabrier IMF ELODIE library    
Chabrier_ELODIE_chi2                   float     NOT NULL, --/U no unit           --/D chi squared, Chabrier IMF ELODIE library                                       
Chabrier_ELODIE_ndof                   float     NOT NULL, --/U no unit           --/D number of degrees of freedom, Chabrier IMF ELODIE library                      
Salpeter_ELODIE_age_lightW 		      float     NOT NULL, --/U years	    	  --/D light weighted age, Salpeter IMF ELODIE library 	                   
Salpeter_ELODIE_age_lightW_up          float     NOT NULL, --/U years    	      --/D light weighted age upper value, Salpeter IMF ELODIE library  	            
Salpeter_ELODIE_age_lightW_low         float     NOT NULL, --/U years             --/D light weighted age lower value, Salpeter IMF ELODIE library             
Salpeter_ELODIE_metallicity_lightW     float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity, Salpeter IMF ELODIE library    
Salpeter_ELODIE_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity upper value, Salpeter IMF ELODIE library 
Salpeter_ELODIE_metallicity_lightW_low float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity lower value, Salpeter IMF ELODIE library 
Salpeter_ELODIE_stellar_mass 		  float     NOT NULL, --/U solar mass         --/D stellar mass, Salpeter IMF ELODIE library 		
Salpeter_ELODIE_stellar_mass_up        float     NOT NULL, --/U solar mass        --/D stellar mass upper value, Salpeter IMF ELODIE library 	                    
Salpeter_ELODIE_stellar_mass_low       float     NOT NULL, --/U solar mass        --/D stellar mass lower value, Salpeter IMF ELODIE library 	                    
Salpeter_ELODIE_spm_EBV 			      float     NOT NULL, --/U no unit        --/D reddenning fitted, Salpeter IMF ELODIE library  		                           
Salpeter_ELODIE_nComponentsSSP         float     NOT NULL, --/U no unit           --/D number of single stellar population components, Salpeter IMF ELODIE library    
Salpeter_ELODIE_chi2                   float     NOT NULL, --/U no unit           --/D chi squared, Salpeter IMF ELODIE library                                       
Salpeter_ELODIE_ndof                   float     NOT NULL, --/U no unit           --/D number of degrees of freedom, Salpeter IMF ELODIE library                      
Kroupa_ELODIE_age_lightW 		      float     NOT NULL, --/U years	    	  --/D light weighted age, Kroupa IMF ELODIE library 	                   
Kroupa_ELODIE_age_lightW_up          float     NOT NULL, --/U years    	          --/D light weighted age upper value, Kroupa IMF ELODIE library  	            
Kroupa_ELODIE_age_lightW_low         float     NOT NULL, --/U years               --/D light weighted age lower value, Kroupa IMF ELODIE library           
Kroupa_ELODIE_metallicity_lightW     float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity, Kroupa IMF ELODIE library  
Kroupa_ELODIE_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity upper value, Kroupa IMF ELODIE library 
Kroupa_ELODIE_metallicity_lightW_low float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity lower value, Kroupa IMF ELODIE library 
Kroupa_ELODIE_stellar_mass 		  float     NOT NULL, --/U solar mass             --/D stellar mass, Kroupa IMF ELODIE library 									
Kroupa_ELODIE_stellar_mass_up        float     NOT NULL, --/U solar mass          --/D stellar mass upper value, Kroupa IMF ELODIE library 	                  
Kroupa_ELODIE_stellar_mass_low       float     NOT NULL, --/U solar mass          --/D stellar mass lower value, Kroupa IMF ELODIE library 	                  
Kroupa_ELODIE_spm_EBV 			      float     NOT NULL, --/U no unit            --/D reddenning fitted, Kroupa IMF ELODIE library  		                         
Kroupa_ELODIE_nComponentsSSP         float     NOT NULL, --/U no unit             --/D number of single stellar population components, Kroupa IMF ELODIE library  
Kroupa_ELODIE_chi2                   float     NOT NULL, --/U no unit             --/D chi squared, Kroupa IMF ELODIE library                                     
Kroupa_ELODIE_ndof                   float     NOT NULL, --/U no unit             --/D number of degrees of freedom, Kroupa IMF ELODIE library                    
Chabrier_STELIB_age_lightW 		      float     NOT NULL, --/U years	    	  --/D light weighted age, Chabrier IMF STELIB library 	                   
Chabrier_STELIB_age_lightW_up          float     NOT NULL, --/U years    	      --/D light weighted age upper value, Chabrier IMF STELIB library  	            
Chabrier_STELIB_age_lightW_low         float     NOT NULL, --/U years             --/D light weighted age lower value, Chabrier IMF STELIB library             
Chabrier_STELIB_metallicity_lightW     float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity, Chabrier IMF STELIB library    
Chabrier_STELIB_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity upper value, Chabrier IMF STELIB library 
Chabrier_STELIB_metallicity_lightW_low float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity lower value, Chabrier IMF STELIB library 
Chabrier_STELIB_stellar_mass_up        float     NOT NULL, --/U solar mass        --/D stellar mass upper value, Chabrier IMF STELIB library 	                    
Chabrier_STELIB_stellar_mass_low       float     NOT NULL, --/U solar mass        --/D stellar mass lower value, Chabrier IMF STELIB library 	                    
Chabrier_STELIB_spm_EBV 			      float     NOT NULL, --/U no unit        --/D reddenning fitted, Chabrier IMF STELIB library  		                           
Chabrier_STELIB_nComponentsSSP         float     NOT NULL, --/U no unit           --/D number of single stellar population components, Chabrier IMF STELIB library    
Chabrier_STELIB_chi2                   float     NOT NULL, --/U no unit           --/D chi squared, Chabrier IMF STELIB library                                       
Chabrier_STELIB_ndof                   float     NOT NULL, --/U no unit           --/D number of degrees of freedom, Chabrier IMF STELIB library                      
Salpeter_STELIB_age_lightW 		      float     NOT NULL, --/U years	    	  --/D light weighted age, Salpeter IMF STELIB library 	                   
Salpeter_STELIB_age_lightW_up          float     NOT NULL, --/U years    	      --/D light weighted age upper value, Salpeter IMF STELIB library  	            
Salpeter_STELIB_age_lightW_low         float     NOT NULL, --/U years             --/D light weighted age lower value, Salpeter IMF STELIB library             
Salpeter_STELIB_metallicity_lightW     float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity, Salpeter IMF STELIB library    
Salpeter_STELIB_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity upper value, Salpeter IMF STELIB library 
Salpeter_STELIB_metallicity_lightW_low float     NOT NULL, --/U solar metallicity --/D light weighted stellar metallicity lower value, Salpeter IMF STELIB library 
Salpeter_STELIB_stellar_mass_up        float     NOT NULL, --/U solar mass        --/D stellar mass upper value, Salpeter IMF STELIB library 	                    
Salpeter_STELIB_stellar_mass_low       float     NOT NULL, --/U solar mass        --/D stellar mass lower value, Salpeter IMF STELIB library 	                    
Salpeter_STELIB_spm_EBV 			      float     NOT NULL, --/U no unit        --/D reddenning fitted, Salpeter IMF STELIB library  		                           
Salpeter_STELIB_nComponentsSSP         float     NOT NULL, --/U no unit           --/D number of single stellar population components, Salpeter IMF STELIB library    
Salpeter_STELIB_chi2                   float     NOT NULL, --/U no unit           --/D chi squared, Salpeter IMF STELIB library                                       
Salpeter_STELIB_ndof                   float     NOT NULL, --/U no unit           --/D number of degrees of freedom, Salpeter IMF STELIB library                      
Kroupa_STELIB_age_lightW 		     float     NOT NULL, --/U years	    	 	  --/D light weighted age, Kroupa IMF STELIB library 	                   
Kroupa_STELIB_age_lightW_up          float     NOT NULL, --/U years    	     	  --/D light weighted age upper value, Kroupa IMF STELIB library  	            
Kroupa_STELIB_age_lightW_low         float     NOT NULL, --/U years               --/D light weighted age lower value, Kroupa IMF STELIB library           
Kroupa_STELIB_metallicity_lightW     float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity, Kroupa IMF STELIB library 
Kroupa_STELIB_metallicity_lightW_up  float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity upper value, Kroupa IMF STELIB library
Kroupa_STELIB_metallicity_lightW_low float     NOT NULL, --/U solar metallicity   --/D light weighted stellar metallicity lower value, Kroupa IMF STELIB library
Kroupa_STELIB_stellar_mass 		  	 float     NOT NULL, --/U solar mass --/D stellar mass, Kroupa IMF STELIB library 									
Kroupa_STELIB_stellar_mass_up        float     NOT NULL, --/U solar mass          --/D stellar mass upper value, Kroupa IMF STELIB library 	                 
Kroupa_STELIB_stellar_mass_low       float     NOT NULL, --/U solar mass          --/D stellar mass lower value, Kroupa IMF STELIB library 	                 
Kroupa_STELIB_spm_EBV 			     float     NOT NULL, --/U no unit             --/D reddenning fitted, Kroupa IMF STELIB library  		                        
Kroupa_STELIB_nComponentsSSP         float     NOT NULL, --/U no unit             --/D number of single stellar population components, Kroupa IMF STELIB library 
Kroupa_STELIB_chi2                   float     NOT NULL, --/U no unit             --/D chi squared, Kroupa IMF STELIB library                                    
Kroupa_STELIB_ndof                   float     NOT NULL, --/U no unit             --/D number of degrees of freedom, Kroupa IMF STELIB library                   
)
