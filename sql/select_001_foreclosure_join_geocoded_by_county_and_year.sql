CREATE OR REPLACE VIEW foreclosures_geocoded AS (
SELECT fc.recording_date, fc.record_type, fc.unique_id_notice, fc.mm_fips_county_name, fc.mm_fips_muni_code, fc.doc_type, fc.ft_site_city, fc.ft_site_zip, fc.fd_delinquent_date, fc.fd_nod_t_auct_date, fc.ft_not_sale_date,
       left(fc.recording_date::text, 4) AS recording_year, 
       ST_Transform(ST_SetSRID(ST_MakePoint(gc.x, gc.y), 4326), 32617) AS geom
  FROM foreclosures fc
  JOIN geocoded gc ON fc.sa_property_id = gc.property_id
 WHERE gc.score >= 80 -- Accept geocodes with a score at or above 80
 
 UNION
SELECT fc.recording_date, fc.record_type, fc.unique_id_notice, fc.mm_fips_county_name, fc.mm_fips_muni_code, fc.doc_type, fc.ft_site_city, fc.ft_site_zip, fc.fd_delinquent_date, fc.fd_nod_t_auct_date, fc.ft_not_sale_date,
       left(fc.recording_date::text, 4) AS recording_year, 
       ST_Transform(ST_SetSRID(ST_MakePoint(gc2.x, gc2.y), 4326), 32617) AS geom
  FROM foreclosures fc
  JOIN geocoded_extra gc2 ON fc.sa_property_id = gc2.property_id
 WHERE gc2.score > 0 -- In second round, any non-zero score is a good geocode
 )