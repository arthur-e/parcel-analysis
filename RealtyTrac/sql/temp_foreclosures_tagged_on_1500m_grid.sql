-- Foreclosures summarized by year on a 1500-m grid
SELECT bg.id AS ID, asm.use_code_std, fc.*
  INTO _temp_foreclosures_tagged_on_1500m_grid_
  FROM foreclosures_geocoded AS fc
  JOIN assessments AS asm ON asm.sa_property_id = fc.sa_property_id
  JOIN grid_1500m AS bg ON ST_Intersects(bg.geom, fc.geom);