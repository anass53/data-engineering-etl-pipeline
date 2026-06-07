SELECT *
FROM "bootcamp"."dbt_schema"."stg_superstore_sales"
WHERE sales > 0
AND (profit / sales) > 1