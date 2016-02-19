--SELECT sa_appraise_yr, COUNT(sa_appraise_val) FROM assessment WHERE sa_appraise_val IS NOT NULL GROUP BY sa_appraise_yr ORDER BY sa_appraise_yr;
--SELECT sa_appraise_yr, COUNT(sa_val_market) FROM assessment WHERE sa_val_market IS NOT NULL GROUP BY sa_appraise_yr ORDER BY sa_appraise_yr;
--SELECT sa_appraise_yr, COUNT(sa_val_assd_land) FROM assessment WHERE sa_val_assd_land IS NOT NULL GROUP BY sa_appraise_yr ORDER BY sa_appraise_yr;

SELECT sa_appraise_yr, COUNT(sa_appraise_val) FROM assessment
 WHERE sa_appraise_val IS NOT NULL
 GROUP BY sa_appraise_yr ORDER BY sa_appraise_yr;