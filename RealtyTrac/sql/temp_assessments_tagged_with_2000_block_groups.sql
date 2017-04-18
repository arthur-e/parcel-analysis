-- Assessments summarized by year and 2000 block group
SELECT bg.bkgpidfp00 AS FIPS, asm.*
  INTO _temp_assessments_tagged_with_2000_block_groups_
  FROM assessments_parcel_characteristics_geocoded AS asm, census2000_block_groups AS bg
 WHERE ST_Intersects(bg.geom, asm.geom);