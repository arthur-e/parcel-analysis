SELECT a.sa_appraise_yr, count(*)
  FROM assessments a
  JOIN geocoding_index gc ON a.sa_property_id = gc.sa_property_id
 WHERE a.sa_appraise_yr IS NOT NULL AND a.sa_appraise_yr != 0
 GROUP BY a.sa_appraise_yr
 ORDER BY a.sa_appraise_yr;