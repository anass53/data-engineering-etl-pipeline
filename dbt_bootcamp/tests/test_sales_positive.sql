select *
from {{ ref('stg_superstore_sales') }}
where sales <= 0