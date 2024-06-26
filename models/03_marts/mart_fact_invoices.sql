with 

_stg_fact_invoices as (
    select * from {{ ref('stg_fact_invoices') }}
),

_stg_dim_stores as (
    select * from {{ ref('stg_dim_stores') }}
),

fact_invoices_with_store_details as (
    select 
        inv.*,
        s.* except(store_number)
    from _stg_fact_invoices as inv
    left join _stg_dim_stores as s using(store_number)
),

final as (
    select 
        -- Invoice details
        -- Date
        date as invoice_date,
        -- Primary (business) key for the fact table
        business_key,
        -- Invoice details
        invoice_no,
        item_no,
        -- Store id
        store_number,
        store_name,
        store_company,
        address,
        city,
        zip_code,
        store_location,
        county_number,
        county,
        -- Product_id
        item_number,
        bottle_volume__ml,
        -- Sales
        state_bottle_cost,
        state_bottle_retail,
        bottles_sold,
        sales__dollars,
        volume_sold__liters,
        volume_sold__gallons
    from fact_invoices_with_store_details
)

select * from final