-- Creates the inflation adjustment table and populates it.

CREATE TABLE cpi_u_housing_2010 (
  year integer PRIMARY KEY,
  cpi decimal,
  adjustment decimal
);

COPY cpi_u_housing_2010 FROM '/usr/local/dev/parcel-analysis/docs/inflation_adjustment_to_2010_dollars_by_CPI-U_housing.csv' WITH HEADER CSV;