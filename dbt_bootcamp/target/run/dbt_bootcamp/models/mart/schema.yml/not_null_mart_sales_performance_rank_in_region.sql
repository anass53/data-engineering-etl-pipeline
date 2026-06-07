
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select rank_in_region
from "bootcamp"."dbt_schema"."mart_sales_performance"
where rank_in_region is null



  
  
      
    ) dbt_internal_test