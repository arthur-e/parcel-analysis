CREATE OR REPLACE VIEW assessments_parcel_characteristics_geocoded AS
SELECT sa_property_id, use_code_std, lot_size_sqft, sa_bldg_sqft, built_area_sqft, net_unbuilt_area_sqft, garage_present, garage_attached, garage_detached, pool_present, year_built, year_improved,
       ST_Transform(ST_SetSRID(ST_MakePoint(gc.x, gc.y), 4326), 32617) AS geom
  FROM assessments_parcel_characteristics a
  JOIN geocoded gc ON a.sa_property_id = gc.property_id
 WHERE gc.score >= 80
 
 UNION
SELECT sa_property_id, use_code_std, lot_size_sqft, sa_bldg_sqft, built_area_sqft, net_unbuilt_area_sqft, garage_present, garage_attached, garage_detached, pool_present, year_built, year_improved,
       ST_Transform(ST_SetSRID(ST_MakePoint(gc2.x, gc2.y), 4326), 32617) AS geom
  FROM assessments_parcel_characteristics a
  JOIN geocoded_extra gc2 ON a.sa_property_id = gc2.property_id
 WHERE gc2.score > 0;