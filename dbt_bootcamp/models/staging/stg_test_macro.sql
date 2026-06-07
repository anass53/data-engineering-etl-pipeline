SELECT
    order_id,
    sales,
    {{ cents_to_dollars('sales') }} as sales_in_dollars
from {{ ref('stg_superstore_sales') }}
limit 10
