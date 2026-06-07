SELECT region
FROM "bootcamp"."dbt_schema"."mart_sales_performance"
GROUP BY region
HAVING MIN(rank_in_region) != 1