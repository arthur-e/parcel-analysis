-- Creates a spatially explicit table of sale prices adjusted to 2010 dollars
CREATE TABLE transactions_residential_adjusted AS
SELECT a.use_code_std, sq.sr_property_id, sq.score, sq.mm_fips_county_name,
       sq.sr_val_transfer_adj, sq.sr_tax_transfer_adj, sq.sr_date_transfer,
       sq.sr_full_part_code, sq.transfer_year, sq.filing_year, sq.geom
       --INTO _temp_transactions_by_year_adjusted_
 FROM (SELECT sr_property_id, score, mm_fips_county_name, 
       sr_val_transfer * cpi.adjustment AS sr_val_transfer_adj, 
       sr_tax_transfer * cpi.adjustment AS sr_tax_transfer_adj, 
       sr_full_part_code, sr_date_transfer,
       transfer_year, filing_year, geom
  FROM transactions_geocoded tr
  JOIN cpi_u_housing_2010 cpi ON tr.transfer_year = cpi.year::text) AS sq
  JOIN assessments a ON a.sa_property_id = sq.sr_property_id
 WHERE a.use_code_std LIKE 'R%';
