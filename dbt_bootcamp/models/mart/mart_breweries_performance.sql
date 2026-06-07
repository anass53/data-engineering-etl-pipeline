WITH int_brew AS (
    SELECT * FROM {{ ref('int_breweries_by_country') }}
),

with_kpis AS (
    SELECT
        country,
        brewery_type,
        nb_breweries,

        -- Part par pays
        ROUND(
            nb_breweries::numeric / SUM(nb_breweries) OVER (PARTITION BY country) * 100,
            2
        ) AS pct_of_country,

        -- Rang par pays
        RANK() OVER (
            PARTITION BY country
            ORDER BY nb_breweries DESC
        ) AS rank_in_country,

        -- Classification
        {{ classify_performance('nb_breweries', low=5, high=20) }} AS size_category

    FROM int_brew
)

SELECT * FROM with_kpis
ORDER BY country, rank_in_country