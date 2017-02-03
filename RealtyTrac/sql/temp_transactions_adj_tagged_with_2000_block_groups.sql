-- Transactions adjusted to 2010 dollars, summarized by year and 2000 block group
SELECT bg.bkgpidfp00 AS FIPS, tr.*
  INTO _temp_transactions_adj_tagged_with_2000_block_groups_
  FROM transactions_by_year_adjusted AS tr, census2000_block_groups AS bg
 WHERE ST_Intersects(bg.geom, tr.geom);