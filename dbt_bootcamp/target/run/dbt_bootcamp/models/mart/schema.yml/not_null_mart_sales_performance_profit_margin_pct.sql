
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select profit_margin_pct
from "bootcamp"."dbt_schema"."mart_sales_performance"
where profit_margin_pct is null



  
  
      
    ) dbt_internal_test