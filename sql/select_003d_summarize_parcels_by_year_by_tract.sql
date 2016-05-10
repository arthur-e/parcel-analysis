SELECT tc.geoid10 AS fips,
       count(*) AS new_housing_starts,
       a.year_built--, a.year_improved
  INTO assessments_by_tract
  FROM census2010_tracts tc, assessments_parcel_characteristics_geocoded a
 WHERE ST_ContainsProperly(tc.geom, a.geom)
 GROUP BY tc.geoid10, a.year_built-- a.year_improved;