
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select brewery_name
from "bootcamp"."dbt_schema"."stg_breweries"
where brewery_name is null



  
  
      
    ) dbt_internal_test