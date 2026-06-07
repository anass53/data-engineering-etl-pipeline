WITH base AS (
    SELECT * FROM {{ ref('stg_breweries') }}
),

aggregated AS (
    SELECT
        country,
        brewery_type,
        COUNT(*) AS nb_breweries
    FROM base
    GROUP BY country, brewery_type
)

SELECT * FROM aggregated
ORDER BY country, nb_breweries DESC