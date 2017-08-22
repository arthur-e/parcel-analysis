-- Assessments summarized by year and 2000 block group
SELECT bg.id AS ID, asm.*
  INTO _temp_assessments_tagged_on_1500m_grid_
  FROM assessments_parcel_characteristics_geocoded AS asm, grid_1500m AS bg
 WHERE ST_Intersects(bg.geom, asm.geom);