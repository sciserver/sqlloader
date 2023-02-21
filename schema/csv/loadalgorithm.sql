
----------------------------- 
--  loadalgorithm.sql
----------------------------- 
SET NOCOUNT ON
GO
TRUNCATE TABLE algorithm
GO

INSERT algorithm VALUES('objid','SDSS ObjID Encoding','','The bit encoding for the long (64-bit) IDs that are used as unique keys in the
SDSS catalog tables is described here.
<h3>PhotoObjID</h3>
The encoding of the photometric object long ID (<b>objID</b> in the photo
tables) is described in the table below.  This scheme applies to the fieldID
and objID (objid bits are 0 for fieldID).
<p>
<table border=1>
  <tr>
    <td><i>Bits</i></td> <td><i>Length<br>(# of bits)</i></td> <td><i>Mask</i></td> <td><i>Assignment</i></td> <td><i>Description</i></td>
  </tr>
  <tr>
    <td>0</td>    <td>1 </td> <td>0x8000000000000000</td> <td> empty </td> <td>unassigned </td>
  </tr>
  <tr>
    <td>1-4</td>   <td>4 </td> <td>0x7800000000000000</td> <td> skyVersion </td> <td>resolved sky version (0=TARGET, 1=BEST, 2-15=RUNS)</td>
  </tr>
  <tr>
    <td>5-15</td>  <td>11</td> <td>0x07FF000000000000</td> <td> rerun </td> <td>number of pipeline rerun</td>
  </tr>
  <tr>
    <td>16-31</td> <td>16</td> <td>0x0000FFFF00000000</td> <td> run </td> <td>run number </td>
  </tr>
  <tr>
    <td>32-34</td> <td>3 </td> <td>0x00000000E0000000</td> <td> camcol</td> <td>camera column (1-6) </td>
  </tr>
  <tr>
    <td>35</td>    <td>1 </td> <td>0x0000000010000000</td> <td> firstField</td> <td>is this the first field in segment? </td>
  </tr>
  <tr>
    <td>36-47</td> <td>12</td> <td>0x000000000FFF0000</td> <td> field </td> <td> field number within run</td>
  </tr>
  <tr>
    <td>48-63</td> <td>16</td> <td>0x000000000000FFFF</td> <td> object</td> <td>object number within field</td>
  </tr>
</table>
<h3>SpecObjID</h3>
The encoding of the long ID for spectroscopic objects is described below.
This applies to plateID, specObjID, specLineID, specLineIndexID, elRedshiftID
and xcRedshiftID.
<p>
<table border=1>
  <tr>
    <td><i>Bits</i></td> <td><i>Length<br>(# of bits)</i></td> <td><i>Mask</i></td> <td><i>Assignment</i></td> <td><i>Description</i></td>
  </tr>
  <tr>
    <td>0-15</td>  <td>16</td> <td>0xFFFF000000000000</td> <td> plate</td> <td>number of spectroscopic plate</td>
  </tr>
  <tr>
    <td>16-31</td> <td>16</td> <td>0x0000FFFF00000000</td> <td>MJD</td> <td>MJD (date) plate was observed</td>
  </tr>
  <tr>
    <td>32-41</td> <td>10</td> <td>0x00000000FFC00000</td> <td> fiberID</td> <td>number of spectroscopic fiber on plate (1-640)</td>
  </tr>
  <tr>
    <td>42-47</td> <td>6 </td> <td>0x00000000003F0000</td> <td> type</td> <td>type of targeted object</td>
  </tr>
  <tr>
    <td>48-63</td> <td>16</td> <td>0x000000000000FFFF</td> <td> line/redshift/index</td> <td>0 for SpecObj, else number of spectroscopic line (SpecLine) or index (SpecLineIndex) or redshift (ELRedhsift or XCRedshift) </td>
  </tr>
</table>
' );
INSERT algorithm VALUES('photoz','Photometric Redshifts','','There are no photometic redshifts available for data releases 2 through 4
(DR2-DR4).  Starting with DR5, there are two versions of photometric redshift
in the SDSS databases, in the Photoz<a href=''tabledesc.asp?key=Photoz''><img src=''images/tableref.gif'' border=0></a> and
Photoz2<a href=''tabledesc.asp?key=Photoz2''><img src=''images/tableref.gif'' border=0></a> tables respectively.  The
algorithms for generating these are described below.  The algorithm used to 
generate the Photoz table changed for DR7 as described below.  At this time,
the Photoz2 table has not been updated for DR7.
<a name="photoz"></a><h3>Photoz Table</h3>
There are two basic methods to create a photometric redshift (photo-z,
hereafter) catalog. The first technique compares the observed colors
of galaxies to a reference set that has both colors and spectroscopic
redshifts observed. The other one uses synthetic colors calculated from
spectral energy distribution templates instead of the empirical
reference set. 
<p>
The advantage of the first method is the better
estimation accuracy, but it cannot extrapolate, so the completeness of
the reference set is crucial. In theory the second method can cover
broader redshift ranges for all types of galaxies and can give
additional information like spectral type, K-correction and absolute
magnitudes, but its accuracy is severely limited by the lack of perfect
SED models. Note, that in DR1, DR5 and DR6 the Photoz table
was based on a template based method and in the last two releases we have 
provided an independent talble, Photoz2,  with phometric redshifts calculated 
by an artificial neural network estimator.
<p>
Based on the experiences of previous releases and utilizing the 
accumulated large spectroscopic reference set, instead of template fitting,
in DR7 we use a hybrid method that combines the advantages of both
methods. For photo-z estimation a reference set would be ideal
had it completely and densely covered the whole color space spanned
by the colors of the objects for which we want to estimate
redshifts. The spectroscopic sample of SDSS contains over 700,000
objects that are categorized as galaxies based on their spectral
features. 
Although the target selection of SDSS was not designed to be a complete
reference set for photo-z, the main sample, the LRG sample together with
some special surveys like the photo-z plate survey of higher redshift
non-LRG galaxies, the low redshift plates, etc. have turned out to
cover pretty well the whole color region. This fact justifies our choice
to use the DR7 spectroscopic set as a reference set for redshift
estimation without any additional data from synthetic spectra. The
estimation method takes all objects in the estimation set 
(all PhotoObjAll objects with type=3 (GALAXY)) and first searches 
the K nearest neighbors from the reference set in the 
ubercal u-g, g-r, r-i, i-z color space and than estimates redshift by fitting a 
local low order polynomial onto these points. 
<p>
The accuracy of the results show some weak dependence on the
number of neighbors and we have found k = 100 and a linear polynomial
(hyperplane) to be optimal regarding estimation accuracy and
robustness. The robustness is further increased by excluding outliers
from the set of neighbors, i.e. those ones with redshift value too far
from the fitted hyperplane. Since the reference set contains over 700
thousand galaxies, and we had to estimate redshift for more than 260
million objects, we have used a k-d tree index for fast nearest neighbor
search. 
<p>
Beyond the redshift (z in the Photoz table in CAS) estimated by
the linear fit, we give the objID (nnObjID) and spectroscopic redshift
(nnSpecz) of the (first) nearest neighbor and calculate also the average
redshift (nnAvgZ) of the neighbors. nnVol gives the 4 dimensional
volume of the rectangular bounding box of the nnCount nearest neighbors
after excluding the outliers, and a flag value (nnIsInside) shows if the
object to be estimated is inside or outside of the box. The latter case,
which occurs for less than 5% of the objects, is a strong indication
that the estimated redshift is the result of an extrapolation and it
should not be trusted. To calculate K-correction (kcorr {u, g, r, i,
z}), distance modulus (dmod), absolute magnitudes (absMag {u, g, r, i,
z}) and rest frame colors (rest {ug, gr, ri, iz}) we combine the above
method with template fitting. We search for the best match of the
measured colors and the synthetic colors calculated from repaired 
empirical template spectra at the redshift given by the local nearest
neighbor fit. This process gives an estimate for the spectral type of
the object (pzType), too, as a scalar value in the range of [0, 1] from
early type ellipticals to late type spirals. 
<p>
We have found, that error propagation from the magnitude errors 
did not give reliable estimate of redshift errors. 
Instead when fitting the linear polynomial, we
calculate the mean deviation of the redshifts of the reference
objects and use this value (zErr) as an error estimator. Together
with the above mentioned nnIsInside and nnVol values zErr can be used to
select objects with reliable photometric redshift. As an
additional cross-check the fitted redshift (z) and the more robust but
less exact average redshift (nnAvgZ) values can be compared. 
<p>
Following the practice used in other tables in CAS, we have used -9999 to mark
missing values (e.g. where the fit gave values beyond the reasonable [0,
1] redshift range). Note that we estimate redshift for objects marked as
galaxies by the photometric pipeline. One one hand this means that
redshift is not estimated for quasars (we plan to do this in a separate
value added catalog). On the other hand those objects which were erroneously
classified as galaxies have nonsense estimated redshift values. Further details
of the method, and statistics on the quality of the estimations will be
covered in a separate paper.
<a name="photoz2"></a><h3>Photoz2 Table</h3>
(This table was not updated for DR7)<br>
The photometric redshifts from the U. Chicago/Fermilab/NYU group 
(H. Oyaizu, M. Lima, C. Cunha, H. Lin, J. Frieman, and E. Sheldon) 
are calculated using a Neural Network method that is 
similar in implementation to that of
Collister and Lahav (2004, PASP, 116, 345).
The photo-z training and validation sets consist of over
551,000 unique spectroscopic redshifts
matched to nearly 640,000 SDSS photometric measurements.
These spectroscopic redshifts come from 
the SDSS as well as the deeper galaxy surveys 2SLAQ, CFRS, 
CNOC2, TKRS, and DEEP+DEEP2.<br>
<br>
We provide photo-z estimates for a sample of over 77.4 million 
DR6 primary objects, classified as galaxies by the 
SDSS <code>PHOTO</code> pipeline (<code>TYPE</code> = 3), 
with dereddened model magnitude <i>r</i> < 22,
and which do not have any of the flags <code>BRIGHT</code>, 
<code>SATURATED</code>, or <code>SATUR_CENTER</code> set.
Note that this is a significant
change in the input galaxy sample selection compared to the DR5 
version of <code>Photoz2</code>.
<br>
<br>
Our data model is
<br>
<p><table border cellspacing=2  align=center> 
<tr>
<td>Name</td>
<td>Type</td>
<td>Description</td>
</tr>
<tr>
<td>objid</td>
<td>bigint</td>
<td>unique ID pointing to PhotoObjAll table</td>
</tr>
<tr>
<td>photozcc2</td>
<td>real</td>
<td>CC2 photo-z</td>
</tr>
<tr>
<td>photozerrcc2</td>
<td>real</td>
<td>CC2 photo-z error</td>
</tr>
<tr>
<td>photozd1</td>
<td>real</td>
<td>D1 photo-z</td>
</tr>
<tr>
<td>photozerrd1</td>
<td>real</td>
<td>D1 photo-z error</td>
</tr>
<tr>
<td>flag</td>
<td>int</td>
<td>0 for objects with r <= 20; 2 for objects with r > 20</td>
</tr>
</table>
<br>
<br>
Both the "CC2" and "D1" photo-z''s are neural network based
estimators.  "D1" uses the galaxy magnitudes in the
photo-z fit, while "CC2" uses only galaxy colors (i.e., only
magnitude differences).  Both methods also employ concentration
indices (the ratio of PetroR50 and PetroR90).
The "D1" estimator provides smaller photo-z errors than the "CC2" estimator,
and is recommended for bright galaxies <i>r</i> < 20 to minimize
the overall photo-z scatter and bias.
However, for faint galaxies <i>r</i> > 20, we recommend "CC2" 
as it provides more accurate photo-z redshift distributions.
If a <i>single</i> photo-z method is desired for simplicity, 
we also recommend "CC2" as the better overall photo-z estimator.
<br>
<br>
Please see 
<a href="http://astro.uchicago.edu/sdss/dr6/photoz2.html">this link 
for a detailed comparison of the two methods</a>, including 
performance metrics (photo-z errors and biases), quality plots,
and photometric redshift vs. spectroscopic redshift distributions
in different magnitude bins.
<br>
<br>
The photo-z errors (1&sigma, or 68% confidence) 
are computed using an empirical "Nearest Neighbor Error" (NNE) method.
NNE is a training set based method that associates similar errors to
objects with similar magnitudes, and is found
to accurately predict the photo-z error when the training set 
is representative.
<br>
<br>
The photo-z "flag" value is set to 2 for fainter objects with <i>r</i> > 20,
whose photo-z''s have larger uncertainties and biases.
<br>
<br>
Full details about the <code>Photoz2</code> photometric redshifts
are available <a href="http://astro.uchicago.edu/sdss/dr6/photoz2.html">here</a> and in Oyaizu et al. (2007), ApJ, submitted,
<a href="http://arxiv.org/abs/0708.0030">arXiv:0708.0030 [astro-ph]</a>.
<br>
' );
INSERT algorithm VALUES('specphotomatch','Spectro-Photo Matchup','','Each BEST<a href=''glossary.asp?key=best''><img src=''images/glossary.gif'' border=0></a> and each TARGET<a href=''glossary.asp?key=target''><img src=''images/glossary.gif'' border=0></a>
photo object points to a spectroscopic object if there is one nearby the photo
object (ra,dec).
<p>
Each SPECTRO object points to a  BEST photo object if there is one
nearby the spectro (ra,dec) and a TARGET object id if there is a
nearby one. 
<p>
We chose 1 arc seconds as the "nearby radius" since that approximates
the fiber radius.
<p>
This is complicated by the fact that 
<ul><li> there may be multiple photo objects at the same (ra,dec)
(primary<a href=''glossary.asp?key=primary''><img src=''images/glossary.gif'' border=0></a>, secondary<a href=''glossary.asp?key=secondary''><img src=''images/glossary.gif'' border=0></a>
objects). 
  <li> the same hole may be observed several times to give several
spectroscopic objects. 
</ul>
<p>
To resolve these ambiguities, we defined two views: 
<ol>
        <li><b>PhotoObj</b><a href=''tabledesc.asp?key=PhotoObj''><img src=''images/tableref.gif'' border=0></a> is the subset of 
PhotoObjAll<a href=''tabledesc.asp?key=PhotoObjAll''><img src=''images/tableref.gif'' border=0></a> that contains all the primary and
secondary objects. 
        <li><b>SpecObj</b><a href=''tabledesc.asp?key=SpecObj''><img src=''images/tableref.gif'' border=0></a> is the subset of
SpecObjAll<a href=''tabledesc.asp?key=SpecObjAll''><img src=''images/tableref.gif'' border=0></a> that are the "science primary"
spectroscopic objects.
</ol>
<p>        There is at most one "primary" object at any spot in the sky.
<p>
So, the logic is as follows:
       <dd> SpecObjAll<a href=''tabledesc.asp?key=SpecObjAll''><img src=''images/tableref.gif'' border=0></a> objects point to the
closest  BEST photoObj object if there is one within 1 arcseconds. 
       <dd>         If not, it points to the closest BEST PhotoObjAll object
if there is one within 1 arcseconds. 
       <dd>         If not, the SpecObj has no corresponding BEST PhotoObj.
<h3>TARGET issues</h3>
TARGET.PhotoObjAll.specObjID = 0, always.  TARGET is not supposed to
depend on BEST, and spectro stuff only lives in BEST.  You can find what
you want using SpecObjAll.targetObjID = TARGET.PhotoObjAll.objID.
<p>
TargetInfo.targetObjID is set while loading the data for a
chunk<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a> into TARGET.  The only difference between a
targetID and targetObjID is the possible flip of one bit.  This bit
distinguishes between identical PhotoObjAll objects that are in fields that
straddle 2 chunks.  Only one of the pair will actually be within the chunk
boundaries, so we want to make sure we match to that one.  Note that the one
of the pair that is actually part of a chunk might not be primary.
<p>
So, setting SpecObjAll.targetObjID does not use a positional match - it''s
all done through ID numbers.  This match should always exist, so
SpecObjAll.targetObjID always points to something in TARGET.PhotoObjAll.
However, it is not guaranteed that SpecObjAll.targetObjID will match
something in TARGET.PhotoObj because in the past we have targetted
non-primaries (stripe 10 for example).  To try to make this slightly less
confusing we require something in SpecObj to have been targetted from
something in TARGET.PhotoObj (ie primary spectra must have been primary
targets).
<p>
SpecObjAll objects with targetObjID = 0 are usually fibers that were not
mapped, so we didn''t have any way to match them to the imaging (for either
TARGET or BEST since we don''t have an ID or position).
<h3>BEST issues</h3>
spSpectroPhotoMatch handles all matching between SpecObjAll and BEST.Photo*,
but doesn''t do anything with SpecObjAll.targetID or TARGET.Photo*.
<p>
SpecObjAll.bestObjID is set as described above.  To be slightly more
detailed about the case where there is no BEST.PhotoObj within 1", we go
through the modes (primary,secondary,family) in order looking for the nearest
BEST.PhotoObjAll within 1".
<p>
BEST.PhotoObjAll.specObjID only points to things in SpecObj (ie
SpecObjAll.sciencePrimary=1) because the mapping to non-sciencePrimary
SpecObjAlls is not unique.  You can still do BEST.PhotoObjAll.objID =
SpecObjAll.bestObjID to get all the matches.
<h3>SUMMARY</h3>
The matching of spectra to the BEST skyversion is done as a nearest object
search within 1" with a preference for primary objects.  There is no better
practical way of doing this - deblending differences cause huge numbers of
special cases that we probably could not even enumerate.
<p>
Ambiguities are not flagged.  There are no ambiguities if you start from
PhotoObj and go to SpecObj.  It might be possible for more than one
SpecObj to point to the same PhotoObj, but there are no examples of this
unless it is a pathological case.  It is possible for a SpecObj to point to
something in PhotoObjAll that is not in PhotoObj, but if you are joining with
PhotoObj you won''t see these.  If you start joining PhotoObjAll and SpecObjAll
you need to be quite careful because the mapping is (necessarily)
complicated.
' );
INSERT algorithm VALUES('spectrophotometry','Spectrophotometry','','<P>Because the SDSS spectra are obtained through 3-arcsecond fibers during
non-photometric observing conditions, special techniques must be employed to
spectrophotometrically calibrate the data. There have been three substantial
improvements to the algorithms which photometrically calibrate the spectra 
<ol>
 <li> improved matching of observed standard stars to models; </li>
 <li> tying the spectrophotometry directly to the observed fiber magnitudes
 from the photometric pipeline; and </li>
 <li> no longer using the "smear" exposures. </li>
</ol>
A separate <A
href="http://www.sdss.org/DR2/products/spectra/spectrophotometry.html">
spectrophotometric quality</A> page describes how we quantify these
improvements.</P>
<H2>Analysis of spectroscopic standard stars</H2> <P>On each spectroscopic
plate, 16 objects are targeted as spectroscopic standards. These objects are
color-selected to be F8 subdwarfs, similar in spectral type to the SDSS
primary standard BD+17 4708.</P> <IMG height=360 alt="standard star colors"
src="images/stdstar_colors.jpg" width=576> <P style="WIDTH: 600px; TEXT-ALIGN:
justify">The color selection of the SDSS standard stars. Red points represent
stars selected as spectroscopic standards. (Most are flux standards; the very
blue stars in the right hand plot are"hot standards"used for telluric
absorption correction.)</P> <P>The flux calibration of the spectra is handled
by the Spectro2d pipeline. It is performed separately for each of the 2
spectrographs, hence each half-plate<a href=''glossary.asp?key=plate''><img src=''images/glossary.gif'' border=0></a> has its own
calibration. In the EDR and DR1 Spectro2d calibration pipelines, fluxing was
achieved by <EM>assuming</EM> that the mean spectrum of the stars on each
half-plate was equivalent to a synthetic composite F8 subdwarf spectrum from
<A
href="http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=1998PASP..110..863P">Pickles
(1998)</A>. In the reductions included in DR2, the spectrum of each standard
star is spectrally typed by comparing with a grid of theoretical spectra
generated from Kurucz model atmospheres <A
href="http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=1992IAUS..149..225K">(Kurucz
1992)</A> using the spectral synthesis code SPECTRUM (<A
href="http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=1994AJ....107..742G">Gray
&amp; Corbally 1994</A>; <A
href="http://adsabs.harvard.edu/cgi-bin/nph-bib_query?bibcode=2001AJ....121.2159G">Gray,
Graham, &amp; Hoyt 2001</A>). The flux calibration vector is derived from the
average ratio of each star (after correcting for Galactic reddening) and its
best-fit model. Since the red and blue halves of the spectra are imaged onto
separate CCDs, separate red and blue flux calibration vectors are
produced. These will resemble the throughput curves under photometric
conditions. Finally, the red and blue halves of each spectrum on each exposure
are multiplied by the appropriate flux calibration vector. The spectra are
then combined with bad pixel rejection and rebinned to a constant
dispersion.</P> <IMG height=384 alt="throughput plot"
src="images/throughput.jpg" width=507> <P style="WIDTH: 530px; TEXT-ALIGN:
justify">Throughput curves for the red and blue channels on the two SDSS
spectrographs.</P> <H3>Note about galactic extinction correction</H3> <P>The
EDR and DR1 data nominally corrected for galactic extinction.  The
spectrophotometry in DR2 is vastly improved compared to DR1, but the final
calibrated DR2 spectra are <EM>not</EM> corrected for foreground Galactic
reddening (a relatively small effect; the median <VAR>E(B-V)</VAR> over the
survey is 0.034). This may be changed in future data releases. Users of
spectra should note, though, that the fractional improvement in
spectrophotometry is much greater than the extinction correction itself.</P>
<H2>Improved Comparison to Fiber Magnitudes</H2> <P>The second update in the
pipeline is relatively minor: We now compute the absolute calibration by tying
the <VAR>r</VAR>-band fluxes of the standard star spectra to the fiber
magnitudes output by the latest version of the photometric pipeline. The
latest version now corrects fiber magnitudes to a constant seeing of 2", and
includes the contribution of flux from overlapping objects in the fiber
aperture; these changes greatly improve the overall data consistency.</P>
<H2>Smears</H2> <P>The third update to the spectroscopic pipeline is that we
no longer use the "smear" observations in our calibration. As the EDR paper
describes, "smear" observations are low signal-to-noise ratio (S/N)
spectroscopic exposures made through an effective 5.5" by 9" aperture, aligned
with the parallactic angle. Smears were designed to account for object light
excluded from the 3" fiber due to seeing, atmospheric refraction and object
extent. However, extensive experiments comparing photometry and
spectrophotometry calibrated with and without smear observations have shown
that the smear correction provides improvements only for point sources (stars
and quasars) with very high S/N. For extended sources (galaxies) the spectrum
obtained in the 3" fiber aperture is calibrated to have the total flux and
spectral shape of the light in the smear aperture.  This is undesirable, for
example, if the fiber samples the bulge of a galaxy, but the smear aperture
includes much of its disk: For extended sources, the effect of the smears was
to give a systematic offset between spectroscopic and fiber magnitudes of up
to a magnitude; with the DR2 reductions, this trend is gone. Finally, smear
exposures were not carried out for one reason or another for roughly 1/3 of
the plates in DR2. For this reason, we do <EM>not</EM> apply the smear
correction to the data in DR2.</P> <P>To the extent that all point sources are
centered in the fibers in the same way as are the standards, our flux
calibration scheme corrects the spectra for losses due to atmospheric
refraction without the use of smears. Extended sources are likely to be
slightly over-corrected for atmospheric refraction. However, most galaxies are
quite centrally concentrated and more closely resemble point sources than
uniform extended sources. In the mean, this overcorrection makes the
<VAR>g-r</VAR> color of the galaxy spectra too red by ~1%.</P>
' );
INSERT algorithm VALUES('tiling','Tiling of spectroscopy plates','','<p>Tiling is the process by which the spectroscopic plates are designed
and placed relative to each other. This procedure involves optimizing
both the placement of fibers on individual
plates, as well as the placement of plates (or tiles) relative to each
other.
<p>
<ol><h2>
<li><a href="#intro">Introduction</a></li>
<li><a href="#setup">Spectroscopy Survey Overview</a></li>
<li><a href="#tiling">What is Tiling?</a></li>
<li><a href="#fiber_placement">Fiber Placement</a></li>
<li><a href="#collisions">Dealing with Fiber Collisions</a></li>
<li><a href="#tile_placement">Tile Placement</a></li>
<li><a href="#tech_details">Technical Details</a></li>
<a name="intro"></a>
</ol></h2>
<h2><u>Introduction</u></h2>
Because of large-scale structure in the galaxy distribution (which
form the bulk of the SDSS targets), a naive covering of the sky with
equally-spaced tiles does not yield uniform sampling. Thus, we present
a heuristic for perturbing the centers of the tiles from the
equally-spaced distribution to provide more uniform
completeness. For the SDSS sample, we can attain a sampling rate of
>92% for all targets, and >99% for the set of targets which do
not collide with each other, with an efficiency >90% (defined as
the fraction of available fibers assigned to targets).
<p>
Much of the content of this page can be found as a 
<a href="http://xxx.lanl.gov/abs/astro-ph/0105535"
target="new">  preprint on astro-ph</a>.
<a name="setup"></a>
<p>
<h2><u>The Spectroscopic Survey</u></h2>
The spectroscopic survey is performed using two multi-object fiber 
spectrographs on the same telescope. Each spectroscopic
 fiber plug plate, referred to as a "tile," has a circular field-of-view
with a radius of 1.49 degrees, and can accommodate 640 fibers, 48 of
which are reserved for observations of blank sky and
spectrophotometric standards.Because of the finite size of the fiber
plugs, the minimum separation of fiber centers is 55". If, for
example, two objects are within 55" of each other, both of them can
be observed only if they lie in the overlap between two adjacent
tiles. The goal of the SDSS is to observe 99% of the maximal set of
targets which has no such collisions (about 90% of all targets).
<a name="tiling"></a>
<p>
<h2><u>What is Tiling?</u></h2>
Around 2,000 tiles will be necessary to provide fibers for all the
targets in the survey. Since each tile which must be observed
contributes to the cost of the survey (due both to the cost of
production of the plate and to the cost of observing time), we desire
to minimize the number of tiles necessary to observe all the desired
targets. In order to maximize efficiency (defined as the fraction of
available fibers assigned to tiled targets) when placing these tiles
and assigning targets to each tile, we need to address two
problems. First, we must be able to determine, given a set of tile
centers, how to optimally assign targets to each tile --- that is, how
to maximize the number of targets which have fibers assigned to them.
Second, we must determine the most efficient placement of the tile
centers, which is non-trivial because the distribution of targets on
the sky is non-uniform, due to the well-known clustering of galaxies
on the sky. We find the exact solution to the first problem and use a
heuristic method developed by Lupton et al. (1998) to find an
approximate solution to the second problem (which is NP-complete).
The code which implements this solution is designed to run on a patch of sky
consisting of a set of rectangles in a spherical coordinate system,
known in SDSS parlance as a tiling region. 
<p><b>NOTE: the term "chunk" or "tiling chunk" is sometimes
used to denote a tiling region. To avoid confusion with the
correct use of the term chunk<a href=''glossary.asp?key=chunk''><img src=''images/glossary.gif'' border=0></a>, we use "tiling region" here.</b><p>
<a name="fiber_placement"></a>
<p>
<h2><u>Fiber Placement</u></h2>
First, we discuss the allocation of fibers given a set of tile
centers, ignoring fiber collisions for the moment. 
Figure 1 shows at the left a very simple example of a
distribution of targets and the positions of two tiles we want to use
to observe these targets. Given that for each tile there is a finite
number of available fibers, how do we decide which targets get
allocated to which tile?  This problem is equivalent to a network flow 
problem, which computer scientists have been kind enough to solve for us 
already.
<a name="fig1"></a>
<br>
<table  border=0 align="center">
<tr><td valign="center" width="45%"><img src="images/tiling_1a.gif"></td><td valign="center" width="45%"><img src="images/tiling_1b.gif"></td></tr>
<tr><td colspan="2" align="center"><h3>Figure 1: Simplified Tiling and Network Flow View</h3></td></tr>
</table>
<p>The basic idea is shown in the right half of Figure 1,
which shows the appropriate network for the situation in the left
half. Using this figure as reference, we here define some terms
which are standard in combinatorial literature and which will be
useful here:</p>
<ol>
<li><b>node</b>: The nodes are the solid dots in the figure; they 
provide either sources/sinks of objects for the flow or simply serve
as junctions for the flow. For example, in this context each target
and each tile corresponds to a node.</li>
<li><b>arc</b>: The arcs are the lines connecting the nodes. They
show the paths along which objects can flow from node to node.  In
Figure 1, it is understood that the flow along the arc
proceeds to the right. For example, the arcs traveling from target
nodes to tile nodes express which tiles each target may be assigned
to.</li>
<li><b>capacity</b>: The minimum and maximum capacity of each arc is
the minimum and maximum number of objects that can flow along it. For
example, because each tile can accommodate only 592 target fibers, the
capacities of the arcs traveling from the tile nodes to the sink node
is 592.</li>
<li><b>cost</b>: The cost per object along each arc is exacted for
allowing objects to flow down a particular arc; the total cost is the
summed cost of all the arcs. In this paper, the network is designed
such that the minimum total cost solution is the desired solution.</li>
</ol>
<p>Imagine a flow of 7 objects entering the network at
the source node at the left. We want the entire flow to leave
the network at the sink node at the right for the lowest possible
cost. The objects travel along the arcs, from node to node. Each
arc has a maximum capacity of objects which it can transport, as
labeled.  (One can also specify a <it>minimum</it> number, which will be
useful later). Each arc also has an associated cost, which is exacted
per object which is allowed to flow across that arc.  Arcs link the
source node to a set of nodes corresponding to the set of
targets. Each target node is linked by an arc to the node of each tile
it is covered by. Each tile node is linked to the sink node by an arc
whose capacity is equal to the number of fibers available on that
tile. None of these arcs has any associated cost. Finally, an
"overflow" arc links the source node directly to the sink node, for
targets which cannot be assigned to tiles. The overflow arc has
effectively infinite capacity; however, a cost is assigned to objects
flowing on the overflow arc, guaranteeing that the algorithm fails to
assign targets to tiles only when it absolutely has to.  This network
thus expresses all the possible fiber allocations as well as the
constraints on the numbers of fibers in each tile.  Finding the
minimum cost solution  then maximizes the number of targets
which are actually assigned to tiles.</p>
<a name="collisions"></a>
<p>
<h2><u>Dealing with Fiber Collisions</u></h2>
<p>As described above, there is a limit of 55" to how close two fibers
can be on the same tile. If there were no overlaps between tiles,
these collisions would make it impossible to observe ~10% of
the SDSS targets.  Because the tiles are circular, some fraction of
the sky will be covered with overlaps of tiles, allowing some of these
targets to be recovered.  In the presence of these collisions, the
best assignment of targets to the tiles must account for the presence
of collisions, and strive to resolve as many as possible of these
collisions which are in overlaps of tiles.  We approach this problem
in two steps, for reasons described below. First, we apply the network
flow algorithm of the <a href="#fiber_placement">above section</a> to the 
set of "decollided"
targets --- the largest possible subset of the targets which do not
collide with each other. Second, we use the remaining fibers and a
second network flow solution to optimally resolve collisions in
overlap regions.</p>
<p>
<a name="fig2"></a>
<br>
<table  border=0 align="center">
<tr><td align="center" width="90%"><img src="images/decollide_1.gif"></td></tr>
<tr><td align="center"><h3>Figure 2: Fiber Collisions</h3></td></tr>
</table>
<p>The "decollided" set of targets is the maximal subset of targets which
are all greater than 55" from each other.  To clarify what we mean by
this maximal set, consider Figure 2. Each circle represents a target;
the circle diameter is 55", meaning that overlapping circles are
targets which collide. The set of solid circles is the "decollided"
set. Thus, in the triple collision at the top, it is best to keep the
outside two rather than the middle one. </p>
<p>
This determination is complicated slightly by the fact that some
targets are assigned higher priority than others. For example, as
explained in the Targeting section<a href=''algorithm.asp?key=target''><img src=''images/algorithm.gif'' border=0></a>, QSOs are 
given higher priority than
galaxies by the SDSS target selection algorithms. What we mean here by
"priority" is that a higher priority target is guaranteed never to
be eliminated from the sample due to a collision with a lower priority
object. Thus, our true criterion for determining whether one set of
assignments of fibers to targets in a group is more favorable than
another is that a greater number of the highest priority objects are
assigned fibers. </p>
<p>
Once we have identified our set of decollided objects, we use the
network flow solution to find the best possible assignment of fibers
to that set of objects.</p> 
<p>
After allocating fibers to the set of decollided 
targets, there will
usually be unallocated fibers, which we want to use to resolve
fiber collisions in the overlaps. We can again express the problem of
how best to perform the collision resolution as a network, although
the problem is a bit more complicated in this case. In the case of
binaries and triples, we design a network flow problem such that the
network flow solution chooses the tile assignments optimally. In the
case of higher multiplicity groups, our simple method for binaries and
triples does not work and we instead resolve the fiber collisions in a
random fashion; however, fewer than 1% of targets are in such groups,
and the difference between the optimal choice of assignments and the
random choices made for these groups is only a small fraction of that.</p>
<p>
We refer the reader to the <a
href="http://xxx.lanl.gov/abs/astro-ph/0105535" target="new">tiling
algorithm paper</a> for more details, including how the fiber
collision network flow is designed and caveats about what
aspects of the method may need to be changed under different
circumstances.</p>
<a name="tile_placement"></a>
<p>
<h2><u>Tile Placement</u></h2>
<p>Once one understands how to assign fibers given a set of tile centers,
one can address the problem of how best to place those tile centers.
Our  method first distributes tiles
uniformly across the sky and then uses a cost-minimization scheme to
perturb the tiles to a more efficient solution.</p>
<p>
In most cases, we set initial conditions by simply laying down a
rectangle of tiles. To set the centers of the tiles along the long
direction of the rectangle, we count the number of targets along the
stripe covered by that tile. The first tile is put at the mean of the
positions of target 0 and target <em>N_t</em>, where <em>N_t</em>
is the number of fibers per tile (592 for the SDSS). The second tile
is put at the mean between target <em>N_t</em> and <em>2N_t</em>, and so on. 
The counting of targets along adjacent stripes is offset by about half a
tile diameter in order to provide more complete covering.</p>
<p>
The method is of perturbing this uniform distribution is iterative.
First, one allocates targets to the tiles, but instead of limiting a
target to the tiles within a tile radius, one allows a target to be
assigned to further tiles, but with a certain cost which increases
with distance (remember that the network flow accommodates the
assignment of costs to arcs). One uses exactly the same fiber
allocation procedure as above.
What this does is to give each tile some information about the
distribution of targets outside of it. Then, once one has assigned a
set of targets to each tile, one changes each tile position to that
which minimizes the cost of its set of targets.  Then, with the new
positions, 
one reruns the fiber
allocation, perturbs the tiles again, and so on. This method is guaranteed 
to converge to a minimum (though
not necessarily a global minimum), because the total cost must
decrease at each step.</p>
<p>
In practice, we also need to determine the appropriate number of tiles
to use. Thus, using a standard binary search, we repeatedly run the
cost-minimization to find the minimum number of tiles necessary to
satisfy the SDSS requirements, namely that we assign fibers to 99%
of the decollided targets.</p>
<p>
In order to test how well this algorithm works, we have applied it
both to simulated and real data.  These results are discussed in the
<a href="http://xxx.lanl.gov/abs/astro-ph/0105535" target="new">Tiling
paper</a>.</p>
<a name="tech_details"></a>
<p>
<h2><u>Technical Details</u></h2>
<p>There are a few technical details which may be useful to mention in
the context of SDSS data.  Most importantly, we will describe which
targets within the SDSS are "tiled" in the manner described here,
and how such targets are prioritized. Second, we will discuss the
method used by SDSS to deal with the fact that the imaging and
spectroscopy are performed within the same five-year time
period. Third, we will describe the tiling outputs which the SDSS
tracks as the survey progresses.  Throughout, we refer to the code
which implements the algorithm described above as <em>tiling</em>.</p>
<p>
Only some of the spectroscopic target types identified by the target
selection algorithms in the SDSS are "tiled." These types (and their
designations in the primary and secondary target bitmasks) are
described in the Targeting pages<a href=''algorithm.asp?key=target''><img src=''images/algorithm.gif'' border=0></a>). They consist
 of most types of QSOs, main sample galaxies,
LRGs, hot standard stars, and brown dwarfs. These are the types of
targets for which tiling is run and for which we are attempting to
create a well-defined sample. Once the code has guaranteed fibers to
all possible "tiled targets," remaining fibers are assigned to other
target types by a separate code.</p>
<p>
All of these target types are treated equivalently, except that they
assigned different "priorities," designated by an integer.  As
described above, the tiling code uses them to help decide fiber
collisions. The sense is that a higher priority object will never lose
a fiber in favor of a lower priority object.  The priorities are
assigned in a somewhat complicated way for reasons immaterial to
tiling, but the essence is the following: the highest priority objects
are brown dwarfs and hot standards, next come QSOs, and the lowest
priority objects are galaxies and LRGs. QSOs have higher priority than
galaxies because galaxies are higher density and have stronger angular
clustering. Thus, allowing galaxies to bump QSOs would allow
variations in galaxy density to imprint themselves into variations in
the density of QSOs assigned to fibers, which we would like to avoid.
For similar reasons, brown dwarfs and hot standard stars (which have
extremely low densities on the sky) are given highest priority.</p>
<p>
Each tile, as stated above, is 1.49 degrees in radius, and has
the capacity to handle 592 tiled targets. No two such targets may be
closer than 55" on the same tile.</p>
<a name="tiling_region"></a>
<p>
The operation of the SDSS makes it impossible to tile the entire
10,000 square degrees simultaneously, because we want to be able to
take spectroscopy during non-pristine nights, based on the imaging
which has been performed up to that point. In practice, periodically a
"tiling region" of data is processed, calibrated, has targets
selected, and is passed to the tiling code. During the first year of
the SDSS, about one tiling region per month has been created; as more
and more imaging is taken and more tiles are created, we hope to
decrease the frequency with which we need to make tiling regions, and
to increase their size.</p>
<p>
A tiling region is defined as a set of rectangles on the sky (defined in
survey
coordinates<a href=''glossary.asp?key=survey_coords''><img src=''images/glossary.gif'' border=0></a>).  All of these rectangles cover only sky which has
been imaged and processed. However, in the case of tiling,  targets
may be missed near the edges of a tiling region because that area
was not covered by tiles. Thus, tiling is actually run on a somewhat larger area than a single tiling region, so the areas near the edges of adjacent
tiling regions are also included. This larger area is known as a <it>tiling region</it>. Thus, in general, tiling regions overlap.</p>
<p>
The first tiling region which is "supported" by the SDSS is denoted
Tiling Region
4. The first tiling region for which the version of tiling described here was
run is Tiling Region 7. Tiling regions earlier than Tiling Region 7 used a different (less
efficient) method of handling fiber collisions. The earlier version
also had a bug which artificially created gaps in the distribution of
the fibers. The locations of the known gaps are given in <a
href="http://www.journals.uchicago.edu/AJ/journal/issues/v123n1/201415/201415.html"
target="new">the EDR paper</a> for Tiling Region 4 as the overlaps
between plates 270 and 271, plates 312 and 313, and plates 315 and 363
(also known as tiles 118 and 117, tiles 76 and 75, and tiles 73 and
74).</p>
<p>
<a name="tiling_window"></a>
<p>
<h2><u>Tiling Window</u></h2>
<P> In order to interpret the spectroscopic sample, one needs to use
the information about how targets were selected, how the tiles were
placed, and how fibers were assigned to targets. We refer to the
geometry defined by this information as the "tiling window" and
describe how to use it in detail elsewhere. As we note below, for the purposes of data release
users it is also important to understand what the photometric imaging
window which is released (including, if desired, masks for image
defects and bright stars) and which plates have been released.</p>
<br>
' );
INSERT algorithm VALUES('sector','Creating Sectors','','<h3> 
Alex Szalay, Gyorgy Fekete, Tamas Budavari, Jim Gray, Adrian Pope, Ani
Thakar </h3>
<h5>August 2003, revised March 2004,  December 2004, November 2005</h5>
<h5>The Problem</h5>
<p>
The SDSS spectroscopic survey will consist of about 2000 circular Tiles, each
about 1.5 deg. in radius, which contain the objects for a given spectroscopic
observation. There are more opportunities to target (get the spectrum of) an
object if it is covered by multiple tiles. If three tiles cover an area, the
objects in that area are three times more opportunity to be targeted. At the
same time, objects are not targeted uniformly over a plate.  The targeting is
driven by a program that uses the SDSS photographic observations to schedule
the spectroscopic observations.   These photographic observations are 2.5
deg. wide stripes across the sky. The strips overlap about 15%, so the sky is
partitioned into disjoint staves and the tiling is actually done in terms of
these staves (see Figure 1.) Staves are often misnamed stripes in the database
and in other SDSS documentation. 
<table width=340 align=left border=1>
   <tr><td><img src="images/sectorFig1.jpg" width="340"
   align="left"></img></td></tr>
   <tr><td class=smallbodytext><b>Figure 1.</b> Observations consist of overlapping <b><i>stripes</i></b>
   partitioned into disjoint <b><i>staves</i></b>. <b><i>Tiling</i></b><i>
   <b>Runs</b></i> work on a set of staves, and each <b><i>Tiling</i></b><i>
   <b>Geometry</b></i> region is contained within a stave. </td></tr>
</table>
<p>
Spectroscopic targeting is done by a tiling run that works with a collection
of staves - actually not whole staves but segments of them called chunks.  The
tiling run generates tiles that define which objects are going to be observed
(actually, which holes to drill in a SDSS spectroscopic plate.)  The tiling
run also generates a list of TilingGeometry rectangular regions that describe
the sections of the staves that were used to make the tiles. Some
TilingGeometry rectangles are positive, others are negative (masks or holes.)
Subsequent tiling runs may use the same staves (chunks) and so tiling runs are
not necessarily disjoint. So, TilingGeometries form rather complex
intersections that we call SkyBoxes. 
<p>
The goal is to compute contiguous sectors covered by some number of plates and
at least one positive TilingGeometry.  We also want to know how many plates
cover the sector. 
<p>
This is a surprisingly difficult task because there are subtle interactions.
We will develop the algorithm to compute sectors in steps.  First we will
ignore the TilingGeometry and just compute the wedges (Boolean combinations of
tiles).  Then we will build TilingBoxes, positive quadrilateral partitions of
each tiling region that cover the regions.  SkyBoxes are the synthesis of the
TilingBoxes from several tiling runs into a partitioning of the survey
footprint into disjoint quadrilaterals positive quadrilaterals.  Now, to
compute sectors, we simply intersect all wedges with all Skyboxes.  The
residue is the tile coverage of the survey.  A tile contributes to a sector if
the tile contributes to the wedge and the tile was created by one of the tile
runs that contain the SkyBox (you will probably understand that last sentence
better after you read to the end of this paper.)
<p>
<h5>Wedges</h5> 
<table width=200 align=left border=1>
   <tr><td><img src="images/sectorFig2.jpg" width=200></img></td></tr>
   <tr><td class=smallbodytext><b>Figure 2.</b> A <b><i>wedge</i></b> and
       <b><i>sector</i></b> covered by one plate. There are adjoining wedges
       covered by 2, 3, 4 plates.  The lower left corner is an area that is
       not part of any wedge or sector.  <b>SkyBoxes</b> break wedges into
       sectors and may mask parts of a wedge.<o:p></o:p></td>
   </tr>
</table>   
A wedge is the intersection of one or more tiles or the intersection of some
tiles with the complements of some others. Each wedge has a depth: the number
of positive tiles covering the wedge (see figures 2, 3). The two intersecting
tiles in figure 2, A and B, have (A-B) and (B-A) wedges of depth 1, and the
intersection (AB) is a depth 2 wedge.
<table width=200 align=right border=1>
   <tr><td><img src="images/sectorFig3.jpg" width=200></img></td></tr>
   <tr><td class=smallbodytext><b>Figure 3.</b> <b><i>Tile</i></b> A has a blue boundary;
       <b><i>tile</i></b> B has the red boundary, both regions of depth
       1. Their intersection is yellow, a Region of depth 2. The crescents
       shaded in blue and green are the two <b><i>wedges</i></b> of
       <b><i>depth</i></b> 1, and the yellow area is a <b><i>wedge</i></b> of
       <b><i>depth</i></b> 2. Nodes are purple dots.</td>
   </tr>
</table>
<p>   
A sector is a wedge modified by intersections with overlapping TilingGeometry
regions.  If the TilingGeometry regions are complex (multiple convexes) or if
they are holes (isMask=1), then the result of the intersection may also be
complex (a region of multiple wedges). By going to a SkyBox model we keep
things simple. Since SkyBoxes partition the sky into areas of known tile-run
depth, SkyBox boundaries do not add any depth to the sectors; they just
truncate them to fit in the box boundary and perhaps mask a tile if that tile
is in a TilingGeometry hole or if the tile that contributes to that wedge is
not part of the TilingGeometry (one of the tiling runs) that make up that
SkyBox (Figure 4 shows a simple example of these concepts). 
<table width=200 align=left border=1>
   <tr><td><img src="images/sectorFig4.jpg" width=200></img></td></tr>
   <tr><td class=smallbodytext><b>Figure 4.</b>This shows how the <b><i>tiles</i></b> and
       <b><i>TilingGeometry</i></b> rectangles intersect to form
       <b><i>sectors</i></b>.  On the figure we have a layout that has wedges
       of various depths, depth 1 is gray, depth 2 is light blue, depth 3 is
       yellow and depth 4 is magenta.  The wedges are clipped by the
       TilingGeometry boundary to form sectors.<o:p></o:p></td>
   </tr>
</table>
<p>
To get started, spCreateWedges() computes the wedge regions, placing them in
the Sectors table, and for each wedge W and each tile T that adds to or
subtracts from W, records the T->W in the Sectors2Tiles table (both positive
and negative parents).  So, in Figure 3, the green wedge (the leftmost wedge)
would have tile A as a positive parent and tile B as a negative parent.
<h5>Boxes </h5>
A particular tiling run works on a set of (contiguous) staves, and indeed only
a section of each stave called a chunk.  These areas are defined by disjoint
TilingRegions.  To complicate matters, some TilingRegions have rectangular
holes in it them that represent bad seeing (bright stars, cosmic rays or other
flaws).   So a tiling run looks something like Figure 5.   And each
TilingGeometry is spherical rectangle with spherical-rectangular holes (see
Figure 5.) 
<table width=400 align=left border=1>
   <tr><td><img src="images/sectorFig5.jpg" width=400></img></td></tr>
   <tr><td class=smallbodytext><b>Figure 5.</b><b><i>Staves</i></b> (convex sides not illustrated)
       are processed in <b><i>chunks. TilingGeometry</i></b> is a
       <b><i>chunk/stave</i></b>subset with <b><i>holes</i></b>
       (<b><i>masks</i></b>). <b><i>TilingBoxes</i></b> cover a
       <b><i>TilingGeometry</i></b>with disjoint spherical rectangles.  There
       are many such coverings, two are shown for TG1.  The one at left has 23
       <b><i>TileBoxes</i></b> while the one at right has 7
       <b><i>TileBoxes</i></b></td>
   </tr>
</table>
To simplify matters, we want to avoid the holes and work only with simple
convex regions.  So we decompose each TileGeometry to a disjoint set of
TileBoxes.  As Figure 5 shows, there are many different TileBox
decompositions.  We want a TileBox decomposition with very few
TileBoxes. Fewer is better - but the answer will be the same in the end since
we will merge adjacent sectors if they have the same depth.
<p>
It is not immediately obvious how to construct the TileBoxes.  Figure 6 gives
some idea. 
<p>
First, the whole operation of subtracting out the masks happens inside the
larger TilingGeometry, called the Universe, U.   We are going to construct
nibbles which are a disjunctive normal form of the blue area with at least one
negative hole edge to make sure we exclude the hole.   These nibbles are
disjoint and cover the TileGeometry and exclude the mask (white) area. 
<p>
As described in "There Goes the Neighborhood: Relational Algebra for Spatial
Data Search" we represent spherical polygons as a set of half-space
constraints of the form  h = (hx,hy,hz,c).   Point p = (px,py,pz) is inside
the halfspace if hx*px+hy*py+hz*pz>c.  A convex region, C ={hi} is the set of
points inside each of the hi.
<p>
Given that representation we can compute the set N of nibbles covering region
R = U-C as follows: 
<p>
Compute R = N = U - C where U and C are convex regions (C is the "hole" in U)
the idea is
<pre>
R 	= {ui} - {ci}
= U &{~c1} | U&{~c2} | ...| U&{~cm}
= U&~c1 | U&c1&~c2 | ... | U&c1&c2&...&cm-1&~cm 
The terms in the last equation are called nibbles.  
They are disjoint (look at the terms if each term has a unique ~ci)
and together they cover R and exclude C (each ~ci excludes C). 
</pre>
<h5>Algorithm:</h5>
<pre>  
   R= {}			-- the disjoint regions will be added to R.
   NewU = spRegionCopy U  	-- make a copy of U so we do not destroy it
   for each c in C	  	-- for each constraint in c that is an arc 
				--   of the hull 
       Nibble = NewU &{ ~c }	-- intersect Not c with the current universe
       if Nibble not empty	-- if Not c intersects universe then 
          add Nibble to R	-- Add  this Nibble to answer set
          NewU = NewU & {c}    	-- Not c is covered, so reduce the universe 
When each positive TilingGeometry is "nibbled" by its masks, the resulting
nibbles are the TileBoxes we need. 
</pre>
<p>
The procedure spCreateTileBoxes creates, for each TilingGeometry, a set of
TilingBox regions that cover it. That procedure also records in Region2Boxes a
mapping of TilingGeometry-> TileBox so that we can tell which TilingGeometry
region covers a box.
<p>
SkyBoxes are the unification of all TileBoxes into a partitioning of the
entire sky.  Logically, SkyBboxes are the Boolean combination of all the
TileBoxes - somewhat analogous to the relationship between wedges and tiles.
A SkyBoxes may be covered by multiple TilingGeometries (and have corresponding
tiling runs); Region2Boxes records this mapping of TilingGeometry -> TileBox.
Figure 7 illustrates how SkyBoxes are computed and how the TilingGeometry
relationship is maintained. 
<table width=300 align=left border=1>
   <tr><td><img src="images/sectorFig7.jpg" width=300></img></td></tr>
   <tr><td class=smallbodytext><b>Figure 7.</b> <b><i>SkyBoxes</i></b> are the intersection of
       <b><i>TileBoxes</i></b>.  A pair can produce up to 7
       <b><i>SkyBoxes</i></b>.  The green areas are covered by the union of
       the <b><i>tiling runs</i></b> of the two <b><i>TileBoxes</i></b> and
       the other <b>SkyBoxes</b> are covered by the <b>Tiling Runs</b> of
       their one parent box.<o:p></o:p>
</td></tr>
</table>
<p>
spCreateSkyBoxes builds all the SkyBoxes and records the dependencies.
spCreateSkyBoxes uses the logic of spRegionQuradangleFourOtherBoxes to create
the SkyBoxes from the intersections of TileBoxes. 
<h5>From Wedges and SkyBoxes to Sectorlets to Sectors</h5>
We really want the sectors, but it is easier to first compute wedges and
SkyBoxes and then build the sectors from them.  Recall that:
<dd>	Wedge: a Boolean combination of tiles. 
<dd>	Skybox: a convex region of the survey covered by certain TilingRuns.
So, the sectors are just 
<dd>	Wedge ( Skybox.
<p>
This is may be fine a partition - but two adjacent sectors computed in this
way might have the same list of covering TileGeometry and Tiles in which case
they should be unified into one sector. So, this first Wedge-SkyBox partition
is called sectorlets. These sectorlets need to be unified into sectors if they
have the same covering tiles.  This unification gives us a unique answer
(remember that Figure 5 showed many different TileBox partitions, this final
step eliminates any "fake" partitions introduced by that step).   
<p>
Sectorlets are computed as follows: Given a wedge W and a SkyBox SB, the area
is just W ( SB. If that area is non-empty then we need to compute the list of
covering tileGeometry and tiles.  The TilingGeometries come from SB.   The
tiles are a bit more complex. Let T be the set of tiles covering W.  Discard
from T any tile not created by a tiling run covering SB.    In mathematical
notation: 
<dd>	T(sectorlet) = { T e T(wedge) | ( TileRun TR covering SB and TR generated T} <br>
T(sectorlet) is the tile list for the sectorlet W ( SB.  This logic is
embodied in the procedure spSectorCreateSectorlets (note that wedges have
positive and negative tiles).
<p>
But, a particular tile or set of tiles can create many sectorlets.   We want
the sector to be all the adjacent sectorlets with the same list of parent
tiles (note that sectorlets have positive (covering) and negative (excluded)
parents that make up the sector).
<table width=400 align=right border=1>
   <tr><td><img src="images/sectorFig8.jpg" width=400></td></tr>
   <tr><td class=smallbodytext><b>Figure 8.</b>This diagram shows some SDSS data and demonstrates
       the concepts of <b><i>Tile</i></b>, <b><i>Mask</i></b>,
       <b><i>TileBox</i></b>, <b><i>TilingGeometry</i></b>,
       <b><i>SkyBox</i></b>, <b><i>Wedge</i></b>, <b><i>Sectorlet</i></b>,
       and <b><i>Sector</i></b>. </td>
   </tr>
</table>
<p>
The routine spSectorCreateSectors unifies all the sectorlets with the same
list of parent tiles into one region.  This region may not be connected (masks
or tiling geometry may break it into pieces which we then glued back together
- see the example of 5 sectorlets creating one sector in Figure 8.) 
<p>
All these routines are driven by the parent spSectorCreate routine. 
' );

GO
----------------------------- 
PRINT '6 lines inserted into algorithm'
----------------------------- 

