SELECT * FROM transaction
 WHERE sr_date_transfer >= 19940101 AND sr_date_transfer < 19950101
   AND mm_fips_muni_code = 163; -- Wayne County