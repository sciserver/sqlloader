This subdirectory contains the SQL schema for the CAS databases.  The
subdirectories under this level are as follows:

- csv: contains CSV files generated for loading into metadata tables
- doc: contains documentation generation scripts and files
- etc: contains miscellaneous .sql files for housekeeping and maintenance
- sql: contains the schema .sql files to create the database tables
- log: contains the weblogDB setup scripts and files


The following is the modification history for the schema.
--------------------------------------
-- V4.1 Nov-23-2002, Ani Thakar, Alex Szalay, Jim Gray, Adrian Pope
--------------------------------------
Synchronized Weblog harvesting versions
  V4.1.0 sqlLoader\schema\sql\WebSupport.sql
		Updated spExecuteSQL to record new params.
		Updated spSkyServerFreeFormQuery to call spExecuteSQL 
     	sqlLoader\schema\log
    		massive rewrite of webLogDBCreate.sql to be driven by logSource table
		add bcpWebLog.js	
		added Logging_SkyServer.doc
		drop copy.bat
		drop xcopyweblogfromyesterday
	added a new htm index to spManageIndices to support the spatial functions.

--------------------------------------
-- V4.1 September-26-2002, Ani Thakar, Alex Szalay, Jim Gray, Adrian Pope
--------------------------------------
Synchronized Jim's, Alex's versions and added Adrian's tiling changes.
  V4.1.0
      New tag in CVS for addition of tiling changes.
      Integrated Jim's changes to validator.
  V4.1.1
      Adrian's tiling changes added.
      Integrated Jim's changes to nearFunctions.sql and webSupport.sql.
  V4.1.2
      Added buildNullV4Schema.bat script.

--------------------------------------
-- V4.0 July-08-2002, Ani Thakar, Alex Szalay, Jim gray
--------------------------------------
Converted to DR1 schema for Photo tables.
  V4.0.1:
      Added Photo v5_3 fields
      Modified photo and field profile schemas and moved the profiles to their
	       own tables (FieldProfile and PhotoProfile)
  V4.0.2:
      Added Mask and ObjMask tables
      Added MaskType to dataConstants

added arcSecPerPixel, arcSecPerPixelErr to SDSS constants
Revised the ProfileDefs table
Added WebLogDB directory with code and utilites to mange weblog DB
Added spSkyServerGrantAccess to make it easy to grant access.
      spSkyServerUpdateStatistics to make it easy to grant access
           (We use the spSkyServer... prefix so that end users do not see these SPs a
           and so that we do not grant access to them.
       
Started building commands to drive DB load/bulid steps ???? INCOMPLETE>>>>
Added code for Validation Step

Dropped HTMID from Neighbors table so that Neighbors are now clustered on ObjID.
added field->segment forign key
added segment->chunk forign key
added chunk->stripeDefs forign key
added fieldProfile->Field
added PhotoProfile-PhotoObj
added Mosaic foreign keys.

Reorganized the SQL file structure.
MakeDB:     commands and ultilites used in making the database
            (SHOULD BE UNIFIED WITH bat I guess)
bat         comands to build databases.
WebLogDB:   SQL and commands for webLogDB
Patches:    Cumulative fixes (up to 3.39)
Doc:        Builds online documentation
etc:        probably should move to MakeDB
WWW???????????????????????????????????????
Out???????????????????????????????????????


--=========================================

--------------------------------------
-- V3.39 July-08-2002, Alex Szalay, Jim Gray
--------------------------------------
Added WebLog database to track web server activity and SQL Verbs.
      This included the procedures needed to import the weblogs every hour.
Modified spExecSQL() to log the SQL commands to a table in the WebLog.
      (this is optional if the weblog DB is defined).
      Also modified the SQL procedure to parse more carefully.
Added or modified 	fGetUrlSpecImg, 
			fGetUrlNavId,
			fGetUrlNavEq,
			fGetUrlFitsSpectrum,
			fGetUrlFitsAtlas, 
			fGetUrlFitsBin, 
			fGetUrlFitsMask, 
			fGetUrlFitsCFrame, 
			fGetUrlFitsField,
Added the SkyServer_Constant's support file.
Redefined the PhotoProfile table with the correct fields and parameters.
Modified fGetNearestFrameEq and fGetNearestMosaicEq to use ASIN() for distance calculation
Added	or SDSS cutout service.
	fGetJpegObjects, 
	fGetNearestFrameEq, and 
	fGetNearestMosaicEq.
	************************************************************************************
	** Alex: the new procedures will not show up in the object browser.
	** this is OK for v3 but we need to update for v4.
	** we may also want to document WebLog DB for V4.
	************************************************************************************
Added SkyServer_GrantAccess file (grants access to user objects)
--------------------------------------
-- V3.38 Dec-08-2001, Alex Szalay, Jim Gray
--------------------------------------
Inserted an extra index into PhotoObj.
Changed the names of CR flags to COSMIC_RAY

--------------------------------------
-- V3.37 Dec-08-2001, Alex Szalay, Jim Gray
--------------------------------------
Added several URL functions, mostly to support FITS access.
<li> fGetUrlFitsXXX point to the respective FITS files
<li> fGetUrlExpId and fGetUrlExpEq point to the Explore Tool
<li> fGetUrlNavId and fGetUrlNavEq point to the Navi Tool
<li> fMagToFlux and fMagToFluxErr
<li> Changed the types of the ConstantSupport functions
Fixed bug in SiteConstants DataServerURL

--------------------------------------
-- V3.36 Dec-08-2001, Alex Szalay, Jim Gray
--------------------------------------
Unified the Near* functions so that the code is 
easier to maintain.
(i)  Moved some functions from websupport 
     to Near* functions files.
(ii) Changed the distance calculation to use a
     sin() rather than cartesian distance for 
     better accuracy
--------------------------------------
-- V3.35 Dec-02-2001 Alex Szalay, Jim Gray
--------------------------------------
There were problems with the DataConstants table.

Alex changed some of the functions, just fixed errors.

Rename PrimTargetFlags ->PrimTarget
Rename SecTargetFlags  -> SecTarget
   both in DataConstants, the references and Views

Jim has overhauled the fGetNearxxxXYZ functions,
  there was a string length problem.

Alex has added to functions to handle uploads.

Alex has added a history table, to track patches.

--------------------------------------
-- V3.34 Nov-26-2001 Alex Szalay
--------------------------------------

Most of the changes in SchemaV3.34 are dealing with
reorganizing the documentation further, introducing
the
	--/H (table header) tag 
	--/K (glossary key) tag

Also, the data type has been dropped from Columns.
It is easier to get it from the syscolumns table.

Also changed the name of SiteStatistics to 
SiteDiagnostics.

----------------------------------------
-- V3.33 Nov-21-2001 Alex Szalay, Jim Gray
--------------------------------------------
This is the basic reload of V3, created in
steps from the existing V2 database. It has 
implemented a large number of changes, which 
are all reflected in the V3 schema.

