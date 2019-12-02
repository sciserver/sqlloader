CREATE TABLE PawlikMorph (
-----------------------------------------
--/H Morphological parameters for all galaxies in MaNGA DR15
--/T This table provides the CAS, gini, M20, shape asymmetry, curve of growth radii, sersic fits and associated parameters measured from SDSS DR7 imaging using the 8-connected structure detection algorithm to define the edges of the galaxies presented in Pawlik et al. (2016, MNRAS, 456, 3032) for all galaxies in MaNGA DR15. This is the original implementation of the Shape Asymmetry algorithm. 
-----------------------------------------
mangaID       varchar(16)  NOT NULL, --/U			--/D MaNGA ID string	
plateifu      varchar(32)  NOT NULL, --/U			--/D String combination of PLATE-IFU to ease searching
run	      smallint NOT NULL, --/U			--/D Run number
rerun	      smallint NOT NULL, --/U			--/D Rerun number
camcol	      tinyint  NOT NULL, --/U			--/D Camera column
field	      smallint NOT NULL, --/U			--/D Field number
imgsize       smallint NOT NULL, --/U pixels		--/D image size
imgmin	      real     NOT NULL, --/U counts		--/D minimum pixel value in the image
imgmax 	      real     NOT NULL, --/U counts    	--/D maximum pixel value in the image
skybgr	      real     NOT NULL, --/U counts/pixel 	--/D sky background estimate 
skybgrerr     real     NOT NULL, --/U counts/pixel 	--/D standard deviation in the sky background
skybgrflag    smallint  NOT NULL, --/U 			--/D flag indicating unreliable measurement of the sky background (0 if everything is OK)
bpixx	      smallint NOT NULL, --/U pixels		--/D  x position of the brightest pixel
bpixy	      smallint NOT NULL, --/U pixels		--/D  y position of the brightest pixel
apixx	      smallint NOT NULL, --/U pixels		--/D  x position yielding minimum value of the rotational light-weighted asymmetry parameter
apixy	      smallint NOT NULL, --/U pixels		--/D  y position yielding minimum value of the rotational light-weighted asymmetry parameter
mpixx	      smallint NOT NULL, --/U pixels		--/D  x position yielding minimum value of the second order moment of light
mpixy	      smallint NOT NULL, --/U pixels		--/D  y position yielding minimum value of the second order moment of light
rmax	      real     NOT NULL, --/U pixels		--/D  the `maximum’ radius of the galaxy, defined as the distance between the furthest pixel in the object’s pixel map, with respect to the central brightest pixel
r20 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 20% of the total flux
r50 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 50% of the total flux
r80 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 80% of the total flux
r90 	      real     NOT NULL, --/U pixels		--/D  curve of growth radii defining a circular aperture that contains 90% of the total flux
C2080 	      real     NOT NULL, --/U 			--/D  the concentration index defined by the logarithmic ratio of  r20 and r80
C5090 	      real     NOT NULL, --/U 			--/D  the concentration index defined by the logarithmic ratio of  r50 and r90
A 	      real     NOT NULL, --/U 			--/D  the asymmetry of light under image rotation about 180 degrees around [apixx,apixy] (background corrected)
Abgr 	      real     NOT NULL, --/U 			--/D  the `background’ asymmetry associated with A
[As]  	      real     NOT NULL, --/U 			--/D  the shape asymmetry under image rotation about 180 degrees around [apixx,apixy]
As90  	      real     NOT NULL, --/U 			--/D  the shape asymmetry under image rotation about 90 degrees around [apixx,apixy]
S 	      real     NOT NULL, --/U 			--/D  the `clumpiness’ of the light distribution (background corrected)
Sbgr 	      real     NOT NULL, --/U 			--/D  the `background’ clumpiness associated with S
G 	      real     NOT NULL, --/U 			--/D  the Gini index
M20 	      real     NOT NULL, --/U 			--/D  the second-order moment of the brightest 20% of the total light
mag 	      real     NOT NULL, --/U mag		--/D  total magnitude within the boundaries of the pixel map
magerr        real     NOT NULL, --/U mag		--/D  the error associated with mag
sb0 	      real     NOT NULL, --/U counts		--/D  Sersic model’s best-fit parameter: the central surface brightness
sb0err        real     NOT NULL, --/U counts		--/D  error associated with sb0
reff 	      real     NOT NULL, --/U pixels		--/D  Sersic model’s best-fit parameter: the effective radius
refferr       real     NOT NULL, --/U pixels		--/D  error associated with reff
n 	      real     NOT NULL, --/U 			--/D  Sersic model’s best-fit parameter: the Sersic index
nerr 	      real     NOT NULL, --/U 			--/D  error associated with n
warningflag   smallint  NOT NULL, --/U 			--/D  flag indicating unreliable measurement (0 if everything is OK)
)
