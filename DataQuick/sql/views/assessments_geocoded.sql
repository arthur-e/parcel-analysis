CREATE OR REPLACE VIEW assessments_geocoded AS (
SELECT a.*,
       -- NOTE: DataQuick geocodes stored positive West longitudes...
       ST_Transform(ST_SetSRID(ST_MakePoint(-gc.sa_x_coord, gc.sa_y_coord), 4326), 26911) AS geom
  FROM assessments a
  JOIN geocoding_index gc ON a.sa_property_id = gc.sa_property_id)