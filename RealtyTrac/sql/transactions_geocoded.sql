-- Joins the two geocoding result tables to the transactions
-- for those geocoding results that scored 80 or better in the first round
-- or zero (0) or better in the second round.
CREATE OR REPLACE VIEW transactions_geocoded AS (
SELECT t.sr_unique_id, t.sr_property_id, gc.score, t.sr_val_transfer, t.sr_tax_transfer, t.sr_full_part_code, t.sr_doc_type, t.sr_deed_type, t.sr_tran_type, t.sr_quitclaim, t.mm_fips_county_name,
       t.sr_date_transfer,
       left(t.sr_date_transfer::text, 4) AS transfer_year, 
       right(left(t.sr_date_transfer::text, 6), 2) AS transfer_month,
       left(t.sr_date_filing::text, 4) AS filing_year, 
       left(t.sr_date_transfer::text, 4) || right(left(sr_date_transfer::text, 6), 2) AS transfer_date_key,
       ST_Transform(ST_SetSRID(ST_MakePoint(gc.x, gc.y), 4326), 32617) AS geom
  FROM transactions t
  JOIN geocoded gc ON t.sr_property_id = gc.property_id -- First round results
 WHERE gc.score >= 80 AND t.sr_val_transfer > 0

 UNION
SELECT t.sr_unique_id, t.sr_property_id, gc2.score, t.sr_val_transfer, t.sr_tax_transfer, t.sr_full_part_code, t.sr_doc_type, t.sr_deed_type, t.sr_tran_type, t.sr_quitclaim, t.mm_fips_county_name,
       t.sr_date_transfer,
       left(t.sr_date_transfer::text, 4) AS transfer_year, 
       right(left(t.sr_date_transfer::text, 6), 2) AS transfer_month,
       left(t.sr_date_filing::text, 4) AS filing_year, 
       left(t.sr_date_transfer::text, 4) || right(left(sr_date_transfer::text, 6), 2) AS transfer_date_key,
       ST_Transform(ST_SetSRID(ST_MakePoint(gc2.x, gc2.y), 4326), 32617) AS geom
  FROM transactions t
  JOIN geocoded_extra gc2 ON t.sr_property_id = gc2.property_id -- Second round results
 WHERE gc2.score > 0 AND t.sr_val_transfer > 0
)