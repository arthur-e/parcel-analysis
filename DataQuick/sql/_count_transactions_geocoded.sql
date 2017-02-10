SELECT left(t.sr_date_transfer::text, 4) AS transfer_year, count(*)
  FROM transactions t
  JOIN geocoding_index gc ON t.sr_property_id = gc.sa_property_id
 WHERE t.sr_val_transfer IS NOT NULL AND t.sr_val_transfer > 0
 GROUP BY transfer_year
 ORDER BY transfer_year;