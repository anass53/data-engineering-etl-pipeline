
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select row_id
from "bootcamp"."dbt_schema"."stg_superstore_sales"
where row_id is null



  
  
      
    ) dbt_internal_test