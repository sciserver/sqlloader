--======================================================================
--   GalaxyZoo2Tables.sql
--   2013-06-13 Ani Thakar
------------------------------------------------------------------------
--  Galaxy Zoo 2 schema for SkyServer  June-13-2013
------------------------------------------------------------------------
--  History:
--* 2013-06-14 Ani: Fixed error in "sample" column definitions.
------------------------------------------------------------------------

SET NOCOUNT ON;
GO



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zoo2MainPhotoz')
	DROP TABLE zoo2MainPhotoz
GO
--
EXEC spSetDefaultFileGroup 'zoo2MainPhotoz'
GO
CREATE TABLE zoo2MainPhotoz (
-------------------------------------------------------------------------------
--/H Description: Morphological classifications of main-sample galaxies
--/H with photometric redshifts only from Galaxy Zoo 2
-------------------------------------------------------------------------------
--/T This table includes galaxies without spectra in SDSS Data Release 7.
--/T Several columns give data that can be used to cross-match rows with
--/T other SDSS tables, including objIDs and positions of the galaxies.
--/T Morphological classifications include six parameters for each category:
--/T unweighted and weighted versions of both the total number of votes and
--/T the vote fraction for that response, the vote fraction after being
--/T debiased, and flags for systems identified as being in clean samples.
--/T 
--/T Reference:  The project and data release are described in Willett et al.
--/T (2013, in prep). Please cite this paper if making use of any data in
--/T this table in publications.
-------------------------------------------------------------------------------
	dr8objid	bigint NOT NULL,	--/D match to the DR8 objID
	dr7objid	bigint NOT NULL,	--/D match to the DR7 objID
	ra	real NOT NULL,	--/D right ascension [J2000.0], decimal degrees
	dec	real NOT NULL,	--/D declination [J2000.0], decimal degrees
	rastring	varchar(16) NOT NULL,	--/D right ascension [J2000.0], sexagesimal
	decstring	varchar(16) NOT NULL,	--/D declination [J2000.0], sexagesimal
	sample	varchar(32) NOT NULL,	--/D sub-sample identification
	total_classifications	int NOT NULL,	--/D total number of classifications for this galaxy
	total_votes	int NOT NULL,	--/D total number of votes for each response, summed over all classifications
	t01_smooth_or_features_a01_smooth_count	int NOT NULL,	--/D number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_fraction	float NOT NULL,	--/D fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_flag	int NOT NULL,	--/D flag for "smooth" - 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a02_features_or_disk_count	int NOT NULL,	--/D number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_fraction	float NOT NULL,	--/D fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_debiased	float NOT NULL,	--/D debiased fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_flag	int NOT NULL,	--/D flag for "features or disk"	- 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a03_star_or_artifact_count	int NOT NULL,	--/D number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_fraction	float NOT NULL,	--/D fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_debiased	float NOT NULL,	--/D debiased fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_flag	int NOT NULL,	--/D flag for "star or artifact"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a04_yes_count	int NOT NULL,	--/D number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_fraction	float NOT NULL,	--/D fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_flag	int NOT NULL,	--/D flag for "edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a05_no_count	int NOT NULL,	--/D number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_fraction	float NOT NULL,	--/D fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_flag	int NOT NULL,	--/D flag for "not edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a06_bar_count	int NOT NULL,	--/D number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_fraction	float NOT NULL,	--/D fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_flag	int NOT NULL,	--/D flag for "bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a07_no_bar_count	int NOT NULL,	--/D number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_fraction	float NOT NULL,	--/D fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_flag	int NOT NULL,	--/D flag for "no bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a08_spiral_count	int NOT NULL,	--/D number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_fraction	float NOT NULL,	--/D fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_flag	int NOT NULL,	--/D flag for "spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a09_no_spiral_count	int NOT NULL,	--/D number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_fraction	float NOT NULL,	--/D fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_flag	int NOT NULL,	--/D flag for "no spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a10_no_bulge_count	int NOT NULL,	--/D number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_flag	int NOT NULL,	--/D flag for "no bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a11_just_noticeable_count	int NOT NULL,	--/D number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_fraction	float NOT NULL,	--/D fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_debiased	float NOT NULL,	--/D debiased fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_flag	int NOT NULL,	--/D flag for "just noticeable bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a12_obvious_count	int NOT NULL,	--/D number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_fraction	float NOT NULL,	--/D fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_debiased	float NOT NULL,	--/D debiased fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_flag	int NOT NULL,	--/D flag for "obvious bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a13_dominant_count	int NOT NULL,	--/D number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_fraction	float NOT NULL,	--/D fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_debiased	float NOT NULL,	--/D debiased fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_flag	int NOT NULL,	--/D flag for "dominant bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a14_yes_count	int NOT NULL,	--/D number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_fraction	float NOT NULL,	--/D fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_flag	int NOT NULL,	--/D flag for "something odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a15_no_count	int NOT NULL,	--/D number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_fraction	float NOT NULL,	--/D fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_flag	int NOT NULL,	--/D flag for "nothing odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a16_completely_round_count	int NOT NULL,	--/D number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_fraction	float NOT NULL,	--/D fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_flag	int NOT NULL,	--/D flag for "smooth and completely round"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a17_in_between_count	int NOT NULL,	--/D number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_fraction	float NOT NULL,	--/D fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_flag	int NOT NULL,	--/D flag for "smooth and in-between roundness"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a18_cigar_shaped_count	int NOT NULL,	--/D number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_fraction	float NOT NULL,	--/D fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_flag	int NOT NULL,	--/D flag for "smooth and cigar-shaped"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a19_ring_count	int NOT NULL,	--/D number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_flag	int NOT NULL,	--/D flag for "odd feature is a ring"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a20_lens_or_arc_count	int NOT NULL,	--/D number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_flag	int NOT NULL,	--/D flag for "odd feature is a lens or arc"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a21_disturbed_count	int NOT NULL,	--/D number of votes for the "odd feature is a disturbed" galaxy response to Task 08
	t08_odd_feature_a21_disturbed_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a disturbed galaxy response to Task 08
	t08_odd_feature_a21_disturbed_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a disturbed galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_flag	int NOT NULL,	--/D flag for "odd feature is a disturbed galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a22_irregular_count	int NOT NULL,	--/D number of votes for the "odd feature is an irregular" galaxy response to Task 08
	t08_odd_feature_a22_irregular_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is an irregular galaxy response to Task 08
	t08_odd_feature_a22_irregular_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is an irregular galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_flag	int NOT NULL,	--/D flag for "odd feature is an irregular galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a23_other_count	int NOT NULL,	--/D number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_flag	int NOT NULL,	--/D flag for "odd feature is something else"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a24_merger_count	int NOT NULL,	--/D number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_flag	int NOT NULL,	--/D flag for "odd feature is a merger"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a38_dust_lane_count	int NOT NULL,	--/D number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_flag	int NOT NULL,	--/D flag for "odd feature is a dust lane"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a25_rounded_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_flag	int NOT NULL,	--/D flag for "edge-on bulge is rounded"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a26_boxy_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_flag	int NOT NULL,	--/D flag for "edge-on bulge is boxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a27_no_bulge_count	int NOT NULL,	--/D number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_flag	int NOT NULL,	--/D flag for "no edge-on bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a28_tight_count	int NOT NULL,	--/D number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_fraction	float NOT NULL,	--/D fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_debiased	float NOT NULL,	--/D debiased fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_flag	int NOT NULL,	--/D flag for "tightly wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a29_medium_count	int NOT NULL,	--/D number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_fraction	float NOT NULL,	--/D fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_debiased	float NOT NULL,	--/D debiased fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_flag	int NOT NULL,	--/D flag for "medium wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a30_loose_count	int NOT NULL,	--/D number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_fraction	float NOT NULL,	--/D fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_debiased	float NOT NULL,	--/D debiased fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_flag	int NOT NULL,	--/D flag for "loosely wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a31_1_count	int NOT NULL,	--/D number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_fraction	float NOT NULL,	--/D fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_debiased	float NOT NULL,	--/D debiased fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_flag	int NOT NULL,	--/D flag for "1 spiral arm"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a32_2_count	int NOT NULL,	--/D number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_fraction	float NOT NULL,	--/D fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_debiased	float NOT NULL,	--/D debiased fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_flag	int NOT NULL,	--/D flag for "2 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a33_3_count	int NOT NULL,	--/D number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_fraction	float NOT NULL,	--/D fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_debiased	float NOT NULL,	--/D debiased fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_flag	int NOT NULL,	--/D flag for "3 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a34_4_count	int NOT NULL,	--/D number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_fraction	float NOT NULL,	--/D fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_flag	int NOT NULL,	--/D flag for "4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a36_more_than_4_count	int NOT NULL,	--/D number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_fraction	float NOT NULL,	--/D fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_flag	int NOT NULL,	--/D flag for "more than 4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a37_cant_tell_count	int NOT NULL,	--/D number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_fraction	float NOT NULL,	--/D fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_flag	int NOT NULL	--/D flag for "spiral arms present, but can't tell how many"	- 1 if galaxy is in clean sample, 0 otherwise
)
GO



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zoo2MainSpecz')
	DROP TABLE zoo2MainSpecz
GO
--
EXEC spSetDefaultFileGroup 'zoo2MainSpecz'
GO
CREATE TABLE zoo2MainSpecz (
-------------------------------------------------------------------------------
--/H Morphological classifications of main-sample spectroscopic galaxies
--/H from Galaxy Zoo 2.
-------------------------------------------------------------------------------
--/T This table includes galaxies with spectra in SDSS Data Release 7.
--/T Several columns give data that can be used to cross-match rows with
--/T other SDSS tables, including objIDs and positions of the galaxies.
--/T Morphological classifications include six parameters for each category:
--/T unweighted and weighted versions of both the total number of votes and
--/T the vote fraction for that response, the vote fraction after being
--/T debiased, and flags for systems identified as being in clean samples.
--/T
--/T Note that this table and zoo2Stripe82Normal contain some of the same
--/T galaxies (with r < 17.0). 
--/T Reference:  The project and data release are described in Willett et
--/T al. (2013, in prep). Please cite this paper if making use of any data
--/T in this table in publications.
-------------------------------------------------------------------------------
	specobjid	bigint NOT NULL,	--/D match to the DR8 spectrum object
	dr8objid	bigint NOT NULL,	--/D match to the DR8 objID
	dr7objid	bigint NOT NULL,	--/D match to the DR7 objID
	ra	real NOT NULL,	--/D right ascension [J2000.0], decimal degrees
	dec	real NOT NULL,	--/D declination [J2000.0], decimal degrees
	rastring	varchar(16) NOT NULL,	--/D right ascension [J2000.0], sexagesimal
	decstring	varchar(16) NOT NULL,	--/D declination [J2000.0], sexagesimal
	sample	varchar(32) NOT NULL,	--/D sub-sample identification
	total_classifications	int NOT NULL,	--/D total number of classifications for this galaxy
	total_votes	int NOT NULL,	--/D total number of votes for each response, summed over all classifications
	t01_smooth_or_features_a01_smooth_count	int NOT NULL,	--/D number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_fraction	float NOT NULL,	--/D fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_flag	int NOT NULL,	--/D flag for "smooth" - 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a02_features_or_disk_count	int NOT NULL,	--/D number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_fraction	float NOT NULL,	--/D fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_debiased	float NOT NULL,	--/D debiased fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_flag	int NOT NULL,	--/D flag for "features or disk"	- 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a03_star_or_artifact_count	int NOT NULL,	--/D number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_fraction	float NOT NULL,	--/D fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_debiased	float NOT NULL,	--/D debiased fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_flag	int NOT NULL,	--/D flag for "star or artifact"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a04_yes_count	int NOT NULL,	--/D number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_fraction	float NOT NULL,	--/D fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_flag	int NOT NULL,	--/D flag for "edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a05_no_count	int NOT NULL,	--/D number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_fraction	float NOT NULL,	--/D fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_flag	int NOT NULL,	--/D flag for "not edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a06_bar_count	int NOT NULL,	--/D number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_fraction	float NOT NULL,	--/D fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_flag	int NOT NULL,	--/D flag for "bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a07_no_bar_count	int NOT NULL,	--/D number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_fraction	float NOT NULL,	--/D fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_flag	int NOT NULL,	--/D flag for "no bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a08_spiral_count	int NOT NULL,	--/D number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_fraction	float NOT NULL,	--/D fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_flag	int NOT NULL,	--/D flag for "spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a09_no_spiral_count	int NOT NULL,	--/D number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_fraction	float NOT NULL,	--/D fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_flag	int NOT NULL,	--/D flag for "no spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a10_no_bulge_count	int NOT NULL,	--/D number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_flag	int NOT NULL,	--/D flag for "no bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a11_just_noticeable_count	int NOT NULL,	--/D number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_fraction	float NOT NULL,	--/D fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_debiased	float NOT NULL,	--/D debiased fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_flag	int NOT NULL,	--/D flag for "just noticeable bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a12_obvious_count	int NOT NULL,	--/D number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_fraction	float NOT NULL,	--/D fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_debiased	float NOT NULL,	--/D debiased fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_flag	int NOT NULL,	--/D flag for "obvious bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a13_dominant_count	int NOT NULL,	--/D number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_fraction	float NOT NULL,	--/D fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_debiased	float NOT NULL,	--/D debiased fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_flag	int NOT NULL,	--/D flag for "dominant bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a14_yes_count	int NOT NULL,	--/D number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_fraction	float NOT NULL,	--/D fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_flag	int NOT NULL,	--/D flag for "something odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a15_no_count	int NOT NULL,	--/D number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_fraction	float NOT NULL,	--/D fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_flag	int NOT NULL,	--/D flag for "nothing odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a16_completely_round_count	int NOT NULL,	--/D number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_fraction	float NOT NULL,	--/D fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_flag	int NOT NULL,	--/D flag for "smooth and completely round"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a17_in_between_count	int NOT NULL,	--/D number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_fraction	float NOT NULL,	--/D fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_flag	int NOT NULL,	--/D flag for "smooth and in-between roundness"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a18_cigar_shaped_count	int NOT NULL,	--/D number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_fraction	float NOT NULL,	--/D fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_flag	int NOT NULL,	--/D flag for "smooth and cigar-shaped"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a19_ring_count	int NOT NULL,	--/D number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_flag	int NOT NULL,	--/D flag for "odd feature is a ring"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a20_lens_or_arc_count	int NOT NULL,	--/D number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_flag	int NOT NULL,	--/D flag for "odd feature is a lens or arc"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a21_disturbed_count	int NOT NULL,	--/D number of votes for the "odd feature is a disturbed" galaxy response to Task 08
	t08_odd_feature_a21_disturbed_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a disturbed galaxy response to Task 08
	t08_odd_feature_a21_disturbed_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a disturbed galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_flag	int NOT NULL,	--/D flag for "odd feature is a disturbed galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a22_irregular_count	int NOT NULL,	--/D number of votes for the "odd feature is an irregular" galaxy response to Task 08
	t08_odd_feature_a22_irregular_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is an irregular galaxy response to Task 08
	t08_odd_feature_a22_irregular_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is an irregular galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_flag	int NOT NULL,	--/D flag for "odd feature is an irregular galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a23_other_count	int NOT NULL,	--/D number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_flag	int NOT NULL,	--/D flag for "odd feature is something else"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a24_merger_count	int NOT NULL,	--/D number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_flag	int NOT NULL,	--/D flag for "odd feature is a merger"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a38_dust_lane_count	int NOT NULL,	--/D number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_flag	int NOT NULL,	--/D flag for "odd feature is a dust lane"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a25_rounded_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_flag	int NOT NULL,	--/D flag for "edge-on bulge is rounded"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a26_boxy_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_flag	int NOT NULL,	--/D flag for "edge-on bulge is boxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a27_no_bulge_count	int NOT NULL,	--/D number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_flag	int NOT NULL,	--/D flag for "no edge-on bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a28_tight_count	int NOT NULL,	--/D number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_fraction	float NOT NULL,	--/D fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_debiased	float NOT NULL,	--/D debiased fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_flag	int NOT NULL,	--/D flag for "tightly wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a29_medium_count	int NOT NULL,	--/D number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_fraction	float NOT NULL,	--/D fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_debiased	float NOT NULL,	--/D debiased fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_flag	int NOT NULL,	--/D flag for "medium wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a30_loose_count	int NOT NULL,	--/D number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_fraction	float NOT NULL,	--/D fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_debiased	float NOT NULL,	--/D debiased fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_flag	int NOT NULL,	--/D flag for "loosely wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a31_1_count	int NOT NULL,	--/D number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_fraction	float NOT NULL,	--/D fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_debiased	float NOT NULL,	--/D debiased fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_flag	int NOT NULL,	--/D flag for "1 spiral arm"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a32_2_count	int NOT NULL,	--/D number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_fraction	float NOT NULL,	--/D fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_debiased	float NOT NULL,	--/D debiased fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_flag	int NOT NULL,	--/D flag for "2 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a33_3_count	int NOT NULL,	--/D number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_fraction	float NOT NULL,	--/D fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_debiased	float NOT NULL,	--/D debiased fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_flag	int NOT NULL,	--/D flag for "3 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a34_4_count	int NOT NULL,	--/D number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_fraction	float NOT NULL,	--/D fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_flag	int NOT NULL,	--/D flag for "4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a36_more_than_4_count	int NOT NULL,	--/D number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_fraction	float NOT NULL,	--/D fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_flag	int NOT NULL,	--/D flag for "more than 4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a37_cant_tell_count	int NOT NULL,	--/D number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_fraction	float NOT NULL,	--/D fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_flag	int NOT NULL	--/D flag for "spiral arms present, but can't tell how many"	- 1 if galaxy is in clean sample, 0 otherwise
)
GO



--============================================
IF EXISTS (SELECT name FROM sysobjects
         WHERE xtype='U' AND name = 'zoo2Stripe82Coadd1')
	DROP TABLE zoo2Stripe82Coadd1
GO
--
EXEC spSetDefaultFileGroup 'zoo2Stripe82Coadd1'
GO
CREATE TABLE zoo2Stripe82Coadd1 (
-------------------------------------------------------------------------------
--/H Morphological classifications of Stripe 82, coadded (sample
--/H 1) spectroscopic galaxies from Galaxy Zoo 2
-------------------------------------------------------------------------------
--/T This table includes classifications from coadded images of Stripe 82
--/T galaxies in SDSS Data Release 7. The co-addition method is described in
--/T Willett et al.; it differs from the second sample in that these images
--/T did NOT desaturate color in their noisy background pixels. Several
--/T columns give data that can be used to cross-match rows with other SDSS
--/T tables, including objIDs and positions of the galaxies. Morphological
--/T classifications include six parameters for each category: unweighted and
--/T weighted versions of both the total number of votes and the vote fraction
--/T for that response, the vote fraction after being debiased, and flags for
--/T systems identified as being in clean samples.
--/T
--/T Reference:  The project and data release are described in Willett et al.
--/T (2013, in prep). Please cite this paper if making use of any data in this
--/T table in publications.
-------------------------------------------------------------------------------
	specobjid	bigint NOT NULL,	--/D match to the DR8 spectrum object
	stripe82objid	bigint NOT NULL,	--/D objID of the galaxy in the Stripe82 context of CasJobs
	dr8objid	bigint NOT NULL,	--/D match to the DR8 objID for the corresponding normal-depth image
	dr7objid	bigint NOT NULL,	--/D match to the DR7 objID for the corresponding normal-depth image
	ra	real NOT NULL,	--/D right ascension [J2000.0], decimal degrees
	dec	real NOT NULL,	--/D declination [J2000.0], decimal degrees
	rastring	varchar(11) NOT NULL,	--/D right ascension [J2000.0], sexagesimal
	decstring	varchar(11) NOT NULL,	--/D declination [J2000.0], sexagesimal
	sample	varchar(32) NOT NULL,	--/D sub-sample identification
	total_classifications	int NOT NULL,	--/D total number of classifications for this galaxy
	total_votes	int NOT NULL,	--/D total number of votes for each response, summed over all classifications
	t01_smooth_or_features_a01_smooth_count	int NOT NULL,	--/D number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_fraction	float NOT NULL,	--/D fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_flag	int NOT NULL,	--/D flag for "smooth" - 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a02_features_or_disk_count	int NOT NULL,	--/D number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_fraction	float NOT NULL,	--/D fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_debiased	float NOT NULL,	--/D debiased fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_flag	int NOT NULL,	--/D flag for "features or disk"	- 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a03_star_or_artifact_count	int NOT NULL,	--/D number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_fraction	float NOT NULL,	--/D fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_debiased	float NOT NULL,	--/D debiased fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_flag	int NOT NULL,	--/D flag for "star or artifact"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a04_yes_count	int NOT NULL,	--/D number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_fraction	float NOT NULL,	--/D fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_flag	int NOT NULL,	--/D flag for "edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a05_no_count	int NOT NULL,	--/D number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_fraction	float NOT NULL,	--/D fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_flag	int NOT NULL,	--/D flag for "not edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a06_bar_count	int NOT NULL,	--/D number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_fraction	float NOT NULL,	--/D fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_flag	int NOT NULL,	--/D flag for "bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a07_no_bar_count	int NOT NULL,	--/D number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_fraction	float NOT NULL,	--/D fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_flag	int NOT NULL,	--/D flag for "no bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a08_spiral_count	int NOT NULL,	--/D number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_fraction	float NOT NULL,	--/D fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_flag	int NOT NULL,	--/D flag for "spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a09_no_spiral_count	int NOT NULL,	--/D number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_fraction	float NOT NULL,	--/D fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_flag	int NOT NULL,	--/D flag for "no spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a10_no_bulge_count	int NOT NULL,	--/D number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_flag	int NOT NULL,	--/D flag for "no bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a11_just_noticeable_count	int NOT NULL,	--/D number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_fraction	float NOT NULL,	--/D fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_debiased	float NOT NULL,	--/D debiased fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_flag	int NOT NULL,	--/D flag for "just noticeable bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a12_obvious_count	int NOT NULL,	--/D number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_fraction	float NOT NULL,	--/D fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_debiased	float NOT NULL,	--/D debiased fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_flag	int NOT NULL,	--/D flag for "obvious bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a13_dominant_count	int NOT NULL,	--/D number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_fraction	float NOT NULL,	--/D fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_debiased	float NOT NULL,	--/D debiased fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_flag	int NOT NULL,	--/D flag for "dominant bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a14_yes_count	int NOT NULL,	--/D number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_fraction	float NOT NULL,	--/D fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_flag	int NOT NULL,	--/D flag for "something odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a15_no_count	int NOT NULL,	--/D number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_fraction	float NOT NULL,	--/D fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_flag	int NOT NULL,	--/D flag for "nothing odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a16_completely_round_count	int NOT NULL,	--/D number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_fraction	float NOT NULL,	--/D fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_flag	int NOT NULL,	--/D flag for "smooth and completely round"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a17_in_between_count	int NOT NULL,	--/D number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_fraction	float NOT NULL,	--/D fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_flag	int NOT NULL,	--/D flag for "smooth and in-between roundness"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a18_cigar_shaped_count	int NOT NULL,	--/D number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_fraction	float NOT NULL,	--/D fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_flag	int NOT NULL,	--/D flag for "smooth and cigar-shaped"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a19_ring_count	int NOT NULL,	--/D number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_flag	int NOT NULL,	--/D flag for "odd feature is a ring"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a20_lens_or_arc_count	int NOT NULL,	--/D number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_flag	int NOT NULL,	--/D flag for "odd feature is a lens or arc"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a21_disturbed_count	int NOT NULL,	--/D number of votes for the "odd feature is a disturbed" galaxy response to Task 08
	t08_odd_feature_a21_disturbed_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a disturbed galaxy response to Task 08
	t08_odd_feature_a21_disturbed_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a disturbed galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_flag	int NOT NULL,	--/D flag for "odd feature is a disturbed galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a22_irregular_count	int NOT NULL,	--/D number of votes for the "odd feature is an irregular" galaxy response to Task 08
	t08_odd_feature_a22_irregular_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is an irregular galaxy response to Task 08
	t08_odd_feature_a22_irregular_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is an irregular galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_flag	int NOT NULL,	--/D flag for "odd feature is an irregular galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a23_other_count	int NOT NULL,	--/D number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_flag	int NOT NULL,	--/D flag for "odd feature is something else"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a24_merger_count	int NOT NULL,	--/D number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_flag	int NOT NULL,	--/D flag for "odd feature is a merger"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a38_dust_lane_count	int NOT NULL,	--/D number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_flag	int NOT NULL,	--/D flag for "odd feature is a dust lane"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a25_rounded_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_flag	int NOT NULL,	--/D flag for "edge-on bulge is rounded"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a26_boxy_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_flag	int NOT NULL,	--/D flag for "edge-on bulge is boxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a27_no_bulge_count	int NOT NULL,	--/D number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_flag	int NOT NULL,	--/D flag for "no edge-on bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a28_tight_count	int NOT NULL,	--/D number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_fraction	float NOT NULL,	--/D fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_debiased	float NOT NULL,	--/D debiased fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_flag	int NOT NULL,	--/D flag for "tightly wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a29_medium_count	int NOT NULL,	--/D number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_fraction	float NOT NULL,	--/D fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_debiased	float NOT NULL,	--/D debiased fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_flag	int NOT NULL,	--/D flag for "medium wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a30_loose_count	int NOT NULL,	--/D number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_fraction	float NOT NULL,	--/D fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_debiased	float NOT NULL,	--/D debiased fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_flag	int NOT NULL,	--/D flag for "loosely wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a31_1_count	int NOT NULL,	--/D number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_fraction	float NOT NULL,	--/D fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_debiased	float NOT NULL,	--/D debiased fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_flag	int NOT NULL,	--/D flag for "1 spiral arm"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a32_2_count	int NOT NULL,	--/D number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_fraction	float NOT NULL,	--/D fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_debiased	float NOT NULL,	--/D debiased fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_flag	int NOT NULL,	--/D flag for "2 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a33_3_count	int NOT NULL,	--/D number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_fraction	float NOT NULL,	--/D fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_debiased	float NOT NULL,	--/D debiased fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_flag	int NOT NULL,	--/D flag for "3 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a34_4_count	int NOT NULL,	--/D number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_fraction	float NOT NULL,	--/D fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_flag	int NOT NULL,	--/D flag for "4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a36_more_than_4_count	int NOT NULL,	--/D number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_fraction	float NOT NULL,	--/D fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_flag	int NOT NULL,	--/D flag for "more than 4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a37_cant_tell_count	int NOT NULL,	--/D number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_fraction	float NOT NULL,	--/D fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_flag	int NOT NULL	--/D flag for "spiral arms present, but can't tell how many"	- 1 if galaxy is in clean sample, 0 otherwise
)
GO
	
	
	
	
--============================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'zoo2Stripe82Coadd2')
	DROP TABLE zoo2Stripe82Coadd2
GO
--
EXEC spSetDefaultFileGroup 'zoo2Stripe82Coadd2'
GO
CREATE TABLE zoo2Stripe82Coadd2 (
-------------------------------------------------------------------------------
--/H Morphological classifications of Stripe 82, coadded (sample 2)
--/H spectroscopic galaxies from Galaxy Zoo 2
-------------------------------------------------------------------------------
--/T This table includes classifications from coadded images of Stripe 82
--/T galaxies in SDSS Data Release 7. Sky background pixels for these co-added
--/T images were desaturated to attempt and avoid bias by classifiers, as
--/T described in Willett et al. Several columns give data that can be used to
--/T cross-match rows with other SDSS tables, including objIDs and positions
--/T of the galaxies. Morphological classifications include six parameters for
--/T each category: unweighted and weighted versions of both the total number
--/T of votes and the vote fraction for that response, the vote fraction after
--/T being debiased, and flags for systems identified as being in clean samples.
--/T
--/T Reference:	The project and data release are described in Willett et al.
--/T (2013, in prep). Please cite this paper if making use of any data in
--/T this table in publications.
-------------------------------------------------------------------------------
	specobjid	bigint NOT NULL,	--/D match to the DR8 spectrum object
	stripe82objid	bigint NOT NULL,	--/D objID of the galaxy in the Stripe82 context of CasJobs
	dr8objid	bigint NOT NULL,	--/D match to the DR8 objID for the corresponding normal-depth image
	dr7objid	bigint NOT NULL,	--/D match to the DR7 objID for the corresponding normal-depth image
	ra	real NOT NULL,	--/D right ascension [J2000.0], decimal degrees
	dec	real NOT NULL,	--/D declination [J2000.0], decimal degrees
	rastring	varchar(11) NOT NULL,	--/D right ascension [J2000.0], sexagesimal
	decstring	varchar(11) NOT NULL,	--/D declination [J2000.0], sexagesimal
	sample	varchar(32) NOT NULL,	--/D sub-sample identification
	total_classifications	int NOT NULL,	--/D total number of classifications for this galaxy
	total_votes	int NOT NULL,	--/D total number of votes for each response, summed over all classifications
	t01_smooth_or_features_a01_smooth_count	int NOT NULL,	--/D number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_fraction	float NOT NULL,	--/D fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_flag	int NOT NULL,	--/D flag for "smooth" - 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a02_features_or_disk_count	int NOT NULL,	--/D number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_fraction	float NOT NULL,	--/D fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_debiased	float NOT NULL,	--/D debiased fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_flag	int NOT NULL,	--/D flag for "features or disk"	- 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a03_star_or_artifact_count	int NOT NULL,	--/D number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_fraction	float NOT NULL,	--/D fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_debiased	float NOT NULL,	--/D debiased fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_flag	int NOT NULL,	--/D flag for "star or artifact"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a04_yes_count	int NOT NULL,	--/D number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_fraction	float NOT NULL,	--/D fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_flag	int NOT NULL,	--/D flag for "edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a05_no_count	int NOT NULL,	--/D number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_fraction	float NOT NULL,	--/D fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_flag	int NOT NULL,	--/D flag for "not edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a06_bar_count	int NOT NULL,	--/D number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_fraction	float NOT NULL,	--/D fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_flag	int NOT NULL,	--/D flag for "bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a07_no_bar_count	int NOT NULL,	--/D number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_fraction	float NOT NULL,	--/D fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_flag	int NOT NULL,	--/D flag for "no bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a08_spiral_count	int NOT NULL,	--/D number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_fraction	float NOT NULL,	--/D fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_flag	int NOT NULL,	--/D flag for "spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a09_no_spiral_count	int NOT NULL,	--/D number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_fraction	float NOT NULL,	--/D fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_flag	int NOT NULL,	--/D flag for "no spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a10_no_bulge_count	int NOT NULL,	--/D number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_flag	int NOT NULL,	--/D flag for "no bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a11_just_noticeable_count	int NOT NULL,	--/D number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_fraction	float NOT NULL,	--/D fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_debiased	float NOT NULL,	--/D debiased fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_flag	int NOT NULL,	--/D flag for "just noticeable bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a12_obvious_count	int NOT NULL,	--/D number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_fraction	float NOT NULL,	--/D fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_debiased	float NOT NULL,	--/D debiased fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_flag	int NOT NULL,	--/D flag for "obvious bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a13_dominant_count	int NOT NULL,	--/D number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_fraction	float NOT NULL,	--/D fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_debiased	float NOT NULL,	--/D debiased fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_flag	int NOT NULL,	--/D flag for "dominant bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a14_yes_count	int NOT NULL,	--/D number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_fraction	float NOT NULL,	--/D fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_flag	int NOT NULL,	--/D flag for "something odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a15_no_count	int NOT NULL,	--/D number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_fraction	float NOT NULL,	--/D fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_flag	int NOT NULL,	--/D flag for "nothing odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a16_completely_round_count	int NOT NULL,	--/D number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_fraction	float NOT NULL,	--/D fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_flag	int NOT NULL,	--/D flag for "smooth and completely round"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a17_in_between_count	int NOT NULL,	--/D number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_fraction	float NOT NULL,	--/D fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_flag	int NOT NULL,	--/D flag for "smooth and in-between roundness"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a18_cigar_shaped_count	int NOT NULL,	--/D number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_fraction	float NOT NULL,	--/D fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_flag	int NOT NULL,	--/D flag for "smooth and cigar-shaped"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a19_ring_count	int NOT NULL,	--/D number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_flag	int NOT NULL,	--/D flag for "odd feature is a ring"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a20_lens_or_arc_count	int NOT NULL,	--/D number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_flag	int NOT NULL,	--/D flag for "odd feature is a lens or arc"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a21_disturbed_count	int NOT NULL,	--/D number of votes for the "odd feature is a disturbed" galaxy response to Task 08
	t08_odd_feature_a21_disturbed_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a disturbed galaxy response to Task 08
	t08_odd_feature_a21_disturbed_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a disturbed galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_flag	int NOT NULL,	--/D flag for "odd feature is a disturbed galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a22_irregular_count	int NOT NULL,	--/D number of votes for the "odd feature is an irregular" galaxy response to Task 08
	t08_odd_feature_a22_irregular_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is an irregular galaxy response to Task 08
	t08_odd_feature_a22_irregular_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is an irregular galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_flag	int NOT NULL,	--/D flag for "odd feature is an irregular galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a23_other_count	int NOT NULL,	--/D number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_flag	int NOT NULL,	--/D flag for "odd feature is something else"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a24_merger_count	int NOT NULL,	--/D number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_flag	int NOT NULL,	--/D flag for "odd feature is a merger"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a38_dust_lane_count	int NOT NULL,	--/D number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_flag	int NOT NULL,	--/D flag for "odd feature is a dust lane"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a25_rounded_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_flag	int NOT NULL,	--/D flag for "edge-on bulge is rounded"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a26_boxy_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_flag	int NOT NULL,	--/D flag for "edge-on bulge is boxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a27_no_bulge_count	int NOT NULL,	--/D number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_flag	int NOT NULL,	--/D flag for "no edge-on bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a28_tight_count	int NOT NULL,	--/D number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_fraction	float NOT NULL,	--/D fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_debiased	float NOT NULL,	--/D debiased fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_flag	int NOT NULL,	--/D flag for "tightly wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a29_medium_count	int NOT NULL,	--/D number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_fraction	float NOT NULL,	--/D fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_debiased	float NOT NULL,	--/D debiased fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_flag	int NOT NULL,	--/D flag for "medium wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a30_loose_count	int NOT NULL,	--/D number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_fraction	float NOT NULL,	--/D fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_debiased	float NOT NULL,	--/D debiased fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_flag	int NOT NULL,	--/D flag for "loosely wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a31_1_count	int NOT NULL,	--/D number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_fraction	float NOT NULL,	--/D fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_debiased	float NOT NULL,	--/D debiased fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_flag	int NOT NULL,	--/D flag for "1 spiral arm"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a32_2_count	int NOT NULL,	--/D number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_fraction	float NOT NULL,	--/D fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_debiased	float NOT NULL,	--/D debiased fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_flag	int NOT NULL,	--/D flag for "2 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a33_3_count	int NOT NULL,	--/D number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_fraction	float NOT NULL,	--/D fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_debiased	float NOT NULL,	--/D debiased fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_flag	int NOT NULL,	--/D flag for "3 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a34_4_count	int NOT NULL,	--/D number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_fraction	float NOT NULL,	--/D fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_flag	int NOT NULL,	--/D flag for "4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a36_more_than_4_count	int NOT NULL,	--/D number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_fraction	float NOT NULL,	--/D fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_flag	int NOT NULL,	--/D flag for "more than 4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a37_cant_tell_count	int NOT NULL,	--/D number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_fraction	float NOT NULL,	--/D fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_flag	int NOT NULL	--/D flag for "spiral arms present, but can't tell how many"	- 1 if galaxy is in clean sample, 0 otherwise
)
GO


--============================================
IF EXISTS (SELECT name FROM sysobjects
	WHERE xtype='U' AND name = 'zoo2Stripe82Normal')
	DROP TABLE zoo2Stripe82Normal
GO
--
EXEC spSetDefaultFileGroup 'zoo2Stripe82Normal'
GO
CREATE TABLE zoo2Stripe82Normal (
-------------------------------------------------------------------------------
--/H Morphological classifications of Stripe 82 normal-depth, spectroscopic
--/H galaxies from Galaxy Zoo 2
-------------------------------------------------------------------------------
--/T This table includes Stripe 82 galaxies with spectra in SDSS Data Release
--/T 7. Several columns give data that can be used to cross-match rows with
--/T other SDSS tables, including objIDs and positions of the galaxies.
--/T Morphological classifications include six parameters for each category:
--/T unweighted and weighted versions of both the total number of votes and
--/T the vote fraction for that response, the vote fraction after being
--/T debiased, and flags for systems identified as being in clean samples.
--/T
--/T Note that this table and zoo2MainSpecz contain some of the same
--/T galaxies (with r < 17.0). 
--/T
--/T Reference:	The project and data release are described in Willett et al.
--/T (2013, in prep). Please cite this paper if making use of any data in
--/T this table in publications.
-------------------------------------------------------------------------------
	specobjid	bigint NOT NULL,	--/D match to the DR8 spectrum object
	dr8objid	bigint NOT NULL,	--/D match to the DR8 objID
	dr7objid	bigint NOT NULL,	--/D match to the DR7 objID
	ra	real NOT NULL,	--/D right ascension [J2000.0], decimal degrees
	dec	real NOT NULL,	--/D declination [J2000.0], decimal degrees
	rastring	varchar(16) NOT NULL,	--/D right ascension [J2000.0], sexagesimal
	decstring	varchar(16) NOT NULL,	--/D declination [J2000.0], sexagesimal
	sample	varchar(32) NOT NULL,	--/D sub-sample identification
	total_classifications	int NOT NULL,	--/D total number of classifications for this galaxy
	total_votes	int NOT NULL,	--/D total number of votes for each response, summed over all classifications
	t01_smooth_or_features_a01_smooth_count	int NOT NULL,	--/D number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth" response to Task 01
	t01_smooth_or_features_a01_smooth_fraction	float NOT NULL,	--/D fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth" out of all responses to Task 01
	t01_smooth_or_features_a01_smooth_flag	int NOT NULL,	--/D flag for "smooth" - 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a02_features_or_disk_count	int NOT NULL,	--/D number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "features or disk" response to Task 01
	t01_smooth_or_features_a02_features_or_disk_fraction	float NOT NULL,	--/D fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_debiased	float NOT NULL,	--/D debiased fraction of votes for "features or disk" out of all responses to Task 01
	t01_smooth_or_features_a02_features_or_disk_flag	int NOT NULL,	--/D flag for "features or disk"	- 1 if galaxy is in clean sample, 0 otherwise
	t01_smooth_or_features_a03_star_or_artifact_count	int NOT NULL,	--/D number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "star or artifact" response to Task 01
	t01_smooth_or_features_a03_star_or_artifact_fraction	float NOT NULL,	--/D fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_debiased	float NOT NULL,	--/D debiased fraction of votes for "star or artifact" out of all responses to Task 01
	t01_smooth_or_features_a03_star_or_artifact_flag	int NOT NULL,	--/D flag for "star or artifact"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a04_yes_count	int NOT NULL,	--/D number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on" response to Task 02
	t02_edgeon_a04_yes_fraction	float NOT NULL,	--/D fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on" out of all responses to Task 02
	t02_edgeon_a04_yes_flag	int NOT NULL,	--/D flag for "edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t02_edgeon_a05_no_count	int NOT NULL,	--/D number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "not edge-on" response to Task 02
	t02_edgeon_a05_no_fraction	float NOT NULL,	--/D fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "not edge-on" out of all responses to Task 02
	t02_edgeon_a05_no_flag	int NOT NULL,	--/D flag for "not edge-on"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a06_bar_count	int NOT NULL,	--/D number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "bar" response to Task 03
	t03_bar_a06_bar_fraction	float NOT NULL,	--/D fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "bar" out of all responses to Task 03
	t03_bar_a06_bar_flag	int NOT NULL,	--/D flag for "bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t03_bar_a07_no_bar_count	int NOT NULL,	--/D number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bar" response to Task 03
	t03_bar_a07_no_bar_fraction	float NOT NULL,	--/D fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bar" out of all responses to Task 03
	t03_bar_a07_no_bar_flag	int NOT NULL,	--/D flag for "no bar"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a08_spiral_count	int NOT NULL,	--/D number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral structure" response to Task 04
	t04_spiral_a08_spiral_fraction	float NOT NULL,	--/D fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral structure" out of all responses to Task 04
	t04_spiral_a08_spiral_flag	int NOT NULL,	--/D flag for "spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t04_spiral_a09_no_spiral_count	int NOT NULL,	--/D number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no spiral structure" response to Task 04
	t04_spiral_a09_no_spiral_fraction	float NOT NULL,	--/D fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_debiased	float NOT NULL,	--/D debiased fraction of votes for "no spiral structure" out of all responses to Task 04
	t04_spiral_a09_no_spiral_flag	int NOT NULL,	--/D flag for "no spiral structure"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a10_no_bulge_count	int NOT NULL,	--/D number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no bulge" response to Task 05
	t05_bulge_prominence_a10_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no bulge" out of all responses to Task 05
	t05_bulge_prominence_a10_no_bulge_flag	int NOT NULL,	--/D flag for "no bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a11_just_noticeable_count	int NOT NULL,	--/D number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "just noticeable bulge" response to Task 05
	t05_bulge_prominence_a11_just_noticeable_fraction	float NOT NULL,	--/D fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_debiased	float NOT NULL,	--/D debiased fraction of votes for "just noticeable bulge" out of all responses to Task 05
	t05_bulge_prominence_a11_just_noticeable_flag	int NOT NULL,	--/D flag for "just noticeable bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a12_obvious_count	int NOT NULL,	--/D number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "obvious bulge" response to Task 05
	t05_bulge_prominence_a12_obvious_fraction	float NOT NULL,	--/D fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_debiased	float NOT NULL,	--/D debiased fraction of votes for "obvious bulge" out of all responses to Task 05
	t05_bulge_prominence_a12_obvious_flag	int NOT NULL,	--/D flag for "obvious bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t05_bulge_prominence_a13_dominant_count	int NOT NULL,	--/D number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "dominant bulge" response to Task 05
	t05_bulge_prominence_a13_dominant_fraction	float NOT NULL,	--/D fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_debiased	float NOT NULL,	--/D debiased fraction of votes for "dominant bulge" out of all responses to Task 05
	t05_bulge_prominence_a13_dominant_flag	int NOT NULL,	--/D flag for "dominant bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a14_yes_count	int NOT NULL,	--/D number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "something odd" response to Task 06
	t06_odd_a14_yes_fraction	float NOT NULL,	--/D fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_debiased	float NOT NULL,	--/D debiased fraction of votes for "something odd" out of all responses to Task 06
	t06_odd_a14_yes_flag	int NOT NULL,	--/D flag for "something odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t06_odd_a15_no_count	int NOT NULL,	--/D number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "nothing odd" response to Task 06
	t06_odd_a15_no_fraction	float NOT NULL,	--/D fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_debiased	float NOT NULL,	--/D debiased fraction of votes for "nothing odd" out of all responses to Task 06
	t06_odd_a15_no_flag	int NOT NULL,	--/D flag for "nothing odd"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a16_completely_round_count	int NOT NULL,	--/D number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and completely round" response to Task 07
	t07_rounded_a16_completely_round_fraction	float NOT NULL,	--/D fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and completely round" out of all responses to Task 07
	t07_rounded_a16_completely_round_flag	int NOT NULL,	--/D flag for "smooth and completely round"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a17_in_between_count	int NOT NULL,	--/D number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and in-between roundness" response to Task 07
	t07_rounded_a17_in_between_fraction	float NOT NULL,	--/D fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and in-between roundness" out of all responses to Task 07
	t07_rounded_a17_in_between_flag	int NOT NULL,	--/D flag for "smooth and in-between roundness"	- 1 if galaxy is in clean sample, 0 otherwise
	t07_rounded_a18_cigar_shaped_count	int NOT NULL,	--/D number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "smooth and cigar-shaped" response to Task 07
	t07_rounded_a18_cigar_shaped_fraction	float NOT NULL,	--/D fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_debiased	float NOT NULL,	--/D debiased fraction of votes for "smooth and cigar-shaped" out of all responses to Task 07
	t07_rounded_a18_cigar_shaped_flag	int NOT NULL,	--/D flag for "smooth and cigar-shaped"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a19_ring_count	int NOT NULL,	--/D number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a ring" response to Task 08
	t08_odd_feature_a19_ring_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a ring" out of all responses to Task 08
	t08_odd_feature_a19_ring_flag	int NOT NULL,	--/D flag for "odd feature is a ring"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a20_lens_or_arc_count	int NOT NULL,	--/D number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a lens or arc" response to Task 08
	t08_odd_feature_a20_lens_or_arc_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a lens or arc" out of all responses to Task 08
	t08_odd_feature_a20_lens_or_arc_flag	int NOT NULL,	--/D flag for "odd feature is a lens or arc"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a21_disturbed_count	int NOT NULL,	--/D number of votes for the "odd feature is a disturbed" galaxy response to Task 08
	t08_odd_feature_a21_disturbed_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a disturbed galaxy response to Task 08
	t08_odd_feature_a21_disturbed_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a disturbed galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a disturbed" galaxy out of all responses to Task 08
	t08_odd_feature_a21_disturbed_flag	int NOT NULL,	--/D flag for "odd feature is a disturbed galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a22_irregular_count	int NOT NULL,	--/D number of votes for the "odd feature is an irregular" galaxy response to Task 08
	t08_odd_feature_a22_irregular_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is an irregular galaxy response to Task 08
	t08_odd_feature_a22_irregular_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is an irregular galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is an irregular" galaxy out of all responses to Task 08
	t08_odd_feature_a22_irregular_flag	int NOT NULL,	--/D flag for "odd feature is an irregular galaxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a23_other_count	int NOT NULL,	--/D number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is something else" response to Task 08
	t08_odd_feature_a23_other_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is something else" out of all responses to Task 08
	t08_odd_feature_a23_other_flag	int NOT NULL,	--/D flag for "odd feature is something else"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a24_merger_count	int NOT NULL,	--/D number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a merger" response to Task 08
	t08_odd_feature_a24_merger_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a merger" out of all responses to Task 08
	t08_odd_feature_a24_merger_flag	int NOT NULL,	--/D flag for "odd feature is a merger"	- 1 if galaxy is in clean sample, 0 otherwise
	t08_odd_feature_a38_dust_lane_count	int NOT NULL,	--/D number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "odd feature is a dust lane" response to Task 08
	t08_odd_feature_a38_dust_lane_fraction	float NOT NULL,	--/D fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_debiased	float NOT NULL,	--/D debiased fraction of votes for "odd feature is a dust lane" out of all responses to Task 08
	t08_odd_feature_a38_dust_lane_flag	int NOT NULL,	--/D flag for "odd feature is a dust lane"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a25_rounded_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is rounded" response to Task 09
	t09_bulge_shape_a25_rounded_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is rounded" out of all responses to Task 09
	t09_bulge_shape_a25_rounded_flag	int NOT NULL,	--/D flag for "edge-on bulge is rounded"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a26_boxy_count	int NOT NULL,	--/D number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "edge-on bulge is boxy" response to Task 09
	t09_bulge_shape_a26_boxy_fraction	float NOT NULL,	--/D fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_debiased	float NOT NULL,	--/D debiased fraction of votes for "edge-on bulge is boxy" out of all responses to Task 09
	t09_bulge_shape_a26_boxy_flag	int NOT NULL,	--/D flag for "edge-on bulge is boxy"	- 1 if galaxy is in clean sample, 0 otherwise
	t09_bulge_shape_a27_no_bulge_count	int NOT NULL,	--/D number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "no edge-on bulge" response to Task 09
	t09_bulge_shape_a27_no_bulge_fraction	float NOT NULL,	--/D fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_debiased	float NOT NULL,	--/D debiased fraction of votes for "no edge-on bulge" out of all responses to Task 09
	t09_bulge_shape_a27_no_bulge_flag	int NOT NULL,	--/D flag for "no edge-on bulge"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a28_tight_count	int NOT NULL,	--/D number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "tightly wound spiral arms" response to Task 10
	t10_arms_winding_a28_tight_fraction	float NOT NULL,	--/D fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_debiased	float NOT NULL,	--/D debiased fraction of votes for "tightly wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a28_tight_flag	int NOT NULL,	--/D flag for "tightly wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a29_medium_count	int NOT NULL,	--/D number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "medium wound spiral arms" response to Task 10
	t10_arms_winding_a29_medium_fraction	float NOT NULL,	--/D fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_debiased	float NOT NULL,	--/D debiased fraction of votes for "medium wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a29_medium_flag	int NOT NULL,	--/D flag for "medium wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t10_arms_winding_a30_loose_count	int NOT NULL,	--/D number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "loosely wound spiral arms" response to Task 10
	t10_arms_winding_a30_loose_fraction	float NOT NULL,	--/D fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_debiased	float NOT NULL,	--/D debiased fraction of votes for "loosely wound spiral arms" out of all responses to Task 10
	t10_arms_winding_a30_loose_flag	int NOT NULL,	--/D flag for "loosely wound spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a31_1_count	int NOT NULL,	--/D number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "1 spiral arm" response to Task 11
	t11_arms_number_a31_1_fraction	float NOT NULL,	--/D fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_debiased	float NOT NULL,	--/D debiased fraction of votes for "1 spiral arm" out of all responses to Task 11
	t11_arms_number_a31_1_flag	int NOT NULL,	--/D flag for "1 spiral arm"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a32_2_count	int NOT NULL,	--/D number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "2 spiral arms" response to Task 11
	t11_arms_number_a32_2_fraction	float NOT NULL,	--/D fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_debiased	float NOT NULL,	--/D debiased fraction of votes for "2 spiral arms" out of all responses to Task 11
	t11_arms_number_a32_2_flag	int NOT NULL,	--/D flag for "2 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a33_3_count	int NOT NULL,	--/D number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "3 spiral arms" response to Task 11
	t11_arms_number_a33_3_fraction	float NOT NULL,	--/D fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_debiased	float NOT NULL,	--/D debiased fraction of votes for "3 spiral arms" out of all responses to Task 11
	t11_arms_number_a33_3_flag	int NOT NULL,	--/D flag for "3 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a34_4_count	int NOT NULL,	--/D number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "4 spiral arms" response to Task 11
	t11_arms_number_a34_4_fraction	float NOT NULL,	--/D fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "4 spiral arms" out of all responses to Task 11
	t11_arms_number_a34_4_flag	int NOT NULL,	--/D flag for "4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a36_more_than_4_count	int NOT NULL,	--/D number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "more than 4 spiral arms" response to Task 11
	t11_arms_number_a36_more_than_4_fraction	float NOT NULL,	--/D fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_debiased	float NOT NULL,	--/D debiased fraction of votes for "more than 4 spiral arms" out of all responses to Task 11
	t11_arms_number_a36_more_than_4_flag	int NOT NULL,	--/D flag for "more than 4 spiral arms"	- 1 if galaxy is in clean sample, 0 otherwise
	t11_arms_number_a37_cant_tell_count	int NOT NULL,	--/D number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_weight	float NOT NULL,	--/D consistency-weighted number of votes for the "spiral arms present, but can't tell how many" response to Task 11
	t11_arms_number_a37_cant_tell_fraction	float NOT NULL,	--/D fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_weighted_fraction	float NOT NULL,	--/D consistency-weighted fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_debiased	float NOT NULL,	--/D debiased fraction of votes for "spiral arms present, but can't tell how many" out of all responses to Task 11
	t11_arms_number_a37_cant_tell_flag	int NOT NULL,	--/D flag for "spiral arms present, but can't tell how many"	- 1 if galaxy is in clean sample, 0 otherwise
)
GO	


--
EXEC spSetDefaultFileGroup 'PrimaryFileGroup'
GO


PRINT '[GalaxyZoo2Tables.sql]: Galaxy Zoo 2 tables created'
GO
