SELECT *
FROM "bootcamp"."dbt_schema"."stg_superstore_sales"
WHERE ship_date < order_date