with raw_csv as (
    select * from {{ ref('csv_store_names_mapping_GPT_cleaned') }}
)

select 
    store_name,
    case 
        when store_company_by_GPT like "%CASEY'S%" then "CASEY'S"
        when store_company_by_GPT like "%COSTCO%" then "COSTCO"
    else store_company_by_GPT end as store_company_by_GPT
from raw_csv