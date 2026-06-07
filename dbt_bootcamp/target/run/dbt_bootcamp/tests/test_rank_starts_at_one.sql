
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  SELECT region
FROM "bootcamp"."dbt_schema"."mart_sales_performance"
GROUP BY region
HAVING MIN(rank_in_region) != 1
  
  
      
    ) dbt_internal_test