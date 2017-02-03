CREATE TABLE _temp_assessments_in_hedonic_pricing_ AS
SELECT a.use_code_std,
       a.sa_val_transfer,
       a.sa_parcel_nbr_change_yr,
       a.mm_fips_county_name,
       right(left(a.sa_date_transfer::text, 6), 2) AS transfer_month,
       left(a.sa_date_transfer::text, 4) AS transfer_year,
       left(a.sa_date_transfer::text, 4)::int - a.sa_yr_blt AS years_until_last_sale,
       a.sa_yr_blt - a.sa_yr_blt_effect AS years_until_last_permit,
       a.sa_parcel_nbr_change_yr - a.sa_yr_blt AS years_until_last_conversion, -- Number of years (since built) before most recent "parcel conversion"
       a.sa_owner_1_trust_flag AS owner_is_trust,
       a.sa_owner_1_type AS owner_is_0individual_1company_2deceased,
       a.sa_company_flag AS owner_is_company,
       a.sa_site_city, a.sa_site_zip,
       --a.sa_mail_city, a.sa_mail_zip, -- Not enough variation
       a.assr_year AS year_last_assessed,
       --a.sa_appraise_yr, a.sa_appraise_val, -- Not enough variation
       --a.sa_val_appraise_land, a.sa_val_market_land, a.sa_val_market,
       a.sa_exemp_flag_2 AS has_disabled_tax_exemption,
       a.sa_exemp_flag_3 AS has_senior_tax_exemption,
       a.sa_exemp_flag_4 AS has_veteran_tax_exemption,
       a.sa_val_assd_prev AS last_assessed_value,
       a.sa_addtns_sqft, a.sa_architecture_code,
       a.sa_attic_sqft, a.sa_bldg_code, a.sa_bldg_shape_code,
       a.sa_bldg_sqft, a.sa_bsmt_2_code, a.sa_condition_code,
       a.sa_construction_code, a.sa_cool_code,
       a.sa_exterior_1_code, a.sa_fin_sqft_tot,
       a.sa_fireplace_code, a.sa_garage_carport,
       a.sa_heat_code, a.sa_lot_depth, a.sa_lot_width, a.sa_lotsize,
       a.sa_nbr_bath, a.sa_nbr_bath_full, a.sa_nbr_bath_dq,
       a.sa_nbr_bedrms, a.sa_nbr_rms, a.sa_nbr_stories,
       a.sa_nbr_units, a.sa_patio_porch_code, a.sa_pool_code,
       a.sa_roof_code, a.sa_sqft_assr_tot, a.sa_structure_code,
       a.sa_structure_nbr, a.sa_view_code, a.sa_yr_blt,
       a.sa_yr_blt_effect
  FROM assessments AS a
 WHERE (a.mm_fips_county_name IN ('Wayne', 'Oakland', 'Macomb') 
   AND a.sa_val_transfer > 0);