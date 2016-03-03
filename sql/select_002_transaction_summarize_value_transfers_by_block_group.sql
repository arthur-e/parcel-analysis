-- Summarizes home prices in a transfer by year and by block group.
--CREATE OR REPLACE VIEW transactions_by_block_group AS
SELECT bg.geoid10 AS fips, tr.transfer_year,
       min(tr.sr_val_transfer) AS min_val_transfer,
       max(tr.sr_val_transfer) AS max_val_transfer,
       median(tr.sr_val_transfer) AS med_val_transfer
  INTO transactions_by_block_group
  FROM census2010_block_groups bg, transactions_geocoded tr
 WHERE ST_ContainsProperly(bg.geom, tr.geom)
 GROUP BY bg.geoid10, tr.transfer_year;