{{
  config(
    materialized = 'view',
    )
}}


with source as (
    select * from {{ source('ingested','raw_iowa_liquor_sales') }}
),

renamed as (
    select
        -- Invoice details
        invoice_item_number,
        -- Date
        date,
        -- Store details
        store_number,
        store_name,
        address,
        city,
        zip_code,
        store_location,
        county_number,
        county,
        -- Product Details
        category,
        category_name,
        vendor_number,
        vendor_name,
        item_number,
        item_description,
        pack,
        bottle_volume__ml_ as bottle_volume__ml,
        state_bottle_cost,
        -- Sales
        state_bottle_retail,
        bottles_sold,
        sale__dollars_ as sales__dollars,
        volume_sold__liters_ as volume_sold__liters,
        volume_sold__gallons_ as volume_sold__gallons,

    from source

)

select * from renamed