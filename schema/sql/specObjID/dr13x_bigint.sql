


----1. Drop indexes
  drop index i_SpecObjAll_BestObjID_sourceTyp on SpecObjAll
   drop index i_SpecObjAll_class_zWarning_z_sc on SpecObjAll
   drop index i_SpecObjAll_fluxObjID on SpecObjAll
   drop index i_SpecObjAll_htmID_ra_dec_cx_cy_ on SpecObjAll
   drop index i_SpecObjAll_ra_dec_class_plat on SpecObjAll
  drop index i_SpecObjAll_targetObjID_sourceT on SpecObjAll
---2. Drop clustered index
  alter table SpecObjAll drop constraint pk_specObjAll_specObjID

--3. alter column
  alter table SpecObjAll
  alter column SpecObjID bigint not null

--4.rebuild clustered index
  ALTER TABLE [dbo].[SpecObjAll2] ADD CONSTRAINT [pk_specObjAll_specObjID2] PRIMARY KEY CLUSTERED ([specObjID] ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [SPEC];

  dbcc traceon(610)
  insert SpecObjAll2 with (tablock)
  select * from SpecObjAll with (nolock)




--5. rebuild NCIs
  CREATE NONCLUSTERED INDEX [i_SpecObjAll_BestObjID_sourceTyp] ON [dbo].[SpecObjAll](bestObjID ASC, sourceType ASC, sciencePrimary ASC, class ASC, htmID ASC, ra ASC, dec ASC, plate ASC, mjd ASC, fiberID ASC, z ASC, zErr ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR = 100, DATA_COMPRESSION=PAGE) ON [SPEC];
CREATE NONCLUSTERED INDEX [i_SpecObjAll_class_zWarning_z_sc] ON [dbo].[SpecObjAll](class ASC, zWarning ASC, z ASC, sciencePrimary ASC, plateID ASC, bestObjID ASC, targetObjID ASC, htmID ASC, ra ASC, dec ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR = 100, DATA_COMPRESSION=PAGE) ON [SPEC];
CREATE NONCLUSTERED INDEX [i_SpecObjAll_fluxObjID] ON [dbo].[SpecObjAll](fluxObjID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR = 100, DATA_COMPRESSION=PAGE) ON [SPEC];
CREATE NONCLUSTERED INDEX [i_SpecObjAll_htmID_ra_dec_cx_cy_] ON [dbo].[SpecObjAll](htmID ASC, ra ASC, dec ASC, cx ASC, cy ASC, cz ASC, sciencePrimary ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR = 100, DATA_COMPRESSION=PAGE) ON [SPEC];
CREATE NONCLUSTERED INDEX [i_SpecObjAll_ra_dec_class_plat] ON [dbo].[SpecObjAll](ra ASC, dec ASC, class ASC, plate ASC, tile ASC, z ASC, zErr ASC, sciencePrimary ASC, plateID ASC, bestObjID ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR = 100, DATA_COMPRESSION=PAGE) ON [SPEC];
CREATE NONCLUSTERED INDEX [i_SpecObjAll_targetObjID_sourceT] ON [dbo].[SpecObjAll](targetObjID ASC, sourceType ASC, sciencePrimary ASC, class ASC, htmID ASC, ra ASC, dec ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR = 100, DATA_COMPRESSION=PAGE) ON [SPEC];
ALTER TABLE [dbo].[SpecObjAll] ADD CONSTRAINT [pk_specObjAll_specObjID] PRIMARY KEY CLUSTERED ([specObjID] ASC) WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = ON, FILLFACTOR =100, DATA_COMPRESSION=PAGE) ON [SPEC];