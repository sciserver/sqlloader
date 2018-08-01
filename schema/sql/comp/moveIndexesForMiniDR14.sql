

CREATE UNIQUE CLUSTERED INDEX [pk_apogeeDesign_designid] ON [dbo].[apogeeDesign](designid ASC) 
 
CREATE UNIQUE CLUSTERED INDEX [pk_apogeeField_location_id] ON [dbo].[apogeeField](location_id ASC) 

CREATE UNIQUE CLUSTERED INDEX [pk_spiders_quasar_name] ON [dbo].[spiders_quasar](name ASC) 
 
CREATE UNIQUE CLUSTERED INDEX [pk_Zone_zoneID_ra_objID] ON [dbo].[Zone](zoneID ASC, ra ASC, objID ASC) 
 

CREATE NONCLUSTERED INDEX [i_SpecPhotoAll_objID_sciencePrim] ON [dbo].[SpecPhotoAll](objID ASC, sciencePrimary ASC, class ASC, z ASC, targetObjID ASC) 
 
CREATE NONCLUSTERED INDEX [i_SpecPhotoAll_targetObjID_scien] ON [dbo].[SpecPhotoAll](targetObjID ASC, sciencePrimary ASC, class ASC, z ASC, objID ASC) 
 