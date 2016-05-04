SELECT bg.geoid10 AS fips,
       sum(a.pool_present) AS pool_count,
       sum(a.pool_present) / count(*) AS pool_proportion, 
       count(*) AS new_housing_starts,
       a.year_built--, a.year_improved
  INTO assessments_by_block_group
  FROM census2010_block_groups bg, assessments_parcel_characteristics_geocoded a
 WHERE ST_ContainsProperly(bg.geom, a.geom)
 GROUP BY bg.geoid10, a.year_built-- a.year_improved;