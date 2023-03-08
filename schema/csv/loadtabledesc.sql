
----------------------------- 
--  loadtabledesc.sql
----------------------------- 
SET NOCOUNT ON
GO
TRUNCATE TABLE tabledesc
GO

INSERT tabledesc VALUES('Algorithm','Meta','','This table provides descriptive text for each of the algorithms used in SDSS
data processing.  It is interlinked with the Glossary and Table Descriptions
pages.
' );
INSERT tabledesc VALUES('Ap7Mag','Photo','','The Ap7Mag table contains the r-band aperture magnitudes in bin 7 for all the
<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a> objects.  See also the functions
fGetPhotoApMag, fPhotoApMag and fPhotoApMagErr.
' );
INSERT tabledesc VALUES('Best2Sector','Geometry','','This table places the Best<a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a> photometric objects into sectors, which are used to divide the sky into geometric regions. Each object appears once, and only once, in this table because a given ra and dec belong to a unique sector.
' );
INSERT tabledesc VALUES('Chunk','Geometry','','This table contains some very basic information for each chunk<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a> loaded in the database. 
' );
INSERT tabledesc VALUES('Convex','Geometry','','' );
INSERT tabledesc VALUES('DataConstants','Meta','','The table DataConstants contains most of the bit-flags and enumerated quantities relevant to the SDSS. DO NOT confuse this with SDSSConstants<a href=''tabledesc.asp?key=SDSSConstants''><img src=''images/tableref.gif'' border=0></a>, which contains actual constants used in data processing.
' );
INSERT tabledesc VALUES('DBColumns','Meta','','This table contains an extremely brief description of every column in every table in the database. Because some quantities appear in multiple tables with multiple meanings, a quantity is uniquely defined only within a single table.
' );
INSERT tabledesc VALUES('DBObjectDescription','Meta','','This table contains the long descriptions for every table and view in the database.
' );
INSERT tabledesc VALUES('DBObjects','Meta','','This table contains names and descriptions of all the tables and views in the database.
' );
INSERT tabledesc VALUES('DBViewCols','Meta','','This table stores the names and descriptions of all columns in all views<a href=''glossary.asp?key=view''><img src=''images/glossary.gif'' border=0></a> in the database. This is used by the auto-documentation.
' );
INSERT tabledesc VALUES('Dependency','Meta','','The Dependency table tracks dependencies between the tables, functions and
stored procedures in the database.  It is aid to the schema designers.
' );
INSERT tabledesc VALUES('Diagnostics','Meta','','This table contains the type and number of rows (if applicable) for each
object in the database.  The type field can have one of the following values:
<table align=center>
<tr><td>F</td><td>Foreign Key</td></tr>
<tr><td>FN</td><td>Scalar Function</td></tr>
<tr><td>I</td><td>Index</td></tr>
<tr><td>P</td><td>Stored Procedure</td></tr>
<tr><td>TF</td><td>Table-valued Function</td></tr>
<tr><td>U</td><td>Table</td></tr>
<tr><td>V</td><td>View</td></tr>
</table>
' );
INSERT tabledesc VALUES('DR3QuasarCatalog','Spectro','','The list of all confirmed quasars found in Data Release 3 of SDSS, along with
their parameters and cross-matches with other major catalogs.  The algorithm
used to extract quasars from SDSS data is described in Schneider et al. 2005.
' );
INSERT tabledesc VALUES('DR5QuasarCatalog','Spectro','','The list of all confirmed quasars found in Data Release 5 of SDSS, along with
their parameters and cross-matches with other major catalogs.  The algorithm
used to extract quasars from SDSS data is described in Schneider et al. 2007
(AJ).  Note that the parameters are somewhat different from the DR3 catalog.
' );
INSERT tabledesc VALUES('ELRedShift','Spectro','','This table contains ALL of the measured emission lines<a href=''algorithm.asp?key=redshift_type''><img src=''images/algorithm.gif'' border=0></a>, along with their redshifts and related information, for ALL spectroscopic objects.
' );
INSERT tabledesc VALUES('Field','Meta','','This table contains all the measured parameters of each imaging field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>, along with relevant summary statistics, and astrometric and photometric information.
' );
INSERT tabledesc VALUES('FieldProfile','Photo','','Need description.
' );
INSERT tabledesc VALUES('FileGroupMap','Meta','','The File Group Map describes the database partitioning scheme, and it is
usually empty when the database is not partitioned.  It is an internal table
used for schema design.
' );
INSERT tabledesc VALUES('First','External','','This table stores measurements from the FIRST radio survey for those FIRST objects which are matched to SDSS photometric objects. ????
' );
INSERT tabledesc VALUES('Frame','Photo','','This table actually contains false color JPEG images of the fields<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>, and their most relevant parameters, in particular the coefficients of the astrometric transformation<a href=''algorithm.asp?key=astrometry''><img src=''images/algorithm.gif'' border=0></a>, and position info. The images are stored at several zoom levels. 
' );
INSERT tabledesc VALUES('Glossary','Meta','','The Glossary table holds the contents of the Glossary Help page, which is
loaded dynamically with a query to the database.
' );
INSERT tabledesc VALUES('HalfSpace','Geometry','','This table contains constraints on the boundaries of different Regions.  See
also the <a href=''tabledesc.asp?key=Region''><img src=''images/tableref.gif'' border=0></a> and <a href=''tabledesc.asp?key=RegionConvex''><img src=''images/tableref.gif'' border=0></a>
tables.
' );
INSERT tabledesc VALUES('History','Meta','','This is a history of changes to the database.
' );
INSERT tabledesc VALUES('HoleObj','Spectro','','This table stores information for non-OBJECT holes<a href=''glossary.asp?key=hole''><img src=''images/glossary.gif'' border=0></a> on spectroscopic plates<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a>, and for OBJECT holes that were not mapped by the fiber mapper. 
' );
INSERT tabledesc VALUES('IndexMap','Meta','','This table drives the creation of database indexes in the database.  It
contains the name, table name, type (primary key, foreign key or covering
index) and description of every index in the database.  
' );
INSERT tabledesc VALUES('Inventory','Meta','','A detailed inventory of every object in the database tracked my DDL module
(file name).
' );
INSERT tabledesc VALUES('LoadHistory','Meta','','This table contains a record of every data loading step that this database has
experienced.   This is helpful in tracking provenance and data errors.
' );
INSERT tabledesc VALUES('Mask','Geometry','','This table contains information about each photometric mask<a href=''glossary.asp?key=mask''><img src=''images/glossary.gif'' border=0></a>. 
' );
INSERT tabledesc VALUES('MaskedObject','Geometry','','This is a list of all masked<a href=''glossary.asp?key=mask''><img src=''images/glossary.gif'' border=0></a> photometric objects. These objects were detected but are within the boundaries of a masked area (see the Mask table) and thus unreliable. Each object may appear multiple times, if it is masked for multiple reasons. 
' );
INSERT tabledesc VALUES('Match','Photo','','This table contains pairs of photometric objects from different runs<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a> (times) that probably are the same object.  These must be SDSS primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> or secondary<a href=''glossary.asp?key=secondary''><img src=''images/glossary.gif'' border=0></a> objects, of type STAR, GALAXY, and UNKNOWN, within 1 arcsec of one another, and from different runs. The table also holds type, mode and distance information. Also see the MatchHead table<a href=''tabledesc.asp?key=MatchHead''><img src=''images/tableref.gif'' border=0></a><a href=''algorithm.asp?key=match''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('MatchHead','Photo','','When photometric objects from different runs<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a> are matched (see the Match table), they form a cluster named by
 the minimum objID in the cluster. MatchHead has summary information (mean position, number in cluster) about each of these clusters, keyed by the objID.<a href=''algorithm.asp?key=match''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT tabledesc VALUES('Neighbors','Photo','','This table contains ALL pairs of photometric objects within 0.5 arcminutes, regardless of their status (primary, secondary, family, outside). This table is very useful for finding objects near each other but care must be taken to select only those objects with the appropriate status.
' );
INSERT tabledesc VALUES('ObjMask','Photo','','This table contains the outlines of each detected photometric object over a 4x4 pixel grid, and the bounding rectangle of the object within the frame.<glossary>frame</glossary> This table should not be confused with the similarly named Mask table, which describes regions excluded from the object catalogs.' );
INSERT tabledesc VALUES('PhotoObjAll','Photo','','This table contains all measured parameters for all photometric objects. Because this table is huge, a variety of Views<a href=''glossary.asp?key=view''><img src=''images/glossary.gif'' border=0></a> have been created:
<ul>
<li><b>PhotoPrimary</b><a href=''tabledesc.asp?key=PhotoPrimary''><img src=''images/tableref.gif'' border=0></a>: all photo objects that are primary (the best version of the object)</li> 
	<ul>
          <li><b>Star</b><a href=''tabledesc.asp?key=Star''><img src=''images/tableref.gif'' border=0></a>: Primary objects that are classified<a href=''algorithm.asp?key=classify''><img src=''images/algorithm.gif'' border=0></a> as stars.</li>  
          <li><b>Galaxy</b><a href=''tabledesc.asp?key=Galaxy''><img src=''images/tableref.gif'' border=0></a>: Primary objects that are classified<a href=''algorithm.asp?key=classify''><img src=''images/algorithm.gif'' border=0></a> as galaxies.</li>  
          <li><b>Sky</b><a href=''tabledesc.asp?key=Sky''><img src=''images/tableref.gif'' border=0></a>: Primary objects which are sky samples.</li>  
          <li><b>Unknown</b><a href=''tabledesc.asp?key=Unknown''><img src=''images/tableref.gif'' border=0></a>: Primary objects which are none of the above</li> 
	</ul>
<li><b>PhotoSecondary</b><a href=''tabledesc.asp?key=PhotoSecondary''><img src=''images/tableref.gif'' border=0></a>: all photo objects that are secondary (secondary detections).
<li><b>PhotoFamily</b><a href=''tabledesc.asp?key=PhotoFamily''><img src=''images/tableref.gif'' border=0></a>:: all photo objects which are neither primary nor secondary. These are the parents<a href=''glossary.asp?key=parent''><img src=''images/glossary.gif'' border=0></a> of deblended<a href=''algorithm.asp?key=deblend''><img src=''images/algorithm.gif'' border=0></a> objects. 
</ul>
' );
INSERT tabledesc VALUES('PhotoAuxAll','Photo','','This table contains the extra parameters for all photometric objects that did not make it into the PhotoObjall table.  These are added as a separate table because adding columns to the very large PhotoObjAll table is prohibitively expensive unless the table is reloaded from scratch.  In a future release, these columns will be added to the PhotoObjAll table.  In the meantime, to access these columns, you may join with the PhotoObjAll table on the objid: <dd> SELECT p.objid, p.ra, q.raErr, p.dec, q.decErr <dd> FROM PhotoObjAll p, PhotoAuxAll q <dd> WHERE p.objid = q.objid <br> Similarly you may join the PhotoObj and PhotoAux views.  PhotoAux is the view of this table analogous to PhotoObj for PhotoObjAll.
' );
INSERT tabledesc VALUES('PhotoProfile','Photo','','This table contains the radial profiles for each photometric object, as the mean flux in each annulus. The radii of the annuli are given in the ProfileDefs table<a href=''tabledesc.asp?key=ProfileDefs''><img src=''images/tableref.gif'' border=0></a>. 
' );
INSERT tabledesc VALUES('PhotoTag','Photo','','This table contains a subset of the parameters for all of the photometric objects. It has all of the objects that are in the PhotoObjAll table<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a>, but only the most popular parameters for each.
' );
INSERT tabledesc VALUES('Photoz','Photo','','The Photoz table contains a set of photometric redshifts that has been
obtained with the template fitting method <a href=''algorithm.asp?key=photoz''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('Photoz2','Photo','','The photometric redshifts in the Photoz2 table are a second set of
photometric redshifts for galaxy objects, calculated using a Neural Network
method<a href=''algorithm.asp?key=photoz''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('PlateX','Spectro','','This table contains overview data for each plate used for spectroscopic observations. 
' );
INSERT tabledesc VALUES('ProfileDefs','Photo','','This table provides the definitions of the radii used in computing the radial profiles for photometric objects, which are stored in the PhotoProfile table<a href=''tabledesc.asp?key=PhotoProfile''><img src=''images/tableref.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('QsoBest','QsoBest','','Contains a record describing the attributes of each QSO Base object and also
best Surrogates to fill in the QsoConcordanceAll view.
' );
INSERT tabledesc VALUES('QsoBunch','QsoBunch','','Describes each bunch of matching QSO candidate objects from Target, Spec, and
Best databases using a search radius of 1.5 arcseconds.
' );
INSERT tabledesc VALUES('QsoCatalogAll','QsoCatalogAll','','A catalog of all objects that "smell like a "QSO" - this is the source table
of candidates for the QuasarCatalog table, which contains the list of
confirmed quasars<a href=''algorithm.asp?key=qsocat''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('QsoConcordanceAll','QsoConcordanceAll','','A concordance of all the objects from Spectro, Best, or Target that "smell"
like a QSO<a href=''algorithm.asp?key=qsocat''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('QsoSpec','QsoSpec','','Contains a record describing the attributes of each QSO Spec object and also
Spectroscopic Surrogates to fill in the QsoConcordanceAll view.
' );
INSERT tabledesc VALUES('QsoTarget','QsoTarget','','Contains a record describing the attributes of each QSO Target object and also
Target Surrogates to fill in the QsoConcordanceAll view.
' );
INSERT tabledesc VALUES('RC3','RC3','','This table contains objects from the RC3 catalog.  The objid is just a unique
number for the RC3 object in the table (not a match to SDSS photoobj objid).
' );
INSERT tabledesc VALUES('Region','Geometry','','This table stores the descriptions of regions which describe various
boundaries in the survey. These are represented by equations of 3D planes,
intersecting the unit sphere, describing great and small circles,
respectively. <a href=''algorithm.asp?key=sector''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT tabledesc VALUES('RegionConvex','Geometry','','This table defines the attributes of a given convex of a given region
Regions are the union of convex hulls and are defined in the Region table.
Convexes are the intersection of halfspaces defined by the HalfSpace table. 
Each convex has a string representation and has some geometry properties.
See also the <a href=''tabledesc.asp?key=Region''><img src=''images/tableref.gif'' border=0></a> and <a href=''tabledesc.asp?key=Halfspace''><img src=''images/tableref.gif'' border=0></a>
tables.
' );
INSERT tabledesc VALUES('Rmatrix','Geometry','','Contains various rotation matrices between spherical coordinate systems.
' );
INSERT tabledesc VALUES('Rosat','External','','This table contains objects from the publicly available ROSAT catalogs which 
match an SDSS object inside the data release boundary. The matching radius used is 60 arcseconds.
' );
INSERT tabledesc VALUES('RunQA','Photo','','The RunQA table provides information relevant to the average data quality
for the objects in each field<a href=''tabledesc.asp?key=field''><img src=''images/tableref.gif'' border=0></a>.  This table may be
joined to the rest of your query to sub-select only fields of the very highest
quality, for instance, with seeing below a certain threshold, if that is
desired.  If you want just one number that describes the overall quality of a
field, your best bet is the fieldQall number (0=bad, 1=acceptable, 2=good,
3=excellent).  This overall quality determination is based on the
(dereddened) principal colors of all the stars in the field vs. the
Galactic value of this quantity, the PSF quality, the difference between
Aperture and PSF magnitudes<a href=''algorithm.asp?key=mag_psf''><img src=''images/algorithm.gif'' border=0></a> for the same stars
in the field, and the seeing.
' );
INSERT tabledesc VALUES('TargRunQA','Photo','','The TargRunQA table provides information relevant to the average data quality
for the objects in each field<a href=''tabledesc.asp?key=field''><img src=''images/tableref.gif'' border=0></a> for the TARGET
skyVersion (see the RunQA table for the BEST skyVersion).  This table may be
joined to the rest of your query to sub-select only fields of the very highest
quality, for instance, with seeing below a certain threshold, if that is
desired.  If you want just one number that describes the overall quality of a
field, your best bet is the fieldQall number (0=bad, 1=acceptable, 2=good,
3=excellent).  This overall quality determination is based on the
(dereddened) principal colors of all the stars in the field vs. the
Galactic value of this quantity, the PSF quality, the difference between
Aperture and PSF magnitudes<a href=''algorithm.asp?key=mag_psf''><img src=''images/algorithm.gif'' border=0></a> for the same stars
in the field, and the seeing.
' );
INSERT tabledesc VALUES('RunShift','Geometry','','In early runs<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a> the telescope was sometimes not tracking correctly. The boundaries of some of the runs had thus to be shifted by a small
 amount, determined by hand. This table contains these manual corrections. These should be applied to the nu<a href=''glossary.asp?key=nu''><img src=''images/glossary.gif'' border=0></a> values derived for these runs.
 Only those runs for which such a correction needs to be applied are in this table. 
' );
INSERT tabledesc VALUES('SDSSConstants','Meta','','This table contains most relevant survey constants and their physical units. DO NOT confuse this with the table DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a>, which contains most of the bit-flags and enumerated quantities relevant to the SDSS. 
' );
INSERT tabledesc VALUES('Sector','Geometry','','This table stores the information about set of unique tile overlaps, produced
as part of the tiling<a href=''algorithm.asp?key=tiling''><img src=''images/algorithm.gif'' border=0></a> algorithm. <a href=''algorithm.asp?key=sector''><img src=''images/algorithm.gif'' border=0></a> 
' );
INSERT tabledesc VALUES('Sector2Tile','Geometry','','This table matches tiles to sectors, and vice versa. It is table is designed to be queried in either direction - one can get all the tiles associated with a sector, or one can find all the sectors to
 which a tile belongs.
' );
INSERT tabledesc VALUES('Segment','Geometry','','This table contains the basic parameters associated with a Segment<a href=''glossary.asp?key=segment''><img src=''images/glossary.gif'' border=0></a> 
' );
INSERT tabledesc VALUES('SpecLineAll','Spectro','','This table contains the measured parameters for every detected spectral line<a href=''algorithm.asp?key=speclinefits''><img src=''images/algorithm.gif'' border=0></a> in every spectroscopic object.
' );
INSERT tabledesc VALUES('SpecLineIndex','Spectro','','This table contains pre-computed spectral line
indices<a href=''algorithm.asp?key=speclinefits''><img src=''images/algorithm.gif'' border=0></a>.  These are combinations of
spectral line intensities used to determine various properties of galaxies,
like age or metallicity.  Note: The D4000 index is called "4000Abreak" in this
table.
' );
INSERT tabledesc VALUES('SpecObjAll','Spectro','','This table contains ALL the spectroscopic information for all spectroscopic objects, including a lot of duplicate and bad data. Most users will want to use the SpecObj view<a href=''tabledesc.asp?key=SpecObj''><img src=''images/tableref.gif'' border=0></a>, which contains only objects we denote sciencePrimary<a href=''glossary.asp?key=scienceprimary''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('SpecPhotoAll','Spectro','','This is a pre-computed join between the PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a> and SpecObjAll<a href=''tabledesc.asp?key=SpecObjAll''><img src=''images/tableref.gif'' border=0></a> tables. There are several criteria used for the join between these two tables, including some tiling and targeting information.  Please see the FAQ entry for SpecPhotAll for more information.   The photo attributes included are similar to those in PhotoTag<a href=''tabledesc.asp?key=PhotoTag''><img src=''images/tableref.gif'' border=0></a>.
 The table also includes certain attributes from Tiles. Many users will want to query the SpecPhoto view<a href=''tabledesc.asp?key=SpecPhoto''><img src=''images/tableref.gif'' border=0></a>, which contains only those objects which are spectroscopically sciencePrimary<a href=''glossary.asp?key=scienceprimary''><img src=''images/glossary.gif'' border=0></a> and photometrically Primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('QuasarCatalog','Spectro','','This is a table containing all the quasars identified in the SDSS
data.  It is a derived table that is usually published after the
main SDSS data is released.  The paper describing the contents of
this table is usually found in the Expert Background page of the
SkyServer SDSS section.
' );
INSERT tabledesc VALUES('Stetson','Stetson','','This table contains objects from the Stetson dataset.  The objid column
contains matches to SDSS photoobj objids as applicable (the value is
NULL if no SDSS match is found).
' );
INSERT tabledesc VALUES('StripeDefs','Geometry','','This table gives the definitions of the stripes<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a> in the survey layout as originally planned.
The lower and upper limits of the actual observed stripes may differ from these values. The actual numbers are found in the Segment<a href=''tabledesc.asp?key=Segment''><img src=''images/tableref.gif'' border=0></a> and Chunk<a href=''tabledesc.asp?key=Chunk''><img src=''images/tableref.gif'' border=0></a> tables. 
' );
INSERT tabledesc VALUES('Target','Spectro','','This table keeps keeps track of objects chosen by target selection<a href=''algorithm.asp?key=target''><img src=''images/algorithm.gif'' border=0></a>,  and which therefore will be fed to the tiling algorithm<a href=''algorithm.asp?key=tiling''><img src=''images/algorithm.gif'' border=0></a>. Objects are added whenever target selection is run on a new chunk<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a>. Objects are also added when southern target selection is run. In the case
 where an object (meaning run,rerun,camcol,field,id) is targeted more than once, there will be only one row in Target for that object, but there
 will be multiple entries for that Target in the TargetInfo<a href=''tabledesc.asp?key=TargetInfo''><img src=''images/tableref.gif'' border=0></a> table. 
' );
INSERT tabledesc VALUES('TargetInfo','Spectro','','This table contains unique information for an object every time it is targeted<a href=''algorithm.asp?key=target''><img src=''images/algorithm.gif'' border=0></a>. If an object is targeted more than once, there
 will be multiple entries for that Target in this table.
' );
INSERT tabledesc VALUES('TargetParam','Spectro','','This table contains the parameters used for a version of the target selection code.
' );
INSERT tabledesc VALUES('TileAll','Spectro','','This table contains information about an individual tile<a href=''glossary.asp?key=tile''><img src=''images/glossary.gif'' border=0></a> on the sky. Every tile ever created is in this table. The view Tile<a href=''tabledesc.asp?key=Tile''><img src=''images/tableref.gif'' border=0></a> contains only the main science tiles for the northern survey.
' );
INSERT tabledesc VALUES('TiledTargetAll','Spectro','','This table Keeps track of why a Target<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> was assigned to a Tile<a href=''glossary.asp?key=tile''><img src=''images/glossary.gif'' border=0></a>. 
This table is designed to be searched both ways - one can find the Targets assigned to a Tile or one can find all the Tiles a Target has been
 assigned to (objects can be assigned to more than one tile if they are QA objects). Information comes from plPlugMapP files, but only
 OBJECT hole info is stored. HoleObj<a href=''tabledesc.asp?key=HoleObj''><img src=''images/tableref.gif'' border=0></a> can be used to find other holetypes that made it to a Plate<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a>. 
' );
INSERT tabledesc VALUES('TilingGeometry','Spectro','','This table contains geometric information about TilingRegions, including 
both tiling boundary and generic information. ' );
INSERT tabledesc VALUES('TilingInfo','Spectro','','Contain info on what happened to a TargetObj in a run of tiling<algorithm>tiling</algorithm> software. ' );
INSERT tabledesc VALUES('TilingNote','Spectro','','Contains human readable notes for a run of tiling<a href=''algorithm.asp?key=tiling''><img src=''images/algorithm.gif'' border=0></a>. This includes information on why specific tiles may be empty or problems with a given tile. 
' );
INSERT tabledesc VALUES('TilingRun','Spectro','','Contains basic information for a run of tiling<a href=''algorithm.asp?key=tiling''><img src=''images/algorithm.gif'' border=0></a>. 
' );
INSERT tabledesc VALUES('USNO','External','','This table contains all of the objects in the USNO-B catalog which
match an SDSS object inside the data release boundary. However, because this
matching was originally done with USNO-A, many new fields from the newer
USNO-B are NOT in this table (such as the POSS-II matches), see the USNOB table.
' );
INSERT tabledesc VALUES('USNOB','External','','This table contains all of the objects in the newer USNO-B catalog which
match an SDSS object inside the data release boundary. 
' );
INSERT tabledesc VALUES('XCRedshift','Spectro','','This table contains the cross-correlation redshifts<a href=''algorithm.asp?key=redshift_type''><img src=''images/algorithm.gif'' border=0></a> for all spectroscopic objects.
' );
INSERT tabledesc VALUES('Zone','Geometry','','This table is mostly for internal database mechanics.  In order to speed up all-sky cross-correlations, this table organizes the PhotoObjs into 0.5 arcmin declination zones, indexed by the zone number and ra. 
' );
INSERT tabledesc VALUES('CoordType','Meta','','This view contains the CoordType enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('FieldMask','Meta','','This view contains the FieldMask flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(4). 
' );
INSERT tabledesc VALUES('FieldQuality','Meta','','This view contains the FieldQuality enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('FramesStatus','Meta','','This view contains the FramesStatus enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('Galaxy','Photo','','This view contains only those primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> photometric objects classified<a href=''algorithm.asp?key=classify''><img src=''images/algorithm.gif'' border=0></a> as galaxies. As such, it is a view of PhotoPrimary<a href=''tabledesc.asp?key=PhotoPrimary''><img src=''images/tableref.gif'' border=0></a>, which is itself a view of PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('HoleType','Meta','','This view contains the HoleType enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('ImageMask','Meta','','This view contains the ImageMask flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(2). 
' );
INSERT tabledesc VALUES('InsideMask','Meta','','This view contains the InsideMask flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(1). 
' );
INSERT tabledesc VALUES('MaskType','Meta','','This view contains the MaskType enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('ObjType','Meta','','This view contains the ObjType enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('PhotoFamily','Photo','','This view contains objects which are in PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a>, but neither PhotoPrimary<a href=''tabledesc.asp?key=PhotoPrimary''><img src=''images/tableref.gif'' border=0></a> nor PhotoSecondary<a href=''tabledesc.asp?key=PhotoSecondary''><img src=''images/tableref.gif'' border=0></a>. These objects are generated if they are neither primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> nor secondary<a href=''glossary.asp?key=secondary''><img src=''images/glossary.gif'' border=0></a> survey objects but a composite object that has been deblended or the
 part of an object that has been deblended<a href=''glossary.asp?key=deblend''><img src=''images/glossary.gif'' border=0></a> wrongfully (like the spiral arms of a galaxy). These objects are kept to track how the deblender is working. 
' );
INSERT tabledesc VALUES('PhotoFlags','Meta','','This view contains the PhotoFlags flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(8). 
' );
INSERT tabledesc VALUES('PhotoMode','Meta','','This view contains the PhotoMode enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('PhotoObj','Photo','','This view contains objects which are in PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a>, which are either PhotoPrimary<a href=''tabledesc.asp?key=PhotoPrimary''><img src=''images/tableref.gif'' border=0></a> or PhotoSecondary<a href=''tabledesc.asp?key=PhotoSecondary''><img src=''images/tableref.gif'' border=0></a>.  These objects are generated if they are either primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> or secondary<a href=''glossary.asp?key=secondary''><img src=''images/glossary.gif'' border=0></a> survey objects.
' );
INSERT tabledesc VALUES('PhotoPrimary','Photo','','This view contains objects from PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a> which are primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a>. As such, this view is itself a view of PhotoObj<a href=''tabledesc.asp?key=PhotoObj''><img src=''images/tableref.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('PhotoSecondary','Photo','','This view contains objects from PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a> which are secondary<a href=''glossary.asp?key=secondary''><img src=''images/glossary.gif'' border=0></a>. As such, this view is itself a view of PhotoObj<a href=''tabledesc.asp?key=PhotoOb''><img src=''images/tableref.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('PhotoStatus','Meta','','This view contains the PhotoStatus flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(4). 
' );
INSERT tabledesc VALUES('PhotoType','Meta','','This view contains the PhotoMode enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('PrimTarget','Meta','','This view contains the PrimTarget flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(4). 
' );
INSERT tabledesc VALUES('ProgramType','Meta','','This view contains the ProgramType enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('PspStatus','Meta','','This view contains the PspStatus enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('SecTarget','Meta','','This view contains the SecTarget flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(4). 
' );
INSERT tabledesc VALUES('Sky','Photo','','This view contains only those primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> photometric objects which are sky samples used for background measurement. As such, it is a view of PhotoPrimary<a href=''tabledesc.asp?key=PhotoPrimary''><img src=''images/tableref.gif'' border=0></a>, which is itself a view of PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('SpecClass','Meta','','This view contains the SpecClass enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('SpecLine','Spectro','','This view contains all actually measured spectroscopic lines from SpecLineAll<a href=''tabledesc.asp?key=SpecLineAll''><img src=''images/tableref.gif'' border=0></a>. The view excludes those SpecLineAll objects which have category=1, and thus have not been measured. This is the view you should use to access the SpecLine data. 
' );
INSERT tabledesc VALUES('SpecLineNames','Meta','','This view contains the SpecLineNames enumerated values from DataConstants<a href=''tabledesc.asp?key=''><img src=''images/tableref.gif'' border=0></a> as integers. 
' );
INSERT tabledesc VALUES('SpecObj','Spectro','','This view includes only those objects from SpecObjAll<a href=''tabledesc.asp?key=SpecObjAll''><img src=''images/tableref.gif'' border=0></a> that have clean spectra. The view excludes QA and Sky and duplicates. Use this as the main way to access the spectroscopic objects. 
' );
INSERT tabledesc VALUES('SpecPhoto','Spectro','','A view of joined Spectro and Photo objects that have clean spectra and photometry. The view includes only those pairs where the SpecObj<tableref>SpecObj</tableref> is a sciencePrimary<glossary>scienceprimary</glossary>, and the BEST<glossary>best</glossary> PhotoObj<tableref>PhotoObj</tableref> is a PRIMARY<glossary>primary</glossary>. (mode=1). ' );
INSERT tabledesc VALUES('SpecZStatus','Meta','','This view contains the SpecZStatus enumerated values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as integers.
' );
INSERT tabledesc VALUES('SpecZWarning','Meta','','This view contains the SpecZWarning flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(4).
' );
INSERT tabledesc VALUES('sppLines','Spectro','','This table contains line indices for a wide range of common features at the
radial velocity of the star for over 250,000 Galactic stars as computed by the
Spectro Parameter Pipeline (spp).  See the sppLines entry in Algorithms
<a href=''algorithm.asp?key=spplines''><img src=''images/algorithm.gif'' border=0></a> and the <a href="realquery.asp#spplines">Sample
Queries</a> for how to use this table.
' );
INSERT tabledesc VALUES('sppParams','Spectro','','Standard stellar atmospheric parameters such as  [Fe/H], log g and Teff 
for over 250,000 Galactic stars (by a variety of methods) as computed by the
Spectro Parameter Pipeline (spp).  See the sppParams entry in Algorithms
<a href=''algorithm.asp?key=sppparams''><img src=''images/algorithm.gif'' border=0></a> and the <a
href="realquery.asp#sppparams">Sample Queries</a> for how to use this
table.
' );
INSERT tabledesc VALUES('Star','Photo','','This view contains only those primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> photometric objects classified<a href=''algorithm.asp?key=classify''><img src=''images/algorithm.gif'' border=0></a> as stars. As such, it is a view of PhotoPrimary<a href=''tabledesc.asp?key=PhotoPrimary''><img src=''images/tableref.gif'' border=0></a>, which is itself a view of PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a>.
' );
INSERT tabledesc VALUES('Tile','Geometry','','This view of TileAll<a href=''tabledesc.asp?key=TileAll''><img src=''images/tableref.gif'' border=0></a> excludes those Tiles<a href=''glossary.asp?key=tile''><img src=''images/glossary.gif'' border=0></a> that have been untiled<a href=''algorithm.asp?key=tiling''><img src=''images/algorithm.gif'' border=0></a>. Thus, it contains those tiles useful for determining spectroscopic survey completeness and geometry.
' );
INSERT tabledesc VALUES('TiledTarget','Spectro','','This view of TiledTargetAll<a href=''tabledesc.asp?key=TiledTargetAll''><img src=''images/tableref.gif'' border=0></a> excludes those targets that are on tiles<a href=''glossary.asp?key=tile''><img src=''images/glossary.gif'' border=0></a> which have been untiled<a href=''algorithm.asp?key=tiling''><img src=''images/algorithm.gif'' border=0></a>. 
' );
INSERT tabledesc VALUES('TilingBoundary','Geometry','','A view of TilingGeometry<a href=''tabledesc.asp?key=TilingGeometry''><img src=''images/tableref.gif'' border=0></a> objects that have isMask = 0 
 The view excludes those TilingGeometry objects that have isMask = 1. See also TilingMask<a href=''tabledesc.asp?key=TilingMask''><img src=''images/tableref.gif'' border=0></a>. 
' );
INSERT tabledesc VALUES('TilingMask','Geometry','','A view of TilingGeometry<a href=''tabledesc.asp?key=TilingGeometry''><img src=''images/tableref.gif'' border=0></a> objects that have isMask = 1 
The view excludes those TilingGeometry objects that have isMask = 0. See also TilingBoundary<a href=''tabledesc.asp?key=TilingBoundary''><img src=''images/tableref.gif'' border=0></a>. 
' );
INSERT tabledesc VALUES('TiMask','Meta','','This view contains the TiMask flag values from DataConstants<a href=''tabledesc.asp?key=DataConstants''><img src=''images/tableref.gif'' border=0></a> as binary(4).
' );
INSERT tabledesc VALUES('UberCal','Photo','','The uber-calibration corrections and corrected magnitudes for PhotoObjAll.
Please see the <b>UberCalibration</b> entry in
Algorithms<a href=''algorithm.asp?key=photometry#ubercal''><img src=''images/algorithm.gif'' border=0></a>  for more information
about the uber-calibration corrections, and also see the <a
href="realquery.asp#ubercal">Sample Queries</a> for how to use the table.
' );
INSERT tabledesc VALUES('Unknown','Photo','','This view contains only those primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> photometric objects classified<a href=''algorithm.asp?key=classify''><img src=''images/algorithm.gif'' border=0></a> as unknown (not a star,galaxy,or sky). As such, it is a view of PhotoPrimary<a href=''tabledesc.asp?key=PhotoPrimary''><img src=''images/tableref.gif'' border=0></a>, which is itself a view of PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a>.
' );

GO
----------------------------- 
PRINT '119 lines inserted into tabledesc'
----------------------------- 

