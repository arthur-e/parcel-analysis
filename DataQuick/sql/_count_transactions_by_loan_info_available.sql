SELECT * FROM (
SELECT 'sr_loan_val_1' AS field, count(*) AS num_valid
  FROM transactions_geocoded_la_by_census2010_tracts
 WHERE sr_loan_val_1 > 0 AND sr_loan_val_1 IS NOT NULL
UNION
SELECT 'sr_loan_type_1' AS field, count(*) AS num_valid
  FROM transactions_geocoded_la_by_census2010_tracts
 WHERE NOT sr_loan_type_1 = '' AND sr_loan_type_1 IS NOT NULL
UNION
SELECT 'sr_loan_val_2' AS field, count(*) AS num_valid
  FROM transactions_geocoded_la_by_census2010_tracts
 WHERE sr_loan_val_2 > 0 AND sr_loan_val_2 IS NOT NULL
UNION
SELECT 'sr_loan_type_2' AS field, count(*) AS num_valid
  FROM transactions_geocoded_la_by_census2010_tracts
 WHERE NOT sr_loan_type_2 = '' AND sr_loan_type_2 IS NOT NULL
UNION
SELECT 'sr_loan_val_3' AS field, count(*) AS num_valid
  FROM transactions_geocoded_la_by_census2010_tracts
 WHERE sr_loan_val_3 > 0 AND sr_loan_val_3 IS NOT NULL
UNION
SELECT 'sr_loan_type_3' AS field, count(*) AS num_valid
  FROM transactions_geocoded_la_by_census2010_tracts
 WHERE NOT sr_loan_type_3 = '' AND sr_loan_type_3 IS NOT NULL) sq
ORDER BY field;