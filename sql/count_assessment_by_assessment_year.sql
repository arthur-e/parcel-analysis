--SELECT sa_appraise_yr, COUNT(sa_property_id) FROM assessment
-- GROUP BY sa_appraise_yr ORDER BY sa_appraise_yr;

--SELECT sa_parcel_nbr_change_yr, COUNT(sa_property_id) FROM assessment
-- GROUP BY sa_parcel_nbr_change_yr ORDER BY sa_parcel_nbr_change_yr;

--SELECT assr_year, COUNT(sa_property_id) FROM assessment
-- GROUP BY assr_year ORDER BY assr_year;

SELECT taxyear, COUNT(sa_property_id) FROM assessment
 GROUP BY taxyear ORDER BY taxyear;
