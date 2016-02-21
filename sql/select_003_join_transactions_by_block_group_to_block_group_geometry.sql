SELECT tr.fips, tr.transfer_year, tr.min_val_transfer, tr.max_val_transfer,
       tr.mean_val_transfer, tr.std_val_transfer, bg.geom
  INTO _temp_
  FROM transactions_by_block_group tr
  JOIN census2010_block_groups bg ON tr.fips = bg.geoid10;