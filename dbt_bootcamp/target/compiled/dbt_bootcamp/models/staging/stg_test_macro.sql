SELECT
    order_id,
    sales,
    
    ROUND(sales::numeric / 100, 2)
 as sales_in_dollars
from "bootcamp"."dbt_schema"."stg_superstore_sales"
limit 10