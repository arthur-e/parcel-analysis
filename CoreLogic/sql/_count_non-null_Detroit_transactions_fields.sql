SELECT * FROM (
SELECT 'fips' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE fips IS NOT NULL
UNION
SELECT 'property_level_latitude' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE property_level_latitude IS NOT NULL
UNION
SELECT 'property_level_longitude' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE property_level_longitude IS NOT NULL
UNION
SELECT 'sale_amount' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE sale_amount IS NOT NULL
UNION
SELECT 'sale_date' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE sale_date IS NOT NULL
UNION
SELECT 'recording_date' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE recording_date IS NOT NULL
UNION
SELECT 'mortgage_amount' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE mortgage_amount IS NOT NULL
UNION
SELECT 'mortgage_date' AS field, count(*) AS total
  FROM detroit.transactions
 WHERE mortgage_date IS NOT NULL;)
 ORDER BY field;