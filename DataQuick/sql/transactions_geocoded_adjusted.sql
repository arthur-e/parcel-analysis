-- Creates a spatially explicit table of sale prices adjusted to 2010 dollars
SELECT a.use_code_std, a.sa_sqft, tr.*,
       -- CPI-U adjustment to 2010 dollars
       sr_val_transfer * cpi.adjustment AS sr_val_transfer_adj, 
       sr_tax_transfer * cpi.adjustment AS sr_tax_transfer_adj,
       sr_loan_val_1 *  cpi.adjustment AS sr_loan_val_1_adj,
       sr_loan_val_2 *  cpi.adjustment AS sr_loan_val_2_adj,
       sr_loan_val_3 *  cpi.adjustment AS sr_loan_val_3_adj
  INTO transactions_geocoded_adjusted_los_angeles
  FROM transactions_geocoded tr
  JOIN cpi_u_housing_2010 cpi ON tr.transfer_year = cpi.year::text
  JOIN assessments a ON a.sa_property_id = tr.sr_property_id
 WHERE tr.mm_fips_county_name = 'LOS ANGELES';
 --WHERE a.use_code_std LIKE 'R%'; -- Residential properties only
