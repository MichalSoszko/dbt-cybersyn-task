with ras_csv_file as (
    select * from {{ ref('csv_Iowa_Liquor_Stores_20240324') }}
),

renamed as (
    select 
        cast(Store as string) as store_number,
        Name as store_name,
        `Store Status` as store_status,
        Address as address,
        City as city,
        State as state,
        cast(`Zip Code` as string) as zip_code,
        `Store Address` as store_location,
        `Report Date` as report_date
    from ras_csv_file
)

select * from renamed