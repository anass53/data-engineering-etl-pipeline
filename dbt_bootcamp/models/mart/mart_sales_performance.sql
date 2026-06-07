WITH int_sales AS (
    SELECT * FROM {{ ref('int_sales_by_region') }}
),

with_kpis AS (
    SELECT
        region,
        category,
        nb_orders,
        total_sales,
        total_profit,
        avg_discount,

        
        {{ calculate_margin('total_profit', 'total_sales')}} AS profit_margin_pct,

        ROUND(
            total_sales / SUM(total_sales) OVER (PARTITION BY region) * 100
            ::numeric, 2
        ) AS pct_of_region_sales,


        RANK() OVER (
            PARTITION BY region
            ORDER BY total_sales DESC
        ) AS rank_in_region,

        {{ classify_performance('total_sales') }} AS performance_category

    FROM int_sales
)

SELECT * FROM with_kpis
ORDER BY region, rank_in_region