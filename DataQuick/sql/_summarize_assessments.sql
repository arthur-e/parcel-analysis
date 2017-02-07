-- Records for each year built
--SELECT sa_yr_blt, count(*)
--  FROM assessments
-- WHERE sa_yr_blt > 1800 OR sa_yr_blt IS NULL
-- GROUP BY sa_yr_blt
-- ORDER BY sa_yr_blt

SELECT 'sa_yr_blt' AS field, count(*) AS total FROM assessments
 WHERE sa_yr_blt > 1800 AND sa_yr_blt IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_structure_code' AS field, count(*) FROM assessments
 WHERE NOT sa_structure_code = '' AND sa_structure_code IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_sqft' AS field, count(*) FROM assessments
 WHERE sa_sqft IS NOT NULL AND sa_sqft > 0
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_nbr_rms' AS field, count(*) FROM assessments
 WHERE sa_nbr_rms IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_garage_carport' AS field, count(*) FROM assessments
 WHERE NOT sa_garage_carport = '' AND sa_garage_carport IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_construction_qlty' AS field, count(*) FROM assessments
 WHERE sa_construction_qlty IS NOT NULL AND sa_construction_qlty > 0
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_bldg_code' AS field, count(*) FROM assessments
 WHERE sa_bldg_code IS NOT NULL AND NOT sa_bldg_code = ''
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_tax_val' AS field, count(*) FROM assessments
 WHERE sa_tax_val IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_val_full_cash' AS field, count(*) FROM assessments
 WHERE sa_val_full_cash IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_val_market' AS field, count(*) FROM assessments
 WHERE sa_val_market IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_appraise_val' AS field, count(*) FROM assessments
 WHERE sa_appraise_val IS NOT NULL
   AND use_code_std LIKE 'R%'
UNION
SELECT 'sa_val_assd' AS field, count(*) FROM assessments
 WHERE sa_val_assd IS NOT NULL
   AND use_code_std LIKE 'R%';
