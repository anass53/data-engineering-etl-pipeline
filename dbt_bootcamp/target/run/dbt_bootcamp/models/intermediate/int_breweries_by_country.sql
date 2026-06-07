
  create view "bootcamp"."dbt_schema"."int_breweries_by_country__dbt_tmp"
    
    
  as (
    WITH base AS (
    SELECT * FROM "bootcamp"."dbt_schema"."stg_breweries"
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
  );