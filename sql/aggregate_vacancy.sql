SELECT avg(v.pct_v_q413) AS mean_pct_vacancy_q413, 
       avg(v.pct_v_q114) AS mean_pct_vacancy_q114, 
       avg(v.pct_v_q214) AS mean_pct_vacancy_q214, 
       avg(v.pct_v_q314) AS mean_pct_vacancy_q314, 
       avg(v.pct_v_q414) AS mean_pct_vacancy_q414,
       max(v.pct_vacancy) AS max_pct_vacancy,
       avg(v.pct_vacancy) AS mean_pct_vacancy,
       bg.geoid10, bg.geom
  INTO _temp_vacancy_by_block_group_
  FROM census2010_block_groups bg,
  (SELECT geom, pct_v_q413, pct_v_q114, pct_v_q214, pct_v_q314, pct_v_q414, 
    unnest(array[pct_v_q413, pct_v_q114, pct_v_q214, pct_v_q314, pct_v_q414]) AS pct_vacancy
     FROM vacancy_by_census_block) v
 WHERE ST_Contains(bg.geom, v.geom)
 GROUP BY bg.geoid10, bg.geom;
