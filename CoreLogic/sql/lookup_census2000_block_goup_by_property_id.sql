SELECT asm.p_id_iris_frmtd, 
       cb.state || cb.county || cb.tract || lpad(cb.blkgroup, 3, '0') AS FIPS
  INTO detroit.lookup_census2000_block_group_by_property_id
  FROM detroit.assessments asm,
       detroit.census2000_block_groups cb
 WHERE ST_Intersects(cb.geom, 
         ST_Transform(
            ST_SetSRID(
               ST_Point(asm.property_level_longitude, asm.property_level_latitude), 
            4326),
         32617));