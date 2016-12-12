-- Assessments summarized by year and 2010 block group
SELECT bg.geoid10 AS FIPS, asm.*
  INTO _temp_assessments_tagged_with_2010_block_groups_
  FROM assessments_parcel_characteristics_geocoded AS asm, census2010_block_groups AS bg
 WHERE ST_Intersects(bg.geom, asm.geom);