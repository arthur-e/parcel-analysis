-- Creates a temporary, spatially explicit (geometry + attributes) table of transfers, corrected for inflation.

SELECT tr.fips, tr.transfer_year,
       tr.min_val_transfer, tr.min_val_transfer * cpi.adjustment AS min_val_adj, 
       tr.max_val_transfer, tr.max_val_transfer * cpi.adjustment AS max_val_adj,
       tr.med_val_transfer, tr.med_val_transfer * cpi.adjustment AS med_val_adj,
       bg.geom
  INTO _temp_
  FROM transactions_by_block_group tr
  JOIN census2010_block_groups bg ON tr.fips = bg.geoid10
  JOIN cpi_u_housing_2010 cpi ON tr.transfer_year = cpi.year::text;