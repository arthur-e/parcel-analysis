-- Creates a spatially explicit geocoding layer: Where records have Point geometry
CREATE OR REPLACE VIEW geocoding_index_spatial AS
-- Create with NAD83 unprojected; project to UTM Zone 11N
SELECT gc.sa_property_id, ST_Transform(
    ST_SetSRID(
      ST_MakePoint(-gc.sa_x_coord, gc.sa_y_coord), 4269), 26911)::geometry(POINT, 26911) AS geom
  FROM geocoding_index gc;

--SELECT UpdateGeometrySRID('public', 'geocoding_index_spatial', 'geom', 26911);