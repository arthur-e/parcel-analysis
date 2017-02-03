-- Foreclosures adjusted to 2010 dollars, summarized by year and 2010 tract
SELECT tracts.geoid10 AS FIPS, fc.*
  INTO _temp_foreclosures_tagged_with_2010_tracts_
  FROM foreclosures_geocoded AS fc, census2010_tracts AS tracts
 WHERE ST_Intersects(tracts.geom, fc.geom);