SELECT asm.p_id_iris_frmtd, 
       cb.geoid10 AS FIPS
  INTO detroit.lookup_census2010_block_by_property_id
  FROM detroit.assessments asm,
       detroit.census2010_blocks cb
 WHERE ST_Intersects(cb.geom, 
         ST_Transform(
            ST_SetSRID(
               ST_Point(asm.property_level_longitude, asm.property_level_latitude), 
            4326),
         32617));