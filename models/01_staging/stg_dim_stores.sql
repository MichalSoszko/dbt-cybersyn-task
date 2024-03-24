{% set store_details = [
    "store_name",
    "address",
    "city",
    "zip_code",
    "store_location",
    "county_number",
    "county"
    ]
-%}


with 

_base_iowa_liquor_sales as (
    select * from {{ ref('base_iowa_liquor_sales') }}
),

_csv_store_names_mapping_GPT_cleaned as (
    select * from {{ ref('csv_store_names_mapping_GPT_cleaned') }}
),

base as (
    select
        date,
        store_number,
        store_name,
        address,
        city,
        zip_code,
        store_location,
        county_number,
        county,
        vendor_number
    from _base_iowa_liquor_sales
),
-- find most used store_location point using distinct address, city, and zip_code
clean_store_location_p1 as (
    select
        address,
        city,
        zip_code,
        ifnull(store_location, "null") as store_location_refined,
        count(*) as cnt
    from _base_iowa_liquor_sales
    group by 1,2,3,4
),

clean_store_location_p2 as (
    select
        address,
        city,
        zip_code,
        store_location_refined,
        row_number() over (partition by address, city, zip_code order by cnt desc) as store_location_rank
    from clean_store_location_p1
),
-- recombine refined store_location_rank and find most used store address set per store_number
clean_store_address_p1 as (
    select
        store_number,
        store_name,
        address,
        city,
        zip_code,
        csl.store_location_refined as store_location,
        county_number,
        county,
        vendor_number,
        count(*) as cnt
    from base as b 
    left join clean_store_location_p2 as csl using(address, city, zip_code)
    where csl.store_location_rank = 1
    group by 1,2,3,4,5,6,7,8,9
),

clean_store_address_p2 as (
    select
        *,
        row_number() over (partition by store_number order by cnt desc) as store_number_rank
    from clean_store_address_p1
),

final as (
    select
        base.store_number,
        store_name,
        address,
        city,
        zip_code,
        nullif(store_location, "null") as store_location,
        county_number,
        county,
        vendor_number,
        map.store_company_by_GPT as store_company
    from clean_store_address_p2 as base
    left join _csv_store_names_mapping_GPT_cleaned as map using(store_name)
    where store_number_rank = 1
)

select * from final
order by 1