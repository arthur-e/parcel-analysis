-- A histogram of the number of times a property has gone into foreclosure
SELECT sq.record_count AS num_foreclosures, count(sq.record_count) FROM (
SELECT count(unique_id_notice) AS record_count
  FROM foreclosures
 GROUP BY sa_property_id
 ORDER BY record_count ASC) sq
 GROUP BY sq.record_count;
 