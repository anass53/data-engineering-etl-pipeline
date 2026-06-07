
    
    

with all_values as (

    select
        segment as value_field,
        count(*) as n_records

    from "bootcamp"."dbt_schema"."stg_superstore_sales"
    group by segment

)

select *
from all_values
where value_field not in (
    'Consumer','Corporate','Home Office'
)


