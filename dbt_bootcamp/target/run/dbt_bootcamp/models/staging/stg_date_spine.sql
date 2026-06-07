
  create view "bootcamp"."dbt_schema"."stg_date_spine__dbt_tmp"
    
    
  as (
    WITH date_spine AS (
    





with rawdata as (

    

    

    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (

    select

    
    p0.generated_number * power(2, 0)
     + 
    
    p1.generated_number * power(2, 1)
     + 
    
    p2.generated_number * power(2, 2)
     + 
    
    p3.generated_number * power(2, 3)
     + 
    
    p4.generated_number * power(2, 4)
     + 
    
    p5.generated_number * power(2, 5)
    
    
    + 1
    as generated_number

    from

    
    p as p0
     cross join 
    
    p as p1
     cross join 
    
    p as p2
     cross join 
    
    p as p3
     cross join 
    
    p as p4
     cross join 
    
    p as p5
    
    

    )

    select *
    from unioned
    where generated_number <= 47.0
    order by generated_number



),

all_periods as (

    select (
        

    cast('2020-01-01' as date) + ((interval '1 month') * (row_number() over (order by 1) - 1))


    ) as date_month
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_month <= cast('2023-12-31' as date)

)

select * from filtered


)

SELECT
    date_month,
    EXTRACT(YEAR FROM date_month)  AS year,
    EXTRACT(MONTH FROM date_month) AS month
FROM date_spine
  );