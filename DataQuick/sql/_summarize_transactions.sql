SELECT 'sr_buyer' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_buyer IS NOT NULL AND NOT sr_buyer = ''
UNION
SELECT 'sr_seller' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_seller IS NOT NULL AND NOT sr_seller = ''
UNION
SELECT 'sr_val_transfer' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_val_transfer IS NOT NULL AND sr_val_transfer > 0
UNION
SELECT 'sr_tax_transfer' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_tax_transfer IS NOT NULL AND sr_tax_transfer > 0
UNION
SELECT 'sr_doc_type' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_doc_type IS NOT NULL AND NOT sr_doc_type = ''
UNION
SELECT 'sr_deed_type' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_deed_type IS NOT NULL AND NOT sr_deed_type = ''
UNION
SELECT 'sr_tran_type' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_tran_type IS NOT NULL AND NOT sr_tran_type = ''
UNION
SELECT 'sr_arms_length_flag' AS field, count(*) AS total FROM transactions_residential
 WHERE sr_arms_length_flag IS NOT NULL AND NOT sr_arms_length_flag = ''
UNION
SELECT 'distress_indicator' AS field, count(*) AS total FROM transactions_residential
 WHERE distress_indicator IS NOT NULL AND NOT distress_indicator = '';
