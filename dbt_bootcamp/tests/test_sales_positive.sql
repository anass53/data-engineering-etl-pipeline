-- Test : toutes les ventes doivent être positives
-- Auteur : Anass El Rhaiti
-- Date : 2026
select *
from {{ ref('stg_superstore_sales') }}
where sales <= 0