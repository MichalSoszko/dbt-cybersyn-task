with _base_iowa_liquor_sales as (
    select * from {{ ref('base_iowa_liquor_sales') }}
),

base as (
    select distinct
        date,
        -- Vendor Details
        vendor_number,
        vendor_name
    from _base_iowa_liquor_sales
),

calc_most_recent_dates as (
    select
        vendor_number,
        vendor_name,
        max(date) as date_most_recent
    from base
    group by 1,2
    order by 1,3 desc
),

calc_vendor_names as (
    select
        vendor_number,
        array_agg(struct(vendor_name, date_most_recent)) as vendor_names
    from calc_most_recent_dates
    group by 1
),

final as (
    select
        vendor_number,
        vendor_names[offset(0)].vendor_name as vendor_name_most_recent,
        vendor_names
    from calc_vendor_names
    where vendor_number is not null
)

select * from final
order by 1
