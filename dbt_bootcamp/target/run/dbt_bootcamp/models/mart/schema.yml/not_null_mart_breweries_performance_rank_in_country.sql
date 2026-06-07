
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select rank_in_country
from "bootcamp"."dbt_schema"."mart_breweries_performance"
where rank_in_country is null



  
  
      
    ) dbt_internal_test