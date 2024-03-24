with _csv_iowa_liquor_stores as (
    select * from {{ ref('csv_Iowa_Liquor_Stores_20240324') }}
),

renamed as (
    select 
        cast(Store as string)   as store_number,
        Name                    as store_name,
        `Store Status`          as store_status,
        Address                 as store_address,
        City                    as store_city,
        State                   as store_state,
        `Zip Code`              as store_zip_code,
        `Store Address`         as store_location,
        `Report Date`           as report_date
    from _csv_iowa_liquor_stores
)

select * from renamed