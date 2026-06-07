SELECT *
FROM {{ ref('stg_superstore_sales') }}
WHERE ship_date < order_date