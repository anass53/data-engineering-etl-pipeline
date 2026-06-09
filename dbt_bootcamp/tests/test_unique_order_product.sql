{{ config(severity='warn') }}

SELECT order_id, product_name, COUNT(*) AS nb
FROM {{ ref('stg_superstore_sales') }}
GROUP BY order_id, product_name
HAVING COUNT(*) > 1