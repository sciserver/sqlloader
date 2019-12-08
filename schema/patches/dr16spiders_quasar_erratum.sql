-- Patch to add erratum to spiders_quasar table for DR16
USE BestDR16
GO

-- Replace the text for the table description with the version that has the erratum
UPDATE DBObjects
SET text=' This table contains data for the SPIDERS (SPectroscopic IDentification  of ERosita  Sources) quasar spectroscopic followup Value Added Catalog  (VAC) based on SDSS DR14. <br>  <font color=''red''>  Erratum: An error was found affecting the 2RXS flux and luminosity  columns in the DR16 version of the VAC (not the DR14 version); <br>  f_class_2RXS, errf_class_2RXS, f_bay_2RXS, errf_bay_2RXS, fden_class_2RXS,  errfden_class_2RXS, fden_bay_2RXS, errfden_bay_2RXS, l_class_2RXS,  errl_class_2RXS, l_bay_2RXS, errl_bay_2RXS, l2keV_class_2RXS,  errl2keV_class_2RXS, l2keV_bay_2RXS, and errl2keV_bay_2RXS.  <br>  A version of the VAC with the error corrected is available at <br>  http://www.mpe.mpg.de/XraySurveys/SPIDERS/SPIDERS_AGN/  </font> '
WHERE name='spiders_quasar'

-- now update the minor version for the database
DELETE FROM Versions WHERE version='16.3'

EXECUTE spSetVersion
  0
  ,0
  ,'16'
  ,'b3a3238bea5fcc81ac3de31eaf26a013b4ac1bee'
  ,'Update DR'
  ,'.3'
  ,'Patch for spiders_quasar erratum'
  ,'Added erratum to spiders_quasar VAC table description'
  ,'A-M.Weijmans, D.Coffey, A.Thakar'
  ,0

  