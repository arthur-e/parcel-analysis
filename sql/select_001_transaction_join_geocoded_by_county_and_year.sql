CREATE OR REPLACE VIEW transactions_geocoded AS (
SELECT t.sr_unique_id, t.sr_property_id, gc.score, t.sr_val_transfer, t.sr_tax_transfer, t.sr_full_part_code, t.sr_doc_type, t.sr_deed_type, t.sr_tran_type, t.sr_quitclaim,
       left(t.sr_date_transfer::text, 4) AS transfer_year, left(t.sr_date_filing::text, 4) AS filing_year, 
       ST_Transform(ST_SetSRID(ST_MakePoint(gc.x, gc.y), 4326), 32617) AS geom
  --INTO _temp_transactions_by_year_
  FROM transactions t
  JOIN geocoded gc ON t.sr_property_id = gc.property_id
 WHERE gc.score >= 80 AND t.sr_val_transfer > 0
   --AND t.sr_date_transfer >= 19940101 AND t.sr_date_transfer < 19950101
   --AND t.mm_fips_muni_code = 163 -- Wayne County 

 UNION
SELECT t.sr_unique_id, t.sr_property_id, gc2.score, t.sr_val_transfer, t.sr_tax_transfer, t.sr_full_part_code, t.sr_doc_type, t.sr_deed_type, t.sr_tran_type, t.sr_quitclaim,
       left(t.sr_date_transfer::text, 4) AS transfer_year, left(t.sr_date_filing::text, 4) AS filing_year, 
       ST_Transform(ST_SetSRID(ST_MakePoint(gc2.x, gc2.y), 4326), 32617) AS geom
  FROM transactions t
  JOIN geocoded_extra gc2 ON t.sr_property_id = gc2.property_id
 WHERE gc2.score > 0 AND t.sr_val_transfer > 0
   --AND t.mm_fips_muni_code = 163; -- Wayne County 
 )