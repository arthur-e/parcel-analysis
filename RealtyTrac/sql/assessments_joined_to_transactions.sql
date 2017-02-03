SELECT sa_val_transfer FROM assessments WHERE sa_val_transfer IS NOT NULL LIMIT 100;
-- Transactions adjusted to 2010 dollars, summarized by year and 2010 block group
SELECT tr.sr_val_transfer_adj,
       tr.transfer_year,
       tr.transfer_year - a.sa_yr_blt AS years_until_last_sale,
       tr.transfer_year - a.sa_yr_blt_effect AS years_until_last_permit,
       a.sa_parcel_nbr_change_yr - a.sa_yr_blt AS years_until_last_conversion, -- Number of years (since built) before most recent "parcel conversion"
       a.sa_owner_1_trust_flag AS owner_is_trust,
       a.sa_owner_1_type AS owner_is_0individual_1company_2deceased,
       a.sa_company_flag AS owner_is_company,
       a.sa_site_city, a.sa_site_zip,
       a.sa_mail_city, a.sa_mail_zip,
       a.assr_year AS year_last_assessed,
       a.sa_appraise_yr, a.sa_appraise_val,
       --a.sa_val_appraise_land, a.sa_val_market_land, a.sa_val_market,
       a.sa_exemp_flag_2 AS has_disabled_tax_exemption,
       a.sa_exemp_flag_3 AS has_senior_tax_exemption,
       a.sa_exemp_flag_4 AS has_veteran_tax_exemption,
       a.sa_val_assd_prev AS last_assessed_value,
       a.sa_addtns_sqft, a.sa_architecture_code,
       a.sa_attic_sqft, a.sa_bldg_code, a.sa_bldg_shape_code,
       a.sa_bldg_sqft, a.sa_bsmt_2_code, a.sa_condition_code,
       a.sa_construction_code, a.sa_cool_code,
       a.sa_exterior_1_code, a.sa_fin_sqft_total,
       a.sa_fireplace_code, a.sa_garage_carport,
       a.sa_heat_code, a.sa_lot_depth, a.sa_lot_width, a.sa_lot_size,
       a.sa_nbr_bath, a.sa_nbr_bath_full, a.sa_nbr_bath_dq,
       a.sa_nbr_bedrms, a.sa_nbr_rms, a.sa_nbr_stories,
       a.sa_nbr_units, a.sa_patio_porch_code, a.sa_pool_code,
       a.sa_roof_code, a.sa_sqft_assr_total, a.sa_structure_code,
       a.sa_structure_nbr, a.sa_view_code, a.sa_yr_blt,
       a.sa_yr_blt_effect,
  FROM transactions_by_year_adjusted AS tr
 WHERE tr.mm_fips_county_name IN ('WAYNE', 'OAKLAND', 'MACOMB')
   AND a.assr_year::int => (tr.transfer_year::int - 1) -- Require that assessments represent last sale
  JOIN assessments AS a
    ON a.sa_property_id = tr.sr_property_id;