-- Foreclosures summarized by year on a 500m grid
SELECT grid.id AS ID, asm.use_code_std, fc.*
  INTO _temp_foreclosures_tagged_on_500m_grid_
  FROM foreclosures_geocoded AS fc
  JOIN assessments AS asm ON asm.sa_property_id = fc.sa_property_id
  JOIN grid_500m AS grid ON ST_Intersects(grid.geom, fc.geom);