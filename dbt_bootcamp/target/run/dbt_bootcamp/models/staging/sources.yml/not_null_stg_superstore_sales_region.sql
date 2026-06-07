
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select region
from "bootcamp"."dbt_schema"."stg_superstore_sales"
where region is null



  
  
      
    ) dbt_internal_test