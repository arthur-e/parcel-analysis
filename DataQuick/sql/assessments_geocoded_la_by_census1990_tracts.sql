-- Transactions adjusted to 2010 dollars, labeled with 1990 Census tract FIPS code
SELECT tracts.fips AS fips, a.*
  INTO assessments_geocoded_la_by_census1990_tracts
  FROM assessments_geocoded AS a, census1990_tracts AS tracts
 WHERE ST_Intersects(tracts.geom, a.geom) AND a.mm_fips_county_name = 'LOS ANGELES';