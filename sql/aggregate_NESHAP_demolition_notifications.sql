SELECT --geom, status AS match_status, score AS match_score, match_type, 
       --match_addr AS match_address, notification_id, geoid10_tract,
       --datestarta AS demo_start_date, 
       --monthstart AS demo_start_month, 
       --daystart AS demo_start_day, 
       --yearstart AS demo_start_year, 
       --dateendact AS demo_end_date, 
       --monthend AS demo_end_month, 
       --dayend AS demo_end_day, 
       --yearend AS demo_end_year,
       count(dn.status) AS demo_count,
       bg.geoid10, bg.geom
  INTO _temp_neshap_demos_by_block_group_
  FROM neshap_demo_notifications dn, census2010_block_groups bg
 WHERE ST_Contains(bg.geom, dn.geom)
 GROUP BY bg.geoid10, bg.geom;
