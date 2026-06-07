
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sales
from "bootcamp"."dbt_schema"."stg_superstore_sales"
where sales is null



  
  
      
    ) dbt_internal_test