with _base_iowa_liquor_sales as (
    select * from {{ ref('base_iowa_liquor_sales') }}
),

renamed as (
    select distinct
        date,
        -- Product Details
        item_number,
        item_description,
        category,
        category_name,
        vendor_number,
        vendor_name,
        pack,
        bottle_volume__ml,
    from _base_iowa_liquor_sales
),

cleaned as (
    select * from renamed
)

select * from cleaned