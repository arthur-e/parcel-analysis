-- Transactions adjusted to 2010 dollars, summarized by year and 2010 tract
SELECT tracts.geoid10 AS FIPS, tr.*
  INTO _temp_transactions_adj_tagged_with_2010_tracts_
  FROM transactions_by_year_adjusted AS tr, census2010_tracts AS tracts
 WHERE ST_Intersects(tracts.geom, tr.geom);