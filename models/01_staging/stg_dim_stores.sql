with _base_iowa_liquor_sales as (
    select * from {{ ref('base_iowa_liquor_sales') }}
),

renamed as (
    select distinct
        -- Store details
        store_number,
        store_name,
        address,
        city,
        zip_code,
        ST_ASTEXT(store_location) as store_location,
        county_number,
        county
    from _base_iowa_liquor_sales
),

cleaned as (
    select * from renamed
)

select * from cleaned