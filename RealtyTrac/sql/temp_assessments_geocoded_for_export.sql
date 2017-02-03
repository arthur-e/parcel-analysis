CREATE TABLE _temp_assessments_geocoded_wayne_ AS (
SELECT gc.x, gc.y, asm.*
  FROM assessments asm
  JOIN geocoded gc ON asm.sa_property_id = gc.property_id
 WHERE gc.score >= 80 -- Accept geocodes with a score at or above 80
   AND asm.mm_fips_county_name IN ('Wayne', 'WAYNE')
 
 UNION
SELECT gc2.x, gc2.y, asm.*
  FROM assessments asm
  JOIN geocoded_extra gc2 ON asm.sa_property_id = gc2.property_id
 WHERE gc2.score > 0
   AND asm.mm_fips_county_name IN ('Wayne', 'WAYNE') -- In second round, any non-zero score is a good geocode
 )