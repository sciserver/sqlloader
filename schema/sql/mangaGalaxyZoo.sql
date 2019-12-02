CREATE TABLE mangaGalaxyZoo (
------------------------------------------------------------------------------
--/H Galaxy Zoo classifications for all MaNGA target galaxies
--/T This tables contains one entry per MaNGA target galaxy.
--/T The Galaxy Zoo (GZ) data for SDSS galaxies has been split 
--/T over several iterations of the website, with the MaNGA target 
--/T galaxies being spread over 5 different GZ data sets. In this 
--/T value added catalog we bring all of these galaxies into one single 
--/T catalog and re-run the debiasing code (Hart 2016) in a consistent 
--/T manner across the all the galaxies. This catalog includes data from
--/T Galaxy Zoo 2 (previously published) and newer data from 
--/T Galaxy Zoo 4 (currently unpublished).
--/T 2019-07-30  Ani: Changed all non-coord floats to reals, increased the
--/T                  varchar lengths, and added commas after each line and 
--/T                  a closing parenthesis.
--/T 2019-07-31  Ani: Changed nsa_id to int from bigint, IFUDESIGNSIZE to 
--/T                  int from real after confirmation from K Masters.
--/T                  Also chamged MANGA_TILEID to int from real.
------------------------------------------------------------------------------
nsa_id								int NOT NULL,		--/D NASA Sloan Atlas ID
IAUNAME	        					       	varchar(32) NOT NULL,		--/D IAU name
IFUDESIGNSIZE						        int NOT NULL,		--/D Design size for the IFU
IFU_DEC	        						float NOT NULL,		--/U degrees	--/D DEC of the IFU
IFU_RA	        					        float NOT NULL,		--/U degrees	--/D RA of the IFU
MANGAID	        						varchar(16) NOT NULL,		--D/ MaNGA ID
MANGA_TILEID						 	int NOT NULL,		--/D MaNGA tile ID
OBJECT_DEC						        float NOT NULL,		--/U degrees	--/D DEC of the galaxy
OBJECT_RA						        float NOT NULL,		--/U degrees	--/D RA of the galaxy
survey	        					        varchar(128) NOT NULL,		--/D The Galaxy Zoo data set(s) the galaxy was part of (comma seperated)
t01_smooth_or_features_a01_smooth_count			        real NOT NULL,		--/D Raw GZ vote count
t01_smooth_or_features_a01_smooth_count_fraction	        real NOT NULL,		--/D Raw GZ vote fraction
t01_smooth_or_features_a01_smooth_debiased		        real NOT NULL,		--/D Debiased GZ vote fraction
t01_smooth_or_features_a01_smooth_weight		        real NOT NULL,		--/D User weighted vote count
t01_smooth_or_features_a01_smooth_weight_fraction	        real NOT NULL,		--/D User weighted vote fraction
t01_smooth_or_features_a02_features_or_disk_count	        real NOT NULL,		--/D Raw GZ vote count
t01_smooth_or_features_a02_features_or_disk_count_fraction	real NOT NULL,		--/D Raw GZ vote fraction
t01_smooth_or_features_a02_features_or_disk_debiased		real NOT NULL,		--/D Debiased GZ vote fraction
t01_smooth_or_features_a02_features_or_disk_weight	        real NOT NULL,		--/D User weighted vote count
t01_smooth_or_features_a02_features_or_disk_weight_fraction	real NOT NULL,		--/D User weighted vote fraction
t01_smooth_or_features_a03_star_or_artifact_count		real NOT NULL,		--/D Raw GZ vote count for
t01_smooth_or_features_a03_star_or_artifact_count_fraction	real NOT NULL,		--/D Raw GZ vote fraction
t01_smooth_or_features_a03_star_or_artifact_debiased		real NOT NULL,		--/D Debiased GZ vote fraction
t01_smooth_or_features_a03_star_or_artifact_weight	        real NOT NULL,		--/D User weighted vote count
t01_smooth_or_features_a03_star_or_artifact_weight_fraction	real NOT NULL,		--/D User weighted vote fraction
t01_smooth_or_features_count					real NOT NULL,		--/D The raw number of GZ votes for task 1
t01_smooth_or_features_weight					real NOT NULL,		--/D The user weighted number of GZ votes for task 1
t02_edgeon_a04_yes_count					real NOT NULL,		--/D Raw GZ vote count
t02_edgeon_a04_yes_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t02_edgeon_a04_yes_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t02_edgeon_a04_yes_weight					real NOT NULL,		--/D User weighted vote count
t02_edgeon_a04_yes_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t02_edgeon_a05_no_count						real NOT NULL,		--/D Raw GZ vote count
t02_edgeon_a05_no_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t02_edgeon_a05_no_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t02_edgeon_a05_no_weight					real NOT NULL,		--/D User weighted vote count
t02_edgeon_a05_no_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t02_edgeon_count						real NOT NULL,		--/D The raw number of GZ votes for task 2
t02_edgeon_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 2
t03_bar_a06_bar_count						real NOT NULL,		--/D Raw GZ vote count
t03_bar_a06_bar_count_fraction					real NOT NULL,		--/D Raw GZ vote fraction
t03_bar_a06_bar_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t03_bar_a06_bar_weight						real NOT NULL,		--/D User weighted vote count
t03_bar_a06_bar_weight_fraction					real NOT NULL,		--/D User weighted vote fraction
t03_bar_a07_no_bar_count					real NOT NULL,		--/D Raw GZ vote count
t03_bar_a07_no_bar_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t03_bar_a07_no_bar_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t03_bar_a07_no_bar_weight					real NOT NULL,		--/D User weighted vote count
t03_bar_a07_no_bar_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t03_bar_count							real NOT NULL,		--/D The raw number of GZ votes for task 3
t03_bar_weight							real NOT NULL,		--/D The user weighted number of GZ votes for task 3
t04_spiral_a08_spiral_count					real NOT NULL,		--/D Raw GZ vote count
t04_spiral_a08_spiral_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t04_spiral_a08_spiral_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t04_spiral_a08_spiral_weight					real NOT NULL,		--/D User weighted vote count
t04_spiral_a08_spiral_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t04_spiral_a09_no_spiral_count					real NOT NULL,		--/D Raw GZ vote count
t04_spiral_a09_no_spiral_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t04_spiral_a09_no_spiral_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t04_spiral_a09_no_spiral_weight					real NOT NULL,		--/D User weighted vote count
t04_spiral_a09_no_spiral_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t04_spiral_count						real NOT NULL,		--/D The raw number of GZ votes for task 4
t04_spiral_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 4
t05_bulge_prominence_a10_no_bulge_count				real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a10_no_bulge_count_fraction		real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a10_no_bulge_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a10_no_bulge_weight			real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a10_no_bulge_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_a11_just_noticeable_count			real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a11_just_noticeable_count_fraction		real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a11_just_noticeable_debiased		real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a11_just_noticeable_weight			real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a11_just_noticeable_weight_fraction	real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_a12_obvious_count				real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a12_obvious_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a12_obvious_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a12_obvious_weight				real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a12_obvious_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_a13_dominant_count				real NOT NULL,		--/D Raw GZ vote count
t05_bulge_prominence_a13_dominant_count_fraction		real NOT NULL,		--/D Raw GZ vote fraction
t05_bulge_prominence_a13_dominant_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t05_bulge_prominence_a13_dominant_weight			real NOT NULL,		--/D User weighted vote count
t05_bulge_prominence_a13_dominant_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t05_bulge_prominence_count					real NOT NULL,		--/D The raw number of GZ votes for task 5
t05_bulge_prominence_weight					real NOT NULL,	  	--/D The user weighted number of GZ votes for task 5
t06_odd_a14_yes_count						real NOT NULL,		--/D Raw GZ vote count
t06_odd_a14_yes_count_fraction					real NOT NULL,		--/D Raw GZ vote fraction
t06_odd_a14_yes_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t06_odd_a14_yes_weight						real NOT NULL,		--/D User weighted vote count
t06_odd_a14_yes_weight_fraction					real NOT NULL,		--/D User weighted vote fraction
t06_odd_a15_no_count						real NOT NULL,		--/D Raw GZ vote count
t06_odd_a15_no_count_fraction					real NOT NULL,		--/D Raw GZ vote fraction
t06_odd_a15_no_debiased						real NOT NULL,		--/D Debiased GZ vote fraction
t06_odd_a15_no_weight						real NOT NULL,		--/D User weighted vote count
t06_odd_a15_no_weight_fraction					real NOT NULL,		--/D User weighted vote fraction
t06_odd_count							real NOT NULL,		--/D The raw number of GZ votes for task 6
t06_odd_weight							real NOT NULL,		--/D The user weighted number of GZ votes for task 6
t07_rounded_a16_completely_round_count				real NOT NULL,		--/D Raw GZ vote count
t07_rounded_a16_completely_round_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t07_rounded_a16_completely_round_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t07_rounded_a16_completely_round_weight				real NOT NULL,		--/D User weighted vote count
t07_rounded_a16_completely_round_weight_fraction		real NOT NULL,		--/D User weighted vote fraction
t07_rounded_a17_in_between_count				real NOT NULL,		--/D Raw GZ vote count
t07_rounded_a17_in_between_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t07_rounded_a17_in_between_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t07_rounded_a17_in_between_weight				real NOT NULL,		--/D User weighted vote count
t07_rounded_a17_in_between_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t07_rounded_a18_cigar_shaped_count				real NOT NULL,		--/D Raw GZ vote count
t07_rounded_a18_cigar_shaped_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t07_rounded_a18_cigar_shaped_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t07_rounded_a18_cigar_shaped_weight				real NOT NULL,		--/D User weighted vote count
t07_rounded_a18_cigar_shaped_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t07_rounded_count						real NOT NULL,		--/D The raw number of GZ votes for task 7
t07_rounded_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 7
t09_bulge_shape_a25_rounded_count				real NOT NULL,		--/D Raw GZ vote count
t09_bulge_shape_a25_rounded_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t09_bulge_shape_a25_rounded_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t09_bulge_shape_a25_rounded_weight				real NOT NULL,		--/D User weighted vote count
t09_bulge_shape_a25_rounded_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t09_bulge_shape_a26_boxy_count					real NOT NULL,		--/D Raw GZ vote count
t09_bulge_shape_a26_boxy_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t09_bulge_shape_a26_boxy_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t09_bulge_shape_a26_boxy_weight					real NOT NULL,		--/D User weighted vote count
t09_bulge_shape_a26_boxy_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t09_bulge_shape_a27_no_bulge_count				real NOT NULL,		--/D Raw GZ vote count
t09_bulge_shape_a27_no_bulge_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t09_bulge_shape_a27_no_bulge_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t09_bulge_shape_a27_no_bulge_weight				real NOT NULL,		--/D User weighted vote count
t09_bulge_shape_a27_no_bulge_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t09_bulge_shape_count						real NOT NULL,		--/D The raw number of GZ votes for task 9
t09_bulge_shape_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 9
t10_arms_winding_a28_tight_count				real NOT NULL,		--/D Raw GZ vote count
t10_arms_winding_a28_tight_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t10_arms_winding_a28_tight_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t10_arms_winding_a28_tight_weight				real NOT NULL,		--/D User weighted vote count
t10_arms_winding_a28_tight_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t10_arms_winding_a29_medium_count				real NOT NULL,		--/D Raw GZ vote count
t10_arms_winding_a29_medium_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t10_arms_winding_a29_medium_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t10_arms_winding_a29_medium_weight				real NOT NULL,		--/D User weighted vote count
t10_arms_winding_a29_medium_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t10_arms_winding_a30_loose_count				real NOT NULL,		--/D Raw GZ vote count
t10_arms_winding_a30_loose_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t10_arms_winding_a30_loose_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t10_arms_winding_a30_loose_weight				real NOT NULL,		--/D User weighted vote count
t10_arms_winding_a30_loose_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t10_arms_winding_count						real NOT NULL,		--/D The raw number of GZ votes for task 10
t10_arms_winding_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 10
t11_arms_number_a31_1_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a31_1_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a31_1_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a31_1_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a31_1_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a32_2_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a32_2_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a32_2_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a32_2_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a32_2_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a33_3_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a33_3_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a33_3_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a33_3_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a33_3_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a34_4_count					real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a34_4_count_fraction				real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a34_4_debiased					real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a34_4_weight					real NOT NULL,		--/D User weighted vote count
t11_arms_number_a34_4_weight_fraction				real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a36_more_than_4_count				real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a36_more_than_4_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a36_more_than_4_debiased			real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a36_more_than_4_weight				real NOT NULL,		--/D User weighted vote count
t11_arms_number_a36_more_than_4_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_a37_cant_tell_count				real NOT NULL,		--/D Raw GZ vote count
t11_arms_number_a37_cant_tell_count_fraction			real NOT NULL,		--/D Raw GZ vote fraction
t11_arms_number_a37_cant_tell_debiased				real NOT NULL,		--/D Debiased GZ vote fraction
t11_arms_number_a37_cant_tell_weight				real NOT NULL,		--/D User weighted vote count
t11_arms_number_a37_cant_tell_weight_fraction			real NOT NULL,		--/D User weighted vote fraction
t11_arms_number_count						real NOT NULL,		--/D The raw number of GZ votes for task 11
t11_arms_number_weight						real NOT NULL,		--/D The user weighted number of GZ votes for task 11
)
GO


