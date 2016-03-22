-- Number of unique addresses in transactions that could be geocoded
SELECT COUNT(sr_property_id) FROM (
SELECT gc.property_id AS sr_property_id FROM
(SELECT property_id FROM geocoded
  WHERE score > 80
  UNION
 SELECT property_id FROM geocoded_extra
  WHERE score > 0
  ) gc
INTERSECT
SELECT sr_property_id FROM transactions) sq;

-- Number of unique addresses in assessor record that could be geocoded:
-- Assumes that `sa_property_id` is drawn from the same pool as `sr_property_id`
SELECT COUNT(sa_property_id) FROM (
SELECT gc.property_id AS sa_property_id FROM
(SELECT property_id FROM geocoded
  WHERE score > 80
  UNION
 SELECT property_id FROM geocoded_extra
  WHERE score > 0
  ) gc
INTERSECT
SELECT sa_property_id FROM assessments) sq;

-- Addresses that were not included in Eric's geocoding...
SELECT * FROM transactions tr
 WHERE tr.sr_property_id NOT IN (
 SELECT gc.property_id AS sr_property_id FROM
(SELECT property_id FROM geocoded
  UNION
 SELECT property_id FROM geocoded_extra) gc
 INTERSECT
 SELECT sr_property_id FROM transactions);
