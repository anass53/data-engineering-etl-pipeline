
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_sales
from "bootcamp"."dbt_schema"."int_sales_by_region"
where total_sales is null



  
  
      
    ) dbt_internal_test