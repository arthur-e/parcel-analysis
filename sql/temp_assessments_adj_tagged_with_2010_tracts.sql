-- Assessments summarized by year and 2010 tract
SELECT tracts.geoid10 AS FIPS, asm.*
  INTO _temp_assessments_tagged_with_2010_tracts_
  FROM assessments_parcel_characteristics_geocoded AS asm, census2010_tracts AS tracts
 WHERE ST_Intersects(tracts.geom, asm.geom);