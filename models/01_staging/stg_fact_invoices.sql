with _base_iowa_liquor_sales as (
    select * from {{ ref('base_iowa_liquor_sales') }}
),

renamed as (
    select 
        -- Date
        date,
        -- Primary (business) key for the fact table
        invoice_item_number as business_key,
        -- Invoice details
        left(invoice_item_number,10) as invoice_no,
        cast(right(invoice_item_number,5) as integer) as item_no,
        -- Store id
        store_number,
        -- Product_id
        item_number,
        -- Sales
        state_bottle_cost,
        state_bottle_retail,
        bottles_sold,
        sales__dollars,
        volume_sold__liters,
        volume_sold__gallons
    from _base_iowa_liquor_sales
)

select * from renamed
