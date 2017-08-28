CREATE OR REPLACE VIEW assessments_geocoded AS (
SELECT lk.fips2010, lk.fips2000, lk.fips1990, sq.* 
  FROM (
SELECT a.*,
       -- NOTE: DataQuick geocodes stored positive West longitudes...
       ST_Transform(ST_SetSRID(ST_MakePoint(-gc.sa_x_coord, gc.sa_y_coord), 4326), 26911) AS geom
  FROM assessments a
  JOIN geocoding_index gc ON a.sa_property_id = gc.sa_property_id
  ) sq
  LEFT OUTER JOIN lookup_census_tract_by_property_id lk
    ON sq.sa_property_id = lk.sr_property_id);