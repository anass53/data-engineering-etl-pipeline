
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category
from "bootcamp"."dbt_schema"."mart_sales_performance"
where category is null



  
  
      
    ) dbt_internal_test