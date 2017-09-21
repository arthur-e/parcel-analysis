SELECT tr.pcl_id_iris_frmtd,
       ST_Transform(
         ST_SetSRID(
           ST_MakePoint(tr.property_level_longitude, tr.property_level_latitude),
           4326), 
         32617) AS geom,
       tr.recording_date,
       left(tr.recording_date::text, 4) AS recording_year, 
       right(left(tr.recording_date::text, 6), 2) AS recording_month,
       tr.document_type, tr.transaction_type, tr.pri_cat_code, 
       tr.mtg_sec_cat_codes_1x10, tr.deed_sec_cat_codes_2x10,
       tr.sale_date, tr.sale_amount, 
       left(tr.sale_date::text, 4) AS sale_year, 
       right(left(tr.sale_date::text, 6), 2) AS sale_month,
       tr.sale_amount * cpi.adjustment AS sale_amount_adj,
       tr.mortgage_amount, tr.mortgage_date,
       tr.mortgage_amount * cpi.adjustment AS mortgage_amount_adj,
       tr.mortgage_loan_type_code, tr.mortgage_deed_type,
       tr.property_indicator, tr.inter_family, tr.resale_or_new_construction,
       tr.cash_or_mortgage_purchase, tr.equity_flag
  INTO detroit.transactions_residential_adjusted
  FROM detroit.transactions tr
  LEFT JOIN public.cpi_u_housing_2010 cpi ON left(tr.recording_date::text, 4) = cpi.year::text
       -- For known residential properties (by use code)
 WHERE tr.property_indicator IN ('10', '11', '21')
       -- And for unknown types, "Miscellaneous" or blank, that are likely to be residential
    OR (tr.residential_model_indicator = 'Y' 
        AND (tr.property_indicator IN ('00', '') OR tr.property_indicator IS NULL));