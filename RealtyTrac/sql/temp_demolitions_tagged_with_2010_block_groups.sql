-- Demolitions summarized by year on a 500m grid
SELECT bg.geoid10 AS FIPS, demos.*
  INTO _temp_demolitions_tagged_with_2010_block_groups_
  FROM neshap_demolitions AS demos, census2010_block_groups AS bg
 WHERE ST_Intersects(bg.geom, demos.geom);