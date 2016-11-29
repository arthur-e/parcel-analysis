-- Transactions adjusted to 2010 dollars, summarized by year on a 500m grid
SELECT grid.id AS ID, tr.*
  INTO _temp_transactions_adj_tagged_on_500m_grid_
  FROM transactions_by_year_adjusted AS tr, grid_500m AS grid
 WHERE ST_Intersects(grid.geom, tr.geom);