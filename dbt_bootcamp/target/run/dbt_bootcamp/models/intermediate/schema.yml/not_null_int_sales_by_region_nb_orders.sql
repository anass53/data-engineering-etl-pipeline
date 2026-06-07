
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select nb_orders
from "bootcamp"."dbt_schema"."int_sales_by_region"
where nb_orders is null



  
  
      
    ) dbt_internal_test