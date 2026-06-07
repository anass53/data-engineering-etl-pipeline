
    
    

with all_values as (

    select
        region as value_field,
        count(*) as n_records

    from "bootcamp"."dbt_schema"."stg_superstore_sales"
    group by region

)

select *
from all_values
where value_field not in (
    'East','West','Central','South'
)


