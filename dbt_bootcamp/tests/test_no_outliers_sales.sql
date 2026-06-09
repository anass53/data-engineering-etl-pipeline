{{ config(severity='warn') }}

WITH stats AS (
    SELECT
        AVG(sales)      AS avg_sales,
        STDDEV(sales)   AS std_sales
    FROM {{ ref('stg_superstore_sales') }}
),

outliers AS (
    SELECT s.*
    FROM {{ ref('stg_superstore_sales') }} s
    CROSS JOIN stats
    WHERE s.sales > stats.avg_sales + (3 * stats.std_sales)
)

SELECT * FROM outliers