-- Creates a spatially explicit table of sale prices adjusted to 2010 dollars
SELECT a.use_code_std, a.sa_sqft, sq.*
 INTO transactions_geocoded_adjusted
 FROM (SELECT tr.*, 
       -- CPI-U adjustment to 2010 dollars
       sr_val_transfer * cpi.adjustment AS sr_val_transfer_adj, 
       sr_tax_transfer * cpi.adjustment AS sr_tax_transfer_adj,
       sr_loan_val_1 *  cpi.adjustment AS sr_loan_val_1_adj,
       sr_loan_val_2 *  cpi.adjustment AS sr_loan_val_2_adj,
       sr_loan_val_3 *  cpi.adjustment AS sr_loan_val_3_adj
  FROM transactions_geocoded tr
  JOIN cpi_u_housing_2010 cpi ON tr.transfer_year = cpi.year::text) AS sq
  JOIN assessments a ON a.sa_property_id = sq.sr_property_id;
 --WHERE a.use_code_std LIKE 'R%'; -- Residential properties only
