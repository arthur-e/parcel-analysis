SELECT COUNT(*), mm_fips_county_name,
  "left"(t.sr_date_transfer::text, 4) AS transfer_year
  --"left"(t.sr_date_filing::text, 4) AS filing_year
  FROM transactions t
 GROUP BY t.mm_fips_county_name, transfer_year
 ORDER BY t.mm_fips_county_name, transfer_year;