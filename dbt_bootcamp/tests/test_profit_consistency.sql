SELECT *
FROM {{ ref('stg_superstore_sales') }}
WHERE sales > 0
AND profit > sales