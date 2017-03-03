-- Transactions adjusted to 2010 dollars, labeled with 2000 Census tract FIPS code
SELECT tracts.fips AS fips, tr.*
  INTO transactions_geocoded_by_census2000_tracts
  FROM transactions_geocoded_adjusted AS tr, census2000_tracts AS tracts
 WHERE ST_Intersects(tracts.geom, tr.geom);