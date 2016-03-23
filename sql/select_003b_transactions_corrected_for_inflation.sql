-- Creates a temporary, spatially explicit table of adjusted prices (up to year 2010 ONLY).
SELECT sr_property_id, score, mm_fips_county_name, 
       sr_val_transfer * cpi.adjustment AS sr_val_transfer_adj, 
       sr_tax_transfer * cpi.adjustment AS sr_tax_transfer_adj, 
       sr_full_part_code, 
       transfer_year, filing_year, geom
  INTO _temp_transactions_by_year_adjusted_
  FROM transactions_geocoded tr
  JOIN cpi_u_housing_2010 cpi ON tr.transfer_year = cpi.year::text;
