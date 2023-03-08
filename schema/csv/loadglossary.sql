
----------------------------- 
--  loadglossary.sql
----------------------------- 
SET NOCOUNT ON
GO
TRUNCATE TABLE glossary
GO

INSERT glossary VALUES('adaptive_moment','adaptive moments','','A method of measuring the deviation from the PSF of an object shape. These 
moments are close to optimal for measuring the shapes of faint galaxies, and 
have been used for weak lensing studies. <a href=''algorithm.asp?key=adaptive''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('APO','APO','','Apache Point Observatory, located in Sunspot, New Mexico. This is the location of the 2.5m SDSS telescope as well as the Photometric Telescope (PT)<a href=''glossary.asp?key=photo_tel''><img src=''images/glossary.gif'' border=0></a>, as well as other non-SDSS telescopes. The observatory homepage is <a href="http://www.apo.nmsu.edu">http://www.apo.nmsu.edu</a> .
' );
INSERT glossary VALUES('ARC','ARC','','Astrophysical Research Consortium.  Body that owns and operates APO<a href=''glossary.asp?key=apo''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('asinh','asinh magnitude','',' Magnitudes within the SDSS are expressed as inverse 
hyperbolic sine (or "asinh") magnitudes, sometimes referred to informally as <em>luptitudes</em> .
The transformation from linear flux measurements to asinh magnitudes
is designed to be virtually identical to the standard astronomical
magnitude at high signal-to-noise ratio, but to switch over to linear behavior at low S/N and even at negative values of flux,
where the logarithm in the Pogson magnitude<a href=''glossary.asp?key=mag_pogson''><img src=''images/glossary.gif'' border=0></a> fails.  Details can be found  in the <a href="http://www.journals.uchicago.edu/AJ/journal/issues/v118n3/990094/990094.html">Lupton et al. 1999 AJ paper</a>. <a href=''algorithm.asp?key=photometry''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('astrans','asTrans file','','FITS binary table with astrometric transformations for every field in a single imaging run. It transforms frame (row,col) coordinates to great circle (mu,nu) coordinates<a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a> for a given inclination. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('Astrda','AstroDA','','The data acquisition and analysis system used to collect data from the survey telescope cameras.
' );
INSERT glossary VALUES('Astrom','Astrom','','The data processing pipeline that maps CCD pixel coordinates to celestial coordinates. The detailed workings of this pipeline are described in the <a href="http://www.journals.uchicago.edu/AJ/journal/issues/v125n3/202156/202156.html">Pier et al. 2003 AJ paper</a>. <a href=''algorithm.asp?key=astrometry''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('astrom_chip','astrometric chip','','The SDSS camera<a href=''glossary.asp?key=camera''><img src=''images/glossary.gif'' border=0></a> contains 24 2048x400 pixel CCDs (in addition to the 30 2048x2048 photometric CCDs) which are used for astrometry and focus monitoring. Because they are smaller chips, the effective exposure time is only 11 seconds, allowing the survey to observe brighter stars without saturation. These bright star positions are necessary to match to objects present in astrometric catalogs used by the Astrom pipeline<a href=''glossary.asp?key=Astrom''><img src=''images/glossary.gif'' border=0></a>. For more details on these chips, please see the <a href="http://www.journals.uchicago.edu/AJ/journal/issues/v116n6/980260/980260.html">AJ imaging camera paper (Gunn et al. 1998)</a>.
' );
INSERT glossary VALUES('astrometry','astrometry','','The process by which image coordinates (from the CCD data) are mapped to celestial coordinates. <a href=''algorithm.asp?key=astrometry''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('astrotools','Astrotools','',' Software to perform various useful SDSS-related tasks. It is available only to the collaboration.
' );
INSERT glossary VALUES('atlas_image','atlas image','','For each detected object<a href=''glossary.asp?key=object''><img src=''images/glossary.gif'' border=0></a>, the atlas image comprises the pixels that were detected as part of the object in any filter. These are available through the DAS, as a single file for each field.
' );
INSERT glossary VALUES('best','Best','','We maintain multiple versions of the SDSS photometric catalogs in our
database. The <b>Best</b> version contains a snapshot of the catalogs
with the highest quality data at the time of the data release.
' );
INSERT glossary VALUES('binned_frame','binned frame','','Each file is a FITS image for one filter, 512 x 372 pixels, with WCS information. These are the corrected frames<a href=''glossary.asp?key=corrected_frame''><img src=''images/glossary.gif'' border=0></a> with detected objects removed and binned 4 pixels by 4 pixels. All pixels that are in atlas images<a href=''glossary.asp?key=atlas_image''><img src=''images/glossary.gif'' border=0></a> are replaced by the background level before binning, with suitable noise added. All of the header parameters from the original image are inherited as well. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('blackbook','Black Book','','Similar to the <em>Project Book</em>, this document provides a description of the original science goals of the survey, as well as the hardware and software designs, and was the 1996 proposal to NASA. Please keep in mind that it is <em>not</em> updated, so information within it may no longer be current. Nevertheless, it provides an excellent overview of the survey. The Black Book can be found <a href="http://www.astro.princeton.edu/PBOOK/welcome.htm">here</a>.
' );
INSERT glossary VALUES('boresight','boresight','','The telescope control computer keeps track
of a specific point in the telescope focal plane that is called the <b>boresight</b>. The boresight is not fixed in the array but is at one of two
places for the two strips<a href=''glossary.asp?key=strip''><img src=''images/glossary.gif'' border=0></a> that compose a stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>. It is the boresight that will track great circles<a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a>. Technically, the boresight tracks a path that is a great circle in J2000 coordinates as viewed from the solar system barycenter.
' );
INSERT glossary VALUES('calibration','calibration','','The process by which the photometric and spectroscopic observations are calibrated. The goal of calibration is to take the digital camera readouts and convert them to measured quantities, like fluxes. The details of these procedures are described for photometry<a href=''algorithm.asp?key=photometry''><img src=''images/algorithm.gif'' border=0></a> and spectrophotometry<a href=''algorithm.asp?key=spectrophotometry''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT glossary VALUES('camcol','camcol','','A Camcol is the output of one camera column as part of a Run<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>. Therefore, 1 Camcol = 1/6 of a Run. It is also a portion of a scanline<a href=''glossary.asp?key=scanline''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('camera','camera','','The instrument used for imaging. It consists of 30 photometric and 24 astrometric CCDs.  The camera is a mosaic of 54 CCD detectors in the focal plane, 30 large devices arranged in 6 columns of 5 each and 24 smaller devices around the periphery. The camera is described in detail in the <a href="http://www.journals.uchicago.edu/AJ/journal/issues/v116n6/980260/980260.html">imaging camera paper (Gunn et al. 1998)</a>.
' );
INSERT glossary VALUES('CAS','CAS (Catalog Archive Server)','','The <I>Catalog Archive Server</I> contains the measured parameters from all objects in the imaging survey and the spectroscopic survey. 
' );
INSERT glossary VALUES('central_meridian','central meridian','','The meridian which passes through the center of the survey area, 12h 20m , defines the central meridian of a scan. The great
circle perpendicular to it passing through the survey center at dec=32.8deg is the survey equator<a href=''glossary.asp?key=survey_equator''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('child','child','','A product of the deblending<a href=''glossary.asp?key=deblend''><img src=''images/glossary.gif'' border=0></a> process. When two objects are near each other on the sky, their images may appear merged. The deblender tries to split this merged image; the resulting sub-images are called children. The initial merged image is called a parent<a href=''glossary.asp?key=parent''><img src=''images/glossary.gif'' border=0></a>. <a href=''algorithm.asp?key=deblend''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('chunk','chunk','','A <i>primar (resolved)</i>chunk is composed of a set of touching but non-overlapping primary
segments<a href=''glossary.asp?key=segment''><img src=''images/glossary.gif'' border=0></a> (or parts of segments) which fills a
"chunk" of a stave<a href=''glossary.asp?key=stave''><img src=''images/glossary.gif'' border=0></a>, and is therefore bounded on
the east and west by lines of constant mu<a href=''glossary.asp?key=mu''><img src=''images/glossary.gif'' border=0></a>, and
north-south by lines of constant eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a> (if in the
North). Southern chunks have no eta boundary applied.  A chunk may
also have a lambda<a href=''glossary.asp?key=lambda''><img src=''images/glossary.gif'' border=0></a> cut if it is at the end of
the survey region for that stripe. Primary chunks do not overlap, so the union
of all existing chunks represents the unique sky coverage for the
survey at any given time. Note that
the bounds on chunks, if using mu/eta, are a mix of survey coordinates<a href=''glossary.asp?key=survey_coords''><img src=''images/glossary.gif'' border=0></a> and great circle coordinates<a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a>. <b>Note:</b>
The term chunk has sometimes been used to describe an area of sky that
has had tiling<a href=''glossary.asp?key=tiling''><img src=''images/glossary.gif'' border=0></a> run on it. This is properly
called a TileRun<a href=''glossary.asp?key=tile_run''><img src=''images/glossary.gif'' border=0></a>.  In general chunks contain overlapping areas which are 
counted multiple times unless the <i>primary</i> or <i>resolved</i> area is indicated.
' );
INSERT glossary VALUES('classification','classification','','The method by which we assign a type (star or galaxy) to each object<a href=''glossary.asp?key=object''><img src=''images/glossary.gif'' border=0></a>. <a href=''algorithm.asp?key=classify''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('cloud_cam','Cloud Camera','','A camera at the mountain that takes continuous pictures
of the sky at 10 microns, a wavelength at which clouds emit.
It is a sensitive measure of the photometricity of the sky as a
function of time.
' ); 
INSERT glossary VALUES('CMM','CMM','','Coordinate Measuring Machine, a device used to measure the positions of holes in the fiber<a href=''glossary.asp?key=fiber''><img src=''images/glossary.gif'' border=0></a> mount plates<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a> for the spectrographic survey.
' );
INSERT glossary VALUES('convex','convex','','A convex is the intersection of one or more circles, with a depth (the
number of circles involved).  If we have two intersection circles, A and B,
then both (A) and (B) are a convex of depth 1, their intersection (A) (B) is
also a convex, but of depth 2.  We call these simple convexes <i>wedges</i>
<a href=''algorithm.asp?key=sector''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('coordinates','coordinates','','The SDSS uses three different coordinate systems. Of course, we use standard astronomical right ascension (RA) and declination (Dec), J2000. There is also the <em>survey coordinate system</em><a href=''glossary.asp?key=survey_coords''><img src=''images/glossary.gif'' border=0></a>, with coordinates lambda<a href=''glossary.asp?key=lambda''><img src=''images/glossary.gif'' border=0></a>  and eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a>. This is just a rotation of the usual RA, Dec system. Finally, there is the <em>great circle coordinate system</em><a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a>, which is actually a separate coordinate system for each stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>. The coordinates of this system are mu<a href=''glossary.asp?key=mu''><img src=''images/glossary.gif'' border=0></a> and nu<a href=''glossary.asp?key=nu''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('corrected_frame','corrected frame','','Each corrected frame is a FITS image for one filter, 2048 columns by 1489 rows, with row number increasing in the scan direction. These are the imaging frames with flat-field, bias, cosmic-ray, and pixel-defect corrections applied. A raw image contains 1361 rows, and a corrected frame has the first 128 rows of the following corrected frame appended to it. The pixels subtend 0".396 square on the sky. Header information using the world coordinate system (WCS)<a href=''glossary.asp?key=wcs''><img src=''images/glossary.gif'' border=0></a> allows standard astronomical FITS tools to convert pixel position to right ascension and declination. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('CVS','CVS','','The Concurrent Versions System, used by SDSS software and website developers to maintain versioning control. An open source project available at http://www.cvshome.org/ .
' );
INSERT glossary VALUES('cx','cx/cy/cz','','The coordinates on the unit sphere utilized by the HTM<a href=''glossary.asp?key=htm''><img src=''images/glossary.gif'' border=0></a> code; these are stored in the database.
' );
INSERT glossary VALUES('DAS','DAS','',' The Data Archive Server, which provides access to the imaging and spectroscopic products of the survey. The public DAS is located at http://das.sdss.org/.
' );
INSERT glossary VALUES('data_model','data model','','The description of the structure and organization of the data in a
database. The data model tells you all the tables names, their contents,
and how they are related to, and linked with, one another. The actual
implementation of a data model is called the database schema. For the
flat files available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>, the data model links
are available in the DAS User Guide.
' );
INSERT glossary VALUES('deblend','deblend','','Deblending is the process by which overlapping objects in images are separated. The frames pipeline<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a> attempts to determine whether each object actually consists of
more than one object projected on the sky and, if so, to deblend such a parent<a href=''glossary.asp?key=parent''><img src=''images/glossary.gif'' border=0></a> object into its constituent children<a href=''glossary.asp?key=child''><img src=''images/glossary.gif'' border=0></a>, self-consistently across the bands (thus, all children have measurements in all bands). For details on how this works, and what flags<a href=''glossary.asp?key=flag''><img src=''images/glossary.gif'' border=0></a> this procedure may set, read this<a href=''algorithm.asp?key=deblend''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT glossary VALUES('Dervish','Dervish','','An FNAL<a href=''glossary.asp?key=FNAL''><img src=''images/glossary.gif'' border=0></a> software toolkit used by many of the data acquisition and reduction systems.
' ); 
INSERT glossary VALUES('dev','deVaucouleurs','','Also know as the r<sup>1/4</sup> law, it describes the radial light profile of a typical elliptical galaxy. Defined as<br><b>I(r) = I<sub>0</sub>exp{-7.67[(r/r<sub>e</sub>)<sup>1/4</sup>]}</b>. An elliptical version of this profile is fit to every detected object, yielding the <code>deV</code> parameters. <a href=''algorithm.asp?key=mag_model''><img src=''images/algorithm.gif'' border=0></a>
' ); 
INSERT glossary VALUES('DR1','DR1','','Data Release 1. The first major release of SDSS data to the public, occurring in March, 2003. A small portion of the data was released earlier as part of the Early Data Release (EDR)<a href=''glossary.asp?key=EDR''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('EDR','EDR','','Early Data Release. The first public release of SDSS data occurred in June of 2001. This current release (DR1) includes the area present in the EDR, and more. The data has also been reprocessed with improved software. The EDR is described in an <a href="http://www.journals.uchicago.edu/AJ/journal/issues/v123n1/201415/201415.html">AJ paper</a>.
' );
INSERT glossary VALUES('ellipticity','ellipticity','','Measures how elliptical an object is. In the SDSS, we have numerous methods to measure this, including the Stokes parameters<a href=''glossary.asp?key=stokes''><img src=''images/glossary.gif'' border=0></a>, the adaptive moments<a href=''glossary.asp?key=adaptive_moment''><img src=''images/glossary.gif'' border=0></a>, the De Vaucouleurs profiles<a href=''glossary.asp?key=dev''><img src=''images/glossary.gif'' border=0></a>, the exponential profiles<a href=''glossary.asp?key=exp''><img src=''images/glossary.gif'' border=0></a>, and the isophotal parameters. 
' );
INSERT glossary VALUES('eta','eta','','Latitude in the survey coordinate system<a href=''glossary.asp?key=survey_coords''><img src=''images/glossary.gif'' border=0></a>. Eta is the angle between the survey equator and the great circle passing through the point perpendicular to the survey meridian, positive to the north.
Constant latitude curves are great circles.
' );
INSERT glossary VALUES('exp','exponential model','','The radial light distribution of a disk galaxy can often be fit by an exponential profile:<br>
<b>I(r) = I<sub>0</sub>exp(-1.68r/r<sub>e</sub>)</b><br>
The number 1.68 is chosen so that the
model radius is a half-light radius. An elliptical version of
this profile is fit to every detected object, yielding the <code>exp</code> parameters.<a href=''algorithm.asp?key=mag_model''><img src=''images/algorithm.gif'' border=0></a>
' ); 
INSERT glossary VALUES('false','False color pipeline','','A pipeline to produce 3-color JPG files of zoomed-down SDSS images.
' );  
INSERT glossary VALUES('family','family objects','','These are objects that are generated when photometric objects are neither
primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> nor
secondary<a href=''glossary.asp?key=secondary''><img src=''images/glossary.gif'' border=0></a> survey objects but a composite object 
that has been deblended or the part of an object that has been
deblended<a href=''glossary.asp?key=deblend''><img src=''images/glossary.gif'' border=0></a> wrongfully (like the spiral arms of a
galaxy). These objects are kept to track how the deblender is working.
' );
INSERT glossary VALUES('fiber','fiber','','The SDSS spectrograph uses optical fibers to direct the light from individual objects to the slithead. Each object is assigned a corresponding <b><font face="arial black, monaco, chicago">fiberID</b></font>. The fibers are 3 arcsec in diameter in the source plane. Each fiber is surrounded by a large sheath which prevents any pair of fibers from being placed closer than 55 arcsec on the same plate<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('fiberMag','fiberMag','','The fiber magnitude.<a href=''glossary.asp?key=mag_fiber''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('field','field','','A field is a part of a camcol<a href=''glossary.asp?key=camcol''><img src=''images/glossary.gif'' border=0></a> that is processed by the Photo pipeline<a href=''glossary.asp?key=photo''><img src=''images/glossary.gif'' border=0></a> at one time. Fields are 2048x1489 pixels; a field consists of the frames<a href=''glossary.asp?key=frame''><img src=''images/glossary.gif'' border=0></a> in the 5 filters for the same part of the sky. Fields overlap each other by 128 rows; primaries<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> are decided when Chunks<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a> are resolved<a href=''glossary.asp?key=resolve''><img src=''images/glossary.gif'' border=0></a> (using objects between rows 64 and1425 as primaries). A field at the edge of a Chunk may in fact be included in 2 (or more) Chunks.
' );
INSERT glossary VALUES('filter','filter','','A piece of material used to allow only specific colors (or wavelengths) of light to pass through. The SDSS uses five filters: <em>u,g,r,i,z</em>. However, defining standards and absolute calibration for these filters has been difficult. Please read the <a href="http://www.sdss.org/dr1/instruments/imager/index.html">Camera Page</a> for details.
' ); 
INSERT glossary VALUES('FITS','FITS','','The Flexible Image Transport System, a standard method of storing astonomical data. The FITS format has a home page at <a href="http://fits.gsfc.nasa.gov/">fits.gsfc.nasa.gov</a>.
' );
INSERT glossary VALUES('flag','flag','','A bitmask used in the database to specify various properties of an object. There are many flags in the SDSS catalogs which tell the user extremely important and useful pieces of information, such as whether the object was deblended<a href=''glossary.asp?key=deblend''><img src=''images/glossary.gif'' border=0></a> or saturated, for instance. There are status flags set by PSP, and by survey operations, on a frame-by-frame basis, describing the quality of the PSF, and the quality of the data overall.  Each object is given status flags that sort out overlaps.  And the spectra have flags at two levels as well: pixel-by-pixel flags, and warning flags accompanying the redshifts and classification to indicate trouble.
<a href=''algorithm.asp?key=flags''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('FNAL','FNAL','','Fermi National Accelerator Laboratory, one of the participating institutions in SDSS. Their homepage is <a href="http://www.fnal.gov">here</a>.
' );
INSERT glossary VALUES('footprint','footprint','','The area on the sky covered by the SDSS. The footprint for a given data
release is described on the Sky Coverage page at <a
href="http://www.sdss.org/" target="new">the main SDSS site</a> (click
on the latest data release page).
' );
INSERT glossary VALUES('fpAtlas','fpAtlas file','','A FITS binary table containing the atlas images<a href=''glossary.asp?key=atlas_image''><img src=''images/glossary.gif'' border=0></a> for all objects detected in all five filters in a single field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>. Requires special software to decode into individual FITS images for each object. The FITS images are available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('fpBin','fpBin file','','See binned frame<a href=''glossary.asp?key=binned_frame''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('fpC','fpC file','','See corrected frame<a href=''glossary.asp?key=corrected_frame''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('fpFieldStat','fpFieldStat file','','A binary FITS table containing a statistical summary of the results of the frames pipeline<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a> for one field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a> for a single frames pipeline run. This information is also found in the Field table in the CAS<a href=''glossary.asp?key=CAS''><img src=''images/glossary.gif'' border=0></a> database. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('fpM','fpM file','','See mask frame<a href=''glossary.asp?key=mask_frame''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('fpObjc','fpObjc file','','These are FITS binary tables containing catalogs of detected objects output by the frames pipeline<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a>. These are <em>uncalibrated</em>, as opposed to the tsObj<a href=''glossary.asp?key=tsobj''><img src=''images/glossary.gif'' border=0></a> files, with no targeting<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> information. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('frame','frame','','The data stream from a single CCD in a scanline is cut into a series of frames which measure 2048 x 1489 pixels and overlap 10% with the adjacent frame. The frames in the 5 filters for the same part of the sky are called a field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('frames_pipeline','frames pipeline','','In this pipeline, the images are  bias-subtracted and flat-fielded, and bad columns, cosmic rays, and bleed trails are interpolated over. This yields corrected frames<a href=''glossary.asp?key=corrected_frame''><img src=''images/glossary.gif'' border=0></a>. Then objects are found by running a PSF-matched filter over the image, and matched up between the five frames making up a field.  A deblender<a href=''glossary.asp?key=deblend''><img src=''images/glossary.gif'' border=0></a> is run to resolve overlaps, and the properties of each object are written to the fpObjc<a href=''glossary.asp?key=fpObjc''><img src=''images/glossary.gif'' border=0></a> files. Atlas images are written to the fpAtlas<a href=''glossary.asp?key=fpAtlas''><img src=''images/glossary.gif'' border=0></a> files.
' );
INSERT glossary VALUES('fundamental_standard','fundamental standard','','The photometry of the primary standard stars
is ultimately tied to the SED of the star BD 17 +4708, which is the
fundamental standard for the SDSS photometric system.  See the Smith et al. 2002 AJ paper for more details. 
' );
INSERT glossary VALUES('gnats','GNATS','','The system used to report and track bugs and issues with SDSS hardware and software; for collaboration use only.
' ); 
INSERT glossary VALUES('great_circle_coords','great circle coordinates','','One of the two main coordinate systems 
utilized by the SDSS. In this system, mu<a href=''glossary.asp?key=mu''><img src=''images/glossary.gif'' border=0></a> and nu<a href=''glossary.asp?key=nu''><img src=''images/glossary.gif'' border=0></a> are spherical coordinates (corresponding to ra and dec) in a system whose equator is along the center of the stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a> in question. The stripes of the survey are great circles which all cross at (RA, Dec) = (95, 0). The stripes are defined by their inclination with respect to the equator, and are indexed by integers <em>n</em> such that the inclination of a stripe is -25 + 2.5<em>n</em>. Thus, stripe <em>n</em>=10 corresponds to the Equator. Astrotools<a href=''glossary.asp?key=astrotools''><img src=''images/glossary.gif'' border=0></a> provides utilities to convert to and from these, such as GSCToSurvey. The design is that the area covered by the imaging on a given stripe (the so-called OK_SCANLINE area in the north) is a 2.5 degree wide rectangle centered on nu=0 in Great Circle coordinates.
' ); 
INSERT glossary VALUES('htm','HTM','','The Hierarchical Triangular Mesh (HTM) is a partitioning scheme to divide the surface of the unit sphere into spherical triangles. It is a hierarchical scheme and the subdivisions have not exactly, but roughly equal areas. HTM is used to index the coordinates in the object databases for faster querying speeds. For more details, and downloadable software, see the HTM Website at http://www.sdss.jhu.edu/htm/.
' ); 
INSERT glossary VALUES('hoggpt','HoggPT','','A program which runs on the mountain, which uses information
from the photometric telescope<a href=''glossary.asp?key=photo_tel''><img src=''images/glossary.gif'' border=0></a> and the cloud camera<a href=''glossary.asp?key=cloud_cam''><img src=''images/glossary.gif'' border=0></a> to determine the
photometricity of a given night.  It was written by David Hogg and
colleagues, thus its name.
' );
INSERT glossary VALUES('hole','hole','','A field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a> or set of fields which is missing from the data, either because of non-photometric conditions, tracking problems, very poor seeing, or simply because that area has not been surveyed yet. This is encoded in the status flags.<a href=''algorithm.asp?key=flags''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('IOP','IOP','','Imaging Observers Program. The software that runs the imaging camera<a href=''glossary.asp?key=camera''><img src=''images/glossary.gif'' border=0></a> on the survey telescope.
' ); 
INSERT glossary VALUES('JHU','JHU','','Johns Hopkins University, one of the participating institutions in SDSS. The SDSS JHU homepage is <a href="http://www.sdss.jhu.edu">www.sdss.jhu.edu</a>.
' );
INSERT glossary VALUES('JPG','JPG','','Japan Participation Group, one of the participating institutions in SDSS. Their homepage is <a href="http://indus.astron.s.u-tokyo.ac.jp/works/SDSS/sdss.html">here</a>.
' );
INSERT glossary VALUES('lambda','lambda','','One of the coordinates of the survey coordinate system<a href=''glossary.asp?key=survey_coords''><img src=''images/glossary.gif'' border=0></a>. The stripe longitude lambda is measured from the survey
central meridian positive to the east along the great circles perpendicular to that meridian. Constant longitude curves are circles centered on the survey poles<a href=''glossary.asp?key=poles''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('luptitude','luptitude','','An informal name for the asinh magnitude<a href=''glossary.asp?key=asinh''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('maggie','maggie','','A <em>maggie</em> is a linear
measure of flux; one maggie has an AB magnitude of 0 (thus a surface
brightness of 20 mag/square arcsec corresponds to 10<sup>-8</sup> maggies
per square arcsec). This unit is used for object radial profiles<a href=''glossary.asp?key=profile''><img src=''images/glossary.gif'' border=0></a>, where we provide the azimuthally averaged object surface brightness in a series of annuli.
' );
INSERT glossary VALUES('mag_fiber','magnitude, fiber','','The flux contained within the aperture of a spectroscopic fiber<a href=''glossary.asp?key=fiber''><img src=''images/glossary.gif'' border=0></a>
(3" in diameter) is calculated in each band and stored in <b><font face="arial black, monaco, chicago">
fiberMag</b></font>.<a href=''algorithm.asp?key=mag_fiber''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('mag_model','magnitude, model','','Just as the PSF magnitudes<a href=''glossary.asp?key=mag_psf''><img src=''images/glossary.gif'' border=0></a> are optimal measures of the fluxes of
stars, the optimal measure of the flux of a galaxy would use a matched galaxy
model.  With this in mind, the code fits two models to the
two-dimensional image of each object in each band:<br>
1. a pure deVaucouleurs profile, and<br>
2. a pure exponential profile.<br>
The best-fit model in the
  r-band is fit to the other four bands; the results are stored as the
  model magnitudes. 
Details, <font color="red"> including a very important warning</font>, can be found here<a href=''algorithm.asp?key=mag_model''><img src=''images/algorithm.gif'' border=0></a>.
' );
INSERT glossary VALUES('mag_petro','magnitude, Petrosian','','Stored as <b><font face="arial black, monaco, chicago">petroMag</b></font>. For galaxy photometry, measuring flux is more difficult than for stars, because galaxies do not all have the same radial surface
brightness profile, and have no sharp edges.  In order to avoid
biases, we wish to measure a constant fraction of the total light,
independent of the position and distance of the object. To satisfy these
requirements, the SDSS has adopted a modified form of the
Petrosian (1976) system, measuring galaxy fluxes within a circular
aperture whose radius is defined by the shape of the azimuthally
averaged light profile.<a href=''algorithm.asp?key=mag_petro''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('mag_pogson','magnitude, Pogson','','The Pogson magnitude is the standard astronomical magnitude system, where one 
increment in magnitude is an increase in brightness by the fifth root of 100.
A star of 1st magnitude is therefore 100 times as bright as a star of 6th magnitude. Mathematically this is expressed as<br>
<code>M1 - M2 = -2.5log(F1/F2)</code><br>
where M1 and M2 are the magnitudes of two objects, and F1 and F2 are their luminous fluxes.
' );
INSERT glossary VALUES('mag_psf','magnitude, PSF','','Stored as <b><font face="arial black, monaco, chicago">psfMag</b></font>. For isolated stars, which are well-described by the point spread function 
(PSF), the optimal
measure of the total flux is determined by fitting a PSF model to the
object. <a href=''algorithm.asp?key=mag_psf''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('mask','mask','','Need definition
' );
INSERT glossary VALUES('mask_frame','mask frame','','Each file is a binary FITS table for one filter. Each row of the table describes a set of pixels in the corrected frame, using mask values described in Table 8 of the EDR paper. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('MAST','MAST','','The Multimission Archive at Space Telescope. Data from a variety of space missions and ground-based telescopes is provided, including the Sloan EDR<a href=''glossary.asp?key=EDR''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('modelMag','modelMag','','The model magnitude. See magnitude, model<a href=''glossary.asp?key=mag_model''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('monitor','Monitor Telescope (MT)','','The previous incarnation of the Photometric Telescope (PT)<a href=''glossary.asp?key=photo_tel''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('MT_field','MT_field','','See secondary patch<a href=''glossary.asp?key=secondary_patch''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('mtpipe','mtpipe','','The pipeline for processing data from the Photometric Telescope<a href=''glossary.asp?key=photo_tel''><img src=''images/glossary.gif'' border=0></a>. A description can be found in the <a href="http://www.sdss.org/dr1/algorithms/EDRpaper.html#sw-photocal-mtpipe">appropriate section of the EDR paper</a>.
' );
INSERT glossary VALUES('mu','mu','','One of the coordinates in the SDSS great circle coordinate system<a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a>. Mu corresponds to RA, or longitude.
' ); 
INSERT glossary VALUES('nfcalib','nfCalib','','The pipeline that uses the results of MTPipe<a href=''glossary.asp?key=mtpipe''><img src=''images/glossary.gif'' border=0></a> and 
astrom<a href=''glossary.asp?key=astrom''><img src=''images/glossary.gif'' border=0></a> to apply the photometric
   and astrometric calibration to each object in the imaging data.
' );  
INSERT glossary VALUES('nu','nu','','One of the coordinates in the SDSS great circle coordinate system<a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a>. Nu corresponds to Dec, or latitude.
' ); 
INSERT glossary VALUES('object','object','','Enumerates photometric objects within a given field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>. Thus, multiple fields may have objects with the same object number.
' );
INSERT glossary VALUES('objectivity','Objectivity','','A brand of object-oriented database used to initially serve the EDR<a href=''glossary.asp?key=EDR''><img src=''images/glossary.gif'' border=0></a> and to run OpDB<a href=''glossary.asp?key=OpDB''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('ObjID','ObjID','','The long object identification, which is a 
bit-encoded integer of run<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>,rerun<a href=''glossary.asp?key=rerun''><img src=''images/glossary.gif'' border=0></a>,
camcol<a href=''glossary.asp?key=camcol''><img src=''images/glossary.gif'' border=0></a>, field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>, object<a href=''glossary.asp?key=object''><img src=''images/glossary.gif'' border=0></a>.  When the data is reprocessed (rerun), this number will change! <b>IMPORTANT NOTE:</b> For spectroscopic objects, there are two possible choices for the matching photometric measurement: <b><font face="arial black, monaco, chicago">TargetObjID</b></font> is the photometric object identification number of the corresponding photometric object <em>when targeting<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> was run</em>, and  <b><font face="arial black, monaco, chicago">BestObjID</b></font>, which points to the best<a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a> imaging and processing of the photometry.
' );
INSERT glossary VALUES('OpDB','OpDB','','The Operations Database. This database at FNAL<a href=''glossary.asp?key=FNAL''><img src=''images/glossary.gif'' border=0></a> keeps track of all operational aspects of the survey. It is not available to the public.
' );
INSERT glossary VALUES('par_file','par file','','Also known as a Yanny parameter file. This is a simple ascii file format developed to store lists of parameters for the SDSS, such as the survey coverage description.
' ); 
INSERT glossary VALUES('parent','parent','','A product of the deblending<a href=''glossary.asp?key=deblend''><img src=''images/glossary.gif'' border=0></a> process. When two objects are near each other on the sky, their images may appear merged. The deblender tries to split this merged image; the initial merged image is called a parent, while the resulting sub-images are called children<a href=''glossary.asp?key=child''><img src=''images/glossary.gif'' border=0></a>.<a href=''algorithm.asp?key=deblend''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('particip','participating institution','','One of the institutions involved in the survey. These institutions have contributed hardware, software, manpower, or financial support to the survey, and thus have pre-public access to data.
' );
INSERT glossary VALUES('photo','Photometric Pipeline (<code>Photo</code>)','','A series of linked pipelines (Serial Stamp Collecting pipeline, SSC<a href=''glossary.asp?key=ssc''><img src=''images/glossary.gif'' border=0></a>; Postage Stamp Pipeline, PSP<a href=''glossary.asp?key=psp''><img src=''images/glossary.gif'' border=0></a>, and
 Frames<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a>) which analyze the raw image data, including bias
   subtraction, sky and PSF determination, flat-fielding, and finding
   and measuring the properties of objects.  The astrometric and
   photometric calibration is carried out with the astrometric
   pipeline<a href=''glossary.asp?key=astrom''><img src=''images/glossary.gif'' border=0></a>, and nfCalib<a href=''glossary.asp?key=nfcalib''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('photo_tel','Photometric Telescope','','Also abbreviated PT. An  0.5-meter telescope used for monitoring subtle changes in the atmosphere during the course of the survey. Its principal function is to aid astronomers in accurately calibrating an object''s brightness, as measured with the main telescope.
' );
INSERT glossary VALUES('plate','plate','','SDSS has the largest multi-fiber spectrograph in operation in the world, observing 640 objects simultaneously. This is done by drilling holes in round aluminum plates at the positions of objects of interest, and plugging optical fibers<a href=''glossary.asp?key=fiber''><img src=''images/glossary.gif'' border=0></a> into each hole.
' );
INSERT glossary VALUES('plate_map','plate mapper','','An instrument that maps which plugged fiber<a href=''glossary.asp?key=fiber''><img src=''images/glossary.gif'' border=0></a> corresponds to which target object. The 640 fibers of the spectrograph<a href=''glossary.asp?key=spectrograph''><img src=''images/glossary.gif'' border=0></a> are placed by hand without regard as to which fiber corresponds to which position. An automated fiber mapper resolves this object-to-fiber match-up by scanning lasers across the terminal ends of the fibers and observing where they "light up" on the focal plane.
' ); 
INSERT glossary VALUES('psf','Point Spread Function (PSF)','','The detailed shape of the response of the
telescope plus instrument to a star.  It varies with position, filter,
and time, due to changes in the atmosphere and the optics of the
telescope.  It is calculated by the PSP<a href=''glossary.asp?key=psp''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('poles','poles','','need definition
' );
INSERT glossary VALUES('psp','Postage Stamp pipeline (PSP)','','This pipeline determines for a run<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>
   the background sky, the flat-field, and the spatially varying Point
   Spread Function (PSF) in each chip, all of which will be used by
   the Frames pipeline<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('primary','Primary','','The "main" observation of an object. Because there are overlaps at many levels of the imaging (runs<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>, stripes<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>), an object may be observed two or more times. Whether or not a specific observation of an object is the primary is 
decided when chunks<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a> are resolved<a href=''glossary.asp?key=resolve''><img src=''images/glossary.gif'' border=0></a>. Whether an object is primary or not depends on a large number of factors.<a href=''algorithm.asp?key=resolve''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('primary_standard','primary standard','','One of the 158 stars on the SDSS photometric
  system that is observed by the PT to measure the extinction of a
  given night, and which is used to calibrate the magnitudes of the
  secondary standards (qv).  The primary standard system is described
  in the <a href="http://www.journals.uchicago.edu/AJ/journal/issues/v123n4/201445/201445.html">Smith et al. 2002 AJ paper</a>.
' );
INSERT glossary VALUES('profile','profile','','An azimuthally-averaged radial
surface brightness profile. In the catalogs, it is given as the
average surface brightness in a series of annuli.  This quantity is in 
units of maggies<a href=''glossary.asp?key=maggie''><img src=''images/glossary.gif'' border=0></a> per square arcsec. The number of annuli for which there is a
measurable signal is listed as <b><font face="arial black, monaco, chicago"> nprof</b></font>, the mean surface
brightness is listed as <b><font face="arial black, monaco, chicago"> profMean</b></font>, and the error is listed as
<b><font face="arial black, monaco, chicago"> profErr</b></font>.  This error includes both photon noise, and the
small-scale "bumpiness" in the counts as a function of azimuthal
angle.
<br>
When converting the <b><font face="arial black, monaco, chicago">profMean</b></font> values to a local surface
brightness, it is <b>not</b> the best approach to assign the mean
surface brightness to some radius within the annulus and then linearly
interpolate between radial bins.  Do not use smoothing
splines, as they will not go through the points in the cumulative
profile and thus (obviously) will not conserve flux. What frames pipeline<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a>
does, e.g., in determining the Petrosian ratio<a href=''glossary.asp?key=mag_petro''><img src=''images/glossary.gif'' border=0></a>, is to fit a taut spline to the
<em>cumulative</em> profile and then differentiate that spline fit,
after transforming both the radii and cumulative profiles with asinh
functions.  We recommend doing the same here.
' );
INSERT glossary VALUES('psField','psField file','','A FITS binary table with preliminary photometric calibration, as well as final point-spread-function fit, for a single field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a> in an imaging run<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('psfMag','psfMag','','The PSF magnitude. See Magnitude, PSF<a href=''glossary.asp?key=mag_psf''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('QA','Quality Assurance (QA)','','Generally speaking, the process by which data
are confirmed to be of survey quality.  Each pipeline carries out QA,
whose results are available for examination. After
the imaging data are calibrated, they are run through a comprehensive
set of tests (runQA) that confirm that the various photometric
measures are consistent, and that, e.g., the Zhed point<a href=''glossary.asp?key=zhed''><img src=''images/glossary.gif'' border=0></a> is
well-behaved.  Overlap QA looks for consistency in the photometry and
astrometry of objects in overlaps between adjacent scanlines<a href=''glossary.asp?key=scanline''><img src=''images/glossary.gif'' border=0></a> and stripes<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('QA_hole','QA hole','','need definition
' );
INSERT glossary VALUES('reconst','Reconstructed Frame','','Images of SDSS fields constructed by "pasting" atlas image<glossary>atlas_image</glossary> cutouts into the field<glossary>field</glossary> and filling the rest of the image with simulated sky noise.' ); 
INSERT glossary VALUES('redden','reddening','','Reddening corrections in magnitudes at the position of each object, called
<b><font face="arial black, monaco, chicago">extinction</b></font> in the database, are computed following Schlegel, Finkbeiner & Davis (1998).  These
corrections are <em><b>not</em></b> applied to the magnitudes in the 
databases.
Conversions from <em>E(B-V)</em> to total extinction <em>A<sub>lambda</sub></em>, assuming a
<em>z=0</em> elliptical galaxy spectral energy distribution, are
tabulated in Table 22 of the EDR Paper.
' );
INSERT glossary VALUES('region','Region','','A region is the union of convex<a href=''glossary.asp?key=convex''><img src=''images/glossary.gif'' border=0></a> areas.<a href=''algorithm.asp?key=sector''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('rerun','rerun','','A reprocessing of an imaging run<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>. The underlying imaging data is the same, just the software version and calibration may have changed.
' );
INSERT glossary VALUES('resolve','resolve','','A term describing the assignments of subsets of data (fields<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>, segments<a href=''glossary.asp?key=segment''><img src=''images/glossary.gif'' border=0></a>, runs<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>) to fill a chunk<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a>. A chunk is "resolved" when there is sufficient data to fill a contiguous length of a stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>. At that time, decisions are made on the best data to use (seeing, photometric conditions) to fill the desired area. A chunk can be resolved multiple times, as new data is acquired or data is reprocessed. This is why we now have multiple snapshots of the data in the database (see Target<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> and Best<a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a>).
' );
INSERT glossary VALUES('run','Run','',' A Run is just a length of a strip<a href=''glossary.asp?key=strip''><img src=''images/glossary.gif'' border=0></a> observed in a single contiguous observing pass scan<a href=''glossary.asp?key=scan''><img src=''images/glossary.gif'' border=0></a>, bounded by lines of mu<a href=''glossary.asp?key=mu''><img src=''images/glossary.gif'' border=0></a> and nu<a href=''glossary.asp?key=nu''><img src=''images/glossary.gif'' border=0></a>. A strip covers a great circle region from pole to pole; this cannot be observed in one pass. The fraction of a strip observed at one time (limited by observing conditions) is a Run. Runs can (and usually do) overlap at the ends. Like strips, it takes a pair of runs to fill in a length of a stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>.  This is why you may read about data taken from "Runs 752/756" or some similar terminology. However, each individual run does contain 6 camcols<a href=''glossary.asp?key=camcol''><img src=''images/glossary.gif'' border=0></a> spanning the same range of nu, but not delimited by eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a>. These run pairs might not have the same starting and ending nu<a href=''glossary.asp?key=nu''><img src=''images/glossary.gif'' border=0></a> coordinates.
' );
INSERT glossary VALUES('scanline','scanline','','A subdivision of a strip<a href=''glossary.asp?key=strip''><img src=''images/glossary.gif'' border=0></a>. Each strip is covered by 6 "scanlines".  Scanlines are defined in
great circle coordinates<a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a>. The great circle coordinate
system is different for each strip, and is defined by setting the
equator of the coordinate system to be the center line of constant eta
for the stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a> to which the strip belongs.  A scanline is then bounded on the top and bottom by
lines of constant nu<a href=''glossary.asp?key=nu''><img src=''images/glossary.gif'' border=0></a>, with no east or west boundaries. 
Scanlines touch but don''t overlap, and thus are a unique mapping on the
sky for that stripe only.  Scanlines for different stripes DO overlap. This is because the scanlines come from the camera columns, or camcols<a href=''glossary.asp?key=camcol''><img src=''images/glossary.gif'' border=0></a>, which 
have a fixed physical width, while the spherical coordinates converge at the poles. <b>Note:</b> At times, the term scanline has been used interchangeably (and improperly) with camcol<a href=''glossary.asp?key=camcol''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('schema','schema','','The implementation of a data model<a href=''glossary.asp?key=data_model''><img src=''images/glossary.gif'' border=0></a> in a database.
' ); 
INSERT glossary VALUES('science_archive','science archive','','Also known as the SX, this was the prior incarnation of the database containing the object catalogs for the SDSS (for the EDR<a href=''glossary.asp?key=EDR''><img src=''images/glossary.gif'' border=0></a>).
' ); 
INSERT glossary VALUES('scienceprimary','sciencePrimary','','Spectra that are considered good enough for science are marked as <b>sciencePrimary</b> spectra and included in the SpecObj<a href=''tabledesc.asp?key=SpecObj''><img src=''images/tableref.gif'' border=0></a> view of the SpecObjAll<a href=''tabledesc.asp?key=SpecObjAll''><img src=''images/tableref.gif'' border=0></a> table.  There are several criteria used to
determine whether the sciencePrimary flag should be set to 1 for an object in the SpecObjAll table.  These are described in the <a href="cas_faq.asp#scienceprimary">FAQ entry for sciencePrimary</a>.' ); 
INSERT glossary VALUES('sdss','SDSS','','The Sloan Digital Sky Survey. The survey will map in detail one-quarter of the entire sky, determining the positions and absolute brightnesses of more than 100 million celestial objects. It will also measure the distances to more than a million galaxies and quasars. For more, visit our <a href="http://www.sdss.org">homepage</a>.
' );
INSERT glossary VALUES('sdssqa','sdssQA','','The SDSS Query Analyzer. A Java-based Graphical User Interface (GUI) that provides the functionality necessary for SDSS users to prepare and submit queries to the SQL server database. 
' );
INSERT glossary VALUES('sdssqt','sdssQT','','Obsolete. This was the SDSS Query Tool, used for the Early Data Release<a href=''glossary.asp?key=EDR''><img src=''images/glossary.gif'' border=0></a>. It is a Graphical User Interface (GUI) that provides the functionality necessary for SDSS users to prepare and submit queries to the Science Archive, the "end product" of the SDSS, where all publicly available scientific data products are stored and
ready for access. 
' );
INSERT glossary VALUES('secondary','secondary object','','The best observation of an object with multiple observation is called the
primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> object, and other observations are stored
in the PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a> table and
PhotoObj<a href=''tabledesc.asp?key=PhotoObj''><img src=''images/tableref.gif'' border=0></a> view as secondary objects.
' );
INSERT glossary VALUES('secondary_patch','secondary patch','','The PT<a href=''glossary.asp?key=photo_tel''><img src=''images/glossary.gif'' border=0></a> observes a series of
  secondary patches on a given night, calibrated to the system of
  primary standards<a href=''glossary.asp?key=primary_standard''><img src=''images/glossary.gif'' border=0></a>.  These patches overlap the 2.5m survey stripes<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>;  with the photometry determined for these, we can set the zeropoints
  of the 2.5m runs<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a>.
' ); 
INSERT glossary VALUES('sector','Sector','','A sector is basically an intersection of
TileRegions<a href=''glossary.asp?key=tile_region''><img src=''images/glossary.gif'' border=0></a>. 
It is a plate wedge modified by intersections with overlapping
<b>tile boundaries</b><a href=''glossary.asp?key=tibound''><img src=''images/glossary.gif'' border=0></a>.  If the TilingBoundary
regions are complex (multiple convexes) or if they are holes (isMask=1), then
the resulting sector is also complex (a region of multiple convexes). As such
a sector is just a single convex.  Tiling boundaries do not add any depth to
the sectors; they just truncate them to fit in the
boundary. <a href=''algorithm.asp?key=sector''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('segment','segment','','A segment is a piece of a given frames<a href=''glossary.asp?key=frames''><img src=''images/glossary.gif'' border=0></a> pipeline
reduction (run<a href=''glossary.asp?key=run''><img src=''images/glossary.gif'' border=0></a> : rerun<a href=''glossary.asp?key=rerun''><img src=''images/glossary.gif'' border=0></a> : camcol<a href=''glossary.asp?key=camcol''><img src=''images/glossary.gif'' border=0></a>), covering a piece of a scanline<a href=''glossary.asp?key=scanline''><img src=''images/glossary.gif'' border=0></a>, bounded on the east and west by lines
of constant mu<a href=''glossary.asp?key=mu''><img src=''images/glossary.gif'' border=0></a>.  Because segments are defined before
the primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a> area of a stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>, segments can actually go beyond the eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a> limits of a stave<a href=''glossary.asp?key=stave''><img src=''images/glossary.gif'' border=0></a> (and a chunk<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a>). Indeed, near the very end of a stripe (near
the poles), a segment may fall completely outside a stave.
' );
INSERT glossary VALUES('ssc',   'Serial Stamp Collecting Pipeline (SSC)','','The first stage of the
   Photometric pipeline<a href=''glossary.asp?key=photo''><img src=''images/glossary.gif'' border=0></a>.  It collects for further analysis the atlas
   images of stars to be used in astrometric calibration and PSF
   determination.' );
INSERT glossary VALUES('skyserver','SkyServer','','A <a href="http://skyserver.sdss.org/">website</a> for distribution of SDSS data. Includes tools to get images, spectra, and catalog info, as well as educational and fun materials.
' );
INSERT glossary VALUES('skyversion','sky version','','The SkyVersion is a numerical designator of whether photometric data is Target<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> (SkyVersion=0), Best<a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a> (SkyVersion=1), or one of the repeated scans of the Southern Survey<a href=''glossary.asp?key=southern_survey''><img src=''images/glossary.gif'' border=0></a> (SkyVersions 2 through 14).
' ); 
INSERT glossary VALUES('small_circle','small_circle','','A section of a sphere which does not contain a diameter of the sphere. Lines of constant latitude are small circles.' );
INSERT glossary VALUES('sos','Son-of-Spectro','','A pared-down version of spec2d<a href=''glossary.asp?key=spec2d''><img src=''images/glossary.gif'' border=0></a> that runs on the
mountain, and gives feedback to the observers about the S/N of each
spectroscopic exposure and any possible problems in the data.
' );
INSERT glossary VALUES('sop','SOP (spectroscopic observing program)','','This is the program which
operates the spectrographs, including guiding the telescope and
controlling the calibrations.
' );
INSERT glossary VALUES('southern_survey','Southern Survey','','In the Southern Galactic Cap region, the SDSS will not observe the entire available area. Instead, selected stripes<glossary>stripe</glossary> will be observed repeatedly for variability studies and to coadd for deeper images.' );
INSERT glossary VALUES('spec1d','Spec1D','','The second half of the spectroscopic pipeline, also known as Spectro 1D, which
classifies the spectra and
performs various scientific analyses on them, including obtaining the
redshifts. The operational goals of the 1D SPECTRO pipeline are:<br>
To fit the continuum of the spectrum.<br>
To determine an emission-line redshift and classify all detected emission
lines.  A flag will also be set to identify any expected emission
lines (on the basis of the spectral classification) which were not seen.<br>
To classify the spectrum by cross-correlating with a set of
template spectra ranging from
stars to quasars.  A principal component
analysis similar to that of Connolly et al. (1995)
has also been implemented for further galaxy spectral classification <a href=''algorithm.asp?key=redshift_type''><img src=''images/algorithm.gif'' border=0></a>.<br>
To cross-correlate the spectrum with the a set of templates and
obtain redshifts <a href=''algorithm.asp?key=redshift_type''><img src=''images/algorithm.gif'' border=0></a>.<br>
  To fit a set of emission/absorption lines as a Gaussian <a href=''algorithm.asp?key=speclinefits''><img src=''images/algorithm.gif'' border=0></a>.<br>
 To measure the velocity dispersion of galaxies <a href=''algorithm.asp?key=veldisp''><img src=''images/algorithm.gif'' border=0></a>.<br>
To measure various absorption line indices, as outlined in the EDR AJ paper.
' );
INSERT glossary VALUES('spec2d','Spec2D','','The first half of the spectroscopic pipeline (also sometimes referred
to as idlspec2d), which reduces the raw 2D spectral frames to 1D calibrated
spectra. The operational goals of the 2D SPECTRO pipeline are:
<br>
To interpolate over bad pixels<br>
To mask all bad pixels and pixels contaminated by strong sky emission.<br>
To bias and dark subtract the raw 2D data frames<br>
To trim the frame<br>
To flat-field  using calibration frames taken at the same telescope pointing position before and after an exposure on the sky.<br>
To optimally extract 1D spectra from this 2D frame.<br>
To apply wavelength calibration, rebin to a common wavelength solution, and sky subtract. <br>
To coadd the three or more individual exposures for each
object. <br>
To put the red and blue halves of the spectrum together.<br>
To flux calibrate the spectrum to obtain 
spectrophotometry good to roughly 15%, using the measured photometry
of spectrophotometric standards on each plate. <br>
' );
INSERT glossary VALUES('specbs','SpecBS','','An alternative 1-d spectroscopic pipeline developed by David Schlegel. The data and documentation for this pipeline are available <a 
="http://spectro.princeton.edu/">here</a> .
' );
INSERT glossary VALUES('specobj','SpecObjID','','A unique bit-encoded 64-bit ID used for spectroscopic objects. It is generated from plateid<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a>, mjd,  and fiberid<a href=''glossary.asp?key=fiber''><img src=''images/glossary.gif'' border=0></a>. Completely independent of any photometric enumeration system.
' );
INSERT glossary VALUES('spectro','Spectro','','The spectroscopic data reduction pipeline. See Spec2D<a href=''glossary.asp?key=spec2d''><img src=''images/glossary.gif'' border=0></a> and Spec1D<a href=''glossary.asp?key=spec1d''><img src=''images/glossary.gif'' border=0></a> for details.
' );
INSERT glossary VALUES('spectrograph','spectrograph','','The instrument used to obtain spectra of objects. SDSS actually uses two identical spectrographs, each receiving as input 320 of the fibers<a href=''glossary.asp?key=fiber''><img src=''images/glossary.gif'' border=0></a> from a plate<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('spectrophotometry','spectrophotometry','','The procedure for absolute flux calibration of spectra.<a href=''algorithm.asp?key=spectrophotometry''><img src=''images/algorithm.gif'' border=0></a>
' );
INSERT glossary VALUES('spPlate','spPlate file','','A FITS image containing the wavelength- and flux-calibrated combined spectrum over all exposures (potentially spanning multiple nights) for a given mapped plate<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a>. Output as part of spec2d<a href=''glossary.asp?key=spec2d''><img src=''images/glossary.gif'' border=0></a>, it does <em>not</em> contain redshift information. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('spSpec','spSpec file','','A FITS image containing the line measurements and redshift determinations, as well as the 1-d spectrum, for a single object, summing over all of its exposures through a given mapped plate<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a>. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('sql','SQL','','The <em><b>S</b>tructured <b>Q</b>uery <b>L</b>anguage</em>, a standard means of asking for data from databases. For more, see our SQL help page.
' );
INSERT glossary VALUES('stave','stave','','A unique region of sky, bounded by two lines of constant eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a>. A stave is a portion of a stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a> that is tapered near the poles so that it does not overlap with the neighboring stave. This term is used analogously to the meaning of stave in barrelmaking.
' );
INSERT glossary VALUES('stokes','Stokes Parameters','',' These quantities are related to object ellipticities.  Define the flux-weighted second moments of the object as:<br>
<b>M<sub>xx</sub> = &lt;x<sup></sup>/r<sup>2</sup>&gt; ,M<sub>yy</sub> = &lt;y<sup>2</sup>/r<sup>2</sup>&gt; , M<sub>xy</sub> = &lt;xy/r<sup>2</sup>&gt;</b><br>
In the case that the object''s isophotes are self-similar ellipses, one can show that: <br>
<b>Q = M<sub>xx</sub>-M<sub>yy</sub> = [(a-b)/(a+b)]&times;cos2&phi; <br> U = M<sub>xy</sub> = [(a-b)/(a+b)]&times;sin2&phi;</b><br>
where a and b are the semimajor and semiminor axes and &phi; is the position angle. Q and U are <b><font face="arial black, monaco, chicago">Q</b></font> and <b><font face="arial black, monaco, chicago">U</b></font> in the table
<b><font face="arial black, monaco, chicago">PhotoObj</b></font> and are referred to as "Stokes parameters." They can be used to reconstruct the axis ratio and position
angle, measured relative to row and column of the CCDs. This is equivalent to the normal definition of position
angle (east of north), for the scans on the equator. The performance of the Stokes parameters are not ideal at low
signal-to-noise ratio, in which case the adaptive moments<a href=''glossary.asp?key=adaptive_moment''><img src=''images/glossary.gif'' border=0></a> will be more useful.
' );
INSERT glossary VALUES('strip','strip','','A strip is a scan along a line of constant survey latitude eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a>. The center of a stripe is set at a given eta; centers of strips have a boresight<a href=''glossary.asp?key=boresight''><img src=''images/glossary.gif'' border=0></a> offset added. Because the columns of CCDs have gaps between them, it is necessary to take two offset but overlapping observations to fill in a stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>. These two scans<a href=''glossary.asp?key=scan''><img src=''images/glossary.gif'' border=0></a> are called strips. Note that while strips are centered on a given eta, THEY ARE NOT BOUND BY ETA LINES. Thus they are rectangular regions. and can overlap at the poles.
' );
INSERT glossary VALUES('stripe','stripe','','Stripes are the sum of two strips, defined in survey coordinates<a href=''glossary.asp?key=survey_coords''><img src=''images/glossary.gif'' border=0></a> (lambda<a href=''glossary.asp?key=lambda''><img src=''images/glossary.gif'' border=0></a>, eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a>).  A "stripe" is
defined by a line of constant eta, bounded on the north and south by
the edges of the two strips that make up the stripe, and bounded on
the east and west by lines of constant lambda. Because both strips and
stripes are defined in "observed" space, they are rectangular areas
which overlap as one approaches the poles. <b>NOTE</b>: You may see the term stripe used to mean an area
bounded by eta lines, which would be a unique part of the sky. That is
a common use of the term, as some of the target selection
documentation uses it that way. The proper (and relatively new) term
for the unique, eta-bound portion of a stripe is a stave<a href=''glossary.asp?key=stave''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('surface_brightness','surface brightness','','The frames pipeline<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a> also reports the radii containing 50% and 90% of the Petrosian flux<a href=''glossary.asp?key=mag_petro''><img src=''images/glossary.gif'' border=0></a> for each band, <b><font face="arial black, monaco, chicago">petroR50</b></font> and <b><font face="arial black, monaco, chicago">petroR90</b></font> respectively. The usual
characterization of surface-brightness in the target selection pipeline of the SDSS is the mean surface brightness within petroR50. 
<br>
It turns out that the ratio of petroR50 to petroR90, the so-called "inverse concentration index", is correlated with morphology (Shimasaku et al. 2001,
Strateva et al. 2001). Galaxies with a de Vaucouleurs profile have an inverse concentration index of around 0.3; exponential galaxies have an inverse
concentration index of around 0.43. Thus, this parameter can be used as a simple morphological classifier. 
<br>
An important caveat when using these quantities is that they are not corrected for seeing. This causes the surface brightness to be underestimated, and
the inverse concentration index to be overestimated, for objects of size comparable to the PSF. The amplitudes of these effects, however, are not yet well
characterized. 
' );
INSERT glossary VALUES('survey_coords','survey coordinates','','One of the two main coordinate systems used by the 
survey, with coordinates eta<a href=''glossary.asp?key=eta''><img src=''images/glossary.gif'' border=0></a> and lambda<a href=''glossary.asp?key=lambda''><img src=''images/glossary.gif'' border=0></a>. 
This is simply another spherical coordinate system, where (eta,lambda)=(0,90.) corresponds to (ra,dec)=(275.,0.) and (eta,lambda)=(57.5,0.) corresponds to 
(ra,dec)=(0.,90.). Note also that at (eta, lambda)=(0.,0.), 
(ra,dec)=(185.,32.5). So, this is a pure rotation of the usual RA/Dec system, as opposed to the great circle system<a href=''glossary.asp?key=great_circle_coords''><img src=''images/glossary.gif'' border=0></a>, which is defined relative to each individual stripe<a href=''glossary.asp?key=stripe''><img src=''images/glossary.gif'' border=0></a>.
For some reason, although "eta" is constant along great 
circles, it is referred to as "survey latitude," while "lambda" is referred to
 as "survey longitude." Also, "eta" runs only from -90. to 90.; the back of 
the sphere is covered by "lambda", which runs from -180. to 180. The Survey 
coordinates are defined such that the "primary" area of a stripe<a href=''glossary.asp?key=stripe>
''><img src=''images/glossary.gif'' border=0></a> (otherwise known as a stave<a href=''glossary.asp?key=stave''><img src=''images/glossary.gif'' border=0></a>) in the north 
is defined by a rectangle in Survey coordinates which is 2.5 degrees wide in 
eta (coordinate width). You may be interested in SM routines which convert 
between Equatorial, Survey, and Great Circle coordinates.
Again, Astrotools<a href=''glossary.asp?key=astrotools''><img src=''images/glossary.gif'' border=0></a> has routines to do this as well.
' );
INSERT glossary VALUES('survey_equator','survey equator','','The great circle perpendicular to the central meridian<a href=''glossary.asp?key=central_meridian''><img src=''images/glossary.gif'' border=0></a>,  passing through the survey center at delta=32.8deg is the survey equator. 
' );
INSERT glossary VALUES('survey_poles','survey poles','','The locations of the poles in the survey coordinate system<a href=''glossary.asp?key=survey_coords''><img src=''images/glossary.gif'' border=0></a>. Due to the unusual nature of this system, there is an east pole and a west one, at delta = 0 , alpha = 18h 20m and 6h 20m.
' );
INSERT glossary VALUES('sx','SX','','An abbreviation for the old Science Archive. This was the prior incarnation of the database containing the object catalogs. utilizing Objectivity<a href=''glossary.asp?key=objectivity''><img src=''images/glossary.gif'' border=0></a> software.
' );
INSERT glossary VALUES('table','Table','',' A specific set of objects and their measured quantities stored in a database.
' );
INSERT glossary VALUES('target','Target','','<b>1.</b> An object select as a candidate for spectroscopy.<br>
<b>2.</b> The pipleine used to select candidates for spectroscopy. The procedures and various type of targets are described in the the Target algorithm page<a href=''algorithm.asp?key=target''><img src=''images/algorithm.gif'' border=0></a>. <br>
<b>3.</b>The database containing photometric measurements for objects at the time <code>Target</code><a href=''algorithm.asp?key=target''><img src=''images/algorithm.gif'' border=0></a> was run. If newer observations or improved calibration or software becomes available, the imaging data may be reprocessed, but <em>not</em> re-<code>Target</code>ed. The improved photometry is placed in the <code>Best</code><a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a> database.
' );
INSERT glossary VALUES('tdi','TDI','','The SDSS imaging data are taken in time-delay-and-integrate (TDI) mode at the sidereal rate almost simultaneously in five bands. The sky tracks through 5 CCD detectors in succession, each located behind a different filter.
' );
INSERT glossary VALUES('tilable','tilable target','','These are spectroscopic targets <a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> which are assigned to tiles<a href=''glossary.asp?key=tile''><img src=''images/glossary.gif'' border=0></a> by tiling<a href=''glossary.asp?key=tiling</glossary. The significance of this is that tilable targets are supposed to have as close to uniform completeness as possible and it should be possible to define well-defined samples of such targets. The bitmasks <b>primTarget</b> and <b>secTarget</b> described in  the description of the target selection<a href=''algorithm.asp?key=target''><img src=''images/algorithm.gif'' border=0></a> contain the target assignments of each object<a href=''glossary.asp?key=object''><img src=''images/glossary.gif'' border=0></a>. Tilable targets for the survey proper are those with the <b>primTarget</b> flags QSO_HIZ, QSO_CAP, QSO_SKIRT, QSO_FIRST_CAP, QSO_FIRST_SKIRT, GALAXY_RED, GALAXY, GALAXY_BIG, GALAXY_BRIGHT_CORE, or STAR_BROWN_DWARF, and those with the <b>secTarget</b> flag HOT_STD.
' );
INSERT glossary VALUES('tile','tile','','A 1.49 deg radius circle on the sky determined by
tiling<a href=''glossary.asp?key=tiling''><img src=''images/glossary.gif'' border=0></a> and which contains the locations of up to
592 tilable targets<a href=''glossary.asp?key=tilable''><img src=''images/glossary.gif'' border=0></a> and other science targets.
This circle will become the plates into which fibers are plugged to observe
spectra.  For each tile one or more plates<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a> will be
created.  Only the part of the Tile that is within the union of the
TilingBoundaries<a href=''glossary.asp?key=tibound''><img src=''images/glossary.gif'' border=0></a> for the
TileRun<a href=''glossary.asp?key=tile_run''><img src=''images/glossary.gif'' border=0></a> and outside the union of the TilingMasks
for the TileRun and the global TilingMasks<a href=''glossary.asp?key=timask''><img src=''images/glossary.gif'' border=0></a> may
actually have targets. If less than the maximum of 592 tilable targets can be
assigned to that tile, the spare fibers are assigned to other spectroscopic
targets. The 48 remaining fibers<a href=''glossary.asp?key=fiber''><img src=''images/glossary.gif'' border=0></a> will be assigned to
calibration targets.
' );
INSERT glossary VALUES('tile_run','TileRun','','A TileRun represents a single run of the tiling software.  It is a
logical unit of geometrical information that consists of a set of
TilingBoundaries<a href=''glossary.asp?key=tibound''><img src=''images/glossary.gif'' border=0></a>,
TilingMasks<a href=''glossary.asp?key=timask''><img src=''images/glossary.gif'' border=0></a>, and Tiles<a href=''glossary.asp?key=tile''><img src=''images/glossary.gif'' border=0></a>
that are associated with exactly one TileRun (ie each TilingBoundary,
TilingMask, and Tile is associated with exactly one TileRun, with one
exception that will be noted later).  Sometimes this is also called a tiling
chunk, although that is incorrect usage of the term and it should not be
confused with an imaging chunk<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('tile_region','TileRegion','','TileRegion is a term used to indicate the portion of a Tile that may
have targets (i.e. within the union of the TilingBoundaries for a TileRun
and outside the union of the TilingMasks for the TileRun and the global
TilingMasks).  These are not necessarily convex because of the TilingMasks.
' );
INSERT glossary VALUES('tibound','TilingBoundary','','A TilingBoundary is a set of "rectangles" that defines the area of the sky that
may be tiled in a TileRun<a href=''glossary.asp?key=tile_run''><img src=''images/glossary.gif'' border=0></a>.  Only targets from
within the union of the TilingBoundaries<a href=''glossary.asp?key=tibound''><img src=''images/glossary.gif'' border=0></a> for a
TileRun may be assigned to Tiles<a href=''glossary.asp?key=tile''><img src=''images/glossary.gif'' border=0></a> created during a 
TileRun.  A single TilingBoundary must be contained within a single chunk.
' );
INSERT glossary VALUES('timask','TilingMask','','TilingMasks are "rectangles" that should not be considered part of
the tileable area during a TileRun<a href=''glossary.asp?key=tile_run''><img src=''images/glossary.gif'' border=0></a>.  I do not
know what other rules govern TilingMasks.  There should be some "global"
TilingMasks that apply to ALL TileRuns.
' );
INSERT glossary VALUES('tiling','tiling','','The process of designing tiles<a href=''algorithm.asp?key=tiling''><img src=''images/algorithm.gif'' border=0></a> for spectroscopy.
' ); 
INSERT glossary VALUES('tpm','TPM','','Telescope Performance Monitor. Software that reports on the physical parameters of the survey telescope.
' );
INSERT glossary VALUES('tsfield','tsField','','The tsField files are FITS binary tables containing the information about each imaging field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a> that is exported to the Field tables in the CAS<a href=''glossary.asp?key=CAS''><img src=''images/glossary.gif'' border=0></a>. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>, in both Best<a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a> and Target<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> versions.
' );
INSERT glossary VALUES('tsobj','tsObj','','<keyword>tsobj</keyword>
The tsObj files are FITS binary tables containing calibrated object catalogs output by the frames pipeline<a href=''glossary.asp?key=frames_pipeline''><img src=''images/glossary.gif'' border=0></a>, one per field<a href=''glossary.asp?key=field''><img src=''images/glossary.gif'' border=0></a>. They are available from the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>, in both Best<a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a> and Target<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a> versions, and form the basis for the photometric data found in the PhotoObj table in CAS<a href=''glossary.asp?key=CAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('tsobjfrommap','tsObjFromMap','','A tsObj file<a href=''glossary.asp?key=tsobj''><img src=''images/glossary.gif'' border=0></a> containing the calibrated information only for those objects which have been targeted<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a>. Available in the DAS<a href=''glossary.asp?key=DAS''><img src=''images/glossary.gif'' border=0></a>.
' );
INSERT glossary VALUES('view','View','','In a database, a way of looking at a subset of the data in a given CAS Table<a href=''glossary.asp?key=table''><img src=''images/glossary.gif'' border=0></a>. Views are treated just like Tables in SQL<a href=''glossary.asp?key=sql''><img src=''images/glossary.gif'' border=0></a> queries. For example, in the CAS<a href=''glossary.asp?key=CAS''><img src=''images/glossary.gif'' border=0></a>, the Galaxy view shows only the subset of PhotoObj table that are classified as galaxies.
' ); 
INSERT glossary VALUES('wcs','WCS','','World Coordinate System. The FITS standard for defining 
astrometric calibrations in the image header. 
' );
INSERT glossary VALUES('zhed','zhed point','','The stellar locus in SDSS color-color space is essentially one-dimensional.  Various canonical positions in color-color space can be defined from bends in the stellar locus; we call these positions the Zhed Points.  The constancy of these positions is a very useful test of the uniformity of our photometry. 
' );

GO
----------------------------- 
PRINT '166 lines inserted into glossary'
----------------------------- 

