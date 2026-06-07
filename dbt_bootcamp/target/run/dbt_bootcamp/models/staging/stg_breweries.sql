
  create view "bootcamp"."dbt_schema"."stg_breweries__dbt_tmp"
    
    
  as (
    With source as(
    Select * from "bootcamp"."public"."breweries"
),

brewery_name as(
    select
        "id",
        "name" as "brewery_name",
        "brewery_type",
        "city",
        "state",       
        "country"       
    FROM source
    where "brewery_type" IS NOT NULL
)

SELECT * FROM brewery_name
  );