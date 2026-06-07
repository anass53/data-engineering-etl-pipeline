
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  select *
from "bootcamp"."dbt_schema"."stg_superstore_sales"
where sales <= 0
  
  
      
    ) dbt_internal_test