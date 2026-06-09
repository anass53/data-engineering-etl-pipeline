-- La marge moyenne par catégorie ne doit pas être inférieure à -50%
WITH category_margins AS (
    SELECT
        category,
        AVG(CASE WHEN sales > 0 THEN profit / sales ELSE 0 END) AS avg_margin
    FROM {{ ref('stg_superstore_sales') }}
    GROUP BY category
)

SELECT *
FROM category_margins
WHERE avg_margin < -0.5