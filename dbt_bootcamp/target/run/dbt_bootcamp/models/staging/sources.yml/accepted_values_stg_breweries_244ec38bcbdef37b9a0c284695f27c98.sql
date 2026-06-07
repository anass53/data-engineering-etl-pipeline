
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        brewery_type as value_field,
        count(*) as n_records

    from "bootcamp"."dbt_schema"."stg_breweries"
    group by brewery_type

)

select *
from all_values
where value_field not in (
    'micro','nano','regional','brewpub','large','planning','bar','contract','proprietor','taproom','closed'
)



  
  
      
    ) dbt_internal_test