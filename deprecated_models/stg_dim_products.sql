with _csv_iowa_liquor_products as (
    select * from {{ ref('csv_Iowa_Liquor_Products_20240324') }}
),

renamed as (
    select
        cast(`Item Number` as string) as item_number,
        `Category Name` as item_category_name,
        `Item Description` as item_description,
        `Vendor` as vendor_number,
        `Vendor Name` as vendor_name,
        `Bottle Volume__ml` as bottle_volume__ml,
        `Pack` as pack,
        `Inner Pack` as inner_pack,
        `Age` as age,
        `Proof` as proof,
        `List Date` as list_date,
        `UPC` as upc,
        `SCC` as scc,
        `State Bottle Cost` as state_bottle_cost,
        `State Case Cost` as state_case_cost,
        `State Bottle Retail` as state_bottle_retail,
        `Report Date` as report_date

    from _csv_iowa_liquor_products
),

cleaned as (
    select * from renamed
)

select * from cleaned