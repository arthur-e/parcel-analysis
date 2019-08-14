SELECT asm.p_id_iris_frmtd, 
       cb.st || cb.co || cb.tract || cb.bg AS FIPS
  INTO detroit.lookup_census1990_block_group_by_property_id
  FROM detroit.assessments asm,
       detroit.census1990_block_groups cb
 WHERE ST_Intersects(cb.geom, 
         ST_Transform(
            ST_SetSRID(
               ST_Point(asm.property_level_longitude, asm.property_level_latitude), 
            4326),
         32617));