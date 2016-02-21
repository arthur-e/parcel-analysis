SELECT sq.transfer_year, COUNT(sq.sr_unique_id) FROM (
SELECT sr_unique_id, left(sr_date_transfer::text, 4) AS transfer_year, left(sr_date_filing::text, 4) AS filing_year
  FROM transactions
 WHERE mm_fips_muni_code = 163) sq -- Wayne County
 GROUP BY sq.transfer_year
 ORDER BY sq.transfer_year;