-- Patch for adding the sdssEbosFirefly VAC into BestDR14
-- Create the new table
--===============================================================
-- eBOSS Firefly VAC table (from sas/sql/sdssEbossFoirefly.sql
--===============================================================
if exists (select * from dbo.sysobjects 
	where id = object_id(N'sdssEbossFirefly')) 
	drop table [sdssEbossFirefly]
GO
--
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
SPECOBJID                             numeric(20,0)   NOT NULL, --/U no unit --/D Unique database ID based on PLATE, MJD, FIBERID, RUN2D     --/F SPECOBJID
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
GO

-- Insert the data into the newly created table from the CSV file in C:\Temp
BULK INSERT sdssEbossFirefly
FROM 'C:\Temp\sdssEbossFirefly.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    TABLOCK
)
GO

-- Add sdssEbossFirefly entry to DBObjects
INSERT DBObjects VALUES('sdssEbossFirefly','U','U',' Contains the measured stellar population parameters for a spectrum. ',' This is a base table containing spectroscopic  information and the results of the FIREFLY fits on  the DR14 speclite spectra observed by SDSS (run2d=26) and eBOSS (run2d=v5_10_0)  This run used the Kroupa, Salpeteror Chabrier stellar initial mass function.  Redshifts used for BOSS and eBOSS plates is the Z_NOQSO version. ','0');
GO

-- Add sdssEbossFirefly columns to DBColumns
INSERT DBColumns VALUES('sdssEbossFirefly','SPECOBJID','no unit','','','Unique database ID based on PLATE, MJD, FIBERID, RUN2D','0');
INSERT DBColumns VALUES('sdssEbossFirefly','BESTOBJID','no unit','','','Object ID of photoObj match (position-based)','0');
INSERT DBColumns VALUES('sdssEbossFirefly','RUN2D','no unit','','','version of the 2d reduction pipeline','0');
INSERT DBColumns VALUES('sdssEbossFirefly','RUN1D','no unit','','','version of the 1d reduction pipeline','0');
INSERT DBColumns VALUES('sdssEbossFirefly','PLATE','no unit','','','Plate number','0');
INSERT DBColumns VALUES('sdssEbossFirefly','MJD','days','','','MJD of observation','0');
INSERT DBColumns VALUES('sdssEbossFirefly','FIBERID','no unit','','','Fiber identification number','0');
INSERT DBColumns VALUES('sdssEbossFirefly','PLUG_RA','degrees','','','Right ascension of fiber, J2000','0');
INSERT DBColumns VALUES('sdssEbossFirefly','PLUG_DEC','degrees','','','Declination of fiber, J2000','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Z','no unit','','','Best redshift','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Z_ERR','no unit','','','Error in redshift','0');
INSERT DBColumns VALUES('sdssEbossFirefly','CLASS','no unit','','','Classification in redshift','0');
INSERT DBColumns VALUES('sdssEbossFirefly','ZWARNING','no unit','','','Bitmask of warning values; 0 means all is well  --F/ ZWARNING','0');
INSERT DBColumns VALUES('sdssEbossFirefly','SN_MEDIAN_ALL','no unit','','','Median signal-to-noise over all good pixels','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_age_lightW','years','','','light weighted age , Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_age_lightW_up','years','','','light weighted age upper value, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_age_lightW_low','years','','','light weighted age lower value, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_stellar_mass','solar mass','','','stellar mass, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_stellar_mass_up','solar mass','','','stellar mass upper value, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_stellar_mass_low','solar mass','','','stellar mass lower value, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_spm_EBV','no unit','','','reddenning fitted, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_nComponentsSSP','no unit','','','number of single stellar population components, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_chi2','no unit','','','chi squared, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_MILES_ndof','no unit','','','number of degrees of freedom, Chabrier IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_age_lightW','years','','','light weighted age, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_age_lightW_up','years','','','light weighted age upper value, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_age_lightW_low','years','','','light weighted age lower value, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_stellar_mass','solar mass','','','stellar mass, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_stellar_mass_up','solar mass','','','stellar mass upper value, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_stellar_mass_low','solar mass','','','stellar mass lower value, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_spm_EBV','no unit','','','reddenning fitted, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_nComponentsSSP','no unit','','','number of single stellar population components, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_chi2','no unit','','','chi squared, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_MILES_ndof','no unit','','','number of degrees of freedom, Salpeter IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_age_lightW','years','','','light weighted age, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_age_lightW_up','years','','','light weighted age upper value, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_age_lightW_low','years','','','light weighted age lower value, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_stellar_mass','solar mass','','','stellar mass, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_stellar_mass_up','solar mass','','','stellar mass upper value, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_stellar_mass_low','solar mass','','','stellar mass lower value, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_spm_EBV','no unit','','','reddenning fitted, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_nComponentsSSP','no unit','','','number of single stellar population components, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_chi2','no unit','','','chi squared, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_MILES_ndof','no unit','','','number of degrees of freedom, Kroupa IMF MILES library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_age_lightW','years','','','light weighted age, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_age_lightW_up','years','','','light weighted age upper value, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_age_lightW_low','years','','','light weighted age lower value, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_stellar_mass_up','solar mass','','','stellar mass upper value, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_stellar_mass_low','solar mass','','','stellar mass lower value, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_spm_EBV','no unit','','','reddenning fitted, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_nComponentsSSP','no unit','','','number of single stellar population components, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_chi2','no unit','','','chi squared, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_ELODIE_ndof','no unit','','','number of degrees of freedom, Chabrier IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_age_lightW','years','','','light weighted age, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_age_lightW_up','years','','','light weighted age upper value, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_age_lightW_low','years','','','light weighted age lower value, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_stellar_mass','solar mass','','','stellar mass, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_stellar_mass_up','solar mass','','','stellar mass upper value, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_stellar_mass_low','solar mass','','','stellar mass lower value, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_spm_EBV','no unit','','','reddenning fitted, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_nComponentsSSP','no unit','','','number of single stellar population components, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_chi2','no unit','','','chi squared, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_ELODIE_ndof','no unit','','','number of degrees of freedom, Salpeter IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_age_lightW','years','','','light weighted age, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_age_lightW_up','years','','','light weighted age upper value, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_age_lightW_low','years','','','light weighted age lower value, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_stellar_mass','solar mass','','','stellar mass, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_stellar_mass_up','solar mass','','','stellar mass upper value, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_stellar_mass_low','solar mass','','','stellar mass lower value, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_spm_EBV','no unit','','','reddenning fitted, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_nComponentsSSP','no unit','','','number of single stellar population components, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_chi2','no unit','','','chi squared, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_ELODIE_ndof','no unit','','','number of degrees of freedom, Kroupa IMF ELODIE library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_age_lightW','years','','','light weighted age, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_age_lightW_up','years','','','light weighted age upper value, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_age_lightW_low','years','','','light weighted age lower value, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_stellar_mass_up','solar mass','','','stellar mass upper value, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_stellar_mass_low','solar mass','','','stellar mass lower value, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_spm_EBV','no unit','','','reddenning fitted, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_nComponentsSSP','no unit','','','number of single stellar population components, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_chi2','no unit','','','chi squared, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Chabrier_STELIB_ndof','no unit','','','number of degrees of freedom, Chabrier IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_age_lightW','years','','','light weighted age, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_age_lightW_up','years','','','light weighted age upper value, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_age_lightW_low','years','','','light weighted age lower value, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_stellar_mass_up','solar mass','','','stellar mass upper value, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_stellar_mass_low','solar mass','','','stellar mass lower value, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_spm_EBV','no unit','','','reddenning fitted, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_nComponentsSSP','no unit','','','number of single stellar population components, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_chi2','no unit','','','chi squared, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Salpeter_STELIB_ndof','no unit','','','number of degrees of freedom, Salpeter IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_age_lightW','years','','','light weighted age, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_age_lightW_up','years','','','light weighted age upper value, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_age_lightW_low','years','','','light weighted age lower value, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_metallicity_lightW','solar metallicity','','','light weighted stellar metallicity, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_metallicity_lightW_up','solar metallicity','','','light weighted stellar metallicity upper value, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_metallicity_lightW_low','solar metallicity','','','light weighted stellar metallicity lower value, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_stellar_mass','solar mass','','','stellar mass, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_stellar_mass_up','solar mass','','','stellar mass upper value, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_stellar_mass_low','solar mass','','','stellar mass lower value, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_spm_EBV','no unit','','','reddenning fitted, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_nComponentsSSP','no unit','','','number of single stellar population components, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_chi2','no unit','','','chi squared, Kroupa IMF STELIB library','0');
INSERT DBColumns VALUES('sdssEbossFirefly','Kroupa_STELIB_ndof','no unit','','','number of degrees of freedom, Kroupa IMF STELIB library','0');
GO

-- Add PK to IndexMap
INSERT IndexMap Values('K','primary key', 'sdssEbossFirefly', 	'specObjID'		,'','SPECTRO');
GO

-- Create the PK index
EXEC spIndexBuildSelection 0, 0, 'K', 'sdssEbossFirefly'
GO


-- Add History and inventory entries
INSERT History VALUES('IndexMap','2017-12-18','Ani','Added PK for sdssEbossFirefly (VAC). ');
INSERT History VALUES('SpectroTables','2017-12-12','Ani','Added new VAC table sdssEbossFirefly (from J Comparat). ');
INSERT Inventory VALUES('SpectroTables','sdssEbossFirefly','U');
GO



-- FInally, update the DB minor version
-- now set the new version; this gets tweaked for each version
EXECUTE spSetVersion
  0
  ,0
  ,'14'
  ,'a92ac476e0ad68036bef605e5cac101671d3caa9'
  ,'Update DR'
  ,'.3'
  ,'eBOSS Firefly VAC addition'
  ,'Added eBOSS Firefly VAC table sdssEbossFirefly'
  ,'J.Comparat,A.Thakar'
