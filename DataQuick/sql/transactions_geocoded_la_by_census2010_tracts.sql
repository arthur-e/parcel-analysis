-- Transactions adjusted to 2010 dollars, labeled with 2010 Census tract FIPS code
SELECT tracts.fips AS fips, tr.*
  INTO transactions_geocoded_la_by_census2010_tracts
  FROM transactions_geocoded_adjusted AS tr, census2010_tracts AS tracts
 WHERE ST_Intersects(tracts.geom, tr.geom) AND tr.mm_fips_county_name = 'LOS ANGELES';