-- Patch to add entry to SiteConstants table for release number (PR #1590).

INSERT SiteConstants
	VALUES( 'Release', '9', 'Data release number' )
