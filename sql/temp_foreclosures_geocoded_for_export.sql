CREATE TABLE _temp_foreclosures_geocoded_wayne_ AS
SELECT fc.*, gc.x, gc.y
  FROM foreclosures fc
  JOIN geocoded gc ON fc.sa_property_id = gc.property_id
 WHERE gc.score >= 80 -- Accept geocodes with a score at or above 80
   AND fc.mm_fips_county_name IN ('Wayne', 'WAYNE')
 
 UNION
SELECT fc.*, gc2.x, gc2.y
  FROM foreclosures fc
  JOIN geocoded_extra gc2 ON fc.sa_property_id = gc2.property_id
 WHERE gc2.score > 0 -- In second round, any non-zero score is a good geocode
   AND fc.mm_fips_county_name IN ('Wayne', 'WAYNE');