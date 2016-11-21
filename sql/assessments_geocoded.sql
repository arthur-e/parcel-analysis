CREATE OR REPLACE VIEW assessments_geocoded AS (
SELECT asm.*,
       ST_Transform(ST_SetSRID(ST_MakePoint(gc.x, gc.y), 4326), 32617) AS geom
  FROM assessments asm
  JOIN geocoded gc ON asm.sa_property_id = gc.property_id
 WHERE gc.score >= 80 -- Accept geocodes with a score at or above 80
 
 UNION
SELECT asm.*,
       ST_Transform(ST_SetSRID(ST_MakePoint(gc2.x, gc2.y), 4326), 32617) AS geom
  FROM assessments asm
  JOIN geocoded_extra gc2 ON asm.sa_property_id = gc2.property_id
 WHERE gc2.score > 0 -- In second round, any non-zero score is a good geocode
 )