SELECT 'fd_delinquent_date', count(DISTINCT unique_id_notice)
  FROM foreclosures
 WHERE fd_delinquent_date IS NOT NULL AND fd_delinquent_date != 19000101
UNION
SELECT 'fd_nod_t_auct_date', count(DISTINCT unique_id_notice)
  FROM foreclosures
 WHERE fd_nod_t_auct_date IS NOT NULL AND fd_nod_t_auct_date != 19000101
UNION
SELECT 'ft_not_sale_date', count(DISTINCT unique_id_notice)
  FROM foreclosures
 WHERE ft_not_sale_date IS NOT NULL AND ft_not_sale_date != 19000101;

