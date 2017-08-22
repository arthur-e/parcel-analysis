SELECT tr.sr_property_id,
       tracts2010.fips AS fips2010, 
       tracts2000.fips AS fips2000,
       tracts1990.fips AS fips1990
  INTO lookup_census_tract_by_property_id
  FROM transactions_geocoded_adjusted AS tr, 
       census2010_tracts AS tracts2010, 
       census2000_tracts AS tracts2000,
       census1990_tracts AS tracts1990
 WHERE tr.mm_fips_county_name = 'LOS ANGELES'
   AND ST_Intersects(tracts2010.geom, tr.geom)
   AND ST_Intersects(tracts2000.geom, tr.geom)
   AND ST_Intersects(tracts1990.geom, tr.geom);