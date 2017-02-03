-- Foreclosures summarized by year and 2010 block group
SELECT bg.geoid10 AS FIPS, asm.use_code_std, fc.*
  INTO _temp_foreclosures_tagged_with_2010_block_groups_
  FROM foreclosures_geocoded AS fc
  JOIN assessments AS asm ON asm.sa_property_id = fc.sa_property_id
  JOIN census2010_block_groups AS bg ON ST_Intersects(bg.geom, fc.geom);