CREATE OR REPLACE VIEW assessments_parcel_characteristics AS
SELECT sa_property_id, 
       use_code_std, 
       sa_lotsize AS lot_size_sqft, 
       sa_bldg_sqft,
       sa_sqft_assr_tot AS built_area_sqft,
       CASE WHEN sa_sqft_assr_tot > 0 THEN sa_lotsize - sa_sqft_assr_tot
            WHEN sa_bldg_sqft > 0 THEN sa_lotsize - sa_bldg_sqft
            WHEN sa_fin_sqft_tot > 0 THEN sa_lotsize - sa_fin_sqft_tot
            ELSE 0 END AS net_unbuilt_area_sqft,
       CASE WHEN left(sa_garage_carport, 1) IN ('C', 'G') THEN 1 
            ELSE 0 END AS garage_present,
       CASE WHEN right(left(sa_garage_carport, 2), 1) = 'A' THEN 1 
            ELSE 0 END AS garage_attached,
       CASE WHEN right(left(sa_garage_carport, 2), 1) = 'D' THEN 1 
            ELSE 0 END AS garage_detached,
       CASE WHEN NOT sa_pool_code = '0' AND sa_pool_code IS NOT NULL
            THEN 1 ELSE 0 END AS pool_present,
       -- Additional measures that may be interesting
       sa_yr_blt AS year_built, 
       sa_yr_blt_effect AS year_improved
  FROM assessments