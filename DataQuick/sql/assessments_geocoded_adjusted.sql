-- Creates a spatially explicit table of RESIDENTIAL sale prices adjusted to 2010 dollars
CREATE OR REPLACE VIEW assessments_geocoded_adjusted AS
SELECT a.use_code_std, a.sa_sqft, sq.*
 FROM (SELECT a.*, 
       -- CPI-U adjustment to 2010 dollars
       sa_val_assd * cpi.adjustment AS sa_val_assd_adj, 
       sa_val_assd_land * cpi.adjustment AS sa_val_assd_land_adj,
       sa_val_assd_improv * cpi.adjustment AS sa_val_assd_improv_adj,
       sa_appraise_val * cpi.adjustment AS sa_appraise_val_adj,
       sa_val_appraise_land * cpi.adjustment AS sa_val_appraise_land_adj,
       sa_val_appraise_improv * cpi.adjustment AS sa_val_appraise_improv_adj,
       sa_val_market * cpi.adjustment AS sa_val_market_adj
  FROM assessments_geocoded a
  -- NOTE: About 225,000 properties have a null or "0" appraisal year...
  JOIN cpi_u_housing_2010 cpi ON a.sa_appraise_yr = cpi.year::text) AS sq
 WHERE a.use_code_std LIKE 'R%'; -- Residential properties only
