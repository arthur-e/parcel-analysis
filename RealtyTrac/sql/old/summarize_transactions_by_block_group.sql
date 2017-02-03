-- Transactions adjusted to 2010 dollars, summarized by year and 2010 block group
SELECT bg.geoid10 AS FIPS, tr.transfer_year,
       count(*) AS record_count,
       min(tr.sr_val_transfer_adj) AS min_val_transfer,
       max(tr.sr_val_transfer_adj) AS max_val_transfer,
       max(tr.sr_val_transfer_adj) - min(tr.sr_val_transfer_adj) AS range_val_transfer,
       median(tr.sr_val_transfer_adj) AS median_val_transfer,
       min(tr.sr_tax_transfer_adj) AS min_tax_transfer,
       max(tr.sr_tax_transfer_adj) AS max_tax_transfer,
       max(tr.sr_tax_transfer_adj) - min(tr.sr_tax_transfer_adj) AS range_tax_transfer,
       median(tr.sr_tax_transfer_adj) AS median_tax_transfer
  INTO transactions_adj_by_2010_block_groups
  FROM _temp_transactions_by_year_adjusted_ AS tr, census2010_block_groups AS bg
 WHERE ST_Contains(bg.geom, tr.geom)
 GROUP BY bg.geoid10, tr.transfer_year;