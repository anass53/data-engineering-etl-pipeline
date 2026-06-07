
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select region
from "bootcamp"."dbt_schema"."int_sales_by_region"
where region is null



  
  
      
    ) dbt_internal_test