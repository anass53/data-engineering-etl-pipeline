SELECT
    {{ dbt_utils.star(ref('stg_superstore_sales'), except=["row_id", "ship_mode"]) }}
FROM {{ ref('stg_superstore_sales') }}