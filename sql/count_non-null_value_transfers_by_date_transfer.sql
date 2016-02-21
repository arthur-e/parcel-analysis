SELECT sr_date_transfer, COUNT(sr_val_transfer)
  FROM transactions
 WHERE sr_val_transfer IS NOT NULL
 GROUP BY sr_date_transfer ORDER BY sr_date_transfer;
