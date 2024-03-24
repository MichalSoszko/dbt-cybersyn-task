with

_stg_dim_stores as (
    select * from {{ ref('stg_dim_stores') }}
),

_stg_dim_vendors as (
    select * from {{ ref('stg_dim_vendors') }}
),

stores_and_vendors_combined as (
    select 
        s.*,
        v.vendor_name_most_recent as vendor_name
    from _stg_dim_stores as s
    left join _stg_dim_vendors as v using(vendor_number)
)

select * from stores_and_vendors_combined
