CREATE OR REPLACE VIEW transactions_residential AS 
SELECT t.*, a.use_code_std
  FROM transactions t
  JOIN assessments a ON t.sr_property_id = a.sa_property_id
 WHERE a.use_code_std LIKE 'R%';