-- Patch to add computed column "rjce" to WISE_allsky (PR #1909).

ALTER TABLE WISE_allsky ADD
     glat        float NOT NULL DEFAULT 0, --/U deg --/D Galactic latitude
     glon        float NOT NULL DEFAULT 0, --/U deg --/D Galactic longitude 
     rjce AS j_m_2mass - k_m_2mass - 1.377 * (h_m_2mass - w2mag - 0.05)	PERSISTED --/D Dereddeing index - computed column used in APOGEE target selection


SELECT a.cntr, b.x, b.y, b.z
INTO #wiseXyz
FROM WISE_allsky a CROSS APPLY dbo.fHtmEqToXyz(ra,dec) b

UPDATE a
     SET a.glat = dbo.fGetLat('J2G',b.x,b.y,b.z),
     	 a.glon = dbo.fGetLon('J2G',b.x,b.y,b.z)
FROM WISE_allsky a 
     JOIN #wiseXyz b ON a.cntr=b.cntr
