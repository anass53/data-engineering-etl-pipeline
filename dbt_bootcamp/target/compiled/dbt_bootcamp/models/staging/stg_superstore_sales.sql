With source as(
    Select * from "bootcamp"."public"."superstore_sales"
),

renamed as(
    select
        "Row ID"        AS ROw_id,
        "Order ID"      AS order_id,
        CAST("Order Date" AS DATE) AS order_date,
        CAST("Ship Date"  AS DATE) AS ship_date,
        "Ship Mode"     AS ship_mode,
        "Customer ID"   AS customer_id,
        "Customer Name" AS customer_name,
        "Segment"       AS segment,
        "Country"       AS country,
        "City"          AS city,
        "State"         AS state,
        "Region"        AS region,
        "Category"      AS category,
        "Sub-Category"  AS sub_category,
        "Product Name"  AS product_name,
        "Sales"         AS sales,
        "Quantity"      AS quantity,
        "Discount"      AS discount,
        "Profit"        AS profit
    FROM source
)

SELECT * FROM renamed

    
        limit 500
    

