CREATE OR REPLACE VIEW transactions_geocoded AS (
SELECT lk.fips2010, lk.fips2000, lk.fips1990, sq.* 
  FROM (
SELECT t.*, 
       left(t.sr_date_transfer::text, 4) AS transfer_year, 
       right(left(t.sr_date_transfer::text, 6), 2) AS transfer_month,
       left(t.sr_date_filing::text, 4) AS filing_year, 
       left(t.sr_date_transfer::text, 4) || right(left(sr_date_transfer::text, 6), 2) AS transfer_date_key,
       -- NOTE: DataQuick geocodes stored positive West longitudes...
       ST_Transform(ST_SetSRID(ST_MakePoint(-gc.sa_x_coord, gc.sa_y_coord), 4326), 26911) AS geom
  FROM transactions t
  JOIN geocoding_index gc ON t.sr_property_id = gc.sa_property_id
  ) sq
  LEFT OUTER JOIN lookup_census_tract_by_property_id lk
    ON sq.sr_property_id = lk.sr_property_id);