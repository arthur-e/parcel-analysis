-- Foreclosures summarized by year and 2010 block group
SELECT bg.geoid10 AS FIPS, fc.*
  INTO _temp_foreclosures_tagged_with_2010_block_groups_
  FROM foreclosures_geocoded AS fc, census2010_block_groups AS bg
 WHERE ST_Intersects(bg.geom, fc.geom);