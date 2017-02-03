-- Creates a spatially explicit table of sale prices adjusted to January, 2010 dollars
CREATE TABLE transactions_by_month_adjusted AS
SELECT a.use_code_std, sq.sr_property_id, sq.score, sq.mm_fips_county_name,
       sq.sr_val_transfer_adj, sq.sr_tax_transfer_adj, sq.sr_date_transfer,
       sq.sr_full_part_code, sq.transfer_year, sq.transfer_month, sq.transfer_date_key,
       sq.filing_year, sq.geom
 FROM (SELECT tr.sr_property_id, tr.score, tr.mm_fips_county_name, 
       tr.sr_val_transfer * cpi.adjustment AS sr_val_transfer_adj, 
       tr.sr_tax_transfer * cpi.adjustment AS sr_tax_transfer_adj, 
       tr.sr_full_part_code, tr.sr_date_transfer, 
       tr.transfer_month, tr.transfer_year, tr.transfer_date_key,
       tr.filing_year, tr.geom
  FROM transactions_geocoded tr
  JOIN cpi_u_housing_monthly_2010 cpi ON tr.transfer_date_key = cpi.key::text) AS sq
  JOIN assessments a ON a.sa_property_id = sq.sr_property_id;
