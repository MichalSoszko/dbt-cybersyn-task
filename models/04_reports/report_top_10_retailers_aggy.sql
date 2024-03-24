with 

_mart_fact_invoices as (
    select 
        invoice_date,
        store_company as retailer,
        sales__dollars,
        volume_sold__liters,
        volume_sold__gallons
    from {{ ref('mart_fact_invoices') }}
),

mart_fact_invoices_aggy as (
    select 
        extract(year from invoice_date) as year,
        retailer,
        sum(sales__dollars) as sum_of_sales,
        sum(volume_sold__liters) as sum_of_liters_sold,
        sum(volume_sold__gallons) as sum_of_gallons_sold
    from _mart_fact_invoices
    group by year, retailer
),

rank_retailers as (
    select 
        *,
        rank() over (partition by year order by sum_of_sales desc) as retailer_rank
    from mart_fact_invoices_aggy
)

select * except(retailer_rank) from rank_retailers
where retailer_rank <= 10
order by 1,3 desc