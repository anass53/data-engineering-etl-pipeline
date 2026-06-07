
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select brewery_type
from "bootcamp"."dbt_schema"."int_breweries_by_country"
where brewery_type is null



  
  
      
    ) dbt_internal_test