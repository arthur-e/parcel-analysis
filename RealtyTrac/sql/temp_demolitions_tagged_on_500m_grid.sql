-- Demolitions summarized by year on a 500m grid
SELECT grid.id AS ID, demos.*
  INTO _temp_demolitions_tagged_on_500m_grid_
  FROM neshap_demolitions AS demos, grid_500m AS grid
 WHERE ST_Intersects(grid.geom, demos.geom);