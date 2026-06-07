WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="month",
        start_date="cast('2020-01-01' as date)",
        end_date="cast('2023-12-31' as date)"
    ) }}
)

SELECT
    date_month,
    EXTRACT(YEAR FROM date_month)  AS year,
    EXTRACT(MONTH FROM date_month) AS month
FROM date_spine