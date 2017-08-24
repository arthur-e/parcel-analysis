SELECT sq.sr_property_id,
       tracts2010.fips AS fips2010, 
       tracts2000.fips AS fips2000,
       tracts1990.fips AS fips1990
  INTO lookup_census_tract_by_property_id
  FROM (
  SELECT DISTINCT tr.sr_property_id, tr.geom
    FROM transactions_geocoded AS tr
   WHERE tr.mm_fips_county_name = 'LOS ANGELES') sq

  JOIN census2010_tracts AS tracts2010 ON ST_Intersects(tracts2010.geom, sq.geom)
  JOIN census2000_tracts AS tracts2000 ON ST_Intersects(tracts2000.geom, sq.geom)
  JOIN census1990_tracts AS tracts1990 ON ST_Intersects(tracts1990.geom, sq.geom);