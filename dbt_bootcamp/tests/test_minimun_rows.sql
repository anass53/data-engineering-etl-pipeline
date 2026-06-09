{{ config(severity='warn') }}

SELECT COUNT(*) AS nb
FROM {{ ref('stg_superstore_sales') }}
HAVING COUNT(*) < 5000