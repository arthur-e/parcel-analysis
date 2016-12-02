-- Creates the inflation adjustment table and populates it.

-- We'd like to use the Final Chained CPI for housing for "All Urban Consumers" as a measure of average inflation across our study period, however, it is only available starting in 1999. Instead, we use the CPI-U (for "All Urban Consumers") without seasonal adjustment. According to the Bureau of Labor Statistics, the unadjusted estimates "are more appropriate for escalation purposes" (http://www.bls.gov/cpi/cpifaq.htm#Question_16).

-- NOTE: The 2010 annual CPI-U is not yet available; a quarterly estimate from 2015 Q1 is used instead.
-- Information on Chained CPI: http://www.bls.gov/cpi/superlink.htm
-- Data, Annual CPI-U for Housing: https://research.stlouisfed.org/fred2/series/USACPIHOUAINMEI
-- Inflation Adjustment Method: https://jobs.utah.gov/wi/pubs/costofliving/calc.html

CREATE TABLE cpi_u_housing_2010 (
  year integer PRIMARY KEY,
  cpi decimal,
  adjustment decimal
);

COPY cpi_u_housing_2010 FROM '/usr/local/dev/parcel-analysis/docs/inflation_adjustment_to_2010_dollars_by_CPI-U_housing.csv' WITH HEADER CSV;

CREATE TABLE cpi_u_housing_monthly_2010 (
  date date,
  key integer PRIMARY KEY,
  year integer,
  month integer,
  cpi decimal,
  adjustment decimal
);

COPY cpi_u_housing_monthly_2010 FROM '/usr/local/dev/parcel-analysis/docs/inflation_adjustment_to_2010_dollars_monthly_by_CPI-U_housing.csv' WITH HEADER CSV;
