--=========================================================
--  ssppTables.sql
--  2009-07-29	Michael Blanton
-----------------------------------------------------------
--  SEGUE Stellar Parameter Pipeline tables schema for SQL Server
-----------------------------------------------------------
-- History:
--* 2009-08-28  Ani: Copied in schema for tables from sas-sql.
--* 2009-08-31  Ani: Adapted sppTargets from sas/sql/seguetsObjSetAll.sql.
--* 2009-10-30  Ani: Added run1d, run2d and runsspp sppParams and sppLines.
--* 2009-10-30  Ani: Added specObjID to sppLines, sppParams and objID to
--*                  appTargets.
--* 2010-02-02  Ani: Updated sppTargets schema from sas-sql.
--* 2010-02-09  Ani: Changed ra,dec and l,b in sppParams to float (from real).
--* 2010-02-09  Ani: Added column bestObjID to sppParams.
--* 2010-07-16  Naren/vamsi : Implemented SEGUE-2 schema changes to 
--*					 sppLines, sppParams and sppTargets Tables.
--* 2010-07-20  Naren/vamsi: Synchronized the schema with SAS/sql for SEGUE2.
--* 2010-07-25  Ani: Changed segueTsObjSetAll to sppTargets.
--* 2010-07-28  Ani: Fixed sppTargets description (created short description
--*                  for --/H tag and changed tag to --/T for long description.
--* 2010-07-29  Ani: Moved sppTargets column provenance comments up to the 
--*                  table description so they get properly displayed in the
--*                  schema browser.
--* 2010-11-04  Ani: Synced sppLines and sppParams with sas-sql version.
--* 2010-11-24  Ani: Fixed OBJID column in sppTargets (no newline before it).
--* 2010-11-24  Ani: Changes Plate2Target.plateID to bigint.
--* 2010-11-25  Ani: Commented out sppLines.seguePrimary for now.
--* 2010-12-08  Ani: Added segueTargetAll table schema.
--* 2012-05-18  Ani: Swapped in new sppParams schema.
--* 2012-05-18  Ani: Swapped in new sppLines schema.
--* 2012-06-10  Ani: Renamed sppParams.ORIGOBJID to FLUXOBJID.
--* 2013-07-08  Ani: Added info links for target flags.
--* 2013-07-08  Ani: Changed LegacyTarget1/2 links to Prim/SecTarget.
--=========================================================

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sppLines')
	DROP TABLE sppLines
GO
--
EXEC spSetDefaultFileGroup 'sppLines'
GO
CREATE TABLE sppLines (
-------------------------------------------------------------------------------
--/H Contains outputs from the SEGUE Stellar Parameter Pipeline (SSPP).
-------------------------------------------------------------------------------
--/T Spectra for over 500,000 Galactic stars of all common spectral types are
--/T available with DR8. These Spectra were processed with a pipeline called the
--/T SEGUE Stellar Parameter Pipeline (SSPP, Lee et al. 2008) that computes line indices for a wide
--/T range of common features at the radial velocity of the star in
--/T question. Note that the line indices for TiO5, TiO8, CaH1, CaH2, and CaH3 are calculated following
--/T the prescription given by the Hammer program (Covey et al. 2007). UVCN and BLCN line indices are computed
--/T by he equations given in Smith & Norris (1982), and FeI_4 and FeI_5 indices by the recipe in Friel (1987).
--/T FeI_1, FeI_2, FeI_3, and SrII line indices are only computed from the local continuum.
--/T Thus, these line indices calculated from different methods report the same values for both the local continuum and
--/T the global continuum. These outputs are stored in this table, and indexed on the 
--/T specObjID key index parameter for queries joining to other 
--/T tables such as specobjall and photoobjall.  See the Sample Queries in
--/T SkyServer for examples of such queries.
-------------------------------------------------------------------------------
 specObjID       numeric(20,0) NOT NULL,                        --/D id number
 bestObjID       bigint NOT NULL, --/D Object ID of photoObj match (flux-based) --/K ID_MAIN
 TARGETOBJID          bigint NOT NULL,                      --/D targeted object ID
 sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
 legacyPrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
 seguePrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj) --/F specsegue
 PLATE                bigint NOT NULL,                        --/D Plate number
 MJD                  bigint NOT NULL,                        --/D Modified Julian Date                                                                        
 FIBER                bigint NOT NULL,                        --/D Fiber ID                                                                   
 RUN2D               varchar(32) NOT NULL,                     --/D Name of 2D rerun
 RUN1D               varchar(32) NOT NULL,                     --/D Name of 1D rerun
 RUNSSPP             varchar(32) NOT NULL,                     --/D Name of SSPP rerun
 H83side              real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.0 with band widths of 3.0     
 H83cont              real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.0 with band widths of 3.0     
 H83err               real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.0 with band widths of 3.0     
 H83mask              tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.0 with band widths of 3.0     
 H812side             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.1 with band widths of 12.0     
 H812cont             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.1 with band widths of 12.0     
 H812err              real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.1 with band widths of 12.0     
 H812mask             tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 12.0     
 H824side             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.1 with band widths of 24.0     
 H824cont             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.1 with band widths of 24.0     
 H824err              real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.1 with band widths of 24.0     
 H824mask             tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 24.0     
 H848side             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from local continuum at 3889.1 with band widths of 48.0     
 H848cont             real NOT NULL,      --/U Angstrom             --/D Hzeta line index from global continuum at 3889.1 with band widths of 48.0     
 H848err              real NOT NULL,      --/U Angstrom             --/D Hzeta line index error in the lind band at 3889.1 with band widths of 48.0     
 H848mask             tinyint NOT NULL,                             --/D Hzeta pixel quality check, =0 good, =1 bad at 3889.1 with band widths of 48.0     
 KP12side             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 12.0     
 KP12cont             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 12.0     
 KP12err              real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 12.0     
 KP12mask             tinyint NOT NULL,                             --/D Ca II K pixel quality check, =0 good, =1 bad at 3933.7 with band widths of 12.0     
 KP18side             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 18.0     
 KP18cont             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 18.0     
 KP18err              real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 18.0     
 KP18mask             tinyint NOT NULL,                             --/D Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 18.0     
 KP6side              real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 6.0     
 KP6cont              real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 6.0     
 KP6err               real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 6.0     
 KP6mask              tinyint NOT NULL,                             --/D Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 6.0     
 CaIIKside             real NOT NULL,      --/U Angstrom           --/D Ca II K line index from local continuum at 3933.6 with band widths of 30.0     
 CaIIKcont             real NOT NULL,      --/U Angstrom           --/D Ca II K line index from global continuum at 3933.6 with band widths of 30.0     
 CaIIKerr              real NOT NULL,      --/U Angstrom           --/D Ca II K line index error in the lind band at 3933.6 with band widths of 30.0     
 CaIIKmask             tinyint NOT NULL,                           --/D Ca II K pixel quality check =0, good, =1 bad at 3933.6 with band widths of 30.0     
 CaIIHKside            real NOT NULL,      --/U Angstrom           --/D Ca II H and K line index from local continuum at 3962.0 with band widths of 75.0     
 CaIIHKcont            real NOT NULL,      --/U Angstrom           --/D Ca II H and K line index from global continuum at 3962.0 with band widths of 75.0     
 CaIIHKerr             real NOT NULL,      --/U Angstrom           --/D Ca II H and K line index error in the lind band at 3962.0 with band widths of 75.0     
 CaIIHKmask            tinyint NOT NULL,                           --/D Ca II H and K pixel quality check =0, good, =1 bad at 3962.0 with band widths of 75.0     
 Hepsside              real NOT NULL,      --/U Angstrom           --/D Hepsilon line index from local continuum at 3970.0 with band widths of 50.0     
 Hepscont              real NOT NULL,      --/U Angstrom           --/D Hepsilon line index from global continuum at 3970.0 with band widths of 50.0     
 Hepserr               real NOT NULL,      --/U Angstrom           --/D Hepsilon line index error in the lind band at 3970.0 with band widths of 50.0     
 Hepsmask              tinyint NOT NULL,                           --/D Hepsilon pixel quality check =0, good, =1 bad at 3970.0 with band widths of 50.0     
 KP16side             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from local continuum at 3933.7 with band widths of 16.0     
 KP16cont             real NOT NULL,      --/U Angstrom             --/D Ca II K line index from global continuum at 3933.7 with band widths of 16.0     
 KP16err              real NOT NULL,      --/U Angstrom             --/D Ca II K line index error in the lind band at 3933.7 with band widths of 16.0     
 KP16mask             tinyint NOT NULL,                             --/D Ca II K pixel quality check =0, good, =1 bad at 3933.7 with band widths of 16.0     
 SrII1side            real NOT NULL,      --/U Angstrom             --/D Sr II line index from local continuum at 4077.0 with band widths of 8.0     
 SrII1cont            real NOT NULL,      --/U Angstrom             --/D Sr II line index from global continuum at 4077.0 with band widths of 8.0     
 SrII1err             real NOT NULL,      --/U Angstrom             --/D Sr II line index error in the lind band at 4077.0 with band widths of 8.0     
 SrII1mask            tinyint NOT NULL,                             --/D Sr II pixel quality check =0, good, =1 bad at 4077.0 with band widths of 8.0     
 HeI121side          real NOT NULL,      --/U Angstrom        --/D He I line index from local continuum at 4026.2 with band widths of 12.0     
 HeI121cont          real NOT NULL,      --/U Angstrom        --/D He I line index from global continuum at 4026.2 with band widths of 12.0     
 HeI121err           real NOT NULL,      --/U Angstrom        --/D He I line index error in the lind band at 4026.2 with band widths of 12.0     
 HeI121mask          tinyint NOT NULL,                        --/D He I pixel quality check =0, good, =1 bad at 4026.2 with band widths of 12.0     
 Hdelta12side         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from local continuum at 4101.8 with band widths of 12.0     
 Hdelta12cont         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from global continuum at 4101.8 with band widths of 12.0     
 Hdelta12err          real NOT NULL,      --/U Angstrom        --/D Hdelta line index error in the lind band at 4101.8 with band widths of 12.0     
 Hdelta12mask         tinyint NOT NULL,                        --/D Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 12.0     
 Hdelta24side         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from local continuum at 4101.8 with band widths of 24.0     
 Hdelta24cont         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from global continuum at 4101.8 with band widths of 24.0     
 Hdelta24err          real NOT NULL,      --/U Angstrom        --/D Hdelta line index error in the lind band at 4101.8 with band widths of 24.0     
 Hdelta24mask         tinyint NOT NULL,                        --/D Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 24.0     
 Hdelta48side         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from local continuum at 4101.8 with band widths of 48.0     
 Hdelta48cont         real NOT NULL,      --/U Angstrom        --/D Hdelta line index from global continuum at 4101.8 with band widths of 48.0     
 Hdelta48err          real NOT NULL,      --/U Angstrom        --/D Hdelta line index error in the lind band at 4101.8 with band widths of 48.0     
 Hdelta48mask         tinyint NOT NULL,                        --/D Hdelta pixel quality check =0, good, =1 bad at 4101.8 with band widths of 48.0     
 Hdeltaside            real NOT NULL,      --/U Angstrom       --/D Hdelta line index from local continuum at 4102.0 with band widths of 64.0     
 Hdeltacont            real NOT NULL,      --/U Angstrom       --/D Hdelta line index from global continuum at 4102.0 with band widths of 64.0     
 Hdeltaerr             real NOT NULL,      --/U Angstrom       --/D Hdelta line index error in the lind band at 4102.0 with band widths of 64.0     
 Hdeltamask            tinyint NOT NULL,                       --/D Hdelta pixel quality check =0, good, =1 bad at 4102.0 with band widths of 64.0     
 CaI4side             real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.0 with band widths of 4.0     
 CaI4cont             real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.0 with band widths of 4.0     
 CaI4err              real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.0 with band widths of 4.0     
 CaI4mask             tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.0 with band widths of 4.0     
 CaI12side            real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.7 with band widths of 12.0     
 CaI12cont            real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.7 with band widths of 12.0     
 CaI12err             real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.7 with band widths of 12.0     
 CaI12mask            tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 12.0     
 CaI24side            real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.7 with band widths of 24.0     
 CaI24cont            real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.7 with band widths of 24.0     
 CaI24err             real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.7 with band widths of 24.0     
 CaI24mask            tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 24.0     
 CaI6side             real NOT NULL,      --/U Angstrom       --/D Ca I line index from local continuum at 4226.7 with band widths of 6.0     
 CaI6cont             real NOT NULL,      --/U Angstrom       --/D Ca I line index from global continuum at 4226.7 with band widths of 6.0     
 CaI6err              real NOT NULL,      --/U Angstrom       --/D Ca I line index error in the lind band at 4226.7 with band widths of 6.0     
 CaI6mask             tinyint NOT NULL,                       --/D Ca I pixel quality check =0, good, =1 bad at 4226.7 with band widths of 6.0     
 Gside                 real NOT NULL,      --/U Angstrom       --/D G band line index from local continuum at 4305.0 with band widths of 15.0     
 Gcont                 real NOT NULL,      --/U Angstrom       --/D G band line index from global continuum at 4305.0 with band widths of 15.0     
 Gerr                  real NOT NULL,      --/U Angstrom       --/D G band line index error in the lind band at 4305.0 with band widths of 15.0     
 Gmask                 tinyint NOT NULL,                       --/D G band pixel quality check =0, good, =1 bad at 4305.0 with band widths of 15.0     
 Hgamma12side         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 12.0     
 Hgamma12cont         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 12.0     
 Hgamma12err          real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 12.0     
 Hgamma12mask         tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 12.0     
 Hgamma24side         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 24.0     
 Hgamma24cont         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 24.0     
 Hgamma24err          real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 24.0     
 Hgamma24mask         tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 24.0     
 Hgamma48side         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 48.0     
 Hgamma48cont         real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 48.0     
 Hgamma48err          real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 48.0     
 Hgamma48mask         tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 48.0     
 Hgammaside            real NOT NULL,      --/U Angstrom       --/D Hgamma line index from local continuum at 4340.5 with band widths of 54.0     
 Hgammacont            real NOT NULL,      --/U Angstrom       --/D Hgamma line index from global continuum at 4340.5 with band widths of 54.0     
 Hgammaerr             real NOT NULL,      --/U Angstrom       --/D Hgamma line index error in the lind band at 4340.5 with band widths of 54.0     
 Hgammamask            tinyint NOT NULL,                       --/D Hgamma pixel quality check =0, good, =1 bad at 4340.5 with band widths of 54.0     
 HeI122side          real NOT NULL,      --/U Angstrom       --/D He I line index from local continuum at 4471.7 with band widths of 12.0     
 HeI122cont          real NOT NULL,      --/U Angstrom       --/D He I line index from global continuum at 4471.7 with band widths of 12.0     
 HeI122err           real NOT NULL,      --/U Angstrom       --/D He I line index error in the lind band at 4471.7 with band widths of 12.0     
 HeI122mask          tinyint NOT NULL,                       --/D He I pixel quality check =0, good, =1 bad at 4471.7 with band widths of 12.0     
 Gblueside            real NOT NULL,      --/U Angstrom        --/D G band line index from local continuum at 4305.0 with band widths of 26.0     
 Gbluecont            real NOT NULL,      --/U Angstrom        --/D G band line index from global continuum at 4305.0 with band widths of 26.0     
 Gblueerr             real NOT NULL,      --/U Angstrom        --/D G band line index error in the lind band at 4305.0 with band widths of 26.0     
 Gbluemask            tinyint NOT NULL,                        --/D G band pixel quality check =0, good, =1 bad at 4305.0 with band widths of 26.0     
 Gwholeside           real NOT NULL,      --/U Angstrom        --/D G band line index from local continuum at 4321.0 with band widths of 28.0     
 Gwholecont           real NOT NULL,      --/U Angstrom        --/D G band line index from global continuum at 4321.0 with band widths of 28.0     
 Gwholeerr            real NOT NULL,      --/U Angstrom        --/D G band line index error in the lind band at 4321.0 with band widths of 28.0     
 Gwholemask           tinyint NOT NULL,                        --/D G band pixel quality check =0, good, =1 bad at 4321.0 with band widths of 28.0     
 Baside                real NOT NULL,      --/U Angstrom        --/D Ba line index from local continuum at 4554.0 with band widths of 6.0     
 Bacont                real NOT NULL,      --/U Angstrom        --/D Ba line index from global continuum at 4554.0 with band widths of 6.0     
 Baerr                 real NOT NULL,      --/U Angstrom        --/D Ba line index error in the lind band at 4554.0 with band widths of 6.0     
 Bamask                tinyint NOT NULL,                        --/D Ba pixel quality check =0, good, =1 bad at 4554.0 with band widths of 6.0     
 C12C13side            real NOT NULL,      --/U Angstrom        --/D C12C13 band line index from local continuum at 4737.0 with band widths of 36.0     
 C12C13cont            real NOT NULL,      --/U Angstrom        --/D C12C13 band line index from global continuum at 4737.0 with band widths of 36.0     
 C12C13err             real NOT NULL,      --/U Angstrom        --/D C12C13 band line index error in the lind band at 4737.0 with band widths of 36.0     
 C12C13mask            tinyint NOT NULL,                        --/D C12C13 band pixel quality check =0, good, =1 bad at 4737.0 with band widths of 36.0     
 CC12side              real NOT NULL,      --/U Angstrom        --/D C2 band line index from local continuum at 4618.0 with band widths of 256.0     
 CC12cont              real NOT NULL,      --/U Angstrom        --/D C2 band line index from global continuum at 4618.0 with band widths of 256.0     
 CC12err               real NOT NULL,      --/U Angstrom        --/D C2 band line index error in the lind band at 4618.0 with band widths of 256.0     
 CC12mask              tinyint NOT NULL,                        --/D C2 band pixel quality check =0, good, =1 bad at 4618.0 with band widths of 256.0     
 metal1side            real NOT NULL,      --/U Angstrom        --/D Metallic line index from local continuum at 4584.0 with band widths of 442.0     
 metal1cont            real NOT NULL,      --/U Angstrom        --/D Metallic line index from global continuum at 4584.0 with band widths of 442.0     
 metal1err             real NOT NULL,      --/U Angstrom        --/D Metlllic line index error in the lind band at 4584.0 with band widths of 442.0     
 metal1mask            tinyint NOT NULL,                        --/D Metal1ic pixel quality check =0, good, =1 bad at 4584.0 with band widths of 442.0     
 Hbeta12side          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 12.0     
 Hbeta12cont          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 12.0     
 Hbeta12err           real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 12.0     
 Hbeta12mask          tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 12.0     
 Hbeta24side          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 24.0     
 Hbeta24cont          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 24.0     
 Hbeta24err           real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 24.0     
 Hbeta24mask          tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 24.0     
 Hbeta48side          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 48.0     
 Hbeta48cont          real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 48.0     
 Hbeta48err           real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 48.0     
 Hbeta48mask          tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 48.0     
 Hbetaside             real NOT NULL,      --/U Angstrom        --/D Hbeta line index from local continuum at 4862.3 with band widths of 60.0     
 Hbetacont             real NOT NULL,      --/U Angstrom        --/D Hbeta line index from global continuum at 4862.3 with band widths of 60.0     
 Hbetaerr              real NOT NULL,      --/U Angstrom        --/D Hbeta line index error in the lind band at 4862.3 with band widths of 60.0     
 Hbetamask             tinyint NOT NULL,                        --/D Hbeta pixel quality check =0, good, =1 bad at 4862.3 with band widths of 60.0     
 C2side                real NOT NULL,      --/U Angstrom        --/D C2 band line index from local continuum at 5052.0 with band widths of 204.0     
 C2cont                real NOT NULL,      --/U Angstrom        --/D C2 band line index from global continuum at 5052.0 with band widths of 204.0     
 C2err                 real NOT NULL,      --/U Angstrom        --/D C2 band line index error in the lind band at 5052.0 with band widths of 204.0     
 C2mask                tinyint NOT NULL,                        --/D C2 band pixel quality check =0, good, =1 bad at 5052.0 with band widths of 204.0     
 C2MgIside            real NOT NULL,      --/U Angstrom        --/D C2 and Mg I line index from local continuum at 5069.0 with band widths of 238.0     
 C2MgIcont            real NOT NULL,      --/U Angstrom        --/D C2 and Mg I line index from global continuum at 5069.0 with band widths of 238.0     
 C2MgIerr             real NOT NULL,      --/U Angstrom        --/D C2 and Mg I line index error in the lind band at 5069.0 with band widths of 238.0     
 C2MgImask            tinyint NOT NULL,                         --/D C2 and Mg I pixel quality check =0, good, =1 bad at 5069.0 with band widths of 238.0     
 MgHMgIC2side        real NOT NULL,      --/U Angstrom        --/D MgH, Mg I, and C2 line index from local continuum at 5085.0 with band widths of 270.0     
 MgHMgIC2cont        real NOT NULL,      --/U Angstrom        --/D MgH, Mg I, and C2 line index from global continuum at 5085.0 with band widths of 270.0     
 MgHMgIC2err         real NOT NULL,      --/U Angstrom        --/D MgH, Mg I, and C2 line index error in the lind band at 5085.0 with band widths of 270.0     
 MgHMgIC2mask        tinyint NOT NULL,                        --/D MgH, Mg I, and C2 pixel quality check =0, good, =1 bad at 5085.0 with band widths of 270.0   
 MgHMgIside           real NOT NULL,      --/U Angstrom        --/D MgH and Mg I line index from local continuum at 5198.0 with band widths of 44.0     
 MgHMgIcont           real NOT NULL,      --/U Angstrom        --/D MgH and Mg I line index from global continuum at 5198.0 with band widths of 44.0     
 MgHMgIerr            real NOT NULL,      --/U Angstrom        --/D MgH and Mg I line index error in the lind band at 5198.0 with band widths of 44.0     
 MgHMgImask           tinyint NOT NULL,                        --/D MgH_MgI pixel quality check =0, good, =1 bad at 5198.0 with band widths of 44.0     
 MgHside               real NOT NULL,      --/U Angstrom        --/D MgH line index from local continuum at 5210.0 with band widths of 20.0     
 MgHcont               real NOT NULL,      --/U Angstrom        --/D MgH line index from global continuum at 5210.0 with band widths of 20.0     
 MgHerr                real NOT NULL,      --/U Angstrom        --/D MgH line index error in the lind band at 5210.0 with band widths of 20.0     
 MgHmask               tinyint NOT NULL,                        --/D MgH pixel quality check =0, good, =1 bad at 5210.0 with band widths of 20.0     
 CrIside               real NOT NULL,      --/U Angstrom        --/D Cr I line index from local continuum at 5206.0 with band widths of 12.0     
 CrIcont               real NOT NULL,      --/U Angstrom        --/D Cr I line index from global continuum at 5206.0 with band widths of 12.0     
 CrIerr                real NOT NULL,      --/U Angstrom        --/D Cr I line index error in the lind band at 5206.0 with band widths of 12.0     
 CrImask               tinyint NOT NULL,                        --/D Cr I pixel quality check =0, good, =1 bad at 5206.0 with band widths of 12.0     
 MgIFeIIside          real NOT NULL,      --/U Angstrom        --/D Mg I and Fe II line index from local continuum at 5175.0 with band widths of 20.0     
 MgIFeIIcont          real NOT NULL,      --/U Angstrom        --/D Mg I and Fe II line index from global continuum at 5175.0 with band widths of 20.0     
 MgIFeIIerr           real NOT NULL,      --/U Angstrom        --/D Mg I and Fe II line index error in the lind band at 5175.0 with band widths of 20.0     
 MgIFeIImask          tinyint NOT NULL,                        --/D Mg I and Fe II pixel quality check =0, good, =1 bad at 5175.0 with band widths of 20.0     
 MgI2side             real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5183.0 with band widths of 2.0     
 MgI2cont             real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5183.0 with band widths of 2.0     
 MgI2err              real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5183.0 with band widths of 2.0     
 MgI2mask             tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5183.0 with band widths of 2.0     
 MgI121side          real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5170.5 with band widths of 12.0     
 MgI121cont          real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5170.5 with band widths of 12.0     
 MgI121err           real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5170.5 with band widths of 12.0     
 MgI121mask          tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5170.5 with band widths of 12.0     
 MgI24side            real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5176.5 with band widths of 24.0     
 MgI24cont            real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5176.5 with band widths of 24.0     
 MgI24err             real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5176.5 with band widths of 24.0     
 MgI24mask            tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5176.5 with band widths of 24.0     
 MgI122side          real NOT NULL,      --/U Angstrom        --/D Mg I line index from local continuum at 5183.5 with band widths of 12.0     
 MgI122cont          real NOT NULL,      --/U Angstrom        --/D Mg I line index from global continuum at 5183.5 with band widths of 12.0     
 MgI122err           real NOT NULL,      --/U Angstrom        --/D Mg I line index error in the lind band at 5183.5 with band widths of 12.0     
 MgI122mask          tinyint NOT NULL,                        --/D Mg I pixel quality check =0, good, =1 bad at 5183.5 with band widths of 12.0     
 NaI20side            real NOT NULL,      --/U Angstrom        --/D Na I line index from local continuum at 5890.0 with band widths of 20.0     
 NaI20cont            real NOT NULL,      --/U Angstrom        --/D Na I line index from global continuum at 5890.0 with band widths of 20.0     
 NaI20err             real NOT NULL,      --/U Angstrom        --/D Na I line index error in the lind band at 5890.0 with band widths of 20.0     
 NaI20mask            tinyint NOT NULL,                        --/D Na I pixel quality check =0, good, =1 bad at 5890.0 with band widths of 20.0     
 Na12side             real NOT NULL,      --/U Angstrom        --/D Na line index from local continuum at 5892.9 with band widths of 12.0     
 Na12cont             real NOT NULL,      --/U Angstrom        --/D Na line index from global continuum at 5892.9 with band widths of 12.0     
 Na12err              real NOT NULL,      --/U Angstrom        --/D Na line index error in the lind band at 5892.9 with band widths of 12.0     
 Na12mask             tinyint NOT NULL,                        --/D Na pixel quality check =0, good, =1 bad at 5892.9 with band widths of 12.0     
 Na24side             real NOT NULL,      --/U Angstrom        --/D Na line index from local continuum at 5892.9 with band widths of 24.0     
 Na24cont             real NOT NULL,      --/U Angstrom        --/D Na line index from global continuum at 5892.9 with band widths of 24.0     
 Na24err              real NOT NULL,      --/U Angstrom        --/D Na line index error in the lind band at 5892.9 with band widths of 24.0     
 Na24mask             tinyint NOT NULL,                        --/D Na pixel quality check =0, good, =1 bad at 5892.9 with band widths of 24.0     
 Halpha12side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 12.0     
 Halpha12cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 12.0     
 Halpha12err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 12.0     
 Halpha12mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 12.0     
 Halpha24side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 24.0     
 Halpha24cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 24.0     
 Halpha24err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 24.0     
 Halpha24mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 24.0     
 Halpha48side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 48.0     
 Halpha48cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 48.0     
 Halpha48err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 48.0     
 Halpha48mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 48.0     
 Halpha70side         real NOT NULL,      --/U Angstrom         --/D Halpha line index from local continuum at 6562.8 with band widths of 70.0     
 Halpha70cont         real NOT NULL,      --/U Angstrom         --/D Halpha line index from global continuum at 6562.8 with band widths of 70.0     
 Halpha70err          real NOT NULL,      --/U Angstrom         --/D Halpha line index error in the lind band at 6562.8 with band widths of 70.0     
 Halpha70mask         tinyint NOT NULL,                         --/D Halpha pixel quality check =0, good, =1 bad at 6562.8 with band widths of 70.0     
 CaHside               real NOT NULL,      --/U Angstrom         --/D CaH line index from local continuum at 6788.0 with band widths of 505.0     
 CaHcont               real NOT NULL,      --/U Angstrom         --/D CaH line index from global continuum at 6788.0 with band widths of 505.0     
 CaHerr                real NOT NULL,      --/U Angstrom         --/D CaH line index error in the lind band at 6788.0 with band widths of 505.0     
 CaHmask               tinyint NOT NULL,                         --/D CaH pixel quality check =0, good, =1 bad at 6788.0 with band widths of 505.0     
 TiOside               real NOT NULL,      --/U Angstrom         --/D TiO line index from local continuum at 7209.0 with band widths of 333.3     
 TiOcont               real NOT NULL,      --/U Angstrom         --/D TiO line index from global continuum at 7209.0 with band widths of 333.3     
 TiOerr                real NOT NULL,      --/U Angstrom         --/D TiO line index error in the lind band at 7209.0 with band widths of 333.3     
 TiOmask               tinyint NOT NULL,                         --/D TiO pixel quality check =0, good, =1 bad at 7209.0 with band widths of 333.3     
 CNside                real NOT NULL,      --/U Angstrom         --/D CN line index from local continuum at 6890.0 with band widths of 26.0     
 CNcont                real NOT NULL,      --/U Angstrom         --/D CN line index from global continuum at 6890.0 with band widths of 26.0     
 CNerr                 real NOT NULL,      --/U Angstrom         --/D CN line index error in the lind band at 6890.0 with band widths of 26.0     
 CNmask                tinyint NOT NULL,                         --/D CN pixel quality check =0, good, =1 bad at 6890.0 with band widths of 26.0     
 OItripside            real NOT NULL,      --/U Angstrom         --/D O I triplet line index from local continuu at 7775.0 with band widths of 30.0     
 OItripcont            real NOT NULL,      --/U Angstrom         --/D O I triplet line index from global continuum at 7775.0 with band widths of 30.0     
 OItriperr             real NOT NULL,      --/U Angstrom         --/D O I triplet line index error in the lind band at 7775.0 with band widths of 30.0     
 OItripmask            tinyint NOT NULL,                         --/D O I triplet pixel quality check =0, good, =1 bad at 7775.0 with band widths of 30.0     
 KI34side             real NOT NULL,      --/U Angstrom         --/D K I line index from local continuum at 7687.0 with band widths of 34.0     
 KI34cont             real NOT NULL,      --/U Angstrom         --/D K I line index from global continuum at 7687.0 with band widths of 34.0     
 KI34err              real NOT NULL,      --/U Angstrom         --/D K I line index error in the lind band at 7687.0 with band widths of 34.0     
 KI34mask             tinyint NOT NULL,                         --/D K I pixel quality check =0, good, =1 bad at 7687.0 with band widths of 34.0     
 KI95side             real NOT NULL,      --/U Angstrom         --/D K I line index from local continuum at 7688.0 with band widths of 95.0     
 KI95cont             real NOT NULL,      --/U Angstrom         --/D K I line index from global continuum at 7688.0 with band widths of 95.0     
 KI95err              real NOT NULL,      --/U Angstrom         --/D K I line index error in the lind band at 7688.0 with band widths of 95.0     
 KI95mask             tinyint NOT NULL,                         --/D K I pixel quality check =0, good, =1 bad at 7688.0 with band widths of 95.0     
 NaI15side            real NOT NULL,      --/U Angstrom         --/D Na I line index from local continuum at 8187.5 with band widths of 15.0     
 NaI15cont            real NOT NULL,      --/U Angstrom         --/D Na I line index from global continuum at 8187.5 with band widths of 15.0     
 NaI15err             real NOT NULL,      --/U Angstrom         --/D Na I line index error in the lind band at 8187.5 with band widths of 15.0     
 NaI15mask            tinyint NOT NULL,                         --/D Na I pixel quality check =0, good, =1 bad at 8187.5 with band widths of 15.0     
 NaIredside            real NOT NULL,      --/U Angstrom         --/D Na I line index from local continuum at 8190.2 with band widths of 33.0     
 NaIredcont            real NOT NULL,      --/U Angstrom         --/D Na I line index from global continuum at 8190.2 with band widths of 33.0     
 NaIrederr             real NOT NULL,      --/U Angstrom         --/D Na I line index error in the lind band at 8190.2 with band widths of 33.0     
 NaIredmask            tinyint NOT NULL,                         --/D Na I pixel quality check =0, good, =1 bad at 8190.2 with band widths of 33.0     
 CaII26side           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8498.0 with band widths of 26.0     
 CaII26cont           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8498.0 with band widths of 26.0     
 CaII26err            real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8498.0 with band widths of 26.0     
 CaII26mask           tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8498.0 with band widths of 26.0     
 Paschen13side        real NOT NULL,      --/U Angstrom      --/D Paschen line index from local continuum at 8467.5 with band widths of 13.0     
 Paschen13cont        real NOT NULL,      --/U Angstrom      --/D Paschen line index from global continuum at 8467.5 with band widths of 13.0     
 Paschen13err         real NOT NULL,      --/U Angstrom      --/D Paschen line index error in the lind band at 8467.5 with band widths of 13.0     
 Paschen13mask        tinyint NOT NULL,                      --/D Paschen pixel quality check =0, good, =1 bad at 8467.5 with band widths of 13.0     
 CaII29side           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8498.5 with band widths of 29.0     
 CaII29cont           real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8498.5 with band widths of 29.0     
 CaII29err            real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8498.5 with band widths of 29.0     
 CaII29mask           tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8498.5 with band widths of 29.0     
 CaII401side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8542.0 with band widths of 40.0     
 CaII401cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8542.0 with band widths of 40.0     
 CaII401err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8542.0 with band widths of 40.0     
 CaII401mask         tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8542.0 with band widths of 40.0     
 CaII161side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet_1 line index from local continuum at 8542.0 with band widths of 16.0     
 CaII161cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet_1 line index from global continuum at 8542.0 with band widths of 16.0     
 CaII161err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet_1 line index error in the lind band at 8542.0 with band widths of 16.0     
 CaII161mask         tinyint NOT NULL,                      --/D Ca II triplet_1 pixel quality check =0, good, =1 bad at 8542.0 with band widths of 16.0     
 Paschen421side      real NOT NULL,      --/U Angstrom      --/D Paschen line index from local continuum at 8598.0 with band widths of 42.0     
 Paschen421cont      real NOT NULL,      --/U Angstrom      --/D Paschen line index from global continuum at 8598.0 with band widths of 42.0     
 Paschen421err       real NOT NULL,      --/U Angstrom      --/D Paschen line index error in the lind band at 8598.0 with band widths of 42.0     
 Paschen421mask      tinyint NOT NULL,                      --/D Paschen pixel quality check =0, good, =1 bad at 8598.0 with band widths of 42.0     
 CaII162side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8662.1 with band widths of 16.0     
 CaII162cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8662.1 with band widths of 16.0     
 CaII162err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8662.1 with band widths of 16.0     
 CaII162mask         tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8662.1 with band widths of 16.0     
 CaII402side         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from local continuum at 8662.0 with band widths of 40.0     
 CaII402cont         real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index from global continuum at 8662.0 with band widths of 40.0     
 CaII402err          real NOT NULL,      --/U Angstrom      --/D Ca II triplet line index error in the lind band at 8662.0 with band widths of 40.0     
 CaII402mask         tinyint NOT NULL,                      --/D Ca II triplet pixel quality check =0, good, =1 bad at 8662.0 with band widths of 40.0     
 Paschen422side      real NOT NULL,      --/U Angstrom      --/D Paschen line index from local continuum at 8751.0 with band widths of 42.0     
 Paschen422cont      real NOT NULL,      --/U Angstrom      --/D Paschen line index from global continuum at 8751.0 with band widths of 42.0     
 Paschen422err       real NOT NULL,      --/U Angstrom      --/D Paschen line index error in the lind band at 8751.0 with band widths of 42.0     
 Paschen422mask      tinyint NOT NULL,                      --/D Paschen pixel quality check =0, good, =1 bad at 8751.0 with band widths of 42.0     
 TiO5side              real NOT NULL,                       --/D TiO5 line index from local continuum at 7134.4 with band widths of 5.0     
 TiO5cont              real NOT NULL,                       --/D TiO5 line index from global continuum at 7134.4 with band widths of 5.0     
 TiO5err               real NOT NULL,                       --/D TiO5 line index error in the lind band at 7134.4 with band widths of 5.0     
 TiO5mask              tinyint NOT NULL,                    --/D TiO5 pixel quality check =0, good, =1 bad at 7134.4 with band widths of 5.0     
 TiO8side              real NOT NULL,                       --/D TiO8 line index from local continuum at 8457.3 with band widths of 30.0     
 TiO8cont              real NOT NULL,                       --/D TiO8 line index from global continuum at 8457.3 with band widths of 30.0     
 TiO8err               real NOT NULL,                       --/D TiO8 line index error in the lind band at 8457.3 with band widths of 30.0     
 TiO8mask              tinyint NOT NULL,                    --/D TiO8 pixel quality check =0, good, =1 bad at 8457.3 with band widths of 30.0     
 CaH1side              real NOT NULL,                       --/D CaH1 line index from local continuum at 6386.7 with band widths of 10.0     
 CaH1cont              real NOT NULL,                       --/D CaH1 line index from global continuum at 6386.7 with band widths of 10.0     
 CaH1err               real NOT NULL,                       --/D CaH1 line index error in the lind band at 6386.7 with band widths of 10.0     
 CaH1mask              tinyint NOT NULL,                    --/D CaH1 pixel quality check =0, good, =1 bad at 6386.7 with band widths of 10.0     
 CaH2side              real NOT NULL,                       --/D CaH2 line index from local continuum at 6831.9 with band widths of 32.0     
 CaH2cont              real NOT NULL,                       --/D CaH2 line index from global continuum at 6831.9 with band widths of 32.0     
 CaH2err               real NOT NULL,                       --/D CaH2 line index error in the lind band at 6831.9 with band widths of 32.0     
 CaH2mask              tinyint NOT NULL,                    --/D CaH2 pixel quality check =0, good, =1 bad at 6831.9 with band widths of 32.0     
 CaH3side              real NOT NULL,                       --/D CaH3 line index from local continuum at 6976.9 with band widths of 30.0     
 CaH3cont              real NOT NULL,                       --/D CaH3 line index from global continuum at 6976.9 with band widths of 30.0     
 CaH3err               real NOT NULL,                       --/D CaH3 line index error in the lind band at 6976.9 with band widths of 30.0     
 CaH3mask              tinyint NOT NULL,                            --/D CaH3 pixel quality check =0, good, =1 bad at 6976.9 with band widths of 30.0     
 UVCNside              real NOT NULL,                               --/D CN line index at 3839  
 UVCNcont              real NOT NULL,                               --/D CN line index at 3839                                     
 UVCNerr               real NOT NULL,                               --/D CN line index error at 3829                              
 UVCNmask              tinyint NOT NULL,                            --/D CN pixel quality check =0, good, =1 bad at 3839         
 BLCNside              real NOT NULL,                               --/D CN line index at 4142                                  
 BLCNcont              real NOT NULL,                               --/D CN line index at 4142                                     
 BLCNerr               real NOT NULL,                               --/D CN line index error at 4142                              
 BLCNmask              tinyint NOT NULL,                            --/D CN pixel quality check =0, good, =1 bad at 4142              
 FEI1side              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4045.8 with band widths of 2.5         
 FEI1cont              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4045.8 with band widths of 2.5        
 FEI1err               real NOT NULL,      --/U Angstrom            --/D Fe I line index error at 4045.8 with band widths of 2.5  
 FEI1mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4045.8 with band widths of 2.5
 FEI2side              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4063.6 with band widths of 2.0         
 FEI2cont              real NOT NULL,      --/U Angstrom            --/D Fe I line index at 4063.6 with band widths of 2.0        
 FEI2err               real NOT NULL,      --/U Angstrom            --/D Fe I line index error at 4063.6 with band widths of 2.0  
 FEI2mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4063.6 with band widths of 2.0 
 FEI3side              real NOT NULL,     --/U Angstrom             --/D Fe I line index at 4071.7 with band widths of 2.0         
 FEI3cont              real NOT NULL,     --/U Angstrom             --/D Fe I line index at 4071.7 with band widths of 2.0        
 FEI3err               real NOT NULL,     --/U Angstrom             --/D Fe I line index error at 4071.7 with band widths of 2.0   
 FEI3mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4071.7 with band widths of 2.0 
 SRII2side              real NOT NULL,     --/U Angstrom             --/D Sr II line index at 4077.7 with band widths of 2.0        
 SRII2cont              real NOT NULL,     --/U Angstrom             --/D Sr II line index at 4077.7 with band widths of 2.0        
 SRII2err               real NOT NULL,     --/U Angstrom             --/D Sr II line index error at 4077.7 with band widths of 2.0   
 SRII2mask              tinyint NOT NULL,                            --/D Sr II pixel quality check =0, good, =1 bad at 4077.7 with band widths of 2.0
 FEI4side              real NOT NULL,                               --/D Fe I line index at 4679.5 with band widths of 87.0        
 FEI4cont              real NOT NULL,                               --/D Fe I line index at 4679.5 with band widths of 87.0        
 FEI4err               real NOT NULL,                               --/D Fe I line index error at 4679.5 with band widths of 87.0   
 FEI4mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 4679.5 with band widths of 87.0
 FEI5side              real NOT NULL,                               --/D Fe I line index at 5267.4 with band widths of 38.8        
 FEI5cont              real NOT NULL,                               --/D Fe I line index at 5267.4 with band widths of 38.8        
 FEI5err               real NOT NULL,                               --/D Fe I line index error at 5267.4 with band widths of 38.8   
 FEI5mask              tinyint NOT NULL,                            --/D Fe I pixel quality check =0, good, =1 bad at 5267.4 with band widths of 38.8
)

GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sppParams')
	DROP TABLE sppParams
GO
--
EXEC spSetDefaultFileGroup 'sppParams'
GO
CREATE TABLE sppParams (
-------------------------------------------------------------------------------
--/H Contains outputs from the SEGUE Stellar Parameter Pipeline (SSPP).
-------------------------------------------------------------------------------
--/T Spectra for over 500,000 Galactic stars of all common spectral types are
--/T available with DR8. These Spectra were processed with a pipeline called the
--/T SEGUE Stellar Parameter Pipeline' (SSPP, Lee et al. 2008) that computes 
--/T standard stellar atmospheric parameters such as  [Fe/H], log g and Teff for 
--/T each star by a variety of methods. These outputs are stored in this table, and
--/T indexed on the  specObjID' key index parameter for queries joining to
--/T other tables such as specobjall and photoobjall. bestobjid is also added (and indexed?)
--/T Note that all values of -9999 indicate missing or no values.
--/T See the Sample Queries in SkyServer for examples of such queries. 
-------------------------------------------------------------------------------
  specObjID       numeric(20,0) NOT NULL,                      --/D id number, match in specObjAll
  BESTOBJID       bigint NOT NULL, --/D Object ID of best PhotoObj match (flux-based) --/K ID_MAIN
  FLUXOBJID       bigint NOT NULL, --/D Object ID of best PhotoObj match (position-based) --/K ID_MAIN
  TARGETOBJID            bigint NOT NULL,                      --/D targeted object ID
  PLATEID         numeric(20,0) NOT NULL, --/D Database ID of Plate (match in plateX)
  sciencePrimary  smallint NOT NULL, --/D Best version of spectrum at this location (defines default view SpecObj) --/F specprimary
  legacyPrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among Legacy plates --/F speclegacy
  seguePrimary  smallint NOT NULL, --/D Best version of spectrum at this location, among SEGUE plates (defines default view SpecObj) --/F specsegue
  FIRSTRELEASE    varchar(32) NOT NULL, --/D Name of first release this object was associated with
  SURVEY          varchar(32) NOT NULL, --/D Survey name
  PROGRAMNAME     varchar(32) NOT NULL, --/D Program name
  CHUNK           varchar(32) NOT NULL, --/D Chunk name
  PLATERUN        varchar(32) NOT NULL, --/D Plate drill run name
  MJD               bigint NOT NULL,                        --/D Modified Julian Date of observation                                  
  PLATE             bigint NOT NULL,                        --/D Plate number                                                
  FIBERID           bigint NOT NULL,                        --/D Fiber number (1-640) --/F fiber
  RUN2D             varchar(32) NOT NULL,                   --/D Name of 2D rerun
  RUN1D             varchar(32) NOT NULL,                   --/D Name of 1D rerun
  RUNSSPP           varchar(32) NOT NULL,                   --/D Name of SSPP rerun
  TARGETSTRING     varchar(32) NOT NULL,                   --/D ASCII translation of target selection information as determined at the time the plate was designed --/F prim_target     
  PRIMTARGET       bigint NOT NULL,                        --/D Target selection information at plate design, primary science selection (for backwards compatibility) --/F primtarget  --/R PrimTarget
  SECTARGET        bigint NOT NULL,                        --/D Target selection information at plate design, secondary/qa/calib selection  (for backwards compatibility)  --/R PrimTarget
  LEGACY_TARGET1   bigint NOT NULL,                        --/D Legacy target selection information at plate design, primary science selection --/F legacy_target1  --/R PrimTarget
  LEGACY_TARGET2   bigint NOT NULL,                        --/D Legacy target selection information at plate design, secondary/qa/calib selection  --/F legacy_target2  --/R SecTarget
  SPECIAL_TARGET1   bigint NOT NULL,                        --/D Special program target selection information at plate design, primary science selection --/F special_target1  --/R SpecialTarget1
  SPECIAL_TARGET2   bigint NOT NULL,                        --/D Special program target selection information at plate design, secondary/qa/calib selection  --/F special_target2  --/R SpecialTarget2
  SEGUE1_TARGET1   bigint NOT NULL,                        --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1  --/R Segue1Target1
  SEGUE1_TARGET2   bigint NOT NULL,                        --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection  --/F segue1_target2  --/R Segue1Target2
  SEGUE2_TARGET1   bigint NOT NULL,                        --/D SEGUE-2 target selection information at plate design, primary science selection --/F segue2_target1  --/R Segue2Target1
  SEGUE2_TARGET2   bigint NOT NULL,                        --/D SEGUE-2 target selection information at plate design, secondary/qa/calib selection  --/F segue2_target2  --/R Segue2Target2
  SPECTYPEHAMMER    varchar(32) NOT NULL,                   --/D Spectral Type from HAMMER                                                 
  SPECTYPESUBCLASS  varchar(32) NOT NULL,                   --/D SpecBS sub-classification                                       
  FLAG              varchar(32) NOT NULL,                   --/D Flag with combination of four letters among BCdDEgGhHlnNSV, n=normal      
  TEFFADOP          real NOT NULL,          --/U Kelvin     --/D Adopted Teff, bi-weigth average of estimators with indicator variable of 1    
  TEFFADOPN         tinyint NOT NULL,       --/U Kelvin     --/D Number of estimators used in bi-weight average
  TEFFADOPUNC       real NOT NULL,          --/U Kelvin     --/D Error in the adopted temperature                            
  TEFFHA24          real NOT NULL,          --/U Kelvin     --/D Teff estimate from HA24                                     
  TEFFHD24          real NOT NULL,          --/U Kelvin     --/D Teff estimate from HD24                                     
  TEFFNGS1          real NOT NULL,          --/U Kelvin     --/D Teff estimate from NGS1                                     
  TEFFANNSR         real NOT NULL,          --/U Kelvin     --/D Teff estimate from ANNSR                                    
  TEFFANNRR         real NOT NULL,          --/U Kelvin     --/D Teff estimate from ANNRR                                    
  TEFFWBG           real NOT NULL,          --/U Kelvin     --/D Teff estimate from WBG                                      
  TEFFK24           real NOT NULL,          --/U Kelvin     --/D Teff estimate from k24                                      
  TEFFKI13          real NOT NULL,          --/U Kelvin     --/D Teff estimate from ki13                                     
  TEFFHA24IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good
  TEFFHD24IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                       
  TEFFNGS1IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFANNSRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFANNRRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFWBGIND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFK24IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFKI13IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  TEFFHA24UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from HA24                            
  TEFFHD24UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from HD24                            
  TEFFNGS1UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from NGS1                            
  TEFFANNSRUNC      real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from ANNSR                           
  TEFFANNRRUNC      real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from ANNRR                           
  TEFFWBGUNC        real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from WBG                             
  TEFFK24UNC        real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from k24                             
  TEFFKI13UNC       real NOT NULL,          --/U Kelvin     --/D Error in Teff estimate from ki13                            
  LOGGADOP          real NOT NULL,          --/U dex        --/D Adopted log g, bi-weigth average of estimators with indicator variable of 2   
  LOGGADOPN         tinyint NOT NULL,                       --/D Number of log g estimators in used bi-weight average                         
  LOGGADOPUNC       real NOT NULL,          --/U dex        --/D Error in the adopted log g                                  
  LOGGNGS2          real NOT NULL,          --/U dex        --/D log g estimate from NGS2                                    
  LOGGNGS1          real NOT NULL,          --/U dex        --/D log g estimate from NGS1                                    
  LOGGANNSR         real NOT NULL,          --/U dex        --/D log g estimate from ANNSR                        
  LOGGANNRR         real NOT NULL,          --/U dex        --/D log g estimate from ANNRR                                   
  LOGGCAI1          real NOT NULL,          --/U dex        --/D log g estimate from CaI1                                    
  LOGGWBG           real NOT NULL,          --/U dex        --/D log g estimate from WBG                                     
  LOGGK24           real NOT NULL,          --/U dex        --/D log g estimate from k24                                     
  LOGGKI13          real NOT NULL,          --/U dex        --/D log g estimate from ki13                                    
  LOGGNGS2IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGNGS1IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGANNSRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGANNRRIND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGCAI1IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGWBGIND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGK24IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                         
  LOGGKI13IND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 good                                        
  LOGGNGS2UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from NGS2                           
  LOGGNGS1UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from NGS1                           
  LOGGANNSRUNC      real NOT NULL,          --/U dex        --/D Error in log g estimate from ANNSR                          
  LOGGANNRRUNC      real NOT NULL,          --/U dex        --/D Error in log g estimate from ANNRR                          
  LOGGCAI1UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from CaI1                           
  LOGGWBGUNC        real NOT NULL,          --/U dex        --/D Error in log g estimate from WBG                            
  LOGGK24UNC        real NOT NULL,          --/U dex        --/D Error in log g estimate from k24                            
  LOGGKI13UNC       real NOT NULL,          --/U dex        --/D Error in log g estimate from ki13                           
  FEHADOP           real NOT NULL,          --/U dex        --/D Adopted [Fe/H], bi-weigth average of estimators with indicator variable of 2
  FEHADOPN          tinyint NOT NULL,                       --/D Number of estimators used in bi-weight average                                
  FEHADOPUNC        real NOT NULL,          --/U dex        --/D Error in the adopted [Fe/H]                                 
  FEHNGS2           real NOT NULL,          --/U dex        --/D [Fe/H] estimate from NGS2                                   
  FEHNGS1           real NOT NULL,          --/U dex        --/D [Fe/H] estimate from NGS1                                   
  FEHANNSR          real NOT NULL,          --/U dex        --/D [Fe/H] estimate from ANNSR                                  
  FEHANNRR          real NOT NULL,          --/U dex        --/D [Fe/H] estimate from ANNRR                                  
  FEHCAIIK1         real NOT NULL,          --/U dex        --/D [Fe/H] estimate from CaIIK1                                 
  FEHCAIIK2         real NOT NULL,          --/U dex        --/D [Fe/H] estimate from CaIIK2                                 
  FEHCAIIK3         real NOT NULL,          --/U dex        --/D [Fe/H] estimate from CaIIK3                                 
  FEHWBG            real NOT NULL,          --/U dex        --/D [Fe/H] estimate from WBG                                    
  FEHK24            real NOT NULL,          --/U dex        --/D [Fe/H] estimate from k24                                    
  FEHKI13           real NOT NULL,          --/U dex        --/D [Fe/H] estimate from ki13                                   
  FEHNGS2IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHNGS1IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHANNSRIND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHANNRRIND       tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHCAIIK1IND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHCAIIK2IND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHCAIIK3IND      tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHWBGIND         tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good  
  FEHK24IND         tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good 
  FEHKI13IND        tinyint NOT NULL,                       --/D Indicator variable, = 0 bad, = 1 low S/N or out of g-r color range, = 2 good
  FEHNGS2UNC        real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from NGS2                          
  FEHNGS1UNC        real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from NGS1                          
  FEHANNSRUNC       real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from ANNSR                         
  FEHANNRRUNC       real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from ANNRR                         
  FEHCAIIK1UNC      real NOT NULL,          --/U dex        --/D Error in [Fe/H] estiimate from CaIIK1                       
  FEHCAIIK2UNC      real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from CaIIK2                        
  FEHCAIIK3UNC      real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from CaIIK3                        
  FEHWBGUNC         real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from WBG                           
  FEHK24UNC         real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from k24                           
  FEHKI13UNC        real NOT NULL,          --/U dex        --/D Error in [Fe/H] estimate from ki13                          
  SNR               real NOT NULL,                          --/D Average S/N per pixel over 4000 - 8000 A                    
  QA                tinyint NOT NULL,                       --/D Quality check on spectrum, depending on S/N 
  CCCAHK            real NOT NULL,                          --/D Correlation coefficient over 3850-4250 A                    
  CCMGH             real NOT NULL,                          --/D Correlation coefficient over 4500-5500 A                  
  TEFFSPEC          real NOT NULL,          --/U Kelvin     --/D Spectroscopically determined Teff, color independent   
  TEFFSPECN         tinyint NOT NULL,                       --/D Number of estimators used in average                   
  TEFFSPECUNC       real NOT NULL,          --/U Kelvin     --/D Error in the spectroscopically determined Teff         
  LOGGSPEC          real NOT NULL,          --/U dex        --/D Spectroscopically determined log g, color independent  
  LOGGSPECN         tinyint NOT NULL,                       --/D Number of estimators used in average                   
  LOGGSPECUNC       real NOT NULL,          --/U dex        --/D Error in the spectroscopically determined log g        
  FEHSPEC           real NOT NULL,          --/U dex        --/D Spectroscopically determined [Fe/H], color independent 
  FEHSPECN          tinyint NOT NULL,                       --/D Number of estimators used in average                   
  FEHSPECUNC        real NOT NULL,          --/U dex        --/D Error in the spectroscopically determined [Fe/H]       
  ACF1              real NOT NULL,                          --/D Auto-Correlation Function over 4000-4086/4116-4325/4355-4500         
  ACF1SNR           real NOT NULL,                          --/D Average signal-to-noise ratio in Auto-Correlation Function 1 (ACF1)      
  ACF2              real NOT NULL,                          --/D Auto-Correlation Functioin over 4000-4086/4116-4280/4280-4500         
  ACF2SNR           real NOT NULL,                          --/D Average signal-to-noise ratio in Auto-Correlation Function 2 (ACF2)      
  INSPECT           varchar(32) NOT NULL,                   --/D Flag with combination of six letters among FTtMmCn, for inspecting spectra  
  ELODIERVFINAL     real NOT NULL,            --/U km/s      --/D Velocity as measured by Elodie library templates, converted to km/s and with the empirical 7.3 km/s offset applied (see Yanny et al. 2009, AJ, 137, 4377)
  ELODIERVFINALERR  real NOT NULL,            --/U km/s      --/D Uncertainty in the measured Elodie RV, as determined from the chisq template-fitting routine.  See the discussion of empirically-determined velocity errors in Yanny et al. 2009, AJ, 137, 4377
  ZWARNING          bigint NOT NULL,                         --/D Warning flags about velocity/redshift determinations 
  TEFFIRFM           real NOT NULL,            --/U Kelvin    --/D Teff from Infrared Flux Methods (IRFM)
  TEFFIRFMIND       tinyint NOT NULL,                        --/D Indicator variable, = 0 bad, = 1 good
  TEFFIRFMUNC       real NOT NULL,            --/U dex       --/D Error in Teff estimate from IRFM
  LOGGNGS1IRFM      real NOT NULL,           --/U dex       --/D log g estimate from NGS1 while fixing Teff from IRFM 
  LOGGNGS1IRFMIND  tinyint NOT NULL,                      --/D Indicator variable, = 0 bad, =1 good
  LOGGNGS1IRFMUNC  real NOT NULL,            --/U dex     --/D Error in log g from NGS1 while fixing Teff from IRFM
  FEHNGS1IRFM       real NOT NULL,           --/U dex      --/D [Fe/H] estimate from NGS1 while fixing Teff from IRFM
  FEHNGS1IRFMIND   tinyint NOT NULL,                      --/D Indicator variable, =0 bad, = 1 good
  FEHNGS1IRFMUNC   real NOT NULL,            --/U dex     --/D  Error in [Fe/H] from NGS1 while fixing Teff from IRFM
  LOGGCAI1IRFM      real NOT NULL,            --/U dex     --/D log g estimate from CAI1 with fixed IRFM Teff
  LOGGCAI1IRFMIND  tinyint NOT NULL,                      --/D Indicator variable,  =0 bad, = 1 good
  LOGGCAI1IRFMUNC  real NOT NULL,            --/U dex     --/D Error in log g from CAI1 with fixed IRFM Teff
  FEHCAIIK1IRFM     real NOT NULL,            --/U dex     --/D [Fe/H] from CaIIK1 with fixed IRFM Teff
  FEHCAIIK1IRFMIND tinyint NOT NULL,                      --/D Indicator variable, =0 bad, = 1 good
  FEHCAIIK1IRFMUNC real NOT NULL,            --/U dex     --/D Error in [Fe/H] from CaIIK1 with fixed IRFM Teff
)                                                                                
GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'sppTargets')
	DROP TABLE sppTargets
GO
--
EXEC spSetDefaultFileGroup 'sppTargets'
GO
CREATE TABLE sppTargets(
-----------------------------------------------------------------------------------------
--/H Derived quantities calculated by the SEGUE-2 target selection pipeline.
-----------------------------------------------------------------------------------------
--/T There are one of these files per plate. The file has one HDU.
--/T That HDU has one row for every object in photoObjAll that is
--/T classified as a star inside a 94.4 arcmin radius of the center of the
--/T plate.  The data for each object are elements of the photoObjAll, specObjAll, 
--/T sppPrams and propermotions tables taken unaltered from the CAS and derived 
--/T quantities calculated by the segue-2 target selection code.  Appended to the
--/T end are the two target selection bitmasks, segue2_target1 and segue2_target2, 
--/T as set by the target selection code.<br>
--/T<br>
--/T <i>Columns from OBJID through PSFMAGERR_:</i> <br>
--/T These are taken directly from photoObjAll <br> 
--/T<br>
--/T <i>Columns from PLATEID through SEGUE2_TARGET2:</i> <br>
--/T These are taken from the specObjAll and sppParams tables for any
--/T objects in this file that have matches in that specObjAll.  For
--/T objects without matches in specObjAll, values are set to -9999.
--/T The names from SpecObjAll are unchanged. <br>
--/T<br>
--/T <i>Columns from MATCH through DIST20: </i><br>
--/T These are taken from the propermotions table, the USNOB proper
--/T motions as recalibrated with the SDSS by Jeff Munn.  For objects
--/T without matches in the ProperMotions table, values are set to -9999.
--/T The names are unchanged from the propermotions table. <br>
--/T<br>
--/T <i>Columns from uMAG0 through VTOT_GALRADREST:</i> <br>
--/T These are the derived quanitites calculated  by the procedure
--/T calderivedquantities in derivedquant.pro in the segue-2 target
--/T selection code.  With the addition of these, this file contains all
--/T the quanitites that the selection code operates on when choosing targets.<br>
--/T<br>
--/T <i>Columns MG_TOHV through V1SIGMAERR_TOHV:</i> <br>
--/T These were added for the November 2008 drilling run and after.
--/T The earlier files will be retrofit (eventually).
-----------------------------------------------------------------------------------------
OBJID              bigint NOT NULL,             --/D Object ID matching DR8 --/F NOFITS
RUN                bigint NOT NULL,             --/D Run number
RERUN              bigint NOT NULL,             --/D Rerun number                                     
CAMCOL             bigint NOT NULL,             --/D Camera column number 
FIELD              bigint NOT NULL,             --/D Field number                                      
OBJ                bigint NOT NULL,             --/D Object                                      
RA                 float   NOT NULL, --/U degree --/D RA                                     
DEC                float   NOT NULL, --/U degree --/D Dec                                     
L                  float   NOT NULL, --/U degree --/D Galactic longitude                                    
B                  float   NOT NULL, --/U degree --/D Galactic latitude                            
FIBERMAG_u         real   NOT NULL, --/U mag    --/D u band fiber magnitudue
FIBERMAG_g         real   NOT NULL, --/U mag    --/D g band fiber magnitudue
FIBERMAG_r         real   NOT NULL, --/U mag    --/D r band fiber magnitudue
FIBERMAG_i         real   NOT NULL, --/U mag    --/D i band fiber magnitudue
FIBERMAG_z         real   NOT NULL, --/U mag    --/D z band fiber magnitudue
PSFMAG_u           real   NOT NULL, --/U mag    --/D u band PSF magnitude
PSFMAG_g           real   NOT NULL, --/U mag    --/D g band PSF magnitude
PSFMAG_r           real   NOT NULL, --/U mag    --/D r band PSF magnitude
PSFMAG_i           real   NOT NULL, --/U mag    --/D i band PSF magnitude
PSFMAG_z           real   NOT NULL, --/U mag    --/D z band PSF magnitude
EXTINCTION_u       real   NOT NULL, --/U mag    --/D u band extinction
EXTINCTION_g       real   NOT NULL, --/U mag    --/D g band extinction
EXTINCTION_r       real   NOT NULL, --/U mag    --/D r band extinction
EXTINCTION_i       real   NOT NULL, --/U mag    --/D i band extinction
EXTINCTION_z       real   NOT NULL, --/U mag    --/D z band extinction
ROWC              int NOT NULL, --/U pix      --/D row centroid
COLC              int NOT NULL, --/U pix      --/D column centroid
TYPE         int NOT NULL, --/D object type from photometric reductions
FLAGS        bigint NOT NULL,             --/D combined flags from all bands
FLAGS_u           bigint NOT NULL,             --/D u band flag
FLAGS_g           bigint NOT NULL,             --/D g band flag
FLAGS_r           bigint NOT NULL,             --/D r band flag
FLAGS_i           bigint NOT NULL,             --/D i band flag
FLAGS_z           bigint NOT NULL,             --/D z band flag
PSFMAGERR_u       real    NOT NULL, --/U mag    --/D Error in u band PSF magnitude
PSFMAGERR_g       real    NOT NULL, --/U mag    --/D Error in u band PSF magnitude
PSFMAGERR_r       real    NOT NULL, --/U mag    --/D Error in u band PSF magnitude
PSFMAGERR_i       real    NOT NULL, --/U mag    --/D Error in u band PSF magnitude
PSFMAGERR_z       real    NOT NULL, --/U mag    --/D Error in u band PSF magnitude
PLATEID       numeric(20,0)  NOT NULL,             --/D Hash of plate and MJD 
SPECOBJID       numeric(20)  NOT NULL,             --/D Spectroscopic object ID
PLATE           bigint   NOT NULL,             --/D Plate number         
MJD             bigint   NOT NULL,             --/D Modified Julian Date     
FIBERID         bigint   NOT NULL,             --/D Fiber number     
ORIGINALPLATEID       bigint  NOT NULL,             --/D Original plate ID hash (if targeted based on previous spectrum)
ORIGINALSPECOBJID       numeric(20,0)  NOT NULL,             --/D Original spectroscopic object ID (if targeted based on previous spectrum)
ORIGINALPLATE           bigint   NOT NULL,             --/D Original plate number   (if targeted based on previous spectrum)       
ORIGINALMJD             bigint   NOT NULL,             --/D Original Modified Julian Date   (if targeted based on previous spectrum)   
ORIGINALFIBERID         bigint   NOT NULL,             --/D Original fiber number    (if targeted based on previous spectrum)(if targeted based on previous spectrum)   
BESTOBJID       bigint  NOT NULL,             --/D Best object ID   --/F NOFITS
TARGETOBJID     bigint  NOT NULL,             --/D Target object ID  
PRIMTARGET      int  NOT NULL,             --/D Primary target  --/R PrimTarget
SECTARGET       int  NOT NULL,             --/D Secondary target  --/R SecTarget
SEGUE1_TARGET1   bigint NOT NULL,                        --/D SEGUE-1 target selection information at plate design, primary science selection --/F segue1_target1  --/R Segue1Target1
SEGUE1_TARGET2   bigint NOT NULL,                        --/D SEGUE-1 target selection information at plate design, secondary/qa/calib selection  --/F segue1_target2  --/R Segue1Target2
SEGUE2_TARGET1   int NOT NULL,  --/D bitmask that records the category or categories for which this object passed the selection criteria  --/F segue2_target1  --/R Segue2Target1
SEGUE2_TARGET2   int NOT NULL,  --/D bitmask that records the category or categories of "standards" for the pipeline, special calibration targets like Stetson standards or globular cluster stars, for which this object passed the selection criteria  --/F segue2_target2  --/R Segue2Target2
MATCH          bigint  NOT NULL,                 --/D ??
DELTA          float    NOT NULL,                 --/D ??
PML            float     NOT NULL, --/U mas/year?  --/D Proper motion in Galactic longitude?
PMB            float     NOT NULL, --/U mas/year?  --/D Proper motion in Galactic latitude?
PMRA           float     NOT NULL, --/U mas/year?  --/D Proper motion in RA  
PMDEC          float     NOT NULL, --/U mas/year?  --/D Proper motion in DEC 
PMRAERR        float     NOT NULL, --/U mas/year?  --/D Proper motion error in RA
PMDECERR       float     NOT NULL, --/U mas/year?  --/D Proper motion error in DEC
PMSIGRA        float     NOT NULL, --/U mas/year?  --/D?
PMSIGDEC       float     NOT NULL, --/U mas/year?  --/D?
NFIT           int NOT NULL,                 --/D?
DIST22         float    NOT NULL,                 --/D?
DIST20         float    NOT NULL,                 --/D?
uMAG0         real  NOT NULL,  --/U mag      --/D u extinction-corrected (SFD 98) psf magnitude 
gMAG0         real  NOT NULL,  --/U mag      --/D g extinction-corrected (SFD 98) psf magnitude   
rMAG0         real  NOT NULL,  --/U mag      --/D r extinction-corrected (SFD 98) psf magnitude   
iMAG0         real  NOT NULL,  --/U mag      --/D i extinction-corrected (SFD 98) psf magnitude  
zMAG0         real  NOT NULL,  --/U mag      --/D z extinction-corrected (SFD 98) psf magnitude  
umg0          real  NOT NULL,  --/U mag      --/D u-g, extinction corrected magnitudes
gmr0          real  NOT NULL,  --/U mag      --/D g-r, extinction corrected magnitudes
rmi0          real  NOT NULL,  --/U mag      --/D r-i, extinction corrected magnitudes
imz0          real  NOT NULL,  --/U mag      --/D i-z, extinction corrected magnitudes
gmi0          real  NOT NULL,  --/U mag      --/D g-i, extinction corrected magnitudes
umgERR       real  NOT NULL,  --/U mag      --/D PSFMAGERR_u and PSFMAGERR_g added in quadrature
gmrERR       real  NOT NULL,  --/U mag      --/D PSFMAGERR_g and PSFMAGERR_r added in quadrature
rmiERR       real  NOT NULL,  --/U mag      --/D PSFMAGERR_r and PSFMAGERR_i added in quadrature
imzERR       real  NOT NULL,  --/U mag      --/D PSFMAGERR_i and PSFMAGERR_z added in quadrature
PSFMAG_umg   real  NOT NULL,  --/U mag      --/D psfmag_u-psfmag_g, no extinction correction --/F psfmag_umg
PSFMAG_gmr   real  NOT NULL,  --/U mag      --/D psfmag_g-psfmag_r, no extinction correction --/F psfmag_gmr
PSFMAG_rmi   real  NOT NULL,  --/U mag      --/D psfmag_r-psfmag_i, no extinction correction --/F psfmag_rmi
PSFMAG_imz   real  NOT NULL,  --/U mag      --/D psfmag_i-psfmag_z, no extinction correction --/F psfmag_imz
PSFMAG_gmi   real  NOT NULL,  --/U mag      --/D psfmag_g-psfmag_i, no extinction correction --/F psfmag_gmi
lcolor       real  NOT NULL,  --/U mag      --/D -0.436*uMag+1.129*gMag-0.119*rMag-0.574*iMag+0.1984 (Lenz et al.1998) 
scolor       real  NOT NULL,  --/U mag      --/D -0.249*uMag+0.794*gMag-0.555*rMag+0.234+0.011*p1s-0.010 (Helmi et al. 2003) used in SEGUE-1 target selection, unused in SEGUE-2
p1s          real  NOT NULL,  --/U mag      --/D 0.91*umg+0.415*umg-1.280 (Helmi et al. 2003) used in SEGUE-1 target selection, unused in SEGUE-2
TOTALPM      real  NOT NULL,  --/U mas/year --/D sqrt(PMRA*PMRA+PMDEC*PMDEC), in mas/year 
Hg           real  NOT NULL,  --/U mag        --/D reduced proper motion, gMag+5*log10(TOTALPM/1000)+5 
Mi           real  NOT NULL,  --/U mag      --/D 4.471+7.907*imz-0.837*imz*imz used in SEGUE-1 target selection, unused in SEGUE-2
DISTi        real  NOT NULL,  --/U mag      --/D 10^((iMag-Mi+5)/5.0) used in SEGUE-1 target selection, unused in SEGUE-2
Hr           real  NOT NULL,  --/U mag        --/D reduced pm (uncorr r): PSFMAG_r+5*log10(TOTALPM/1000)+5   
VMI_TRANS1   real  NOT NULL,  --/U mag      --/D V-I from VMAG_TRANS-(iMag-0.337*rmi-0.37) --/F vmi_trans1
VMI_TRANS2   real  NOT NULL,  --/U mag      --/D V-I from 0.877*gmr+0.358 --/F vmi_trans2
VMAG_TRANS   real  NOT NULL,  --/U mag      --/D V mag from gMag - 0.587*gmr -0.011 --/F vmag_trans
MV_TRANS     real  NOT NULL,  --/U mag     --/D not stuffed --/F NOFITS
DISTV_KPC    real  NOT NULL,  --/U kpc      --/D 10^(dmV/5.-2.) where VMAG_TRANS-(3.37*VMI_TRANS1+2.89) --/F distv_kpc
VTRANS_GALREST      real  NOT NULL,  --/U km/s      --/D transvere velocity, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy --/F vtrans_galrest
MUTRANS_GALRADREST  real  NOT NULL,  --/U mas/year  --/D derived PM (mas/year) perpendicular to the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy --/F mutrans_galradrest
MURAD_GALRADREST    real  NOT NULL,  --/U mas/year  --/D derived PM (mas/year) along the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy --/F murad_galradrest
VTOT_GALRADREST     real  NOT NULL,  --/U km/s      --/D total velocioty, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy --/F vtot_galradrest
MG_TOHV          real  NOT NULL,  --/U mag       --/D 5.7 + 10.0*(GMR - 0.375) --/F mg_tohv
VTRANS_TOHV      real  NOT NULL,  --/U km/s      --/D transverse velocity in Galactocentric coords, using the distance estimate from MG_TOHV which is appropriate for old stars near the MSTO and corrected for peculiar solar motion 16.6 km/s toward RA,Dec 267.5,28.1  --/F vtrans_tohv
PM1SIGMA_TOHV    real  NOT NULL,  --/U mas/year  --/D Estimate of the 1-sigma error in total proper motion at this r magnitude.  Formula is sqrt(4.56*4.56 + frate*2.30*2.30), where frate is 10^(0.4*(rMag-19.5)).  The constants come from the Munn et al. 2004 (AJ, 127, 3034) paper describing the recalibration of USNOB with SDSS. --/F pm1sigma_tohv
V1SIGMAERR_TOHV  real  NOT NULL,  --/U km/s      --/D The corresponding 1-sigma error in the transverse velocity based on PM1SIGMA_TOHV and the the distance estimate using MG_TOHV --/F v1sigmaerr_tohv
TARGET_VERSION   varchar(100)  --/D version of target used  --/F TARGET_VERSION
)

GO
--

--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'Plate2Target')
	DROP TABLE Plate2Target
GO
--
EXEC spSetDefaultFileGroup 'Plate2Target'
GO

CREATE TABLE Plate2Target (
-------------------------------------------------------------------------------
--/H Which objects are in the coverage area of which plates?
--/T This table has an entry for each case of a target from the 
--/T sppTargets table having been targetable by a given plate.
--/T Can be joined with plateX on the PLATEID column, and with
--/T sppTargets on the OBJID column. Some plates are included
--/T that were never observed; the PLATEID values for these 
--/T will not match any entries in the plateX table.
-------------------------------------------------------------------------------
plate2targetid  [int]  NOT NULL,  --/D primary key --/F NOFITS
plate  [int]  NOT NULL,  --/D plate number
plateid  [numeric](20,0)  NOT NULL,  --/D plate identification number in plateX
objid  [bigint]  NOT NULL,  --/D object identification number in sppTargets
loadVersion     int NOT NULL            --/D Load Version --/F NOFITS
)

GO
--


--=========================================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'segueTargetAll')
	DROP TABLE segueTargetAll
GO
--
EXEC spSetDefaultFileGroup 'segueTargetAll'
GO

CREATE TABLE segueTargetAll (
-------------------------------------------------------------------------------
--/H SEGUE-1 and SEGUE-2 target selection run on all imaging data
--/T This table gives the results for SEGUE target selection algorithms
--/T for the full photometric catalog. The target flags in these files 
--/T are not the ones actually used for the SEGUE-1 and SEGUE-2 survey.  
--/T Instead, they are derived from the final photometric data set from 
--/T DR8. Only objects designated RUN_PRIMARY have target selection 
--/T flags set. 
-------------------------------------------------------------------------------
      objid bigint NOT NULL,	--/D unique id, points to photoObj --/K ID_MAIN
      segue1_target1 [int] NOT NULL,	--/D SEGUE-1 primary target selection flag --/K ID_MAIN  --/R Segue1Target1
      segue1_target2 [int] NOT NULL,	--/D SEGUE-1 secondary target selection flag --/K ID_MAIN  --/R Segue1Target2
      segue2_target1 [int] NOT NULL,	--/D SEGUE-2 primary target selection flag --/K ID_MAIN  --/R Segue2Target1
      segue2_target2 [int] NOT NULL,	--/D SEGUE-2 secondary target selection flag --/K ID_MAIN  --/R Segue2Target2
      lcolor       real  NOT NULL,  --/U mag      --/D SEGUE-1 and -2 target selection color: -0.436*uMag+1.129*gMag-0.119*rMag-0.574*iMag+0.1984 (Lenz et al.1998) 
      scolor       real  NOT NULL,  --/U mag      --/D SEGUE-1 target selection color: -0.249*uMag+0.794*gMag-0.555*rMag+0.234+0.011*p1s-0.010 (Helmi et al. 2003) 
      p1s          real  NOT NULL,  --/U mag      --/D SEGUE-1 target selection color: 0.91*umg+0.415*umg-1.280 (Helmi et al. 2003) 
      totalpm      real  NOT NULL,  --/U mas/year --/D sqrt(PMRA*PMRA+PMDEC*PMDEC), in mas/year 
      hg           real  NOT NULL,  --/U mag        --/D reduced proper motion, gMag+5*log10(TOTALPM/1000)+5 
      Mi           real  NOT NULL,  --/U mag      --/D 4.471+7.907*imz-0.837*imz*imz used in SEGUE-1 target selection, unused in SEGUE-2
      disti        real  NOT NULL,  --/U mag      --/D 10^((iMag-Mi+5)/5.0) used in SEGUE-1 target selection, unused in SEGUE-2
      Hr           real  NOT NULL,  --/U mag        --/D reduced pm (uncorr r): PSFMAG_r+5*log10(TOTALPM/1000)+5   
      vmi_trans1   real  NOT NULL,  --/U mag      --/D V-I from VMAG_TRANS-(iMag-0.337*rmi-0.37) 
      vmi_trans2   real  NOT NULL,  --/U mag      --/D V-I from 0.877*gmr+0.358 
      vmag_trans   real  NOT NULL,  --/U mag      --/D V mag from gMag - 0.587*gmr -0.011 
      Mv_trans     real  NOT NULL,  --/U mag     --/D 
      distv_kpc    real  NOT NULL,  --/U kpc      --/D 10^(dmV/5.-2.) where VMAG_TRANS-(3.37*VMI_TRANS1+2.89) 
      vtrans_galrest      real  NOT NULL,  --/U km/s   --/D transvere velocity, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy 
      mutrans_galradrest  real  NOT NULL,  --/U mas/year  --/D derived PM (mas/year) perpendicular to the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy 
      murad_galradrest    real  NOT NULL,  --/U mas/year  --/D derived PM (mas/year) along the Galactocentric radial vector, assuming all motion is along a Galactocentric radial vector, in a frame at rest w.r.t the Galaxy 
      vtot_galradrest     real  NOT NULL,  --/U km/s      --/D total velocity, km/s, derived from TOTALPM and DISTV_KPC, in a frame at rest w.r.t the Galaxy 
      mg_tohv          real  NOT NULL,  --/U mag       --/D 5.7 + 10.0*(GMR - 0.375) 
      vtrans_tohv      real  NOT NULL,  --/U km/s      --/D transverse velocity in Galactocentric coords, using the distance estimate from MG_TOHV which is appropriate for old stars near the MSTO and corrected for peculiar solar motion 16.6 km/s toward RA,Dec 267.5,28.1  
      pm1sigma_tohv    real  NOT NULL,  --/U mas/year  --/D Estimate of the 1-sigma error in total proper motion at this r magnitude.  Formula is sqrt(4.56*4.56 + frate*2.30*2.30), where frate is 10^(0.4*(rMag-19.5)).  The constants come from the Munn et al. 2004 (AJ, 127, 3034) paper describing the recalibration of USNOB with SDSS. 
      v1sigmaerr_tohv  real  NOT NULL,  --/U km/s      --/D The corresponding 1-sigma error in the transverse velocity based on PM1SIGMA_TOHV and the the distance estimate using MG_TOHV 
)
GO
--


EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO
--
PRINT '[ssppTables.sql]: SEGUE Stellar Parameter Pipeline tables and related views created'
GO

