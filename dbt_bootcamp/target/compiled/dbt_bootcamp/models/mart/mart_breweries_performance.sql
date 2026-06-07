WITH int_brew AS (
    SELECT * FROM "bootcamp"."dbt_schema"."int_breweries_by_country"
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
        
    CASE
        WHEN nb_breweries < 5 THEN 'low'
        WHEN nb_breweries <= 20 THEN 'medium'
        ELSE 'High'
    END
 AS size_category

    FROM int_brew
)

SELECT * FROM with_kpis
ORDER BY country, rank_in_country