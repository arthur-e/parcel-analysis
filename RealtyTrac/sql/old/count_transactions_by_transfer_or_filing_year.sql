CREATE OR REPLACE VIEW transactions_nonzero_by_county_and_year AS (
SELECT mm_fips_county_name AS county, sq.transfer_year, COUNT(sq.sr_unique_id) FROM (
SELECT sr_unique_id, mm_fips_county_name,
       left(sr_date_transfer::text, 4) AS transfer_year, 
       left(sr_date_filing::text, 4) AS filing_year
  FROM transactions
 WHERE sr_val_transfer > 0) sq
 GROUP BY mm_fips_county_name, sq.transfer_year
 ORDER BY mm_fips_county_name, sq.transfer_year
);