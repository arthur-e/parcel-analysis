-- Transactions adjusted to 2010 dollars, summarized by year and on a 1500-m grid
SELECT bg.id AS ID, tr.*
  INTO _temp_transactions_adj_tagged_on_1500m_grid_
  FROM transactions_by_year_adjusted AS tr, grid_1500m AS bg
 WHERE ST_Intersects(bg.geom, tr.geom);