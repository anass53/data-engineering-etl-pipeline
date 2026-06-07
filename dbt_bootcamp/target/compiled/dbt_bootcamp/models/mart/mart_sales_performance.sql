WITH int_sales AS (
    SELECT * FROM "bootcamp"."dbt_schema"."int_sales_by_region"
),

with_kpis AS (
    SELECT
        region,
        category,
        nb_orders,
        total_sales,
        total_profit,
        avg_discount,

        
        
    CASE
        WHEN total_sales = 0 THEN 0
        ELSE ROUND((total_profit::numeric / total_sales::numeric * 100), 2)
    END
 AS profit_margin_pct,

        ROUND(
            total_sales / SUM(total_sales) OVER (PARTITION BY region) * 100
            ::numeric, 2
        ) AS pct_of_region_sales,


        RANK() OVER (
            PARTITION BY region
            ORDER BY total_sales DESC
        ) AS rank_in_region,

        
    CASE
        WHEN total_sales < 100 THEN 'low'
        WHEN total_sales <= 500 THEN 'medium'
        ELSE 'High'
    END
 AS performance_category

    FROM int_sales
)

SELECT * FROM with_kpis
ORDER BY region, rank_in_region