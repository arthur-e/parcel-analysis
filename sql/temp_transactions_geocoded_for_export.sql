-- Joins the two geocoding result tables to the transactions
-- for those geocoding results that scored 80 or better in the first round
-- or zero (0) or better in the second round.
CREATE TABLE _temp_transactions_geocoded_wayne_ AS (
SELECT gc.x AS longitude, gc.y AS latitude, t.*
  FROM transactions t
  JOIN geocoded gc ON t.sr_property_id = gc.property_id -- First round results
 WHERE gc.score >= 80
   AND t.mm_fips_county_name IN ('WAYNE', 'Wayne')
   
 UNION
SELECT gc2.x AS longitude, gc2.y AS latitude, t.*
  FROM transactions t
  JOIN geocoded_extra gc2 ON t.sr_property_id = gc2.property_id -- Second round results
 WHERE gc2.score > 0
   AND t.mm_fips_county_name IN ('WAYNE', 'Wayne'))