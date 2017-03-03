--ALTER TABLE census2000_tracts ADD COLUMN fips varchar(13);
UPDATE census2000_tracts SET fips = state || county || tract;
