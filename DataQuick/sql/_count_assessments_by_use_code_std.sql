SELECT sq.use_code_std, sq.Total, sq.Total / 2401744.0 AS Proportion, sum(sq.Total) OVER (ORDER BY Total DESC)
  FROM
(SELECT use_code_std, count(*) AS Total
   FROM assessments
  WHERE mm_fips_county_name = 'LOS ANGELES'
  GROUP BY use_code_std
  ORDER BY Total DESC) sq;