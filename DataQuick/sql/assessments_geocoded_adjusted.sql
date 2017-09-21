-- Creates a spatially explicit table of RESIDENTIAL sale prices adjusted to 2010 dollars
SELECT a.*, 
  -- CPI-U adjustment to 2010 dollars
  a.sa_val_assd * cpi.adjustment AS sa_val_assd_adj, 
  a.sa_val_assd_land * cpi.adjustment AS sa_val_assd_land_adj,
  a.sa_val_assd_imprv * cpi.adjustment AS sa_val_assd_imprv_adj,
  a.sa_appraise_val * cpi.adjustment AS sa_appraise_val_adj,
  a.sa_val_appraise_land * cpi.adjustment AS sa_val_appraise_land_adj,
  a.sa_val_appraise_imprv * cpi.adjustment AS sa_val_appraise_imprv_adj,
  a.sa_val_market * cpi.adjustment AS sa_val_market_adj
  INTO assessments_geocoded_adjusted_los_angeles
  FROM assessments_geocoded a
  -- NOTE: About 225,000 properties have a null or "0" appraisal year...
  JOIN cpi_u_housing_2010 cpi ON a.sa_appraise_yr = cpi.year
 WHERE a.mm_fips_county_name = 'LOS ANGELES';
 --WHERE a.use_code_std LIKE 'R%'; -- Residential properties only
