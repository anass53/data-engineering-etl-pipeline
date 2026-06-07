
  create view "bootcamp"."dbt_schema"."int_sales_by_region__dbt_tmp"
    
    
  as (
    --ventes par Region et Category
WITH base AS (
    SELECT * FROM "bootcamp"."dbt_schema"."stg_superstore_sales"
),

aggregated AS (
    SELECT
        region,
        category,
        COUNT(DISTINCT order_id)            AS nb_orders,
        ROUND(SUM(sales)::numeric, 2)       AS total_sales,
        ROUND(SUM(profit)::numeric, 2)      AS total_profit,
        ROUND(AVG(discount)::numeric, 4)    AS avg_discount
    FROM base
    GROUP BY region, category
)

SELECT * FROM aggregated
  );