﻿SELECT bg.geoid10 AS fips,
       median(a.year_built) AS year_built_median,
       avg(a.lot_size_sqft) AS lot_size_sqft_mean, 
       median(a.lot_size_sqft) AS lot_size_sqft_median, 
       stddev(a.lot_size_sqft) AS lot_size_sqft_sd,
       avg(a.sa_bldg_sqft) AS sa_bldg_sqft_mean, 
       median(a.sa_bldg_sqft) AS sa_bldg_sqft_median,
       stddev(a.sa_bldg_sqft) AS sa_bldg_sqft_sd,
       avg(a.built_area_sqft) AS built_area_sqft_mean, 
       median(a.built_area_sqft) AS built_area_sqft_median,
       stddev(a.built_area_sqft) AS built_area_sqft_sd,
       avg(a.net_unbuilt_area_sqft) AS net_unbuilt_area_sqft_mean, 
       median(a.net_unbuilt_area_sqft) AS net_unbuilt_area_sqft_median,
       stddev(a.net_unbuilt_area_sqft) AS net_unbuilt_area_sqft_sd,
       sum(a.net_unbuilt_area_sqft) AS net_unbuilt_area_sqft_total--, a.year_built, a.year_improved
  INTO assessments_static_by_block_group
  FROM census2010_block_groups bg, assessments_parcel_characteristics_geocoded a
 WHERE ST_ContainsProperly(bg.geom, a.geom)
 GROUP BY bg.geoid10--, a.year_improved; -- Assume that improvement is pool, garage