
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  SELECT *
FROM "bootcamp"."dbt_schema"."stg_superstore_sales"
WHERE ship_date < order_date
  
  
      
    ) dbt_internal_test