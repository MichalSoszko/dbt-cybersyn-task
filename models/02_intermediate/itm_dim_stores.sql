with _stg_dim_stores as (
    select * from {{ ref('stg_dim_stores') }}
),

_base_csv_store_iowa_liquor_stores as (
    select * from {{ ref('base_csv_iowa_liquor_stores') }}
),

fill_missing_data as (
    select
        b.store_number,
        b.store_name,
        coalesce(b.address, c.address) as address,
        coalesce(b.city, c.city) as city,
        coalesce(b.zip_code, c.zip_code) as zip_code,
        coalesce(b.store_location, c.store_location) as store_location,
        b.county_number,
        b.county,
        b.store_company,
    from _stg_dim_stores as b 
    left join _base_csv_store_iowa_liquor_stores as c using(store_number)
)

select * from fill_missing_data
order by 1
