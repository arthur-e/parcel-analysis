SELECT asm.p_id_iris_frmtd, 
       grid.id AS grid_2000m_id
  INTO detroit.lookup_summary_area_by_property_id
  FROM detroit.assessments asm,
       detroit.grid_2000m grid
 WHERE ST_Intersects(grid.geom, 
         ST_Transform(
            ST_SetSRID(
               ST_Point(asm.property_level_longitude, asm.property_level_latitude), 
            4326),
         32617));