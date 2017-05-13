-- Transactions adjusted to 2010 dollars, labeled with 2010 Census tract FIPS code
SELECT tracts.fips AS fips, a.*
  INTO assessments_geocoded_la_by_census2010_tracts
  FROM assessments_geocoded AS a, census2010_tracts AS tracts
 WHERE ST_Intersects(tracts.geom, a.geom) AND a.mm_fips_county_name = 'LOS ANGELES';