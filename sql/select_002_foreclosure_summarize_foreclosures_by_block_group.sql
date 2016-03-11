-- Summarizes foreclosures by year and by block group.
SELECT bg.geoid10 AS fips, fc.recording_year,
       count(DISTINCT fc.unique_id_notice)
  INTO foreclosures_by_block_group
  FROM census2010_block_groups bg, foreclosures_geocoded fc
 WHERE ST_ContainsProperly(bg.geom, fc.geom)
 GROUP BY bg.geoid10, fc.recording_year;